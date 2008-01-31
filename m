From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [linux-usb-devel] 2.6.24: NULL scatter-gather pointer in usb_storage:usb_stor_access_xfer_buf?
Date: Thu, 31 Jan 2008 17:17:52 +0200
Message-ID: <47A1E6A0.8050500@panasas.com>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org>	<47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080131070846.4464eb3c-uevSgErl2ChVvDCLMmKh5Q@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 31 2008 at 17:08 +0200, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org> wrote:
> On Thu, 31 Jan 2008 11:27:39 +0200
> Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> Please check the below patch.
>>
>> one thing that I can see is that the isd200 does an INQUARY transfer
>> of sizeof(struct inquiry_data) which is 96 bytes, when scsi_scan.c
>> sends an INQUARY with 36 bytes buffer. So we have an underflow in 
>> usb_stor_access_xfer_buf().
>>
>> The below patch will only check my theory. I will send a proper fix
>> later, please confirm that this fixes it.
>>
>> What kills me is that this condition has existed before my patch, I'll
>> try to see why it is triggered now
> 
> I applied this patch to 2.6.24, and it now works for me.  It was
> crashing consistently whenever I'd plug this device in, now it goes
> through successfully:
> 
Yes Thanks this is grate :)

I will send a proper patch to scsi maintainer. Alan is it OK to send this
patch threw James's scsi-misc?

> 
> [24775.788039] usb 3-2: new full speed USB device using uhci_hcd and address 3
> [24775.939275] usb 3-2: configuration #1 chosen from 1 choice
> [24776.084409] usbcore: registered new interface driver libusual
> [24776.103604] Initializing USB Mass Storage driver...
> [24776.213916] scsi3 : SCSI emulation for USB Mass Storage devices
> [24776.214366] usbcore: registered new interface driver usb-storage
> [24776.214377] USB Mass Storage support registered.
> [24776.215604] usb-storage: device found at 3
> [24776.215724] usb-storage: waiting for device to settle before scanning
> [24778.333378] scsi 3:0:0:0: Direct-Access     SAMSUNG  HM120JC          YL10 PQ: 0 ANSI: 0
> [24778.333715] sd 3:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
> [24778.333841] sd 3:0:0:0: [sdb] Write Protect is off
> [24778.333848] sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
> [24778.333853] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> [24778.334196] sd 3:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
> [24778.334396] sd 3:0:0:0: [sdb] Write Protect is off
> [24778.334403] sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
> [24778.334408] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> [24778.334414]  sdb: sdb1
> [24778.824103] sd 3:0:0:0: [sdb] Attached SCSI disk
> [24778.824210] sd 3:0:0:0: Attached scsi generic sg1 type 0
> [24778.825119] usb-storage: device scan complete
> 
> 
> I'm happy to test further patches.  Let me know if you need more
> testing.
> 
> Do you still want me to try out the scsi-misc branch?
> 
No, That was my mistake, scsi-misc is now identical to mainline.

This here is a new fix that will need to go in. I will send a patch
soonish. If you can test it and send a Tested-by: it could be grate

> Mark
> 
> 
>> ---
>>  drivers/usb/storage/protocol.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/storage/protocol.c
>> b/drivers/usb/storage/protocol.c index a41ce21..d0ff1f6 100644
>> --- a/drivers/usb/storage/protocol.c
>> +++ b/drivers/usb/storage/protocol.c
>> @@ -229,6 +229,12 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
>>  	unsigned int offset = 0;
>>  	struct scatterlist *sg = NULL;
>>  
>> +	BUG_ON(!scsi_sglist(srb));
>> +
>> +	if(buflen > scsi_bufflen(srb))
>> +		buflen = scsi_bufflen(srb);
>> +		/*FIXME: should we set an underflow condition here*/
>> +
>>  	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>>  			TO_XFER_BUF);
>>  	if (buflen < scsi_bufflen(srb))
>>

Thanks Mark
(CCing linux-scsi ml)

Boaz
