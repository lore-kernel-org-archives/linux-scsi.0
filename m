From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/3] block-cciss: Deletion of an unnecessary check before
 the function call "put_disk"
Date: Sun, 18 Jan 2015 15:37:42 +0100
Message-ID: <54BBC536.5010006@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54BBC3AB.6040207@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54BBC3AB.6040207@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 11:14:16 +0100

The put_disk() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..4be0de0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4424,8 +4424,7 @@ static void free_hba(ctlr_info_t *h)
 
 	hba[h->ctlr] = NULL;
 	for (i = 0; i < h->highest_lun + 1; i++)
-		if (h->gendisk[i] != NULL)
-			put_disk(h->gendisk[i]);
+		put_disk(h->gendisk[i]);
 	kfree(h);
 }
 
-- 
2.2.2
