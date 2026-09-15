Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CA2222597
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 01:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789434153; cv=none; b=auiEEnrAGr9F6AOlh7wMK8HYqOZS/+/oKl+bwI3aX3YgO4VHYZ6Aav5uBKOYpg4CdyYO570u8oQcQnNyt2g2vHgh8KZeko1MRSnM+SCIB6QD7ln1zE2G/uUUEbffLd7N2+d20wpARY2LlKbCeLKEQHM+1CxhqQJnkzmguaLBWHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789434153; c=relaxed/simple;
	bh=3AjDIB7EWMAVyxipcTRH5OCK7onXDuyQbUsnnxBTwFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opsIq9vDjCNFTszczi1ZjrFVwxSRKRQNPzmgWgMym1GpKGAHbqusrYfa06l2IPCXFoI6ZWqS7nKuvglB2um6pjqypvAqORkLX2fNSMREPUbRtEoBDEnxYgwGLoxFHN2I56ymMGAdgoH9Ar4QzlbHKowunxTbgFC0ip2jPcGJ6Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FdkH8As1; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FdkH8As1"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9121fe38733so26736766d6.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 18:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789434150; x=1790038950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VPCy7DFPSTAzIsYv8xVVBEwv2TCCDPqTTW4KAZaR2co=;
        b=FdkH8As1b5Cp5neTY4ZJtVfRYAsIhf40UdVseCJS2LA1crSRqEcrY5B/+jKAXDIwj8
         SJJRYahn0DFpTUKfOOfXH3dqwLd/h8atQiBiGh73yObTeaRPp9idNFIMEzCW36eoQH0C
         tXFpLy3Xh3N7GyV94qSAz3DxbSDLyrlUvioaHlPhuAlDZan8DdxaDPgYre/sQ/uPkJ3m
         AYqD3LyaPUmbGZBlHZy048Ies41AiODsPSgtaMVsxi1y6Q5QdHC2gQK8XD9IvMRN+uyL
         YcBfi6Gqk+I2BRz/Pwb6Vi5nYMETLVvT81/dW1pKMc2yLYCrJapZN68Kl7+ibbR5KMTV
         RvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789434150; x=1790038950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VPCy7DFPSTAzIsYv8xVVBEwv2TCCDPqTTW4KAZaR2co=;
        b=fWY4KcrUIK1998KhdsyFWV6hOtyWjw2dekAp8wd0szmWocN1yZNS84PxFOqFOGBBh4
         AmvP4QmcgOD95Itt/lEBtrGhsLLDK1Lt68e2jpZn5+/QTwmzFwhTDhDHPaqQdCH5ugPT
         U2co9M5bsIIw3i5FQmB/dnQxkjuaE36qQxilNOklk6bONP3yG4P+5dwFI7gKr+Mfb+QL
         kNthwrsycBWHJDzFSGtk7DSa6OSO5f7o0ZRwHNSqO7Azf43FNSxfWFlcArejga568Zpv
         g43U8PFthEN072rp/vGIviGNd71Qy4cBEsvh/8iqLBHEDvkZY7LTeAf5HcA+7Pj2aKFf
         AwVw==
X-Gm-Message-State: AFuF++k15gDGBUn40jvnIs5IAvy2c9/Ri20wg1bYYIsOFF8LU6Udz/gq
	OHCgUogZTz+YXXAkwfpFfcQuSxveKLYOQ3+7Z2AZW5crCN/lzfuCpBg=
X-Gm-Gg: AYBFou23A4ZeQiW5K7Sy46yfesTzWba+T3MWOA1iwfjylay5MbJh5q7dkynfzQqzx1b
	WPvFq5b6/G11S6b1Wno78kh85WoIyRlDM+mBUaBofdcsaQJ5V1OS0rJBtMduC45OZCOtljORwF3
	r2zfXCG41MHHBBRwI5d6Md+I4RjyfkBp0iKrMSY3/+DvbaeLyDzt51VrUqu34Js49S3zUaZ2N3q
	ce9YRzn/WL0fWeeP2/gW4N3qPhf2ks9OIXeI1LYXEQwZHaIad3SLhXSn3EghMPHNnjMQ7zh1dJ7
	ariN3lLrecpEzQOt8SOoQVRLIFOPlAxGV08Y32GTpKXooPZNdZa7y1WNQjBwsEm4As/MzqC0F7+
	yUYOn8HfXeQtNtpi1Y3eLAlDREV6zmBUGN835xFp36Q1MSPtHecVASGkKOORlfFzwb67BiF8nIn
	XXpA26iLcy/hXP7q9tEBQtR9bMQ4NGT1+ljdCcUEUvGH8vEclrEnMVED4pKnccfm3bknCK+993P
	S1xxayIHHsovN/+udgcb40bUCz06DezCxKmqwbBPQeFuWm6Iw2ZCnGtJhBVG/2VULtKYCrbS9US
	0kk4YmSX14Bvc/gnNpQPUrtgRPPHlVur3iBs9XpU/JRE/kYCz/d2IOzspq4I6FhdRnsRGQ==
X-Received: by 2002:ad4:5ae7:0:b0:90e:95d0:927a with SMTP id 6a1803df08f44-9122e4d4aecmr105329926d6.6.1789434149663;
        Mon, 14 Sep 2026 18:02:29 -0700 (PDT)
Received: from 6e-wmo5420-02.ad.psu.edu.net (6e-wmo5420-02.ad.psu.edu. [104.39.213.233])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d51ffsm110574986d6.45.2026.09.14.18.02.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 18:02:29 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] scsi: aic79xx: Disable PCI on configuration failure
Date: Mon, 14 Sep 2026 21:02:09 -0400
Message-ID: <20260915010209.53250-2-mhun512@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260915010209.53250-1-mhun512@gmail.com>
References: <20260915010209.53250-1-mhun512@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ahd_linux_pci_dev_probe() enables the PCI device before calling
ahd_pci_config(). If configuration fails, ahd_free() releases the
controller resources but leaves the PCI enable reference outstanding.
The remove callback is not called for a failed probe.

Disable the PCI device after ahd_free() on this error path. The
imbalance already exists in the initial Git import.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 5fba316..37f4395 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -189,6 +189,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	error = ahd_pci_config(ahd, entry);
 	if (error != 0) {
 		ahd_free(ahd);
+		pci_disable_device(pdev);
 		return (-error);
 	}
 
