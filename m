From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: RE: [Patch v2] Storvsc: Select channel based on available percentage
 of ring buffer to write
Date: Sun, 22 Apr 2018 18:53:50 +0000
Message-ID: <DM5PR2101MB1030DC17E849B106A223E40EDC8A0@DM5PR2101MB1030.namprd21.prod.outlook.com>
References: <20180419215424.3557-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419215424.3557-1-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.=
org> On Behalf
> Of Long Li
> Sent: Thursday, April 19, 2018 2:54 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen
> Hemminger <sthemmin@microsoft.com>; James E . J . Bottomley <JBottomley@o=
din.com>;
> Martin K . Petersen <martin.petersen@oracle.com>; devel@linuxdriverprojec=
t.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [Patch v2] Storvsc: Select channel based on available percentage=
 of ring buffer to
> write
>=20
> From: Long Li <longli@microsoft.com>
>=20
> This is a best effort for estimating on how busy the ring buffer is for
> that channel, based on available buffer to write in percentage. It is sti=
ll
> possible that at the time of actual ring buffer write, the space may not =
be
> available due to other processes may be writing at the time.
>=20
> Selecting a channel based on how full it is can reduce the possibility th=
at
> a ring buffer write will fail, and avoid the situation a channel is over
> busy.
>=20
> Now it's possible that storvsc can use a smaller ring buffer size
> (e.g. 40k bytes) to take advantage of cache locality.
>=20
> Changes.
> v2: Pre-allocate struct cpumask on the heap.
> Struct cpumask is a big structure (1k bytes) when CONFIG_NR_CPUS=3D8192 (=
default
> value when CONFIG_MAXSMP=3Dy). Don't use kernel stack for it by pre-alloc=
ating
> them using kmalloc when channels are first initialized.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 90 ++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 72 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index a2ec0bc9e9fa..2a9fff94dd1a 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -395,6 +395,12 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buff=
er size
> (bytes)");
>=20
>  module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
>  MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to subch=
annels");
> +
> +static int ring_avail_percent_lowater =3D 10;
> +module_param(ring_avail_percent_lowater, int, S_IRUGO);
> +MODULE_PARM_DESC(ring_avail_percent_lowater,
> +		"Select a channel if available ring size > this in percent");
> +
>  /*
>   * Timeout in seconds for all devices managed by this driver.
>   */
> @@ -468,6 +474,13 @@ struct storvsc_device {
>  	 * Mask of CPUs bound to subchannels.
>  	 */
>  	struct cpumask alloced_cpus;
> +	/*
> +	 * Pre-allocated struct cpumask for each hardware queue.
> +	 * struct cpumask is used by selecting out-going channels. It is a
> +	 * big structure, default to 1024k bytes when CONFIG_MAXSMP=3Dy.

I think you mean "1024 bytes" or "1k bytes" in the above comment.

> +	 * Pre-allocate it to avoid allocation on the kernel stack.
> +	 */
> +	struct cpumask *cpumask_chns;
>  	/* Used for vsc/vsp channel reset process */
>  	struct storvsc_cmd_request init_request;
>  	struct storvsc_cmd_request reset_request;
> @@ -872,6 +885,13 @@ static int storvsc_channel_init(struct hv_device *de=
vice, bool is_fc)
>  	if (stor_device->stor_chns =3D=3D NULL)
>  		return -ENOMEM;
>=20
> +	stor_device->cpumask_chns =3D kcalloc(num_possible_cpus(),
> +			sizeof(struct cpumask), GFP_KERNEL);

Note that num_possible_cpus() is 240 for a Hyper-V 2016 guest unless=20
overridden on the kernel boot line, so this is going to allocate 240 Kbytes=
 for each
synthetic SCSI controller.  On an Azure VM, which has two IDE and two SCSI
controllers, this is nearly 1 Mbyte.  It's unfortunate to have to allocate =
this much
memory for a what is essentially a temporary variable.   Further down in th=
ese
comments, I've proposed an alternate implementation of the code that avoids
the need for the temporary variable, and hence avoids the need for this
allocation.

> +	if (stor_device->cpumask_chns =3D=3D NULL) {
> +		kfree(stor_device->stor_chns);
> +		return -ENOMEM;
> +	}
> +
>  	stor_device->stor_chns[device->channel->target_cpu] =3D device->channel=
;
>  	cpumask_set_cpu(device->channel->target_cpu,
>  			&stor_device->alloced_cpus);
> @@ -1232,6 +1252,7 @@ static int storvsc_dev_remove(struct hv_device *dev=
ice)
>  	vmbus_close(device->channel);
>=20
>  	kfree(stor_device->stor_chns);
> +	kfree(stor_device->cpumask_chns);
>  	kfree(stor_device);
>  	return 0;
>  }
> @@ -1241,7 +1262,7 @@ static struct vmbus_channel *get_og_chn(struct stor=
vsc_device
> *stor_device,
>  {1G/
>  	u16 slot =3D 0;
>  	u16 hash_qnum;
> -	struct cpumask alloced_mask;
> +	struct cpumask *alloced_mask =3D &stor_device->cpumask_chns[q_num];
>  	int num_channels, tgt_cpu;
>=20
>  	if (stor_device->num_sc =3D=3D 0)
> @@ -1257,10 +1278,10 @@ static struct vmbus_channel *get_og_chn(struct st=
orvsc_device
> *stor_device,
>  	 * III. Mapping is persistent.
>  	 */
>=20
> -	cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
> +	cpumask_and(alloced_mask, &stor_device->alloced_cpus,
>  		    cpumask_of_node(cpu_to_node(q_num)));
>=20
> -	num_channels =3D cpumask_weight(&alloced_mask);
> +	num_channels =3D cpumask_weight(alloced_mask);
>  	if (num_channels =3D=3D 0)
>  		return stor_device->device->channel;
>=20
> @@ -1268,7 +1289,7 @@ static struct vmbus_channel *get_og_chn(struct stor=
vsc_device
> *stor_device,
>  	while (hash_qnum >=3D num_channels)
>  		hash_qnum -=3D num_channels;
>=20
> -	for_each_cpu(tgt_cpu, &alloced_mask) {
> +	for_each_cpu(tgt_cpu, alloced_mask) {
>  		if (slot =3D=3D hash_qnum)
>  			break;
>  		slot++;

Here's an alternate implementation of the core code in get_og_chn() that av=
oids
the need for a struct cpumask as a temporary variable.  It checks the node
cpumask on-the-fly, rather than precomputing the logical AND.  This
implementation might be slightly slower from a CPU standpoint, but the
alloced_cpus mask is sparse, and get_og_chn() is only called a few
times at the beginning of the usage of the synthetic SCSI controller, so it
has no material impact.

	const struct cpumask *node_mask;

	node_mask =3D cpumask_of_node(cpu_to_node(q_num));

	num_channels =3D 0;
	for_each_cpu(tgt_cpu, &stor_device->alloced_cpus) {
		if (cpumask_test_cpu(tgt_cpu, node_mask))
			num_channels++;
	}
	if (num_channels =3D=3D 0)
		return stor_device->device->channel;

	hash_qnum =3D q_num;
	while (hash_qnum >=3D num_channels)
		hash_qnum -=3D num_channels;

	for_each_cpu(tgt_cpu, &stor_device->alloced_cpus) {
		if (!cpumask_test_cpu(tgt_cpu, node_mask))
			continue;
		if (slot =3D=3D hash_qnum)
			break;
		slot++;
	}

The same approach of checking the node cpumask on-the-fly instead of
pre-computing can also be used in storvsc_do_io().   The perf impact in
storvsc_do_io() is probably nil.   Then with both uses of the temp cpumask
eliminated, the large memory allocation for it could be removed.

> @@ -1285,9 +1306,9 @@ static int storvsc_do_io(struct hv_device *device,
>  {
>  	struct storvsc_device *stor_device;
>  	struct vstor_packet *vstor_packet;
> -	struct vmbus_channel *outgoing_channel;
> +	struct vmbus_channel *outgoing_channel, *channel;
>  	int ret =3D 0;
> -	struct cpumask alloced_mask;
> +	struct cpumask *alloced_mask;
>  	int tgt_cpu;
>=20
>  	vstor_packet =3D &request->vstor_packet;
> @@ -1301,22 +1322,53 @@ static int storvsc_do_io(struct hv_device *device=
,
>  	/*
>  	 * Select an an appropriate channel to send the request out.
>  	 */
> -
>  	if (stor_device->stor_chns[q_num] !=3D NULL) {
>  		outgoing_channel =3D stor_device->stor_chns[q_num];
> -		if (outgoing_channel->target_cpu =3D=3D smp_processor_id()) {
> +		if (outgoing_channel->target_cpu =3D=3D q_num) {
>  			/*
>  			 * Ideally, we want to pick a different channel if
>  			 * available on the same NUMA node.
>  			 */
> -			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
> +			alloced_mask =3D &stor_device->cpumask_chns[q_num];
> +			cpumask_and(alloced_mask, &stor_device->alloced_cpus,
>  				    cpumask_of_node(cpu_to_node(q_num)));
> -			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
> -					outgoing_channel->target_cpu + 1) {
> -				if (tgt_cpu !=3D outgoing_channel->target_cpu) {
> -					outgoing_channel =3D
> -					stor_device->stor_chns[tgt_cpu];
> -					break;
> +
> +			for_each_cpu_wrap(tgt_cpu, alloced_mask, q_num + 1) {
> +				if (tgt_cpu =3D=3D q_num)
> +					continue;
> +				channel =3D stor_device->stor_chns[tgt_cpu];
> +				if (hv_get_avail_to_write_percent(
> +							&channel->outbound)
> +						> ring_avail_percent_lowater) {
> +					outgoing_channel =3D channel;
> +					goto found_channel;
> +				}
> +			}
> +
> +			/*
> +			 * All the other channels on the same NUMA node are
> +			 * busy. Try to use the channel on the current CPU
> +			 */
> +			if (hv_get_avail_to_write_percent(
> +						&outgoing_channel->outbound)
> +					> ring_avail_percent_lowater)
> +				goto found_channel;
> +
> +			/*
> +			 * If we reach here, all the channels on the current
> +			 * NUMA node are busy. Try to find a channel in
> +			 * other NUMA nodes
> +			 */
> +			cpumask_andnot(alloced_mask, &stor_device->alloced_cpus,
> +					cpumask_of_node(cpu_to_node(q_num)));
> +
> +			for_each_cpu(tgt_cpu, alloced_mask) {
> +				channel =3D stor_device->stor_chns[tgt_cpu];
> +				if (hv_get_avail_to_write_percent(
> +							&channel->outbound)
> +						> ring_avail_percent_lowater) {
> +					outgoing_channel =3D channel;
> +					goto found_channel;
>  				}
>  			}
>  		}
> @@ -1324,7 +1376,7 @@ static int storvsc_do_io(struct hv_device *device,
>  		outgoing_channel =3D get_og_chn(stor_device, q_num);
>  	}
>=20
> -
> +found_channel:
>  	vstor_packet->flags |=3D REQUEST_COMPLETION_FLAG;
>=20
>  	vstor_packet->vm_srb.length =3D (sizeof(struct vmscsi_request) -
> @@ -1732,8 +1784,9 @@ static int storvsc_probe(struct hv_device *device,
>  				(num_cpus - 1) / storvsc_vcpus_per_sub_channel;
>  	}
>=20
> -	scsi_driver.can_queue =3D (max_outstanding_req_per_channel *
> -				 (max_sub_channels + 1));
> +	scsi_driver.can_queue =3D max_outstanding_req_per_channel *
> +				(max_sub_channels + 1) *
> +				(100 - ring_avail_percent_lowater) / 100;
>=20
>  	host =3D scsi_host_alloc(&scsi_driver,
>  			       sizeof(struct hv_host_device));
> @@ -1864,6 +1917,7 @@ static int storvsc_probe(struct hv_device *device,
>=20
>  err_out1:
>  	kfree(stor_device->stor_chns);
> +	kfree(stor_device->cpumask_chns);
>  	kfree(stor_device);

I don't think the memory freeing in err_out1 is correct.  You end up
in err_out1 when storvsc_connect_to_vsp() fails.  But it could fail in
multiple scenarios, some of which leave cpumask_chns allocated, and
some of which don't.   As a result you could free memory that isn't allocat=
ed
or that has already been freed.  In fact, the same problem already exists
for stor_chns.  I'm not sure about stor_device itself.

>=20
>  err_out0:
> --
> 2.14.1
