Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208828;
	b=SizbzO2yUU/6M5pykB4nJ6DhHnJvRCYh2j69icIa1zxSnIh2ZOngqaiFeBBThKJuoMwV
	 yZsI/yKQla1NdUQiDRubyoBxyGz8afqa61BdVze3GHzPdmh1kElqE34ePlnhAUXZSpiA0
	 7SqmVk613XmrumRnxA8/WTEXPfWlCM3BdSIg3YJWsNNp3gPSxwgLggcEb5to7LS2vyc2w
	 drrT5HvR7ysD9RsHMWN/iKk5M7ojQuYJz5HrV/awnZCP5x/i9qQYI5Em5wU+6MLONPECz
	 1DCLSk3bZgIQnA/1fCLdc/PUCTa1kht7vua3e+g1kEdocnzI1DSAAQVD5TrMwBfMpcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208828;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=F5ab+9ZUu1hpB4j69IrQ60356a2NEHljDJSj0qILUKI=;
	b=syd4DFnKzI7QDB6fmIbylqd1MxvhJQslmGGD+MXouaIZfPdOmArdzOJmbtd/8jIWT0N1
	 iEZeEBBoNd2arjsBoUvfMWMiLQtxGhGiB+SS1Mbg9xGa5BSOpMRP2vjik2D6fbTnGgorp
	 dzjSSRsHV6ALHnFlP3QuVUuufqnOeeGTEL+oMFPu299haV8ptfzLoEneVuG4RNHAVeOzt
	 p34+ecBYeKWtc6BxlZcp4BomzTLJ1DM43vesFmCleey1+HDkmp9kkfv4jPRuS+2V0TwaM
	 DsnpQ/U/1UaPIY7YhJz0NTdiQblbv9oGeWm+PDPjd/FpGsdo5ZTOT0z30ASyREjCboQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRVwL2qa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCAB606A6AC;
	Fri, 20 Nov 2026 21:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRVwL2qa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1CF1F000D3;
	Fri, 20 Nov 2026 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208828;
	bh=F5ab+9ZUu1hpB4j69IrQ60356a2NEHljDJSj0qILUKI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=HRVwL2qa3PyMkqJh4Kx41KHTv4O1p70lPtNjBOPEZI3E6iVodJeQ87qrCM23QkCn3
	 Ivuj4YGxmevjeZpUkZJE4j1OD5hUQzhsTklp3D3e9kkmiGHFdRiyU9mkdFXo6VSemo
	 oS+w9tSCNKNFBFHIsewkH9WMFLSkRptA4Gc1bxPyI6p82LZasvQ6wx9RJXz4nX+HoN
	 TerqvOMiQLI4x2+fY5DublZ7nAnilw/ZYgCgLngh8JsF3z/pfVYqPCP1guOJkMFEjy
	 TT0gx9b0TdXVmrOQjaeWgCNxJPZ+p6uHN3tCJ0+KO478T8+seVK9t3XcauPnkwURLP
	 RKRmPuR45LCmw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 10/13] scsi: scsi_proto: refine the definition of storage element health
Date: Sat, 21 Nov 2026 06:06:48 +0900
Message-ID: <20261120210651.580511-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120210651.580511-1-dlemoal@kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
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
index 0ee0cf3200d0..ec98e4bd38cc 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -411,9 +411,11 @@ enum scsi_phys_element_type {
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

