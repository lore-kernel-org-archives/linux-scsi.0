Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D4B2620EE;
	Thu,  3 Apr 2025 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707072; cv=none; b=p//EOdgTC+aICRcMLY7wEEKGM1D+zCqpwH1NKIzvNQHaEdjrqy60sVhT/tw1omaBNJq9gW6Szjwj5pamKXomHaKsgdlUxpste35UKfRLez7bFTYs2MSPf7GVhvaHHPd1oN1afQJpxmkl1Kr+RbwZr7r4wkATxPOqLMHAN+OIOEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707072; c=relaxed/simple;
	bh=g0zBLxavqYSYO0LoA1sa/2C1ksx9MMtJvA8PF7M0r7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MaZFu6gvM6WU35xpUmfvQpAiIq/hTLm433vccPvFi4ZGkR6eumEJhj8YJIAefdQrE6R5CM1oVznkbD08chQANdYk2+J//Tp7h0otaV91bFtCWbD6dwN6xjplNFHhwQ19zhpN1o9JBSDmXYM1UPRXeYkHvNti/KCRnwAH15lHgsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkmKrlwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkmKrlwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509A4C4CEEA;
	Thu,  3 Apr 2025 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707072;
	bh=g0zBLxavqYSYO0LoA1sa/2C1ksx9MMtJvA8PF7M0r7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkmKrlwpXS7+oKnH+9BOY83hP2Bp76FCNVxTLDzoOJ7ZiuwcWbJe4HgvE0dNUzbfF
	 OJjXsiMMntRUrcPpuYNnMg7aY/nCEhCI56KXuRjo2sqQGeW6xmXuzGcb9kP3nGq+g9
	 m1k4plIyFk2bNv4fpnGVCe2BSE6huSwTJjCQzY1VoztVz3Hk7OKUTm/+NVmD9/K8jd
	 lLLAONIySmMFQJyyg7ZGxX9gMRnZ6QBseftCklCaS1/GPJ4Rx/zSwrBZzEGPrBwaiw
	 ZD6QxkUYcK1WpFMF6yRjCanifrv2kgoTCCpnkdbCQGWEPU5UudbgOxpsedLM7xRhwD
	 zFbIMT/OTD87A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 12/49] scsi: target: spc: Fix RSOC parameter data header size
Date: Thu,  3 Apr 2025 15:03:31 -0400
Message-Id: <20250403190408.2676344-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190408.2676344-1-sashal@kernel.org>
References: <20250403190408.2676344-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.9
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

