From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Wed, 17 Sep 2003 15:50:42 +0900
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200309170651.PAA02272@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org

Hi Alan,

Alan> The system sent commands, but the device didn't respond to them. 
Alan> However, it's possible that this patch will help.
Alan> Try it out and see what happens.

Using 2.4.22-bk15, 
It was adapted in the following patche and I tested.

===== your patch =====

--- 2.4.22/drivers/usb/storage/protocol.c.orig	Mon Aug 25 07:44:42 2003
+++ 2.4.22/drivers/usb/storage/protocol.c	Fri Sep  5 16:20:26 2003
@@ -237,6 +237,10 @@
 	 * a unsigned char cmnd[12], so we know we have storage available
 	 */
 
+	/* Pad the ATAPI command with zeros */
+	for (; srb->cmd_len<12; srb->cmd_len++)
+		srb->cmnd[srb->cmd_len] = 0;
+
 	/* set command length to 12 bytes (this affects the transport layer) */
 	srb->cmd_len = 12;

===== end of your patch =====

The test was successful the 3rd day or more with this patch.
However, it became the following errors.
I think that no data was transferred from the drive, 
and the command timed out and was aborted.
Ejection will also be impossible if it will be in this state. 
I recovered the error by the power supply OFF.

</proc/bus/usb/devices>

:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 0.00
S:  Product=USB UHCI Root Hub
S:  SerialNumber=d400
C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 0.00
S:  Product=USB UHCI Root Hub
S:  SerialNumber=d800
C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 0.00
:  Product=USB UHCI Root Hub
S:  SerialNumber=e400
C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 0.00
S:  Product=USB UHCI Root Hub
S:  SerialNumber=ec00
C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 4
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS= 8 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.04
S:  Manufacturer=Linux 2.4.22-bk15 ehci_hcd
S:  Product=VIA Technologies, Inc. USB 2.0
S:  SerialNumber=00:0c.2
C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=256ms
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=093b ProdID=0012 Rev=11.01
S:  Manufacturer=Plextor Corp.
S:  Product=USB Storage Adapter
S:  SerialNumber=11100E000052487C
C:* #Ifs= 1 Cfg#= 2 Atr=c0 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=08(stor.) Sub=02 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   2 Ivl=32ms

<dmesg>
rage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 2048/2048
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x14a4c2d R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 2d e1 00 00 01 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x14a4c2e Trg 0 LUN 0 L 2048 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 2048/2048
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x14a4c2e R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 2d e2 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x14a4c2f Trg 0 LUN 0 L 129024 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 2048/2048
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x14a4c2f R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 2e 21 00 00 01 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x14a4c30 Trg 0 LUN 0 L 2048 F 128 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_transfer_partial(): xfer 2048 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 2048/2048
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: Bulk status result = 0
usb-storage: Bulk status Sig 0x53425355 T 0x14a4c30 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 2e 22 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x14a4c31 Trg 0 LUN 0 L 129024 F 128 CL 12
usb-storage: command_abort() called
usb-storage: Bulk command transfer result=-104
usb-storage: -- transport indicates command was aborted
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x14a4c32 Trg 0 LUN 0 L 0 F 0 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: command_abort() called
usb-storage: -- transport indicates command was aborted
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: device_reset() called
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: bus_reset() called
hub.c: port 1, portstatus 511, change 0, 480 Mb/s
hub.c: port 1 of hub 1 not reset yet, waiting 10ms
hub.c: port 1, portstatus 511, change 0, 480 Mb/s
hub.c: port 1 of hub 1 not reset yet, waiting 10ms
ehci_hcd 00:0c.2: port 1 high speed
ehci_hcd 00:0c.2: GetStatus port 1 status 001005 POWER sig=se0  PE CONNECT
hub.c: port 1, portstatus 503, change 10, 480 Mb/s
usb.c: ignoring set_interface for dev 2, iface 0, alt 0
usb-storage: Examinging driver usb-storage...skipping ourselves.
usb-storage: bus_reset() complete
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 3f 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x14a4c33 Trg 0 LUN 0 L 0 F 0 CL 12
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: command_abort() called
usb-storage: -- transport indicates command was aborted
usb-storage: Bulk reset requested
usb_control/bulk_msg: timeout
usb-storage: Bulk soft reset failed -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
SCSI cdrom error : host 0 channel 0 id 0 lun 0 return code = 50000
 I/O error: dev 0b:00, sector 47240
 I/O error: dev 0b:00, sector 47244
 I/O error: dev 0b:00, sector 47492
 I/O error: dev 0b:00, sector 47240

Thanks!!
Haruo 


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
