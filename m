Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217917;
	b=YBtXaZzSm0irAAe465eXgMqp0jWdDyvgoE4mThowvZzAWJVFIqlVpzvGNiLutei1glO6
	 N8g7vlV4Tw1Q3DQ3Ld4oDptbcG1HT6cFgdJlDdhHR675ymYGi5ATds8Mtt3cM/M17m0Yu
	 5brvwxcH0WyuBKrW1ByfrCBs8qlMR6uOhl1Hod75UvTOzGsqSo3fKRayb7ja6XWmj30lH
	 vAlgzpmCO8PGPgV46FVI8tmZPXg0amCufzOEjJyni+8nwzcS2TvdlfO29FpTvHCQFQUpC
	 WIxXujTTZCVkMrJxWi3RY2V8KaUcN55fkr9bplI7worc6b/V5u28b4F5PLyukCscR2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217917;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Svoqi3SYFKJJbMSAnX8XBEuum7F45sNpHNrJV2C48TU=;
	b=w921lrhvV4FFuvf5zeSBLhG/0IEnK53kBvKsvBxlK0jRWY4X87YRyy/vXzRGOMzON9Ej
	 Onq4NQmT/P7fKZvw/uUjr/wAEoR91+A3D3IGv3PXtQ7LdoQFJPyZg3gDAwH81X0tY6a3t
	 gX9rp5Z1rYMjdI2Bq1zAabVTH6wk/7DYigU0VYk7AoWHb5iNaynlTSo4Yb/ts2hx3qF9X
	 kyLUjGnXB2wbnxVLJrTEEKIDy7mn6nJ+gg83P4Zb0KqVDrYv+K20AIL0C3KF1+QxptUL2
	 UyNFGjixhWWhmh0rDlKznaDa41U4Deh9IjcBnQOnE0PNWE5qMLA6GUW1UwzkOs1C+SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzY57c1Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6BE606D80C;
	Mon,  9 Nov 2026 09:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzY57c1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6B81F0089F;
	Mon,  9 Nov 2026 09:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217916;
	bh=Svoqi3SYFKJJbMSAnX8XBEuum7F45sNpHNrJV2C48TU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hzY57c1QwfnLgR572OcQYHjI4MQd8NOaWE+GS2rHPFi+F+liwjv9aQkKzISQHsQHu
	 bEHLh9G+vKTz2laJ50kwPxfByGCwuUaE6702LWwKyb5hreMGmQlpOCAiOPkkAlJA4/
	 0brfWNDbFgZ5NbBia9IBgeJhDWTWi3rhfXC/ftLxV7unARKcwsojVK33VEYzyBA4jS
	 ULZOtEm1UL6lqjKPCFARaajBCKQM2vKTBoqmiAUaAzjhwFmUeYJlVzYfmYRwtoigmB
	 ImP4ED+Lqp3h8gT+bNcwgJoMl5z6lUJeL7no7enh4ZL+aW7i8OakRgD5q8rz6y583h
	 va3KVrdOhxBew==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 09/12] scsi: scsi_proto: refine the definition of storage element health
Date: Mon,  9 Nov 2026 18:51:41 +0900
Message-ID: <20261109095144.819709-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
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

