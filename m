Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2392561DD;
	Thu,  3 Apr 2025 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743706960; cv=none; b=BriuiSA+rCfZWvioXoYqRLGc43EfNJW0UiQSRGOeIi/8u2ObzKB4dVacc88ijuigrHf2PCtffRN9ng/ikoOgZXS+i04D3iRb6tdmOkHwh03QxjJA3xbHwLoKgobGiJdbDSNLf47SPE6jhp3t52i64bIYcQ/W0x7U7j8x2kEZy5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743706960; c=relaxed/simple;
	bh=g0zBLxavqYSYO0LoA1sa/2C1ksx9MMtJvA8PF7M0r7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qZ4vYFP8a9X+SUP6Gr6PyYfgQ79Dl2J+V7gV1K/N6X6hj6FGQSR0QQAp3Lqh4twKtSCRgYBEPgNqum+gOdWb9B9uyqyUk64LJKsXNryFreCBJcbL9+XilhEMtAty9OR19XOEYhqkJUZ0rAamQn+msqOf78Ax6HpxTl8GrBEq4DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lyjz3nDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyjz3nDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB6C4CEE8;
	Thu,  3 Apr 2025 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743706960;
	bh=g0zBLxavqYSYO0LoA1sa/2C1ksx9MMtJvA8PF7M0r7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyjz3nDrpStKa+qltVje8D+qOkteIa20l6VnlobwHDqkLwBdBesMrdg4dFmZhzIln
	 mHLUYaYHJ0rtTh603lPW70oAUxppYMESEk+HHKtqwJ3eyI7ccWrns3veUUPD8oino4
	 QheN7DYlmtJ/vT+LsDvP+TdW99xtBsPZBsF17oYhlls2zXW8BbsAEqTMqECfDboKtM
	 qt5a+6H1lhu11pRn9ctpQH6kONfP99CF52Ox+mArERMhAxUtIqTKJrQHamxpWQVugn
	 cZqZsTnmkk1h0h5M8BiOPgRdIhXjz5GoqtJzKptWia7faURQa9jK22gMUMOh9B+8yq
	 Am9HHTOLImp8g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 14/54] scsi: target: spc: Fix RSOC parameter data header size
Date: Thu,  3 Apr 2025 15:01:29 -0400
Message-Id: <20250403190209.2675485-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190209.2675485-1-sashal@kernel.org>
References: <20250403190209.2675485-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14
Content-Transfer-Encoding: 8bit

From: Chaohai Chen <wdhh66@163.com>

[ Upstream commit b50532318793d28a7628c1ffc129a2226e83e495 ]

The SPC document states that "The COMMAND DATA LENGTH field indicates the
length in bytes of the command descriptor list".

The length should be subtracted by 4 to represent the length of the
description list, not 3.

Signed-off-by: Chaohai Chen <wdhh66@163.com>
Link: https://lore.kernel.org/r/20250115070739.216154-1-wdhh66@163.com
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ea14a38356814..61c065702350e 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -2243,7 +2243,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 			response_length += spc_rsoc_encode_command_descriptor(
 					&buf[response_length], rctd, descr);
 		}
-		put_unaligned_be32(response_length - 3, buf);
+		put_unaligned_be32(response_length - 4, buf);
 	} else {
 		response_length = spc_rsoc_encode_one_command_descriptor(
 				&buf[response_length], rctd, descr,
-- 
2.39.5

