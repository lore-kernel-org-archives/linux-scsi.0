From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Numerous problems, partial success getting
 FujiFilm Finepix 3800 to work under 2.6.
Date: Tue, 20 Apr 2004 15:41:07 -0400 (EDT)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0404201527310.1247-100000@ida.rowland.org>
References: <40856AFF.7070002@nogin.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <40856AFF.7070002@nogin.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Aleksey Nogin <aleksey@nogin.org>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2004, Aleksey Nogin wrote:

> I am having trouble getting my FujiFilm Finepix 3800 camera to work with
> the 2.6.5 kernel (under Fedora Core Development - AKA Red Hat Raw Hide).
> It worked fine under 2.4 (both in Fedora Core 1 and Red Hat Linux 9, I
> believe).
> 
> After a lot of messing up and some blind experimentations with 
> unusual_devs.h I have been successful in making camera work, but _only_ 
> when it is connected directly to the computer, not via a hub with other 
> devices attached.

That doesn't make much sense.  Your original setup, with no unusual_devs.h 
entry, should have worked the same regardless of whether there was an 
external hub.

> My setup (which used to work under 2.4) is a follows: I have an external 
> hub connected to my laptop and I have a mouse, a printer and the camera 
> is question connected to the hub.
> 
> I have tried the following:
> 
> ------------ Attempt (0) --------------
> Using it w/o any changes to the kernel - both via hub and connecting 
> directly. It did not work:
> 
> usb 1-1: new full speed USB device using address 8
> SCSI subsystem initialized
> Initializing USB Mass Storage driver...
> scsi0 : SCSI emulation for USB Mass Storage devices
> USB Mass Storage device found at 8
> drivers/usb/core/usb.c: registered new driver usb-storage
> USB Mass Storage support registered.
> 
> and the usb_storage and scsi_mod modules get loaded. However, the camera
> does not seem to get "attached" to any specific /dev/xyz (or /udev/xyz
> for that matter) - e.g. when I try to access /dev/sda, I get "No such
> device or address".


> ------------- Attempt (1) ------------------
> Next I have compiled the kernel with CONFIG_USB_STORAGE_DEBUG enabled. 
> Now when I plugged the camera I saw the following:
> 
> usb 1-1.3: new full speed USB device using address 5
> Initializing USB Mass Storage driver...
> usb-storage: USB Mass Storage device detected
> usb-storage: altsetting is 0, id_index is 112
> usb-storage: -- associate_dev
> usb-storage: Transport: Control/Bulk/Interrupt
> usb-storage: Protocol: 8070i
> usb-storage: Endpoints: In: 0xdfc3c2c0 Out: 0xdfc3c2d4 Int: 0xdfc3c2e8 
> (Period 1)
> usb-storage: *** thread sleeping.
> scsi0 : SCSI emulation for USB Mass Storage devices
> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Command INQUIRY (6 bytes)
> usb-storage:  12 00 00 00 24 00
> usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 
> len=12
> usb-storage: Status code 0; transferred 12/12
> usb-storage: -- transfer complete
> usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
> usb-storage: Status code 0; transferred 36/36
> usb-storage: -- transfer complete
> usb-storage: CBI data stage result is 0x0
> usb-storage: usb_stor_intr_transfer: xfer 2 bytes
> usb-storage: Status code 0; transferred 2/2
> usb-storage: -- transfer complete
> usb-storage: Got interrupt data (0x29, 0x0)
> usb-storage: CBI IRQ data showed reserved bType 0x29
> usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
> usb-storage: usb_stor_clear_halt: result = 0
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 
> len=12
> usb-storage: Status code 0; transferred 12/12
> usb-storage: -- transfer complete
> usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
> usb-storage: Status code 0; transferred 18/18
> usb-storage: -- transfer complete
> usb-storage: CBI data stage result is 0x0
> usb-storage: usb_stor_intr_transfer: xfer 2 bytes
> usb-storage: Status code 0; transferred 2/2
> usb-storage: -- transfer complete
> usb-storage: Got interrupt data (0x0, 0x0)
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
> usb-storage: Unit Attention: Power on, reset, or bus device reset occurred
> usb-storage: scsi cmd done, result=0x2
> usb-storage: *** thread sleeping.

That much is fairly normal.  Your camera should not have replied with Unit 
Attention status to the INQUIRY command, but it's a fairly common mistake.  
The SCSI core wasn't expecting it, though, and as a result believed your 
camera was an invalid device.  That's why you couldn't use it.

> usb-storage: queuecommand called
> usb-storage: *** thread awakened.
> usb-storage: Bad target number (1:0)
> usb-storage: scsi cmd done, result=0x40000
> usb-storage: *** thread sleeping.

As you can see, instead of repeating the INQUIRY command the SCSI driver 
moved on to the next target.

This patch may improve things.  Try it, with nothing added to
unusual_devs.h, and see if it works even with an external hub.

Alan Stern



===== scsi_scan.c 1.57 vs edited =====
--- 1.57/drivers/scsi/scsi_scan.c	Wed Mar 17 14:05:26 2004
+++ edited/drivers/scsi/scsi_scan.c	Tue Apr 20 15:35:52 2004
@@ -355,10 +355,12 @@
 	if (sreq->sr_result) {
 		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
 		    (sreq->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION &&
-		    sreq->sr_sense_buffer[12] == 0x28 &&
+		    (sreq->sr_sense_buffer[12] == 0x28 ||
+		     sreq->sr_sense_buffer[12] == 0x29) &&
 		    sreq->sr_sense_buffer[13] == 0) {
-			/* not-ready to ready transition - good */
+			/* not-ready to ready transition or power-on - good */
 			/* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
+			/* Supposedly, but many buggy devices do so anyway */
 		} else
 			/*
 			 * assume no peripheral if any other sort of error




-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
