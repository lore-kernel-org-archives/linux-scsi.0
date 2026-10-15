Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD831F998
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025875; cv=none; b=s5cpVoUyZ5nukG4PJIu511RzCnzZHPn01SY8CoIqSyAZZroYhwSXlaHJPT2OGUMGhHlbRzU2ALUI7U3/l5Wq5b32pRGqF48XNIYkzn+9Rxl19tWFwmfESCIAxuZ8evarZDslRc8OLTZn1k1dQaZFdcZcvgEE0OafaGxYptLUo8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025875; c=relaxed/simple;
	bh=2Ma9GnRZ1pfxKss3kXTKJt7xWTgrbB9CuG2Ct5tdYxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWCWYDFnYvLbW/WkqQY2ZFeLefxGq1mjtNN7jwrNLQUv27tblBR8T06oKAUnWEgRmvhRid5elctcodqhRfGDPyCqmUxbImjJqxLDZw7Euey99ZIMCqL2XvdOd2joPY18YhWZndipHtvmjJ6E3+aOQ7r30q3td0U0ALCn+N2ylDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=SotAyp8Y; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="SotAyp8Y"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so826422a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792025873; x=1792630673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vF71tENdAwcc/5EFA5/ur+3tYq0jtuBokrygU53hPlU=;
        b=SotAyp8Y52320RhY7JRNVnL5jD+Wb6ofMBdBCkKYgl//1reWVVtUukYi/R4M559RJ4
         MFaLidxe+nCp46cPAh2kyLUVbmN2eTpAqNWs3vJbq3Cj6KP5ykg6cWOBcHWc31tNuCNU
         xMdH9YYBptYu1kdfOjOvHXmBB0UPkeXrTCc+8iaKmK5ujCF8gTjjJhx2tGI6jsZOhLkp
         VT/+AzrjYnyzfndG1oQMVbZdNB90ABv5XwdDezh2YRBC8PJ3SOWO0Qr71YVPeJBA7+fK
         5iQhfqc1jIo3gfwuHkpy1zKq7sQ0R9LiOhbXd7w4vrelmy2woj64hNEi6vVkvq8oK0L3
         7oqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792025873; x=1792630673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vF71tENdAwcc/5EFA5/ur+3tYq0jtuBokrygU53hPlU=;
        b=w08OmM8eGvXbFHx5aY23pHUg8kIH6oFy/svobapyOMUaJecZ8ysbAm3TM4CfnGIL/5
         IKiHUl3hAroD531JI10tT79lgdv2S3Ms7JSB/MztDVzSgJyl2C9AgUUuVlCgGhop1bCB
         PKJZyr2qlJAWn7Ax1Mzy0ePWWnAyhCGcG2HWkcwkDDXqi5zaq9DZ9KzWNJ0DrGMy1loJ
         Ecs8B/YL4DRUK0747Io5K/oFg84EyCs9K6AobUN9MVRF7Dy+b16lG9rR159OQguMfD4h
         Vqjt9gCRD+wEW+0X0wl4BZRE1EoJD78Up65HZsAYoRzfl/jcBcdtkJNDlyY2OcVY4ic/
         NIEw==
X-Gm-Message-State: AFq9FYI0JQYXDz9KDHZVkZwbvQfwzz8x4pGcQv3FY2YIcmQz98jt6LPZ
	i1IEVC33B4iIjGsAlhP6sMW6+m2LVN7/CIQyYmAqenZMsB1kFtPaYXPNpDq6BT3KY2TQjeELGTn
	amygO
X-Gm-Gg: AYBFou1VzIoKJ9C5Fb3xxKZtIgXrv36iKOnkTPRUqnurlaf2EBDMGKA658y69/UGLRm
	S6RrKmX0OvF8jqLRAQubg/Jr6xC1pIdvgYJWDQSOoi5EupwjMw5KTBOGll/92rrBmAeGJjMyaGY
	7t7yv+vTryK0L9pUy9RvKQ8DuFTRujexT1JbOBcbokNGJ8LMED21rQ2+e4kzCoy62fRasPgK9p7
	hgHBJM/zbRJFSuEpflDGZkgXE+ffQRgk4ywPvXt2+HHmAcIAmSOd6Io6TyS4R7U8X7kQdy8vkW7
	M17DNXAyFGQ8mOPK2/rd7tZgONefqGnD3zPS2ungYgg9xuPQKDClc6jDPDlGhKUPXhUcecLrs45
	PJabFBhU1kKFLjiaZz8aJxo1MD3dxBoPiWRIsDUKVfPsGRZqxA9ad9qJ63F0/4eg/50k64rNdEh
	tXnovkA7w+d9bZ3nv5URYJ1D89N852Ef3x76p7w8KqfYJC3/2ozmvLznjbg9jkk41Xon6nTGjs/
	hcflA==
X-Received: by 2002:a17:90a:ec8c:b0:3ab:24b2:9016 with SMTP id 98e67ed59e1d1-3ab3a9a8d8dmr16519426a91.25.1792025873377;
        Wed, 14 Oct 2026 17:57:53 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac92a43d98sm999198a91.0.2026.10.14.17.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 17:57:53 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v7 7/7] scsi: mvumi: fix the DMA address rebuilt in mvumi_delete_internal_cmd()
Date: Thu, 15 Oct 2026 09:57:17 +0900
Message-ID: <20261015005717.3719956-8-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_internal_cmd_sgl() splits the address of the internal command's data
buffer across two u32 fields, lower_32_bits() in baseaddr_l and
upper_32_bits() in baseaddr_h.  mvumi_delete_internal_cmd() puts it back
together with

	phy_addr = (dma_addr_t) m_sg->baseaddr_l |
		(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);

but baseaddr_h is a u32, so both shifts happen in 32-bit arithmetic and the
result is zero.  Every byte of the upper half is dropped, and on a 64-bit
host whose DMA mask let the buffer land above 4G, dma_free_coherent() is
handed an address that is not the one it returned.

Shift in u64 and cast once.  Where dma_addr_t is 32 bits the cast truncates
to what lower_32_bits() stored, and upper_32_bits() stored zero, so the
result is unchanged there.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 2410d2aa147d9..bd1a8c1d54aeb 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -295,8 +295,8 @@ static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
 			m_sg = (struct mvumi_sgl *) &cmd->frame->payload[0];
 			sgd_getsz(mhba, m_sg, size);
 
-			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
-				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
+			phy_addr = (dma_addr_t)(((u64)m_sg->baseaddr_h << 32) |
+						m_sg->baseaddr_l);
 
 			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
 								phy_addr);
-- 
2.43.0

