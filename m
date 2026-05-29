Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E14218A3
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 20:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780088167; cv=none; b=oXiUJJ0zfvtLyV92KFX/CgEywqSMIj1GWSVWI/nhsuc90pl9k9yjFVEvAJeWN7yAKtJ08L8n9Dq5XndZhCOqOlYRBdV5L8+PF6XiA4UUIcU3/foDhc2VHfPVx21MpU/5TzwuC9pxgCzyRhZODZcuBgQ1eJosf/RxV9ssTlfVT44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780088167; c=relaxed/simple;
	bh=QUkTU9MAzHVjY/R52ylF2nX1IyF7xZP2bnvafUhKIKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MDEkimBCUoOfxo/MWspARVzcn24b3kSoxOtsOgmwSAcu7v5ibZ2BtZTlxrTGSgygLVrk1U0jwJqBIeP0BmtS6Tz3wwymNsq1Dw2t/qz8N7VX07eQPOCwOhy6j+tcjZMtT0wR3gQGfHZfdCUthkoq+BefcNmb5uWhNkWwFnPMGOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBQq8e21; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBQq8e21"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef3efa8b0so112687f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 13:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780088164; x=1780692964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W6SZ4oP1DlaBjPFDdYbBzO7LwjBZ+p9b7ExzMxZ0B/w=;
        b=lBQq8e21lrncbsphyR1LoJ6t+QCFg7wiFY52HEuknXbcIc0V78RJoTqqaOfwyA47P7
         ak3YNsRrnelh3goINfm9ndO6W5t1C2iXTHwyvxnInHBY2CA37fU7OeHvGYOgFLfZWwWC
         RerZrykSU/WAAuBlOxFxkpcez76Ut8hBIc/eFY+4KSIdKMUJYN9pxidKjnWlLTlh/+yq
         q4wow7zDB7pNwTH8G2bedilGd1uhMoZtvmgdYJyBB9eF9MKxc6TPdBctHuRrgdVxfYsd
         OsYXeyWyj2cAvl0BGrDJEkjiVhccHkusap7Sp25ICH1riFf88F62YWMWps3rgNRXPlHE
         ReqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780088164; x=1780692964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6SZ4oP1DlaBjPFDdYbBzO7LwjBZ+p9b7ExzMxZ0B/w=;
        b=WsvHG1mIIHbTOU8CmLUlJpoVJRbV/3A6q1WHtHjuGL4b/Yp53/7/D32iY7gX+fa83M
         C23r/mHiHFA/d2uybUcg7MV6pzokMx303kW1qznFTLOemrKh2DDWPab+wN0XwbqH/202
         qhf+nKYmgw7l/fp7OSSBt/1l9l3sGj06IGmJ7TvgzxErJEWDLDCKW6edoUcPZZaD+8ik
         n82O6pJQGuuFCbYjBvlMaCXNS6bgqynuHizq+izFINDOYu0/As1V5slO/gOnZIx21hj6
         L8r6jiI5RFvqEYbEo2btAq7r/ODHa5UH3Izta5xF6J02SkGbf85RRD2oRDDlNtl1mK+r
         7JTQ==
X-Forwarded-Encrypted: i=1; AFNElJ/i5L3x9X7L1btfouhPv+kweyKdw8OVEG4HUFkGYsgNe8C7p0Q6wZlEy1DGPcOP2AkUDZDYOYDia6XT@vger.kernel.org
X-Gm-Message-State: AOJu0YwSeEL17aOkrKjBMtzvm4xE2ESyUwyUERGlqWC/5KeK+rR0jJuu
	vys5f+htCNB02oFiRczxHyIHIjOAYuNtg414Ie+ChCmP59z6Rn6HR2s=
X-Gm-Gg: Acq92OGjxoBbiMZxZYNBJ5HMz+u0yHQvacFOGpzVyUSZGPUTTsnPau4TGG8lFDBhrUP
	ZejJzFQEMdnO3gIk83TTT7/69PnTQxsJt4lzIc7iHBPtEaiycYSLXVG7BUDRfhpQy5XPB8aFT/r
	aa2ABZuc7mMRBeaAb47z/f0v3Dn7ahPhWV/D0vG9YKKXMlmMm/SrZ1GZCrb3n57UnelgVjpOZwD
	obmNrk/oVk1S3xt/Dnypw68uW5nJhI1a6raa1lgXnU/f29VMaHmpxeLREZpYLtrAlE20P/iGSMX
	/lAPNR5zT60kixCoG1TvyDdJRciCAx3yEPU2KIA/nh02VGOHde+lcU4DrN1IWA3co2H/lJSG+Pm
	+7H5iG0JxKjXNBXu0zYgxi6ZRY+bmTMG3UDTAzPb9BILRKLA3+b1RovBE28iVIDXGsY1EOT2ZJd
	7/ciAZYMWHL+CEni4+tqAtP0C64iVkE0CM+DeNYyDqZIwBbRq8q6SpWlAFDSimHWq5uM/iYUk=
X-Received: by 2002:a05:600c:3e18:b0:485:c456:5e4f with SMTP id 5b1f17b1804b1-490a28d24admr8850055e9.0.1780088163713;
        Fri, 29 May 2026 13:56:03 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909cab0e79sm126968085e9.13.2026.05.29.13.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 13:56:03 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Alexander Perlis <aperlis@math.lsu.edu>,
	Nikkos Svoboda <nsvoboda@math.lsu.edu>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] scsi: devinfo: broaden Promise VTrak E310/E610 identification
Date: Fri, 29 May 2026 22:56:02 +0200
Message-ID: <20260529205602.177515-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

The Promise VTrak Ex10 series share the same hardware base and firmware.
Consequently all interface variants, whether fibre channel ("f") or
SAS ("s") in dual/single controller, exhibit the same SCSI behavior.

Instead of adding separate blacklist entries for every specific model
variant (such as E610f, E610s, E310f, E310s), consolidate and
broaden the match strings to "VTrak E310" and "VTrak E610".

Cc: Alexander Perlis <aperlis@math.lsu.edu>
Cc: Nikkos Svoboda <nsvoboda@math.lsu.edu>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
BTW: Be careful with the dual-controller models. They advertise ALUA
to the OS, but they have a non-standard implementation. This could
also happen with other Promise VTrak/Vess models, whether legacy or newer.

From its multipath-tools/libmultipath/prioritizers/alua_spc3.h:
[...]
#define AAS_OPTIMIZED                   0x0
#define AAS_STANDBY                     0x2

struct rtpg_tpg_dscr {
        unsigned char   b0;             /* x....... = pref(ered) port        */
                                        /* .xxx.... = reserved               */
                                        /* ....xxxx = asymetric access state */
[...]

static inline int
rtpg_tpg_dscr_get_aas(struct rtpg_tpg_dscr *d)
{
        return (d->b0 & 0x0f);
}

/* added for PROMISE VTRAK */
static inline int
rtpg_tpg_dscr_get_aas_for_promise(struct rtpg_tpg_dscr *d)
{
        return ((d->b0 & 0x80)? AAS_OPTIMIZED: AAS_STANDBY);
}
---
 drivers/scsi/scsi_devinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c6defe1c3152..15ffbe93ac72 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -218,8 +218,8 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"Promise", "VTrak E310f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
-	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
+	{"Promise", "VTrak E310", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
+	{"Promise", "VTrak E610", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
 	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
-- 
2.54.0

