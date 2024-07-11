Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C7012C52E;
	Thu, 11 Jul 2024 17:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720111; cv=none; b=ZwU+2skPbRSucr0gCX6XPHAHoxSQ7AEn2dbmA94sELDcIpj+rT8+c5cNOcwx1V5MmcltLrCEJWMVS63ej3ifMue6FErHoghfcnVHSMtiDrBIKQyIdM4cdJIQMVcavKtkP6fmSQGSVNv0ce9ExQqHepu8WLvf4oeJkkUPW9lyfxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720111; c=relaxed/simple;
	bh=HGcnN4KTok0t7axiVRtqkEovmvgm24DUvqfkC7/4Hg8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hJxevq49jWTv+T47AumknaEyvyvBys8GtBWjmd1Pzj9IA/15N30Okiwz88v4nYuSk1NqC/WSI0sCZNurXDU2OkchCn7eT38h7AfYk5vAFwxDD9hJwg/TlnzdMU47vGkrx+xKD1pAHpdTHsDDXzA6MEy2qCG5ey74Eqk/q9Iu/6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOWPD0iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOWPD0iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54666C116B1;
	Thu, 11 Jul 2024 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720720111;
	bh=HGcnN4KTok0t7axiVRtqkEovmvgm24DUvqfkC7/4Hg8=;
	h=From:To:Cc:Subject:Date:From;
	b=sOWPD0iQO2087GV6Wy719T6yjDeOLzuMNTPbXZovWf2BDn1PwG73n/8Ab5vpzMq9z
	 2N/lp9SlQNTuU1oRPuQ/7FGn2h4YbFjHW8ArgPQ9dVVRXjXAAsNDvZ6hesXB0D8XkO
	 kLPXAIsernn2DppfhCrBKcOLpAe1G65MLp/fmMVTB2G2xMMCxZYxGI8cMHX0TMHqQx
	 D464k1Cq3DMxgXC7p7douXiPWXzzo8L14uKJMRkb8/W6nid5/CkZ2/1maXFMvh3T/e
	 HlKj6Qh7POFGR2QFgrMdxuyU0+ohryrZ2ZUyAFB6i/gNfvvVLqWYM9TyWpYNYOV6uI
	 zlCDz9iG1aWTw==
From: Kees Cook <kees@kernel.org>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: aacraid: union aac_init: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:48:23 -0700
Message-Id: <20240711174815.work.689-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2162; i=kees@kernel.org; h=from:subject:message-id; bh=HGcnN4KTok0t7axiVRtqkEovmvgm24DUvqfkC7/4Hg8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBrmlNgW/4H9lf+vQtTOiV5fbi4QsQb2L+v/c lqeVpUgiLaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAa5gAKCRCJcvTf3G3A Jn/GD/wK2gm1gCxL5IXKrUtAmylMoT/MHacXDK47HEy1zGd3V029xS/MeYZ9IDnrmkCsqIGFQNz sdE3svAvY7o8hF5g1o3o0FrPQhYAJFMr5oxOFBEFyh9PtXwUCW0AA7ObaVPv0dGhkBq7tW42uTg taR1hMccfb567jp4LFqZM/lobei5rC4DQsgjwJpDujRvbNZSX/AgnTRTLEhzhZUOR6aGy4CQntJ QWu4tdcjPP5sbTAeQ03xB9+cxzPnAz4IESFDuUAq7insuUx3aPnfosbdPZzCbIIZkcrJosRW6gE XF9gdkqI32U9s4zX+HFVowiIb4piatszrZqG/hs4uibdRCqZ+gvOhTSCbz6M7+8Ms37j+155tzH hC+4P4f5DRkGXGlnInHXeIkZiLMxUC/sRsiqmOc/eLO8CsEdk0slpRKT7BUXbnTAByBJKrU5k3Z 4E63tKRhu2ajGzfiYp0NQsg9WPcYqHTNia7rob6tVge1D3MGj1wW9XKoVb3VqA9HP8vXmtLCXvz dxg+VLIktYMPNLvuLSLSoOLuk2aTJwMROdiPBXc/fK4C6Wdx97cuefifeLGD6BB0K83+I+HtLRi E+sKnbC0JHa7woXQz9kfEzwinw2RjD+65F7KT+9run/0IFjvULyGaO2+oK9TH+R63u+Uu/BWRck G403EI6tkQOIA
 CQ==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
union aac_init with a modern flexible array.

Additionally add __counted_by annotation since rrq is only ever accessed
after rr_queue_count has been set (with the same value used to control
the loop):

                init->r8.rr_queue_count = cpu_to_le32(dev->max_msix);
		...
                for (i = 0; i < dev->max_msix; i++) {
                        addr = (u64)dev->host_rrq_pa + dev->vector_cap * i *
                                        sizeof(u32);
                        init->r8.rrq[i].host_addr_high = cpu_to_le32(
                                                upper_32_bits(addr));

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 drivers/scsi/aacraid/src.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 7d5a155073c6..659e393c1033 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -873,7 +873,7 @@ union aac_init
 			__le16	element_count;
 			__le16	comp_thresh;
 			__le16	unused;
-		} rrq[1];		/* up to 64 RRQ addresses */
+		} rrq[] __counted_by_le(rr_queue_count); /* up to 64 RRQ addresses */
 	} r8;
 };
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96..28115ed637e8 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -410,7 +410,7 @@ static void aac_src_start_adapter(struct aac_dev *dev)
 			lower_32_bits(dev->init_pa),
 			upper_32_bits(dev->init_pa),
 			sizeof(struct _r8) +
-			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq),
+			AAC_MAX_HRRQ * sizeof(struct _rrq),
 			0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 	} else {
 		init->r7.host_elapsed_seconds =
-- 
2.34.1

