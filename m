From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] megaraid_sas: fix a bug for 64 bit arches
Date: Sat, 29 Jun 2013 00:21:04 +0300
Message-ID: <20130628212104.GA16035@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21449 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3F1VVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 17:21:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>, "Sumit.Saxena@lsi.com" <Sumit.Saxena@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 64 bit then -1UL and -1U are not equal, so these conditions don't
work as intended and it breaks error handling.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 8056eac..4f401f7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -585,7 +585,7 @@ u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 stripe,
 	case 1:
 		/* start with logical arm */
 		arm = get_arm_from_strip(instance, ld, stripe, map);
-		if (arm != -1UL)
+		if (arm != -1U)
 			arm *= 2;
 		break;
 	}
@@ -637,7 +637,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 
 	if (raid->level == 6) {
 		logArm = get_arm_from_strip(instance, ld, stripRow, map);
-		if (logArm == -1UL)
+		if (logArm == -1U)
 			return FALSE;
 		rowMod = mega_mod64(row, SPAN_ROW_SIZE(map, ld, span));
 		armQ = SPAN_ROW_SIZE(map, ld, span) - 1 - rowMod;
