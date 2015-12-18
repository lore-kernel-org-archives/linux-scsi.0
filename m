From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V3 4/4] scsi: storvsc: Tighten up the interrupt path
Date: Fri, 18 Dec 2015 16:20:00 +0000
Message-ID: <BY2PR0301MB16544C0D5B825A54AA0319DFA0E10@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1450038486-19211-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-4-git-send-email-kys@microsoft.com>
 <5673C92B.5070602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5673C92B.5070602@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, December 18, 2015 12:52 AM
> To: KY Srinivasan <kys@microsoft.com>; gregkh@linuxfoundation.org; li=
nux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.co=
m;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.o=
rg;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com
> Subject: Re: [PATCH V3 4/4] scsi: storvsc: Tighten up the interrupt p=
ath
>=20
> On 12/13/2015 09:28 PM, K. Y. Srinivasan wrote:
> > On the interrupt path, we repeatedly establish the pointer to the
> > storvsc_device. Fix this.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Long Li <longli@microsoft.com>
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Tested-by: Alex Ng <alexng@microsoft.com>
> > ---
> >   drivers/scsi/storvsc_drv.c |   23 ++++++++---------------
> >   1 files changed, 8 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.=
c
> > index d6ca4f2..b68aebe 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -945,19 +945,16 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
> >   }
> >
> >
> > -static void storvsc_command_completion(struct storvsc_cmd_request
> *cmd_request)
> > +static void storvsc_command_completion(struct storvsc_cmd_request
> *cmd_request,
> > +				       struct storvsc_device *stor_dev)
> >   {
> >   	struct scsi_cmnd *scmnd =3D cmd_request->cmd;
> > -	struct hv_host_device *host_dev =3D shost_priv(scmnd->device-
> >host);
> >   	struct scsi_sense_hdr sense_hdr;
> >   	struct vmscsi_request *vm_srb;
> >   	struct Scsi_Host *host;
> > -	struct storvsc_device *stor_dev;
> > -	struct hv_device *dev =3D host_dev->dev;
> >   	u32 payload_sz =3D cmd_request->payload_sz;
> >   	void *payload =3D cmd_request->payload;
> >
> > -	stor_dev =3D get_in_stor_device(dev);
> >   	host =3D stor_dev->host;
> >
> >   	vm_srb =3D &cmd_request->vstor_packet.vm_srb;
> > @@ -987,14 +984,13 @@ static void storvsc_command_completion(struct
> storvsc_cmd_request *cmd_request)
> >   		kfree(payload);
> >   }
> >
> > -static void storvsc_on_io_completion(struct hv_device *device,
> > +static void storvsc_on_io_completion(struct storvsc_device *stor_d=
evice,
> >   				  struct vstor_packet *vstor_packet,
> >   				  struct storvsc_cmd_request *request)
> >   {
> > -	struct storvsc_device *stor_device;
> >   	struct vstor_packet *stor_pkt;
> > +	struct hv_device *device =3D stor_device->device;
> >
> > -	stor_device =3D hv_get_drvdata(device);
> >   	stor_pkt =3D &request->vstor_packet;
> >
> >   	/*
> > @@ -1049,7 +1045,7 @@ static void storvsc_on_io_completion(struct
> hv_device *device,
> >   	stor_pkt->vm_srb.data_transfer_length =3D
> >   	vstor_packet->vm_srb.data_transfer_length;
> >
> > -	storvsc_command_completion(request);
> > +	storvsc_command_completion(request, stor_device);
> >
> >   	if (atomic_dec_and_test(&stor_device->num_outstanding_req) &&
> >   		stor_device->drain_notify)
> > @@ -1058,21 +1054,19 @@ static void storvsc_on_io_completion(struct
> hv_device *device,
> >
> >   }
> >
> > -static void storvsc_on_receive(struct hv_device *device,
> > +static void storvsc_on_receive(struct storvsc_device *stor_device,
> >   			     struct vstor_packet *vstor_packet,
> >   			     struct storvsc_cmd_request *request)
> >   {
> >   	struct storvsc_scan_work *work;
> > -	struct storvsc_device *stor_device;
> >
> >   	switch (vstor_packet->operation) {
> >   	case VSTOR_OPERATION_COMPLETE_IO:
> > -		storvsc_on_io_completion(device, vstor_packet, request);
> > +		storvsc_on_io_completion(stor_device, vstor_packet,
> request);
> >   		break;
> >
> >   	case VSTOR_OPERATION_REMOVE_DEVICE:
> >   	case VSTOR_OPERATION_ENUMERATE_BUS:
> > -		stor_device =3D get_in_stor_device(device);
> >   		work =3D kmalloc(sizeof(struct storvsc_scan_work),
> GFP_ATOMIC);
> >   		if (!work)
> >   			return;
> > @@ -1083,7 +1077,6 @@ static void storvsc_on_receive(struct hv_devi=
ce
> *device,
> >   		break;
> >
> >   	case VSTOR_OPERATION_FCHBA_DATA:
> > -		stor_device =3D get_in_stor_device(device);
> >   		cache_wwn(stor_device, vstor_packet);
> >   #ifdef CONFIG_SCSI_FC_ATTRS
> >   		fc_host_node_name(stor_device->host) =3D stor_device-
> >node_name;
> > @@ -1133,7 +1126,7 @@ static void storvsc_on_channel_callback(void
> *context)
> >   					vmscsi_size_delta));
> >   				complete(&request->wait_event);
> >   			} else {
> > -				storvsc_on_receive(device,
> > +				storvsc_on_receive(stor_device,
> >   						(struct vstor_packet
> *)packet,
> >   						request);
> >   			}
> >
> Hmm. I would've thought the compiler optimizes this away. Have you
> checked whether it actually makes a difference in the assembler outpu=
t?

I have not checked the assembler output. It was easy enough to fix the =
source.

K. Y
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
