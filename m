Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37C626A1CB;
	Thu,  3 Apr 2025 19:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707182; cv=none; b=fTBkns/mizKdNwrCvpJUH3cD55XFQg26v4BxaY1MVS9YMre/BZ74+EVbvBkO0AhGMRjtaVoxRNLiA+hyGpd4qObZEJ/HUlp66UgfkkiSRODQOk5W7rgHRQgptVV9+LWQVokkCMUghsoNfVKozvDP0eof/KGQg0yr98nuq9Ab/9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707182; c=relaxed/simple;
	bh=g0zBLxavqYSYO0LoA1sa/2C1ksx9MMtJvA8PF7M0r7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RCuW6eF6k8IK6pmOn+16Cl4LU7+YjxPcHurAxe0icjexK7CdpQUYHUzqq1VvjL2Aog4e2duXrO+FZk3zphrFoE40nEsoXtfMLdrv+Ro1s5ksW2ddaR1jpQfxZGN/lZXM94F+6PLmQ4VDZFetWazkfgNIdFeRl7lIA08oPAHw2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/f8KWj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/f8KWj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9678AC4CEE8;
	Thu,  3 Apr 2025 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707182;
	bh=g0zBLxavqYSYO0LoA1sa/2C1ksx9MMtJvA8PF7M0r7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/f8KWj4WoRt2ql9cVEUKkbIc3WG0OozuYnJPD6vlkGk+VGp3OpZWhgqEL3Vk3JH0
	 YdlGIA2zNfZVXclf3UHv/9xaNV299Vo6gyurKmt/DZNmapHQFXWtyZS0afpI+dFXlm
	 wRDhcO4TMd2YcODgszC01GRoozZeoLL9ADsQEK2Qj19tmfQnPcRbUcrzDoFZvef0dS
	 7ZceGqfdvwsePZTBYdfhaqppcagWdgLp2XLi/Dti7u2pgAW3nVQ/pB+Sai1iuJQZim
	 xN7f8OJSHcwqAZHElsFUxXYcnKcYpWHAYDtQCR0SSk/lU6F3HKH1rZaGYIf1GRFNBY
	 ZeYB+l26ztA6w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 12/47] scsi: target: spc: Fix RSOC parameter data header size
Date: Thu,  3 Apr 2025 15:05:20 -0400
Message-Id: <20250403190555.2677001-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190555.2677001-1-sashal@kernel.org>
References: <20250403190555.2677001-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.21
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

