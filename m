Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865035;
	b=4fS5fcmQRxDpSkxLo3KxvxHWLjv5k/PPcGoqRAYK5kezcy2UZPQgPazJvpNHkXqr4f00
	 jXBXzuRCjSUVSCtit1qpLxga6T2+bVzTclyzYx4fF51b7MXwnfPBH8wMjllI8Ra7JT5vB
	 mu0cVdHY6iLudDWEMxYP2oV4nOzPb8OgPKlVrFtchcQWfzeYTGen3RYxNbJf+8L3qkGGD
	 fgdWQv7FCNl7pjk4DFJYIF8DokWEv+jG2XNAjWi9difHgbeV9XS6KoK2VpMxAKdQZDgU7
	 cIBGqU3pwXGpeTPFCUwedkl8iYD+DmMVl8KnJu46ApF+YhSnkPVHo4DVSdJqp2pDD+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865035;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DjhSozQl2ybllrZvqUos4/bIaOLJZANVcsLtTPeVlHs=;
	b=RaANYFvF3ad08squrG+rBJTlZ/8Nt0/NiRCTr33l757rZlaNEyxKccUqlRjJNPwpzvsI
	 ZXDZb/6qcn7vTloc+qqpf/M+ysHYpA3wP4oUtXUlrdB570e+tquHAiznuX6u4DPf5xkt9
	 nH35lAqudHKa0DY/ImWwg/kHYm9G/r/hzCX8lJKaiXxoq+/NF+gmPYOcSSXWibIzbzFFB
	 2+7qndC7PnF1l+AsBL85l8dz8oS+1a8ZITjpgcLf6tMKiBbuT/M+CuIG0cJ6mu05pqsr9
	 phBvWOPdaqMgcEctc55zDcaC/R9nT8757via0wArVmlzzVg7u4j9h3nDXiopqTYrdug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QKnekWhp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F372606A33A;
	Mon, 16 Nov 2026 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QKnekWhp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27E01F000C4;
	Mon, 16 Nov 2026 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865035;
	bh=DjhSozQl2ybllrZvqUos4/bIaOLJZANVcsLtTPeVlHs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=QKnekWhpGj2lYZPO/JqTZUz/NkmcCZnH36O4ptyM2p2nkOw7+feCrYKRgii+v+Pxi
	 co9WGaPZvG9h2HskITcRcvqydS/BsOFiUrmBVdH01eeaTugtayjWu5BtlO1pW703W+
	 tXXAxAdSHr3S8aEyuArWIYpOsNeqYAjMAZqxKKBrDB3dxdFxhp7rTIUF8FXjBBA1ut
	 b9kXumb4/B4F19Y1hKf2/l8nl11W02aXzC8R9FrCNa8lm9OOsctxy1F7rsaLvrh6eq
	 GrLh6pXS+VJrQ36/6K9sW1EZuZvHPRbV4/O+CAZcW6XfJ/v0dVUOnrv1/Zf5UwwFfy
	 rHv0BOBkNjdhQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 10/13] scsi: scsi_proto: refine the definition of storage element health
Date: Tue, 17 Nov 2026 06:36:59 +0900
Message-ID: <20261116213702.225970-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116213702.225970-1-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A disk may report the health of a storage element as being within or
outside of the manufacturer's specification limits using a range of values
for the health field. However, in scsi_proto.h, we only define the
start of each range using the SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS and
SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS enum value.

Define the full range by renaming SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS
to SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN and by defining the
healthy range end with SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX. The
same treatment is done for the outside range with the renaming of
SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS to
SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN, and the definition of the
range upper value with SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi_proto.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 9c7d31aa6bae..f290a214e3e0 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -408,9 +408,11 @@ enum scsi_phys_element_type {
 /* SCSI physical element health. */
 enum scsi_phys_element_health {
 	SCSI_PHYS_ELEM_HEALTH_NOT_REPORTED		= 0x00,
-	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS	= 0x01,
+	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN	= 0x01,
+	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX	= 0x63,
 	SCSI_PHYS_ELEM_HEALTH_AT_SPEC_LIMITS		= 0x64,
-	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS	= 0x65,
+	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN	= 0x65,
+	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX	= 0xCF,
 	SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_ERR		= 0xFB,
 	SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_IN_PROGRESS	= 0xFC,
 	SCSI_PHYS_ELEM_HEALTH_DEPOP_ERR			= 0xFD,
-- 
2.56.1

