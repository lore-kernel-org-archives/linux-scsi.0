From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-bfa: Delete more unnecessary checks before the function
 call "vfree"
Date: Thu, 05 Feb 2015 22:07:43 +0100
Message-ID: <54D3DB9F.5040100@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, "James E. J. Bottomley" <JBottomley@parallels.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 5 Feb 2015 22:02:16 +0100

The vfree() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/bfa/bfad.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e90a374..05c8ca0 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1810,11 +1810,11 @@ bfad_load_fwimg(struct pci_dev *pdev)
 static void
 bfad_free_fwimg(void)
 {
-	if (bfi_image_ct2_size && bfi_image_ct2)
+	if (bfi_image_ct2_size)
 		vfree(bfi_image_ct2);
-	if (bfi_image_ct_size && bfi_image_ct)
+	if (bfi_image_ct_size)
 		vfree(bfi_image_ct);
-	if (bfi_image_cb_size && bfi_image_cb)
+	if (bfi_image_cb_size)
 		vfree(bfi_image_cb);
 }
 
-- 
2.2.2
