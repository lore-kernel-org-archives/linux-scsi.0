From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/4] scsi: storvsc: Tighten up the interrupt path
Date: Fri, 11 Dec 2015 10:12:45 +0100
Message-ID: <20151211091245.GF9903@c203.arch.suse.de>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-4-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1449792860-15447-4-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 04:14:20PM -0800, K. Y. Srinivasan wrote:
> On the interrupt path, we repeatedly establish the pointer to the
> storvsc_device. Fix this.
> =

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   23 ++++++++---------------
>  1 files changed, 8 insertions(+), 15 deletions(-)
> =

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 6f18e94..8ba9908 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -958,19 +958,16 @@ static void storvsc_handle_error(struct vmscsi_requ=
est *vm_srb,
>  }
>  =

>  =

> -static void storvsc_command_completion(struct storvsc_cmd_request *cmd_r=
equest)
> +static void storvsc_command_completion(struct storvsc_cmd_request *cmd_r=
equest,
> +				       struct storvsc_device *stor_dev)
>  {
>  	struct scsi_cmnd *scmnd =3D cmd_request->cmd;
> -	struct hv_host_device *host_dev =3D shost_priv(scmnd->device->host);
>  	struct scsi_sense_hdr sense_hdr;
>  	struct vmscsi_request *vm_srb;
>  	struct Scsi_Host *host;
> -	struct storvsc_device *stor_dev;
> -	struct hv_device *dev =3D host_dev->dev;
>  	u32 payload_sz =3D cmd_request->payload_sz;
>  	void *payload =3D cmd_request->payload;
>  =

> -	stor_dev =3D get_in_stor_device(dev);
>  	host =3D stor_dev->host;
>  =

>  	vm_srb =3D &cmd_request->vstor_packet.vm_srb;
> @@ -1000,14 +997,13 @@ static void storvsc_command_completion(struct stor=
vsc_cmd_request *cmd_request)
>  		kfree(payload);
>  }
>  =

> -static void storvsc_on_io_completion(struct hv_device *device,
> +static void storvsc_on_io_completion(struct storvsc_device *stor_device,
>  				  struct vstor_packet *vstor_packet,
>  				  struct storvsc_cmd_request *request)
>  {
> -	struct storvsc_device *stor_device;
>  	struct vstor_packet *stor_pkt;
> +	struct hv_device *device =3D stor_device->device;
>  =

> -	stor_device =3D hv_get_drvdata(device);
>  	stor_pkt =3D &request->vstor_packet;
>  =

>  	/*
> @@ -1062,7 +1058,7 @@ static void storvsc_on_io_completion(struct hv_devi=
ce *device,
>  	stor_pkt->vm_srb.data_transfer_length =3D
>  	vstor_packet->vm_srb.data_transfer_length;
>  =

> -	storvsc_command_completion(request);
> +	storvsc_command_completion(request, stor_device);
>  =

>  	if (atomic_dec_and_test(&stor_device->num_outstanding_req) &&
>  		stor_device->drain_notify)
> @@ -1071,21 +1067,19 @@ static void storvsc_on_io_completion(struct hv_de=
vice *device,
>  =

>  }
>  =

> -static void storvsc_on_receive(struct hv_device *device,
> +static void storvsc_on_receive(struct storvsc_device *stor_device,
>  			     struct vstor_packet *vstor_packet,
>  			     struct storvsc_cmd_request *request)
>  {
>  	struct storvsc_scan_work *work;
> -	struct storvsc_device *stor_device;
>  =

>  	switch (vstor_packet->operation) {
>  	case VSTOR_OPERATION_COMPLETE_IO:
> -		storvsc_on_io_completion(device, vstor_packet, request);
> +		storvsc_on_io_completion(stor_device, vstor_packet, request);
>  		break;
>  =

>  	case VSTOR_OPERATION_REMOVE_DEVICE:
>  	case VSTOR_OPERATION_ENUMERATE_BUS:
> -		stor_device =3D get_in_stor_device(device);
>  		work =3D kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
>  		if (!work)
>  			return;
> @@ -1096,7 +1090,6 @@ static void storvsc_on_receive(struct hv_device *de=
vice,
>  		break;
>  =

>  	case VSTOR_OPERATION_FCHBA_DATA:
> -		stor_device =3D get_in_stor_device(device);
>  		cache_wwn(stor_device, vstor_packet);
>  		fc_host_node_name(stor_device->host) =3D stor_device->node_name;
>  		fc_host_port_name(stor_device->host) =3D stor_device->port_name;
> @@ -1144,7 +1137,7 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>  					vmscsi_size_delta));
>  				complete(&request->wait_event);
>  			} else {
> -				storvsc_on_receive(device,
> +				storvsc_on_receive(stor_device,
>  						(struct vstor_packet *)packet,
>  						request);
>  			}
> -- =

> 1.7.4.1
> =

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
