From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 4/4] scsi: storvsc: Tighten up the interrupt path
Date: Mon, 21 Dec 2015 08:28:22 -0800
Message-ID: <1450715302.22583.8.camel@HansenPartnership.com>
References: <1450038486-19211-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-4-git-send-email-kys@microsoft.com>
 <5673C92B.5070602@suse.de>
 <BY2PR0301MB16544C0D5B825A54AA0319DFA0E10@BY2PR0301MB1654.namprd03.prod.outlook.com>
 <1450457288.2439.7.camel@HansenPartnership.com>
 <BY2PR0301MB1654C8B001A86200B918B9DFA0E20@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <BY2PR0301MB1654C8B001A86200B918B9DFA0E20@BY2PR0301MB1654.namprd03.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2015-12-19 at 02:28 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com
> > ]
> > Sent: Friday, December 18, 2015 8:48 AM
> > To: KY Srinivasan <kys@microsoft.com>; Hannes Reinecke <
> > hare@suse.de>;
> > gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com;
> > jbottomley@parallels.com; hch@infradead.org; 
> > linux-scsi@vger.kernel.org;
> > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > martin.petersen@oracle.com
> > Subject: Re: [PATCH V3 4/4] scsi: storvsc: Tighten up the interrupt
> > path
> > 
> > On Fri, 2015-12-18 at 16:20 +0000, KY Srinivasan wrote:
> > > 
> > > > -----Original Message-----
> > > > From: Hannes Reinecke [mailto:hare@suse.de]
> > > > Sent: Friday, December 18, 2015 12:52 AM
> > > > To: KY Srinivasan <kys@microsoft.com>; 
> > > > gregkh@linuxfoundation.org;
> > > > linux-
> > > > kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > > ohering@suse.com;
> > > > jbottomley@parallels.com; hch@infradead.org;
> > > > linux-scsi@vger.kernel.org;
> > > > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > > > martin.petersen@oracle.com
> > > > Subject: Re: [PATCH V3 4/4] scsi: storvsc: Tighten up the
> > > > interrupt
> > > > path
> > > > 
> > > > On 12/13/2015 09:28 PM, K. Y. Srinivasan wrote:
> > > > > On the interrupt path, we repeatedly establish the pointer to
> > > > > the
> > > > > storvsc_device. Fix this.
> > > > > 
> > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > Reviewed-by: Long Li <longli@microsoft.com>
> > > > > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> > > > > Tested-by: Alex Ng <alexng@microsoft.com>
> > > > > ---
> > > > >   drivers/scsi/storvsc_drv.c |   23 ++++++++---------------
> > > > >   1 files changed, 8 insertions(+), 15 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/scsi/storvsc_drv.c
> > > > > b/drivers/scsi/storvsc_drv.c
> > > > > index d6ca4f2..b68aebe 100644
> > > > > --- a/drivers/scsi/storvsc_drv.c
> > > > > +++ b/drivers/scsi/storvsc_drv.c
> > > > > @@ -945,19 +945,16 @@ static void storvsc_handle_error(struct
> > > > vmscsi_request *vm_srb,
> > > > >   }
> > > > > 
> > > > > 
> > > > > -static void storvsc_command_completion(struct
> > > > > storvsc_cmd_request
> > > > *cmd_request)
> > > > > +static void storvsc_command_completion(struct
> > > > > storvsc_cmd_request
> > > > *cmd_request,
> > > > > +				       struct storvsc_device
> > > > > *stor_dev)
> > > > >   {
> > > > >   	struct scsi_cmnd *scmnd = cmd_request->cmd;
> > > > > -	struct hv_host_device *host_dev = shost_priv(scmnd
> > > > > ->device-
> > > > > host);
> > > > >   	struct scsi_sense_hdr sense_hdr;
> > > > >   	struct vmscsi_request *vm_srb;
> > > > >   	struct Scsi_Host *host;
> > > > > -	struct storvsc_device *stor_dev;
> > > > > -	struct hv_device *dev = host_dev->dev;
> > > > >   	u32 payload_sz = cmd_request->payload_sz;
> > > > >   	void *payload = cmd_request->payload;
> > > > > 
> > > > > -	stor_dev = get_in_stor_device(dev);
> > > > >   	host = stor_dev->host;
> > > > > 
> > > > >   	vm_srb = &cmd_request->vstor_packet.vm_srb;
> > > > > @@ -987,14 +984,13 @@ static void
> > > > > storvsc_command_completion(struct
> > > > storvsc_cmd_request *cmd_request)
> > > > >   		kfree(payload);
> > > > >   }
> > > > > 
> > > > > -static void storvsc_on_io_completion(struct hv_device
> > > > > *device,
> > > > > +static void storvsc_on_io_completion(struct storvsc_device
> > > > > *stor_device,
> > > > >   				  struct vstor_packet
> > > > > *vstor_packet,
> > > > >   				  struct
> > > > > storvsc_cmd_request
> > > > > *request)
> > > > >   {
> > > > > -	struct storvsc_device *stor_device;
> > > > >   	struct vstor_packet *stor_pkt;
> > > > > +	struct hv_device *device = stor_device->device;
> > > > > 
> > > > > -	stor_device = hv_get_drvdata(device);
> > > > >   	stor_pkt = &request->vstor_packet;
> > > > > 
> > > > >   	/*
> > > > > @@ -1049,7 +1045,7 @@ static void
> > > > > storvsc_on_io_completion(struct
> > > > hv_device *device,
> > > > >   	stor_pkt->vm_srb.data_transfer_length =
> > > > >   	vstor_packet->vm_srb.data_transfer_length;
> > > > > 
> > > > > -	storvsc_command_completion(request);
> > > > > +	storvsc_command_completion(request, stor_device);
> > > > > 
> > > > >   	if (atomic_dec_and_test(&stor_device
> > > > > ->num_outstanding_req) &&
> > > > >   		stor_device->drain_notify)
> > > > > @@ -1058,21 +1054,19 @@ static void
> > > > > storvsc_on_io_completion(struct
> > > > hv_device *device,
> > > > > 
> > > > >   }
> > > > > 
> > > > > -static void storvsc_on_receive(struct hv_device *device,
> > > > > +static void storvsc_on_receive(struct storvsc_device
> > > > > *stor_device,
> > > > >   			     struct vstor_packet
> > > > > *vstor_packet,
> > > > >   			     struct storvsc_cmd_request
> > > > > *request)
> > > > >   {
> > > > >   	struct storvsc_scan_work *work;
> > > > > -	struct storvsc_device *stor_device;
> > > > > 
> > > > >   	switch (vstor_packet->operation) {
> > > > >   	case VSTOR_OPERATION_COMPLETE_IO:
> > > > > -		storvsc_on_io_completion(device,
> > > > > vstor_packet,
> > > > > request);
> > > > > +		storvsc_on_io_completion(stor_device,
> > > > > vstor_packet,
> > > > request);
> > > > >   		break;
> > > > > 
> > > > >   	case VSTOR_OPERATION_REMOVE_DEVICE:
> > > > >   	case VSTOR_OPERATION_ENUMERATE_BUS:
> > > > > -		stor_device = get_in_stor_device(device);
> > > > >   		work = kmalloc(sizeof(struct
> > > > > storvsc_scan_work),
> > > > GFP_ATOMIC);
> > > > >   		if (!work)
> > > > >   			return;
> > > > > @@ -1083,7 +1077,6 @@ static void storvsc_on_receive(struct
> > > > > hv_device
> > > > *device,
> > > > >   		break;
> > > > > 
> > > > >   	case VSTOR_OPERATION_FCHBA_DATA:
> > > > > -		stor_device = get_in_stor_device(device);
> > > > >   		cache_wwn(stor_device, vstor_packet);
> > > > >   #ifdef CONFIG_SCSI_FC_ATTRS
> > > > >   		fc_host_node_name(stor_device->host) =
> > > > > stor_device-
> > > > > node_name;
> > > > > @@ -1133,7 +1126,7 @@ static void
> > > > > storvsc_on_channel_callback(void
> > > > *context)
> > > > >   					vmscsi_size_delta))
> > > > > ;
> > > > >   				complete(&request
> > > > > ->wait_event);
> > > > >   			} else {
> > > > > -				storvsc_on_receive(device,
> > > > > +				storvsc_on_receive(stor_devi
> > > > > ce,
> > > > >   						(struct
> > > > > vstor_packet
> > > > *)packet,
> > > > >   						request);
> > > > >   			}
> > > > > 
> > > > Hmm. I would've thought the compiler optimizes this away. Have
> > > > you
> > > > checked whether it actually makes a difference in the assembler
> > > > output?
> > > 
> > > I have not checked the assembler output. It was easy enough to
> > > fix
> > > the source.
> > 
> > Could you?  You're making what you describe as an optimisation but
> > there are two reasons why this might not be so.  The first is that
> > the
> > compiler is entitled to inline static functions.  If it did, likely
> > it
> > picked up the optmisation anyway as Hannes suggested.  However, the
> > other reason this might not be an optimisation (assuming the
> > compiler
> > doesn't inline the function) is you're passing an argument which
> > can be
> > offset computed.  On all architectures, you have a fixed number of
> > registers for passing function arguments, then we have to use the
> > stack.  Using the stack comes in far more expensive than computing
> > an
> > offset to an existing pointer.  Even if you're still in registers,
> > the
> > offset now has to be computed and stored and the compiler loses
> > track
> > of the relation.
> > 
> > The bottom line is that adding an extra argument for a value which
> > can
> > be offset computed is rarely a win.
> 
> James,
> When I did this, I was mostly concerned about the cost of
> reestablishing state that was
> already known. So, even with the function being in-lined, I felt the
> cost of reestablishing
> state that was already known is unnecessary. In this particular case,
> I did not change the
> number of arguments that were being passed; I just changed the type
> of one of them -
> instead of passing struct hv_device *, I am now passing struct
> storvsc_device *. In the
> current code, we are using struct hv_device * to establish a pointer
> to struct storvsc_device *
> via the function get_in_stor_device(). This pattern currently exists
> in the call chain from the
> interrupt handler - storvsc_on_channel_callback().
> 
> While the compiler is smart enough to inline both
> get_in_stor_device() as well as many of the static
> functions in the call chain from storvsc_on_channel_callback(),
> looking at the assembled code,
> the compiler is repeatedly inlining the call to get_in_stor_device() 
> and this clearly is less than optimal.

OK, so the reason for the recomputation is the destruction condition
check which is evaluated every time you call it?  Perhaps what you
simply want is an __get_in_stor_device() that does the offset
mathematics without the destruction check.  It's doing exactly what
passing the additional parameter does: the calling function is taking
on the burden of verifying they've got a device which is still valid.

I'm not making this a hard requirement for reviewing the code: you have
arguments to spare in the functions, so I don't think it matters which
way this is done.  I do, however, think it makes consumers of the stor
device think about why they're using it and whether they actually need
the destruct check.

James
