From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: Possible bug in usb storage (2.6.11 kernel)
Date: Tue, 27 Sep 2005 22:38:01 +0900 (JST)
Message-ID: <20050927.223801.130240000.anemo@mba.ocn.ne.jp>
References: <4789af9e05090813287f05e12a@mail.gmail.com>
	<Pine.LNX.4.44L0.0509081637410.4545-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0509081637410.4545-100000@iolanthe.rowland.org>
Sender: linux-usb-users-admin@lists.sourceforge.net
Errors-To: linux-usb-users-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
To: stern@rowland.harvard.edu
Cc: jim.ramsay@gmail.com, mdharm-kernel@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> On Thu, 8 Sep 2005 16:40:16 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> said:

stern> I've long thought that usb-storage should allocate its own
stern> transfer buffer for sense data.  In the past people have said,
stern> "No, don't bother, it's not really needed."  Here's a good
stern> reason for doing it.

stern> Expect a patch before long.

Did you already create the patch?  If not, how about this (against 2.6.13) ?


Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

diff -u linux-2.6.13/drivers/usb/storage/transport.c linux/drivers/usb/storage/transport.c
--- linux-2.6.13/drivers/usb/storage/transport.c	2005-08-29 08:41:01.000000000 +0900
+++ linux/drivers/usb/storage/transport.c	2005-09-27 18:03:32.000000000 +0900
@@ -638,7 +638,8 @@
 
 		/* use the new buffer we have */
 		old_request_buffer = srb->request_buffer;
-		srb->request_buffer = srb->sense_buffer;
+		srb->request_buffer =
+			kmalloc(max(dma_get_cache_alignment(), 18), GFP_NOIO);
 
 		/* set the buffer length for transfer */
 		old_request_bufflen = srb->request_bufflen;
@@ -655,7 +656,13 @@
 		/* issue the auto-sense command */
 		old_resid = srb->resid;
 		srb->resid = 0;
-		temp_result = us->transport(us->srb, us);
+		if (srb->request_buffer) {
+			temp_result = us->transport(us->srb, us);
+			memcpy(srb->sense_buffer, srb->request_buffer, 18);
+			kfree(srb->request_buffer);
+		} else {
+			temp_result = USB_STOR_TRANSPORT_FAILED;
+		}
 
 		/* let's clean up right away */
 		srb->resid = old_resid;


---
Atsushi Nemoto


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
