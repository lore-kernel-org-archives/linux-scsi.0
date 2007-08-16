From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Errors on USB-storage device are ignored.
Date: Thu, 16 Aug 2007 16:58:17 +0200
Message-ID: <20070816145817.GA24105@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: usb-storage@lists.one-eyed-alien.net, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi,

I have an usb-storage enclosure that houses a normal desktop 
harddrive. I have been wondering why disks in that enclosure 
seemed to be  having less errors than when connected to a 
normal IDE connector. 

The reason is: USB-storage is ignoring a hint that something is
wrong. Probably my enclosure is also not completely following specs, 
but Linux is ignoring the hint as well.... 

On hitting a bad block, the disk reports error. The USB converter
then reports "auto-sense-required", and this is carried out. However
at this point, my USB enclosure returns all-zeroes. This is
considered non-fatal by the kernel. 

I'm guessing not many people are testing these things with 
bad drives. So, I don't know wether or not other USB converters
handle this situation more gracefully. 

As a patch, I've decided to set the sense key to "vendor specific"
(9), and then no "additional sense" (0:0), if, and only if the device
didn't return any valid sense info. 

The rest of the kernel then correctly interprets the situation
as an IO error. 

	Roger Wolff. 

--- linux-2.6.20.3.clean/drivers/usb/storage/transport.c	2007-03-13 19:27:08.000000000 +0100
+++ linux-2.6.20.3.kostunrix/drivers/usb/storage/transport.c	2007-08-16 16:47:00.000000000 +0200
@@ -629,6 +629,14 @@
 
 		/* let's clean up right away */
 		memcpy(srb->sense_buffer, us->sensebuf, US_SENSE_SIZE);
+		if (((srb->sense_buffer[2]&0xf) == 0) &&
+		    (srb->sense_buffer[12] == 0) &&
+		    (srb->sense_buffer[13] == 0)) {
+			/* Hmmmmm. The device requested sense, but then
+			   declined to give us more info.... -- REW */ 
+			srb->sense_buffer[2] |= 0x09; /* Vendor specific */
+		}
+
 		srb->resid = old_resid;
 		srb->request_buffer = old_request_buffer;
 		srb->request_bufflen = old_request_bufflen;



-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
