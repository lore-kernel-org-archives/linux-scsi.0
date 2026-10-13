Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08F4657D6;
	Tue, 13 Oct 2026 09:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884639; cv=none; b=gjjOF1BeMOjmqcG8aYA9D+HrtnSYTDA28nlz9hZa0+TaFWyYaEb4+HFdn+H3qDnbA7yEEymU7jTNVBwN7yqIhbli1e0FkrlyVJumW+1oDuc4+iit4ANP1+PNWKdnoT4YZxus0v0jIyWgZUxPFZ7rNcHHln06bHJV44rNkA7m/WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884639; c=relaxed/simple;
	bh=iBeMOXfwqztkScXJ6EBRdzSuX6cQGWoav8I2nGPJz5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O6gl0YB2vQs78FdinGVf0LhKXzOBo9UsXFiJM/kG8CwdgeR9pFOfke2fMJwDZuhmKSUTTnsbo2p+FrgqWn6g6n1+JXT0PklthK3O/qcSNVsyfeMTRzeZNmr8Qx1PiMjwWKRKd9LCq1/x+ArniAl5WYKFW8zfOcW1KGQ9iuH+y80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqQ6GeQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqQ6GeQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8858B1F000FF;
	Tue, 13 Oct 2026 09:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791884638;
	bh=YqX6SKPwcexzVKqyQwTik17Zxcole8YP5YtIpcK777o=;
	h=From:To:Cc:Subject:Date;
	b=lqQ6GeQP6pGpRlgiOhMcYb9X5LbjDUh2tHvkNfQS4cUbjWkqRV4hluNc43zABKVAJ
	 3fZxe2zBMen/85Dm/pTKgsJM7te5L4DElNaUERPKy26S0DKp+zqBvKMeXstYq3BCQI
	 fj6UCVZqBDXwEuZBX5jR4l/aGJbDK4GPGPFctsLtHh1TcdTH5vTPejW+65z8fHF7s9
	 EiTgMHplCCeqYoBJS08JMSL/0Ea0sg61RTBvuiwfO2sn2AEQmp2txBzX7WAhbVEe+u
	 6hEa/TbXbyvXaj3stgnoG3Qjv8E/6wUbDuveuAS+D18oVMXWJ0oiz2D+W0uGZ6nE3R
	 /laFOJUlL9XOw==
From: Imre Kaloz <kaloz@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Tue, 13 Oct 2026 11:42:53 +0200
Message-ID: <20261013094253.2956-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The REQUEST SENSE length was taken from sg->len after the
AHC_DMA_LAST_SEG flag was or-ed in and the value converted to
little-endian, so the 8-bit field is 0x80 on big-endian hosts and the
target is asked for 128 bytes into a 32-byte buffer. Use the buffer
size, as aic79xx does. On an SGI O2 with a Fujitsu MAX3147NC, the sense
data of its CHECK CONDITIONs during probe was lost.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index b9761f9f0bbc..db330ca92767 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1097,7 +1097,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 				sc->byte2 = SCB_GET_LUN(scb) << 5;
 			sc->unused[0] = 0;
 			sc->unused[1] = 0;
-			sc->length = sg->len;
+			sc->length = ahc_get_sense_bufsize(ahc, scb);
 			sc->control = 0;
 
 			/*

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.47.3

