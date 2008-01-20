From: Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH] [2.6.23.13] udev hangs USB-storage (HP
	r707 camera)
Date: Sat, 19 Jan 2008 22:25:53 -0700
Message-ID: <20080120052553.GA5452@colo.lackof.org>
References: <20080119174556.GE11553@colo.lackof.org>
	<47929B9F.8080607@s5r6.in-berlin.de>
	<20080120022829.GG11553@colo.lackof.org>
	<1200797791.11214.3.camel@localhost.localdomain>
	<20080120031008.GI11553@colo.lackof.org>
	<1200802265.11214.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1200802265.11214.8.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 19, 2008 at 10:11:05PM -0600, James Bottomley wrote:
...
> Add the device to drivers/usb/storage/unusual_devs.h with
> US_FL_FIX_CAPACITY.  You'll need to know it's USB ids as well for this
> file.

James,
Thanks! Patch below (for Alan) works for me.

Jan 19 20:50:17 localhost kernel: USB Mass Storage support registered.
Jan 19 20:50:22 localhost kernel: scsi scan: INQUIRY result too short (5), using 36
Jan 19 20:50:22 localhost kernel: scsi 0:0:0:0: Direct-Access     HP       PhotoSmart R707  A001 PQ: 0 ANSI: 0
Jan 19 20:50:22 localhost kernel: sd 0:0:0:0: [sda] 60800 512-byte hardware sectors (31 MB)
Jan 19 20:50:22 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 19 20:50:22 localhost kernel: sd 0:0:0:0: [sda] 60800 512-byte hardware sectors (31 MB)
Jan 19 20:50:22 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 19 20:50:22 localhost kernel:  sda: sda1
Jan 19 20:50:22 localhost kernel: sd 0:0:0:0: [sda] Attached SCSI removable disk

FTR, previous sd output was showing 60801 sectors.

root@mb500:~ # lsusb
Bus 001 Device 007: ID 03f0:4002 Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage)
Bus 001 Device 004: ID 046d:c030 Logitech, Inc. iFeel Mouse
Bus 001 Device 003: ID 0451:1446 Texas Instruments, Inc. TUSB2040/2070 Hub
Bus 001 Device 002: ID 7fff:bfff  
Bus 001 Device 001: ID 0000:0000  



Thanks!
grant

Commit Log entry:

Add "FIX_CAPACITY" entry for HP Photosmart r707 Camera in "Disk" mode.
Camera will wedge when /lib/udev/vol_id attempts to access the last sector,
EIO gets reported to dmesg, and block device is marked "offline" (it is).
Reproduced vol_id behavior with:
	"dd if=/dev/sda of=/dev/null skip=60800 count=1"

With patch, linux now reports 60800 sectors and udev is happy.

email thread reference:
    http://marc.info/?t=120076483300002&r=1&w=2

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

--- linux-2.6.23.13/drivers/usb/storage/unusual_devs.h	2008-01-19 19:59:15.000000000 -0800
+++ linux-2.6.23-GGG/drivers/usb/storage/unusual_devs.h	2008-01-19 20:40:40.000000000 -0800
@@ -86,6 +86,14 @@
 		US_SC_8070, US_PR_USBAT, init_usbat_cd, 0),
 #endif
 
+/* Reported by Grant Grundler <grundler@parisc-linux.org>
+ * HP r707 camera in "Disk" mode with 2.00.23 or 2.00.24 firmware.
+ */
+UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x0001,
+		"HP",
+		"PhotoSmart R707",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, US_FL_FIX_CAPACITY),
+
 /* Reported by Sebastian Kapfer <sebastian_kapfer@gmx.net>
  * and Olaf Hering <olh@suse.de> (different bcd's, same vendor/product)
  * for USB floppies that need the SINGLE_LUN enforcement.


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
