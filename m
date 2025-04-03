Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9977227D77F;
	Thu,  3 Apr 2025 19:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707273; cv=none; b=PiZ7Fn3LXHaveHsb8+O1svGPI0xP2wC2VC76OaUFGcUWTUVGa5QK2wIIxbCcgOAq/8tw6hAcZIc7LUj9+OW9q/VCvucgdihZsdYHiN8xzKow42cLaK7dh7jFrtsW+oW2rYl4NTyxw0S1nAKov8f7n52oYRE0NQQ51CdhG4hyj0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707273; c=relaxed/simple;
	bh=G0h4UFeQC29x4Ftgnub9inmXYtnCE0F0FEY/LS3V9Ps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QOYQ87Af+I7wGBxeGbqHK5JF0hJr0ScA7YrEiOgI1orW3YPNXVdVBNqzk6nRbL9mAZpH4yq9gtr1gpxpl7xVZC91pYink1hInHOUOTU051S6juNaBYp2Q3wzT80sgre3opbRtr5ijyblxizXkwG3r4YW+pOBgdZckq/BJKM1EM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0s6qoIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0s6qoIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDDCC4CEE3;
	Thu,  3 Apr 2025 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707273;
	bh=G0h4UFeQC29x4Ftgnub9inmXYtnCE0F0FEY/LS3V9Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0s6qoIwOuRqS0I302Vi/t0mvZooZbDgnu4aBF6BDo1gt+KYpfTVhitJzQeadi24i
	 Mx2zVuOBbMrbnsT8b8ZD3EEpKCCgF3ZqQ0Xxqc20I0U5m7WSJCQcO69Xdbfz1PbHAx
	 kzWvwyQ24JIHySOdRmLYtrlq9G5dNpnM75fKp9qVPrkXMxaZvaFSiWOrJdH5BLUXZN
	 QJewMrMiri9G6BTz++yqjs2ONEk+VtaOzRUsC4JvLbP3btMBmwefTR8bDMIrEWYHu/
	 +cQLLc8S9stt9dz9ute7J2EVrYX4lHOZFQspTEKynjHslAJzj73yFJeBhGXXTxWHpm
	 Z1XlO4FLAE07Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chaohai Chen <wdhh66@163.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 03/26] scsi: target: spc: Fix RSOC parameter data header size
Date: Thu,  3 Apr 2025 15:07:22 -0400
Message-Id: <20250403190745.2677620-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190745.2677620-1-sashal@kernel.org>
References: <20250403190745.2677620-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.85
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
index 50290abc07bc2..f110f932ba054 100644
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

