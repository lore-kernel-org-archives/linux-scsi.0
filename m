Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7B290BC3;
	Mon,  5 May 2025 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484464; cv=none; b=HAm3asSshodwBoj5YTZbGi0Je6bVtHZ1dO5e+AaI0daKhLJMcGSiBUIwVc++UViR9FR//z29EchOOg8A4C1pKY1HkDDlrVQNuTM7Tuushk7rHObMWiZ47ikXRppijJBpQPC502uNAD6NTDhxjIwQJZxxc5rvf8Q+oZASc+eRuxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484464; c=relaxed/simple;
	bh=eqh0H8xljnVjnyVHXMzmwhnw19zLffKsvfB+BptY+yA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iy95WcOJ0uO/YqhGSbYN+ni8QWQvMuS9DsScU1XQUhC+9H7rLIVvfu0GGsgImm82sxZC5aRSPkmeBFK6N0RMwJrY6/n4C3REMA1QNxQ06dsYSeiqHo8r/A5XKuuzJSoX1Nw1pueRJVmBJKpcResdYy4z8St7eRCQlubq7NX09UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBWsIXcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBWsIXcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A5BC4CEE4;
	Mon,  5 May 2025 22:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484464;
	bh=eqh0H8xljnVjnyVHXMzmwhnw19zLffKsvfB+BptY+yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBWsIXcfk9ys6TEaKzpNT4Org5iJxM8EiCoxmdqSjQ8xHeF/TG5wmeBqZCProLNCu
	 2OSn8jioDCvXx5vcBQwXfXiiDfSjlIzejO/eeaejZBOXNsQcDbFzya5fhD+pmMfhVW
	 k/N2VdjTFzIasLqhWcW++TcdM9euMghHCQ4v1e/2q5LqJ7X9pBHzpafG8j957fv4Yk
	 /kO4Se4FTAdP5yIRhFJYqHqHFsiKfTljZaWgpN3LM+cC3+x5YYVFg4GLkhJdA516DG
	 iRw70qowKN1ofCaO+KEX8JlY0AkkREkHOV595osuOrg8AFTu0oXNXz3QXDWqJhW5sI
	 hKkvhsKN5Ev2Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 485/642] scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()
Date: Mon,  5 May 2025 18:11:41 -0400
Message-Id: <20250505221419.2672473-485-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 785a97536212b..0a02492bef701 100644
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

