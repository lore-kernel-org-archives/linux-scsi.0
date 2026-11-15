Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785620;
	b=NGaeP7LSNpwd6w/oX51hapy3BtJjImbnCy2gveMkO2zmgPNflfiH6BOd+52eZixK2OIm
	 6Vx2Cnb9OMP0Y774BVp8BNKOpeADH15sW/BPkPWKQle9bNlwm/G04nXD8yDA23gjNrfrP
	 pdmCwp4HLsE/xzpjY0yCuimFr55fiBZr7GUxejizZ7bDUJJxzhftmASW8eKUaCCPfqazs
	 yQS5QZVVN/eMSj4RPUYm3DrGkzJALaWV0UnYCv9wC7zRgQ966lIPmVTCO7I/0+6h/f3Qj
	 SKbinIuGflux5UY1bcA3gOeh2TiGJn3eKf73lTV8B04oSbwMrdYr1l8SBfZGDiMpBvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785620;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aG7SLsBMCKK3KHh8tJEKySbfqFCHL1//lVE0aKE2nhk=;
	b=GC2rZL5O5cb9phikFif72L992YocmO2LkRrDv3j0Ik5vm2p/W/QyMHLIXsokEcycBP6L
	 gf9cFxwuFb5YRMPoSvJDCEficLlR/e94V0NKh+By6rwOc8yT/A21lGqHeCF0RitPug5nM
	 idSvpYEFcVo9gHfxIYfjGXFatVGaCtUiVVvkBmRCDVLWIzRJNazaaOJa6itzNq5dGnJTJ
	 eZHKYE0LUa+4JQ9ToKdbRTYUnIFJOkdgOE+mTsEUHsOb2AGINT3Omi+jn5qNynzVkdLyD
	 y0OLeiE15SgzKX8/kkTFWLZUVN7M3RZpqwn9y6EAzZrnsLkG0AWR/OKWmHt2SVuN84A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6th9Tob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AA8606A336;
	Sun, 15 Nov 2026 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6th9Tob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56991F000C4;
	Sun, 15 Nov 2026 23:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785620;
	bh=aG7SLsBMCKK3KHh8tJEKySbfqFCHL1//lVE0aKE2nhk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=n6th9TobuNRukDCVBaobzmd49/Xj2E2rwT0VAoikoLQigYkixLETUs5eFHBCYbsff
	 05qvg5T/GZaLTvLbfkQGWTBhZkayUGIJ0MU/IBBqaMd7iihxS5WVrfBo5MfraW57+V
	 I+XQDH5YFLFwpoYH+79KDn2I8Y1w482boRHo3E5NPwoWemOEgAcz6etKf9a6zJ0UBh
	 kInNOFF7v6TDCKzCduLzR6jCIgusIF9HRsDeGJ04OHGL/qwSEebYUyJfFVljHCfb+n
	 qZl2a9/dd/9GijPjgrEJaCb0HgHgxwDNlx+fVbCCX9gPHF8qbQ9sVbv0gXSyWKL44v
	 LgQDPse9fTerw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 10/13] scsi: scsi_proto: refine the definition of storage element health
Date: Mon, 16 Nov 2026 08:33:24 +0900
Message-ID: <20261115233327.941586-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115233327.941586-1-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
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
2.56.0

