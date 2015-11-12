From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] hpsa: logical vs bitwise AND typo
Date: Thu, 12 Nov 2015 12:43:38 +0300
Message-ID: <20151112094338.GB28432@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, Scott Teel <scott.teel@pmcs.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

HPSA_DIAG_OPTS_DISABLE_RLD_CACHING is a mask and bitwise AND was
intended here instead of logical &&.  This bug is essentially harmless,
it means that sometimes we don't print a warning message which we wanted
to print.

Fixes: c2adae44e916 ('hpsa: disable report lun data caching')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6a8f958..a386036 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8671,7 +8671,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
 		goto errout;
 
-	if (*options && HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
+	if (*options & HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
 		goto out;
 
 errout:
