Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38A1DD525
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765377266; cv=none; b=hSUCMAfjE2mM81UbYT4LHHhl8icXsGTXOpEBEAHGvsu9WsM+aw2yA13a8NJIhJJj/a35rtZqAP4ksK/jlvtetmEo6eL47u5zGzDVFCz8ydQ8ADn9laBVsVduptO7yQJQsJCVlOqRQxlD4VyHPlWa65BAzasrFZ1UE6zokakuGFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765377266; c=relaxed/simple;
	bh=2WS3rrZm+F8ovENMEl/dXpGHHcrtvzF1EVbHs4QGHAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OhSjFUNIgvgGy8/l3QciAcgVpzI/3kRNc9hKOzkaZJXbDGWxsyY/TAdgJTc1eYSCEgg1u9zpTcLNRdTo6px5jAv09aOEhnY3f8AWO0pz79HorzvZ+6OLZKYAOVdg/DE7FrTqdUVAdIFeFT6liWRV7NTSAejgYtxKNZt+9DhWtbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i4CvwCeW; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i4CvwCeW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765377262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tEsHJveht0SyJbnfKVHDY8F78/di9eypxFpFVPZa3EE=;
	b=i4CvwCeWvbDRySmld2aUX1/i7tLfgQ4nxG0L+1T2fHqsCwrVkhE2EbYK5qEnfV5rZUpGD+
	MSExMbrAnYHWYIoOLXU4sA2C3ncT7tvU0ePOdEQpX57/Y7g8tdI1kRkPikxYKx40a76tHf
	TPxnowz/BNHSmzRcSGDFH5jwqWNOYGw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Replace cpu_to_be64 + le64_to_cpu with swab64
Date: Wed, 10 Dec 2025 15:34:04 +0100
Message-ID: <20251210143404.596284-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace cpu_to_be64(le64_to_cpu()) with swab64() to simplify
mpt3sas_atto_get_sas_addr().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0d652db8fe24..d60464668123 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5539,7 +5539,7 @@ mpt3sas_atto_get_sas_addr(struct MPT3SAS_ADAPTER *ioc, union ATTO_SAS_ADDRESS *s
 		return r;
 
 	addr = *((__be64 *) nvram->SasAddr);
-	sas_addr->q = cpu_to_le64(be64_to_cpu(addr));
+	sas_addr->q = swab64(addr);
 	return r;
 }
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

