From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V6 5/5] virtio-scsi: reset virtqueue affinity when doing
	cpu hotplug
Date: Wed, 20 Mar 2013 15:56:31 +0800
Message-ID: <51496BAF.2030202@cn.fujitsu.com>
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363762884-11000-6-git-send-email-gaowanlong@cn.fujitsu.com>
	<20130320072425.GA23182@hj.localdomain>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20130320072425.GA23182@hj.localdomain>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Asias He <asias@redhat.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 03/20/2013 03:24 PM, Asias He wrote:
> On Wed, Mar 20, 2013 at 03:01:24PM +0800, Wanlong Gao wrote:
>> Add hot cpu notifier to reset the request virtqueue affinity
>> when doing cpu hotplug.
>>
>> Cc: linux-scsi@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>> Reviewed-by: Asias He <asias@redhat.com>
>> ---
>>  drivers/scsi/virtio_scsi.c | 29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 13d7672..0ad9017 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -110,6 +110,9 @@ struct virtio_scsi {
>>  	/* if the affinity hint is set for virtqueues */
>>  	bool affinity_hint_set;
>>  
>> +	/* CPU hotplug notifier */
>> +	struct notifier_block nb;
>> +
>>  	struct virtio_scsi_vq ctrl_vq;
>>  	struct virtio_scsi_vq event_vq;
>>  	struct virtio_scsi_vq req_vqs[];
>> @@ -762,6 +765,23 @@ static void virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
>>  	put_online_cpus();
>>  }
>>  
>> +static int virtscsi_cpu_callback(struct notifier_block *nfb,
>> +				 unsigned long action, void *hcpu)
>> +{
>> +	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
>> +	switch(action) {
>> +	case CPU_ONLINE:
>> +	case CPU_ONLINE_FROZEN:
>> +	case CPU_DEAD:
>> +	case CPU_DEAD_FROZEN:
>> +		__virtscsi_set_affinity(vscsi, true);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return NOTIFY_OK;
>> +}
>> +
>>  static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>>  			     struct virtqueue *vq)
>>  {
>> @@ -884,6 +904,13 @@ static int virtscsi_probe(struct virtio_device *vdev)
>>  	if (err)
>>  		goto virtscsi_init_failed;
>>  
>> +	vscsi->nb.notifier_call = &virtscsi_cpu_callback;
>> +	err = register_hotcpu_notifier(&vscsi->nb);
>> +	if (err) {
>> +		pr_err("registering cpu notifier failed\n");
>> +		goto scsi_add_host_failed;
>> +	}
>> +
>>  	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
>>  	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
>>  	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
>> @@ -921,6 +948,8 @@ static void virtscsi_remove(struct virtio_device *vdev)
>>  
>>  	scsi_remove_host(shost);
>>  
>> +	unregister_hotcpu_notifier(&vscsi->nb);
>> +
>>  	virtscsi_remove_vqs(vdev);
>>  	scsi_host_put(shost);
>>  }
>> -- 
>> 1.8.2.rc2
>>
> 
> This one does not apply on top of virtio-next + patch 1-4 in this series.

I'm very sorry.

This fault is because I modified the 4/5 from 
"/* if the affinity hint is set for virtqueues */"
to
"/* If the affinity hint is set for virtqueues */"
by hand.

You can also change "If" to "if" in 5/5 to apply this patch without 3-way merge.

Thanks,
Wanlong Gao

> 
