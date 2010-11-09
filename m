From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix mem leak in scsi target interface
Date: Tue, 9 Nov 2010 22:08:32 +0800
Message-ID: <AANLkTikwExfibO+7=21NruN-Pd6e=-XN_vc6iq4KRbG7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32901 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0KIOIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 09:08:35 -0500
Received: by wyb36 with SMTP id 36so4847173wyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2010 06:08:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When error encountered, the allocated page/s could be returned back to
the mm system of linus, which triggers mem leak.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_tgt_if.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_tgt_if.c	2010-11-09 21:35:10.000000000 +0800
@@ -18,6 +18,10 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  * 02110-1301 USA
+ *
+ * Nov 9, 2010	Hillf Danton <dhillf@gmail.com>
+ *		minor fix of memory leakage
+ *
  */
 #include <linux/miscdevice.h>
 #include <linux/gfp.h>
@@ -359,11 +363,15 @@ static int tgt_ring_init(struct tgt_ring
 		ring->tr_pages[i] = get_zeroed_page(GFP_KERNEL);
 		if (!ring->tr_pages[i]) {
 			eprintk("out of memory\n");
-			return -ENOMEM;
+			goto err;
 		}
 	}

 	return 0;
+ err:
+ 	for (; --i >= 0;)
+		free_page(ring->tr_pages[i]);
+	return -ENOMEM;
 }

 void scsi_tgt_if_exit(void)
