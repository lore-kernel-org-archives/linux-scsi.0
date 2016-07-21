From: tom.ty89@gmail.com
Subject: [PATCH resend 4/5] libata-scsi: have all checks done before calling ata_mselect_*()
Date: Fri, 22 Jul 2016 02:41:53 +0800
Message-ID: <14bd98eb08ddf86be28f558817bed3cd27c397cd.1469126217.git.tom.ty89@gmail.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com> <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com> <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

The one-page-at-a-time check in ata_scsi_mode_select_xlat() should
be done before either of the ata_mselect_*() is called.

Also updated the comment. We have more than one mode page that has
changeable bit since commit 06dbde5f3a44 ("libata: Implement
control mode page to select sense format").

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3c93341..6c424c5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3837,6 +3837,12 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	if (pg_len > len)
 		goto invalid_param_len;
 
+	/*
+	 * Currently we only support setting one page at a time.
+	 */
+	if (len > pg_len)
+		goto invalid_param;
+
 	switch (pg) {
 	case CACHE_MPAGE:
 		if (ata_mselect_caching(qc, p, pg_len, &fp) < 0) {
@@ -3855,13 +3861,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param;
 	}
 
-	/*
-	 * Only one page has changeable data, so we only support setting one
-	 * page at a time.
-	 */
-	if (len > pg_len)
-		goto invalid_param;
-
 	return 0;
 
  invalid_fld:
-- 
2.9.0
