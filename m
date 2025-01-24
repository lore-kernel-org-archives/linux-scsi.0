Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BE51DB134;
	Fri, 24 Jan 2025 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737708963; cv=none; b=I/s6s7mK2a3l3BTtlfChaiQ23zcBnHNAZ1V1AXWxcTnzt/o/15YWVZtLj/igRxAUmnS3lNenvB4O7x/DBkvxHog6G6eUEZ60YQvV2keUdrIBFWFAHu1TRbRS8FWr1ySUpQ/IUORYcbWkSpKxyHgxgK0gQRyorCzraWrCeOVVz7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737708963; c=relaxed/simple;
	bh=f+3XVC1aLmke/mCYCccO4Pdn9mtftQ8yMG2YeEkkS/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jtz7vhU+xFqlRmmT2/O6DYcRXp9Leagdl8upkGaTFfjALko/MCUqKf/Xs9DA4aZq/jBX1P8pFYymivkeyxO8gzmeMpR7sz+Hkf7TDZiq23Oek4ogM0xVVRW1maK21HcuULd95h9yfoLupEoQpx0iDM8rnge8Xkjd70uc+WQi1to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IqQy4GV5; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IqQy4GV5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=u3ml6
	oirXfxqinCWDiCI7YbbQypdRbr7GDnduF1Mx5g=; b=IqQy4GV50GGqQfry4b6Fo
	wrDxQR0aq3OALlVJux1v4OV4zOjrfa7NJFeq8UPZWbsEBAuiI5Pf3C1j8HdVhZe3
	J+jbBvrvcEq4lGIOjfU4jMhuWxgcNXL8N/AIgTrcIWJuX1m+YDbSiePNFLUE6swF
	PLlecsb4Oi9r3uO9/57Ytc=
Received: from wdhh6.sugon.cn (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3n0WRVZNn1Hr4IA--.32746S2;
	Fri, 24 Jan 2025 16:55:46 +0800 (CST)
From: Chaohai Chen <wdhh66@163.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	d.bogdanov@yadro.com,
	Chaohai Chen <wdhh66@163.com>
Subject: [PATCH] scsi:target: remove invalid loop traversal in spc_rsoc_get_descr
Date: Fri, 24 Jan 2025 16:55:42 +0800
Message-Id: <20250124085542.109088-1-wdhh66@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n0WRVZNn1Hr4IA--.32746S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw1fGr1fuF13uFWrAr43KFg_yoW8Xw17pw
	4DG34jyrWrWay8Gr18ta1UJFy3Ga4xJryDCr92gayfZw47trZ2g3ZayryxtF15JFyFkr15
	Wr47Aa13CrW5u3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbJ5OUUUUU=
X-CM-SenderInfo: hzgkxlqw6rljoofrz/1tbiEBLe1meTRHr29wAAsB

It is necessary to stop traversing after find appropriate descr

Signed-off-by: Chaohai Chen <wdhh66@163.com>
---
 drivers/target/target_core_spc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ea14a3835681..7f2cbe1f77fc 100644
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
2.34.1

