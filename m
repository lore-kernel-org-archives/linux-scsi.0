Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212953;
	b=eKRiq/vMtLjPtkH2178uIfPk2BeXedP84LddRiD/hq2/Nya+A+QlR57QaWPUlRD+25RX
	 aOZ/KPFx0+rbl8xu6234YGfW3CoViGeHQuGRLoECNUTb0TKycfVJUREmRh+6Gg099SeZM
	 6u75cDE96oF6h9M23kXxZiqOZTEeav9xkePvWUXRTCerfGGHdC4Jo2JCOxAPOfcahd6ev
	 UNk96RqTdOPKieZRR+mZOBnP33DoRwFGY7W2ZmxINowuSqLT/fkWyd3kodTux8nMejZEt
	 7KO0MKB+FZkKk9cMPtfitm/N3vjKrAznuTTbvyiQkZo46+VVYskJk+Wux+uHG0t8ykA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212953;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z57n06VxnMVqFWoAETIEnriHf2j5yRJflYi5zzCjYM4=;
	b=2UZk0q2JqYL95zFBcbmYpBJDnawanmjpy4r46X2EeMhbInODKBTM2lcrxIjynA/kSZWp
	 mBbnqPS3u/DSCJQ5f9+Rh8uhR2OOiHU2xWVw85t1XoqGydW0eONITWgfDR2ad429GhBF8
	 p5B9373sTFPWi4mRenFoDG09+ydcRzpsyhXvlWA3Qq9yY6vXp7O6H0VlmyquUfuUhOOPe
	 6t12AoYh05vgSNPqj9ic3nzFiVKv1dQGbZNIMFQ3G8hrv/lMu19ao9E7U3g2VdmZgzlwa
	 mgjgx4u2KqOo5932lVHFgn6d5AHU/3PfXf5lhqNm6jrXa9dQazT2bWsHmuVd9stderA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=GdvD0+JU;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF0606A331
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 18:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBDF0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=GdvD0+JU
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so1850105eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 11:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793212952; x=1793817752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z57n06VxnMVqFWoAETIEnriHf2j5yRJflYi5zzCjYM4=;
        b=GdvD0+JU7QrOVCGxl99dvHEe6Xqd5q+biYPRG65x+9Nt2tIZcBiCdOdBcsYMtXuuwA
         Hxr6v/NoanMyUD5+36PqG0I0vhov6XkBrwa/7S350fqXR45Ld7B1uo5BJP1kRKxjan/8
         M+9IwvT+s9dNsrtGknlO7y5dmGRVFvoqDBP9MhgPcsUp+wHpqvBODlsB4xXXl3/wkQQ1
         AT8tdo3qbCTzEXFprsAdnhi6ETegvyxyP6tWleDEbimozFmRUOascoNjB8OotaUGN1WE
         k4Iq0AB4RKXdgue+Okv9RNgUl5LDJLzxmkgobYxw5STvbs3wbMyw/XXOeDIGOT6B9kxt
         O4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212952; x=1793817752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z57n06VxnMVqFWoAETIEnriHf2j5yRJflYi5zzCjYM4=;
        b=KRN4b0n9apZ2QKKarfhOuuWwtuSxmFTNLmA/+KXlzQcOTecw/eU9m5f4IlkN3028Kz
         aTovZclWrGYaLBO+A/7zONXapRh7SBtjcXyxBygV/hDC6jCH1klgy6Mcked7zz/N7tB+
         YZfJSg4lkgI8sOhwBqn4s684mPTuGIKe6irtp47HmLdmI9ghdqCU+41gy02ldlTN+VnG
         OWCVJb8BlrG7BCUB0rDgap7E0zn3/mzlPrPwCKHDaePJdB2Y1i+0BwqolhQKEUakivoM
         b1gbx7KmX4GyPUxAMU2nZ7YDOAhUu/UAw0cESE9i+x1HU0EdDojhdAJjRdL3USwOQcpT
         Dx6w==
X-Gm-Message-State: AFq9FYIU8nn0WHzgA4eBPjx38fd8Vz8YH7o/3eeCYo9zOVvGY6njJe/b
	8GdFBDvxO6i0puWGLDUSsNjPrR4Ag1dc+7EXSps0gPB01yKx4LkC4MTZOKc0c9QTu93ANYqfHYc
	na0UaCh9s/KLjegFSqIQpaFh0dRSXZGMUtbxpcZlaU3hOdym6RLxh5oPCPHxLtQxID3GSTONceh
	sCFoRvxxYChlBdLcopM6pBzJAx3YFDLaoV3WnPAa1T+SkzseoUtQ==
X-Gm-Gg: AYBFou1bHj/4jwEHC7C92su9VqcJDxfPsesK3pJKYEuBX9p2ksAiWWZIrYwXe2M2Cfg
	b8RI9vKgzyWD4X+doYcA2f9gWB3CIr8bf/7pDd6Zfw68jXk0o4t/hYvdgXIMZ+w6SMy6R2UP72I
	sCVKCXa0Gqj3uvxPSeg9ZzoV5Zx0KfruTFypBzIAAL/Hm6YzpGEK4WO26CNczfIcO4qCS2cm6pR
	U9f8nf1ARIbjwB6aZjPLCfwServqtu6R7zMe3pKs+DS4ft35LoTQt/ORHToRNoFolmQlXgFYmy7
	4VztwwasKxuFtPxcQybu9w+EDuo9WR/R1KUX6TAT++xazBOSkV5cNV9DZd0M+ONcDJn8kt2M2W6
	0gwD0e3LV9VvrRXhxhYHPoAlpFo/5Nn7Fr9mRe1wVnvfn0Q5+GpYrBH+MmOgo3dXzcAMnbyxivg
	HNqsoIVj+PFehY9hVwZ8cj54pJUmNtGGJoz6CJ84JPjqMK0SK0vBaDpKQqXOzb6aCkTxyoOlNXq
	nHvyp0hhgIpfpbQQdrsMt+ttAexEPxMhM5A4odHI9BkH2ShDlsk6BHbfMqZEZMYE9ao0iph5rSS
	shE/vR6OOCffTOR5Vims+lZh4w8S0NNbjLzyTSb42Vp/+U0p/7R4/koin7LBpDcv7WOgjlY42Nx
	0Yntc3e9XAoAEOZgLoQd+NiC2Fb7PxBm+RsbqjGu9o9oPxsUXkIhQ8mPjLF/UspUNDzcyzGBmKu
	rSN/K/gbUeqQBT4eT8I4Y8cEVRk2Pl6bvf+B3+yAefpFUVDAc=
X-Received: by 2002:a05:693c:2587:b0:36a:1732:1e5 with SMTP id 5a478bee46e88-36a2012faabmr3622481eec.37.1793212951504;
        Wed, 28 Oct 2026 11:42:31 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da3e1sm11604066eec.8.2026.10.28.11.42.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 11:42:30 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 4/4] scsi: core: Match ULDs to logical units in the ALUA unavailable state
Date: Wed, 28 Oct 2026 11:42:16 -0700
Message-ID: <20261028184216.25453-5-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028184216.25453-1-brian@purestorage.com>
References: <20261028184216.25453-1-brian@purestorage.com>
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

scsi_bus_match() only matches devices with peripheral qualifier 000b,
so a LU that is in the ALUA unavailable state on a target port when
the host scans it never gets an upper-level driver on that path. When
the target port becomes available again, nothing binds sd and the path
stays unusable until the device is deleted and rescanned. A host that
was already running when the path became unavailable keeps sd bound,
so the result depends on when the host scanned.

Peripheral qualifier 001b cannot be matched on its own: an unmapped
LUN reports it as well, and some targets report every possible LUN in
REPORT LUNS. Binding sd to all of those would create disks with no
backing LU.

The SCSI core now reads the access state of a device that supports
target port groups with REPORT TARGET PORT GROUPS before the device is
registered, and an unmapped LUN fails that command. Also match PQ 001b
devices whose access state is unavailable. sd then binds to the
unavailable path like it does to a standby path, the path stays in the
multipath map as a failed path, and the existing UNIT ATTENTION
handling brings it back when the target port becomes available.

This is the same situation as a path in the standby state, to which sd
already binds: SPC-4 requires READ CAPACITY in neither state. The
cached INQUIRY data in sysfs keeps the peripheral qualifier reported at
scan time, like the rest of the INQUIRY data; access_state shows the
current ALUA state.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_sysfs.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e..8d90f0c715ce 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -539,7 +539,19 @@ static int scsi_bus_match(struct device *dev, const struct device_driver *gendrv
 	sdp = to_scsi_device(dev);
 	if (sdp->no_uld_attach)
 		return 0;
-	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
+	if (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)
+		return 1;
+	/*
+	 * Peripheral qualifier 001b is also what a LU reports while it is in
+	 * the ALUA unavailable state on this target port (SPC-4 5.15.2.4.5).
+	 * scsi_add_lun() reads that state with REPORT TARGET PORT GROUPS
+	 * before the device is registered. A LUN that is not mapped reports
+	 * 001b too, but fails REPORT TARGET PORT GROUPS and so is not
+	 * matched.
+	 */
+	return sdp->inq_periph_qual == SCSI_INQ_PQ_NOT_CON &&
+	       (sdp->access_state & SCSI_ACCESS_STATE_MASK) ==
+			SCSI_ACCESS_STATE_UNAVAILABLE;
 }
 
 static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env)
-- 
2.56.0

