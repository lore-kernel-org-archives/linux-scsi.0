From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-starge not working in the latest kernel 2.4
Date: Fri, 5 Sep 2003 11:31:30 -0400 (EDT)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0309051106080.982-100000@ida.rowland.org>
References: <200309051115.UAA22250@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <200309051115.UAA22250@toshiba.co.jp>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Fri, 5 Sep 2003, Tomita, Haruo wrote:

> I tested using kernel 2.4.22-bk6. It failed by the following two patterns.
> 1. Bulk command transfer result=-104
> 2.  usb_stor_bulk_msg() returned -32

This was two different failures on two separate runs?

> The detailed message is as follows.
> 
> 1. Bulk command transfer result=-104

> usb-storage: Command READ_10 (10 bytes)
> usb-storage: 28 00 00 01 ce 22 00 00 3f 00 00 00
> usb-storage: Bulk command S 0x43425355 T 0x93534f Trg 0 LUN 0 L 129024 F 128 CL 12
> usb-storage: command_abort() called
> usb-storage: Bulk command transfer result=-104
> usb-storage: -- transport indicates command was aborted

This was the same sort of pattern we saw before.  No data was transferred
from the drive, and the command timed out and was aborted.

> usb-storage: bus_reset() called
> hub.c: port 1, portstatus 511, change 0, 480 Mb/s
> hub.c: port 1 of hub 1 not reset yet, waiting 10ms
> hub.c: port 1, portstatus 511, change 0, 480 Mb/s
> hub.c: port 1 of hub 1 not reset yet, waiting 10ms
> ehci_hcd 00:0c.2: port 1 high speed
> ehci_hcd 00:0c.2: GetStatus port 1 status 001005 POWER sig=se0  PE CONNECT
> hub.c: port 1, portstatus 503, change 10, 480 Mb/s
> usb.c: ignoring set_interface for dev 3, iface 0, alt 0
> usb-storage: Examinging driver usb-storage...skipping ourselves.
> usb-storage: bus_reset() complete

This time the bus_reset() routine worked, which is an improvement over 
what you were seeing before.  But the device still didn't respond:

> usb-storage: queuecommand() called
> usb-storage: *** thread awakened.
> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage: 00 00 00 00 00 00 00 00 3f 00 00 00
> usb-storage: Bulk command S 0x43425355 T 0x935351 Trg 0 LUN 0 L 0 F 0 CL 12
> usb-storage: Bulk command transfer result=0
> usb-storage: Attempting to get CSW...
> usb-storage: command_abort() called
> usb-storage: -- transport indicates command was aborted
> usb-storage: Bulk reset requested
> usb_control/bulk_msg: timeout
> usb-storage: Bulk soft reset failed -110
> usb-storage: scsi command aborted
> usb-storage: *** thread sleeping.
> scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
> SCSI cdrom error : host 0 channel 0 id 0 lun 0 return code = 50000
>  I/O error: dev 0b:00, sector 473224
>  I/O error: dev 0b:00, sector 473228
>  I/O error: dev 0b:00, sector 473476
>  I/O error: dev 0b:00, sector 473224

Once that happened there were no error recovery procedures left to try, so 
the driver gave up and marked the device offline.

There's something a little strange I just noticed in the log.  It's
probably not related to your problem, but we should check it out anyway.  
Please send a copy of /proc/bus/usb/devices, with the drive plugged in.


> 2.  usb_stor_bulk_msg() returned -32

Under what circumstances did this error occur?  It must have been quite 
different from the other error.

> usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
> usb-storage: usb_stor_bulk_msg() returned -32 xferred 0/2048

> usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
> usb-storage: Not Ready: LUN in process of becoming ready

That's normal.  It means that the drive was just turned on or reset, and 
it's not yet ready to execute commands.

> usb-storage: Unit Attention: not ready to ready transition

More of the same.  This means that the drive just finished its 
initialization and now it's ready to operate.

> usb-storage: scsi cmd done, result=0x2
> usb-storage: *** thread sleeping.
>  I/O error: dev 0b:00, sector 804236
>  I/O error: dev 0b:00, sector 804240
>  I/O error: dev 0b:00, sector 804492
>  I/O error: dev 0b:00, sector 804236

But apparently at this point the SCSI driver got tired of waiting and set 
the drive offline.  This should be fixed in the SCSI driver.  That's why 
it's important to know what you were doing when the error occurred.

Alan Stern



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
