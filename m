From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 02/11] hpsa: correct decode sense data
Date: Sat, 18 Jul 2015 11:12:28 -0500
Message-ID: <20150718161228.31955.89625.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:56151 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbGRQOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:14:44 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1d5f4fd..e9b2073 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -325,7 +325,7 @@ static int check_for_unit_attention(struct ctlr_info *h,
 
 	decode_sense_data(c->err_info->SenseInfo, sense_len,
 				&sense_key, &asc, &ascq);
-	if (sense_key != UNIT_ATTENTION || asc == -1)
+	if (sense_key != UNIT_ATTENTION || asc == 0xff)
 		return 0;
 
 	switch (asc) {

