Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9092D3F82;
	Mon,  5 May 2025 22:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485593; cv=none; b=d+vmtGgbNqSnQQQ/NdjiGUm6C3eUTP6h05DZ0zD79FPDRNnOJ5bJAw9C4FlyWtPPO8kEl8pFLN44jPsy0qu0j91c+KNq/MHCV7CnTtVwOmD+wKb9JBZDTiaNs9m79heK/zy7oFWeoppsCklKmrl64nvZS2Fi8BsHmOeLDekli2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485593; c=relaxed/simple;
	bh=/ZfG5SNQ1bIVbs6hFU7RU8RBy+koTOJxzYhRtYQ7/9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oFq+FMkqPgk3V1juc+IIfkCeHhBeLizt7xpmYbIBk9HNsqeMM4ouHDH/YSEMuknTanQkneYgFSXOLL2+KOO+/kZGJp9pwAEHb0oV1l4DFNS4YLb6GkN8IsshFxVqZiOu+54DnqS/hzx33kppNFSXA2vPU8vEUo1nJ1TxYgMiWMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3blRtbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3blRtbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A13C4CEEE;
	Mon,  5 May 2025 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485592;
	bh=/ZfG5SNQ1bIVbs6hFU7RU8RBy+koTOJxzYhRtYQ7/9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3blRtbqwEmeSiwxKYSQMXGuq9B0OP5htCSql8HePd3fSfp/D4zYDc+5xW50Ukbzl
	 mRfdlkvnN692mHU1HlOfM2wEWIvSgnlOetzPnmTnwXO9O0jAu5VCE7H0M0O3StQM9c
	 37cvYpaheT9iVNIY9MDMhTSTB09jPEI9jmGkm7MpfCBMUc0TSU1Jl00KoIj8qiifEi
	 mt74/brkBfgdnmgSmzhs88vKdZ4Vnr9BsqSCzngKuh1euPhw2pWRcdZIAmhvXsnaad
	 S4SSYZWo3VfNFr3aftQjlMELvnvE1cd2BMDG/dI+5sWzhpJYZvbBFcCmsPML/7DBnh
	 IZrEqxDyAm45A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 378/486] scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()
Date: Mon,  5 May 2025 18:37:34 -0400
Message-Id: <20250505223922.2682012-378-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index 61c065702350e..701dcbd7b63cf 100644
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

