Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931073;
	b=x8pBu9oAwUX9CVBedBPrcHbsdKoJJ6VeLK7rF4NXWYDn85J3Crevyzc7zN6RnIfnccDS
	 VT5ITbho6YSDMGg2humazFNe9o0jlw9IfRWRnVD4RzjyIwe9iOiaIP5AD8Id8U63spqrA
	 ltav2e62b99YmWikkm8pGS5WAOAOKN0GzP5bqoyh844BivHkrnWeyG9qYax+TWc43YD74
	 cBuJtuBKrjsNiBdqcPjAETRjL5cLv80IAUXwgxt+OplPPLnFMsmluDGKvLSw4p4t5qVqY
	 3wicrhDHJsHPfZcDjOBWv7XcsKeYARuE9ClB7IOJ7ExzN0idaHCG46TyZSMwqiyeVFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931073;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DjhSozQl2ybllrZvqUos4/bIaOLJZANVcsLtTPeVlHs=;
	b=Weby4oJO1doT6SiK5/ueh1yC+kxps5++I9PI+pOvzzcSVeyc7aQYPc61lcrmoQXrrylm
	 00t156dy5hDMTHN2ScGQDMqlWiw09YeCzCTazgXjxrXWPShj8wvo7MnXXGpK9vr+AD9zu
	 4D5h80uoCL0zs1MBcSs4qcr1rX8rfA5E9OCf+MG9BGI5Du8qHfLEvdT22s7abZlqDI39o
	 9Nf0wrQ+3M2EG83JULZMyqicwuPty9K6nP0FIAuZ3NWQrN7x0EJhbaHkTv/pzsMT19IJp
	 Fr2JNP5aVCtHVpIfOVFCFRNBobmA2ftMa2I8J+7uVBKS66Hpy3YO14gE0dDlUdv2hQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HYcuxxG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCF2606A32F;
	Tue, 17 Nov 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HYcuxxG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B028E1F000C9;
	Tue, 17 Nov 2026 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931073;
	bh=DjhSozQl2ybllrZvqUos4/bIaOLJZANVcsLtTPeVlHs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=HYcuxxG4tO/4sqDcq9UyScN+mKIVO0iiF8xaWOeRMZiNXYk+o89YBHIWpKPOBiY91
	 wPkrA3b0XWVOQ3xK7Yy7aHrhPzEAc1yNtJiI0ZvgTOm4D0NBdfN2QhVV45zc5mPBYM
	 V36UOUAQuM6QQ4ZsbWfhFaS5hq3iujXxnHxoSSblfPUKDWwDJ5dFBAYpOLy1fLNUmf
	 31xfOmOwXVI49kKR59bV+RmH4flcC/tsUvmQmlRSnws3Hxg9BxwKBNLZmLbhUTKRbT
	 gcjMxwwMgJcNhZ67RYIPmNZ/PIDjL0pRGnUNQR9HAP3zUv3WHHwSV05WSrnFPb1sdW
	 cV4NGk984BF1g==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 10/13] scsi: scsi_proto: refine the definition of storage element health
Date: Wed, 18 Nov 2026 00:57:36 +0900
Message-ID: <20261117155739.304506-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155739.304506-1-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
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

