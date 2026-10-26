Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.73.89.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008328;
	b=gwgSQqaUEYO779H5Jh0U48tlfYzKG4Mk+Fv2QHraMCOQcBeTb4lE1Mu8HRNuMhloi0/t
	 5pFfAY9O3kzWkw5QBxmsPwu2AVw7cJgVYNTwT79dRa1WhgXqny8ji8iqep6KV5YR6OzsA
	 6/70AIMx73ZtL06xCfjwquGDnsXhvR2k2H9WOwSlxR7dnV2Z60eB381P+qqpToqX+C9U4
	 qdZDdCXGr2X3HuiaAKioYF452BPEtNvdikgywGwGPW7s/AkR39aaE+Dq4Dhu2UnU//SQx
	 VBSL8StKpMpbibM/1rvwu1/rlcpXvb+idKAYlk2Elh9NUnNhGvQhnUjLN2TAGlN4tvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008328;
	h=DMARC-Filter:Received:Received:From:Content-Type:
	 Content-Transfer-Encoding:Mime-Version:Subject:Message-Id:Date:Cc:To:
	 X-Mailer;
	bh=b663ovS+3r1v/8UqeGNu+yv1SsbRjYEg5RNSbzMsgto=;
	b=l4EhP41YraSkmEpNdcwuCCJyyh6/wD1YWJWjqJJWmWLfGXuOHZYqO2i7EoR7RdzWbSWb
	 P743kTqLv6KjcYHuKI6Kg/l1ySuiNOMBCKlm8AvOPnMbUfuBL/GcYXit/u8yS0I4EwPqr
	 qRy+GAl/BzOMBEoxESVD/biTzG7lwqyi8GzWWVWnmvtE6c41eiat/4F9MZ2E6+jeCdOP6
	 etP9O2J3qrmD2DEc79hQrtqXNsPCStx+GnBVkmFRRSRDufnhFIHYoRhtN9IN59nMPlqCF
	 TITjc2JlF56l6z/WNcfHJ38UjCa/BgtC9b02WbPIm/BQ9iNG17fIH8r5GPLWnv+whvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=h3q.com;
	spf=pass smtp.mailfrom=h3q.com;
	arc=none smtp.remote-ip=213.73.89.199
Received: from mail.h3q.com (mail.h3q.com [213.73.89.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6004606A32E
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 09:52:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6004606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=h3q.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h3q.com
Received: (qmail 26869 invoked from network); 26 Oct 2026 09:52:04 -0000
Received: from mail.h3q.com (HELO mail.h3q.com) (mail.h3q.com)
  by mail.h3q.com with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 26 Oct 2026 09:52:04 -0000
From: Denis Ahrens <denis@h3q.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: [PATCH] scsi: mvme16x: enable 53c710 burst-8 hardware transfer mode
Message-Id: <733CA975-51A9-4687-BBD5-1FB4171FA3FE@h3q.com>
Date: Mon, 26 Oct 2026 10:51:54 +0100
Cc: "Martin K. Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)

The shared 53c700.c backend runs the 53c710 with burst mode disabled
when hostdata->burst_length is left unset: NCR_700_chip_setup() falls
through to BURST_DISABLE in CTEST7 and a 1-byte burst length in
DMODE_710_REG, so the chip delivers one byte per transfer period.
The other 53c710 hosts in-tree already use it: sim710 and lasi700 pick
burst 8, sni_53c710 burst 4.

A/B verified on an MVME177 (53c710 rev 2, ZuluSCSI drives):
  raw reads 16 MiB @64k  4.7/4.8/5.1 -> 5.8/6.1/6.7 MB/s (+23..26%)
  4 MiB @16k             3.4 -> 4.4 MB/s
  4 MiB @4k              3.2 -> 3.9 MB/s
  4 MiB @512B            2.1 -> 2.2 MB/s (small-buffer case is SCSI
                         command-count bound; burst only raises bytes
                         per command, not commands)
  writes                 unchanged (filesystem-bound, not ASIC-bound)

Integrity: a 16 MiB /dev/urandom payload round-trips bit-exact on a
cold read (sync + drop_caches, md5 verified write vs read); dmesg
clean with no timeouts, sense errors, retries or resets.

Signed-off-by: Denis Ahrens <denis@h3q.com>
---
 drivers/scsi/mvme16x_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index f4db93c13986..ff6b22c864a9 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -60,6 +60,7 @@ static int mvme16x_probe(struct platform_device *dev)
 	hostdata->base = (void __iomem *)0xfff47000UL;
 	hostdata->clock = 50;	/* XXX - depends on the CPU clock! */
 	hostdata->chip710 = 1;
+	hostdata->burst_length = 8;
 	hostdata->dmode_extra = DMODE_FC2;
 	hostdata->dcntl_extra = EA_710;
 	hostdata->ctest7_extra = CTEST7_TT1;

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.43.0

