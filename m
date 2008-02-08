From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 11/9 update] firewire: fw-sbp2: enforce a retry of
	__scsi_add_device if bus generation changed
Date: Fri, 8 Feb 2008 22:33:29 +0100 (CET)
Message-ID: <tkrat.e02d667ba3320993@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
	<47A9FBFD.50100@s5r6.in-berlin.de>
	<tkrat.b66856ee2df66cd4@s5r6.in-berlin.de>
	<200802081354.23299.jwilson@redhat.com>
	<47ACB449.3060200@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47ACB449.3060200@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed

fw-sbp2 is unable to reconnect while performing __scsi_add_device
because there is only a single workqueue thread context available for
both at the moment.  This should be fixed eventually.

An actual failure of __scsi_add_device is easy to handle, but an
incomplete execution of __scsi_add_device with an sdev returned would
remain undetected and leave the SBP-2 target unusable.

Therefore we use a workaround:  If there was a bus reset during
__scsi_add_device (i.e. during the SCSI probe), we remove the new sdev
immediately, log out, and attempt login and SCSI probe again.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

The previous patch "firewire: fw-sbp2: retry login if scsi_device was
offlined early" should be folded into this one before upstream
submission.

 drivers/firewire/fw-sbp2.c |   43 ++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -824,36 +824,31 @@ static void sbp2_login(struct work_struc
 
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
-	if (IS_ERR(sdev)) {
-		/*
-		 * The most frequent cause for __scsi_add_device() to fail
-		 * is a bus reset while sending the SCSI INQUIRY.  Try again.
-		 */
+	/*
+	 * FIXME:  We are unable to perform reconnects while in sbp2_login().
+	 * Therefore __scsi_add_device() will get into trouble if a bus reset
+	 * happens in parallel.  It will either fail or leave us with an
+	 * unusable sdev.  As a workaround we check for this and retry the
+	 * whole login and SCSI probing.
+	 */
+
+	if (IS_ERR(sdev))
 		goto out_logout_login;
 
-	} else if (sdev->sdev_state == SDEV_OFFLINE) {
-		/*
-		 * FIXME:  We are unable to perform reconnects while in
-		 * sbp2_login().  Therefore __scsi_add_device() will get
-		 * into trouble if a bus reset happens in parallel.
-		 * It will either fail (that's OK, see above) or take sdev
-		 * offline.  Here is a crude workaround for the latter.
-		 */
-		scsi_device_put(sdev);
+	scsi_device_put(sdev);
+
+	smp_rmb(); /* get current card generation */
+	if (generation != device->card->generation) {
 		scsi_remove_device(sdev);
 		goto out_logout_login;
-
-	} else {
-		/*
-		 * Can you believe it?  Everything went well.
-		 */
-		lu->sdev = sdev;
-		smp_wmb();  /* We need lu->sdev when we want to block lu. */
-		atomic_dec(&lu->tgt->dont_block);
-		scsi_device_put(sdev);
-		goto out;
 	}
 
+	/* Everything went well. */
+	lu->sdev = sdev;
+	smp_wmb();  /* We need lu->sdev when we want to block lu. */
+	atomic_dec(&lu->tgt->dont_block);
+	goto out;
+
  out_logout_login:
 	smp_rmb(); /* generation may have changed */
 	generation = device->generation;

-- 
Stefan Richter
-=====-==--- --=- -=---
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
