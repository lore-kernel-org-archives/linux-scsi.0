From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/1] SCSI-libfc: Deletion of an unnecessary check before the
 function call "fc_fcp_ddp_done"
Date: Thu, 20 Nov 2014 20:15:39 +0100
Message-ID: <546E3DDB.5040508@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@parallels.com>, Robert Love <robert.w.love@intel.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 20:10:19 +0100

The fc_fcp_ddp_done() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/libfc/fc_exch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1b3a094..aad6f48 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2120,8 +2120,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	spin_unlock_bh(&ep->ex_lock);
 	return sp;
 err:
-	if (fsp)
-		fc_fcp_ddp_done(fsp);
+	fc_fcp_ddp_done(fsp);
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
-- 
2.1.3
