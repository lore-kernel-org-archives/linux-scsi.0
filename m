Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9320395272;
	Mon,  5 May 2025 23:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486270; cv=none; b=b3yxlI+GDslR59ww0P4KowxeGrs1MQOlOGNjA/M/sxIjTqO9ZTxLvco7es86GLGE0InSsMjv52PJZB3GaG4d6WxL1SUnAtxecuhdAcATgyeyefcEhckTXmyI/IXM/UJpnMb4nI38CVbwJgRa5ZfQfcZ/dBApug9xl8CU9WMZLQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486270; c=relaxed/simple;
	bh=pezJFGNqJYcMCIUcG2oynIeI9Ofz2rix52mArlSiCCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V9aL00Xx3v5yZo5Q5GD2BRHEbr21gutC8zbuSENOYDIsavcBKvHde699faOfCpvrAKWxr+azMn/Ovgz+TkWRp+tOlusdkc6Fl9MZuY2PCKFuvhr8YGyD9UtQFubdeBbn98WqoEzAs9Y0/nolAtyQezVIaPbotKh9myfRYmh8HXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rl570EER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rl570EER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99866C4CEED;
	Mon,  5 May 2025 23:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486268;
	bh=pezJFGNqJYcMCIUcG2oynIeI9Ofz2rix52mArlSiCCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl570EERQMGpgjHzGd0kHFrfnCzrY7tkcNIYpwvghdUGfaN6iew5KDuEdgyCzvinZ
	 P3poznVY7VEn4F+M4nusOtc0kBNB+XXFwG58mejPDGlClelzfBzW0qqBHqDtfxdmEs
	 2v6V+6QVlRUP4va49pAl7MnI6ssK6PFogMwOBJUKgV7lhdNusah8bxABCo/SMRCCKe
	 KSGeprCxJ53pMGLvgPahsoSolXmNN/umEWijb/zjzX7M4a+WW22lr2qesif3IveeE4
	 16XCZHzM38RhChHZL5GeXywg2upzULjgQR9Qz8dumTd1sd6Mj1gBMJ8gKlvaN4it/5
	 +RVKdoXeecY2w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 231/294] scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()
Date: Mon,  5 May 2025 18:55:31 -0400
Message-Id: <20250505225634.2688578-231-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Chaohai Chen <wdhh66@163.com>

[ Upstream commit 04ad06e41d1c74cc323b20a7bd023c47bd0e0c38 ]

Stop traversing after finding the appropriate descriptor.

Signed-off-by: Chaohai Chen <wdhh66@163.com>
Link: https://lore.kernel.org/r/20250124085542.109088-1-wdhh66@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_spc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f110f932ba054..675f774be1d30 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -2151,8 +2151,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 
-			if (!descr->enabled || descr->enabled(descr, cmd))
+			if (!descr->enabled || descr->enabled(descr, cmd)) {
 				*opcode = descr;
+				return TCM_NO_SENSE;
+			}
 			break;
 		case 0x2:
 			/*
@@ -2166,8 +2168,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid &&
 			    descr->service_action == requested_sa) {
 				if (!descr->enabled || descr->enabled(descr,
-								      cmd))
+								      cmd)) {
 					*opcode = descr;
+					return TCM_NO_SENSE;
+				}
 			} else if (!descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 			break;
@@ -2180,13 +2184,15 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 */
 			if (descr->service_action == requested_sa)
 				if (!descr->enabled || descr->enabled(descr,
-								      cmd))
+								      cmd)) {
 					*opcode = descr;
+					return TCM_NO_SENSE;
+				}
 			break;
 		}
 	}
 
-	return 0;
+	return TCM_NO_SENSE;
 }
 
 static sense_reason_t
-- 
2.39.5

