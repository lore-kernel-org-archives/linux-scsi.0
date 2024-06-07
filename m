Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454CF19B3FE
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783071; cv=none; b=Ls49cDJgvrlxAZwVq8d1sEkhdUZjARPUqHdHysCCIgfq8AFve8XA3K5cdofvbMc0ff3mH5kn36uJK108kxRjpJJAXAQ+W8HYD8HGdZ1JWHW57i8er0o0xR1ZXF+Q3thSrkuLYJnNxTJJviZAI0BReVRsu3Fv/FBJ353JBEjEnB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783071; c=relaxed/simple;
	bh=kceaFwwjaSlBmkhXtusA3USI+23jbBoLODkMZKgX7RE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dsJP2jaFvS0e2fy5OMSVeS5ZC46d3jtInT/aPUJOPInzCRpGcpKZCyn4VrpBz4kuKWOUyJm3UyN7Z9NaP2dEu9ovsUzOfQLtAuFLtTNGZnH/AmjaOVjS/Pph82q9pbeebOirrUjj8qfyNbzVVAA8JujvXX75EPYMixWcaBVBTSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PX6kx7Pi; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PX6kx7Pi"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a0841402aso36729717b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717783069; x=1718387869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=68M9FutlL8cAjPUlj6bX6OztbAKg98sW3h68noYav98=;
        b=PX6kx7Pi7Pi5pBl4e6DZGHy18AgFLMWz4iuwOpWW3nxYSqlabtLJCQeUoCv01bEybO
         SN8FN8z4/b29sxLG60rOdmweMU3ixP+Y8/NHFwXirPyZfdt4AHGHMZ1ll+X1O6K4LKmt
         QlMh2DVFJd87n+hiEtcUFR8RbGha79j8ouNBUUGr1ajHWkbC+umY7qj4Yh9ZLvx31sFQ
         Hp5GTgGkZAO60xigUFeThLcahCeJZsXjQjFrtlbozJSyPnMHiUKWNBuvPS2xnX8YIRcO
         cl0Tf9YDGhslrApG5Omn53rGlYB/+piL302rNxeBhMrSCRU3mn4J79ys3+5HhrCTjaDr
         Wtug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783069; x=1718387869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68M9FutlL8cAjPUlj6bX6OztbAKg98sW3h68noYav98=;
        b=LMtZIJJcCWRIXm7YWJ+YHwtCtghwPcgPKlmkNU+BKqj9qUqrhlW1f5Ay08+nyxt/tl
         xllI60mv+BqaVhVBz8VJb5MLs0xoTPOXDCCQaO/w9ujlhR+V+1r/xpkT+ABDBFqz/3Oi
         dJSxVayErzHfmFWChD/hwR7DrpcF0SPcY9SJglotKqTo1+OtM+GdGO6LeJdM4/zUgxX4
         5knTAKZQLpIOm+/ubjlExWIAQ7xlCoEZmxRrFEn2wSBj1kqqHNeUvoFE6HBxRBkCgLb2
         PIbYRgtsOoxL/uigATwTrKi/DJrh5CuF5MHtNHb3WQv4Hlo6vzp3VISKV6XFgKzzzeM+
         ABuQ==
X-Gm-Message-State: AOJu0YyweC6iBhGtbHkMm39/4xA/vAzHA5rYJ1ERGZNMyuOpydSfthCw
	8gkBpsJdf6C40ZNG1T4CBwtRggM4QWUsdBAfyH2kU3ONh+RgmzGFtEiMYPZjftDS5jN4BTIFSiS
	WHG1oK0hR4Q==
X-Google-Smtp-Source: AGHT+IFSVowxqqPvr0+4CvkqgeikyT0vf4vjJ2LiCufzLnHvtpyVCokVVjJIiQzdT4oPCJcaV2sRwUt/x9KYIw==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:690c:4:b0:62a:4932:68de with SMTP id
 00721157ae682-62cd566adc9mr9535477b3.8.1717783069258; Fri, 07 Jun 2024
 10:57:49 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:57:41 +0000
In-Reply-To: <20240607175743.3986625-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607175743.3986625-1-tadamsjr@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607175743.3986625-2-tadamsjr@google.com>
Subject: [PATCH 1/3] scsi: pm80xx: Set phy->enable_completion only when we
 wait for it
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

pm8001_phy_control() populates the enable_completion pointer with a
stack address, sends a PHY_LINK_RESET / PHY_HARD_RESET, waits 300 ms,
and returns. The problem arises when a phy control response comes late.
After 300 ms the pm8001_phy_control() function returns and the passed
enable_completion stack address is no longer valid. Late phy control
response invokes complete() on a dangling enable_completion pointer
which leads to a kernel crash.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a5a31dfa4512..ee2da8e49d4c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -166,7 +166,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	unsigned long flags;
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	phy = &pm8001_ha->phy[phy_id];
-	pm8001_ha->phy[phy_id].enable_completion = &completion;
 
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		/*
@@ -190,6 +189,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				rates->maximum_linkrate;
 		}
 		if (pm8001_ha->phy[phy_id].phy_state ==  PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -198,6 +198,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_HARD_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -206,6 +207,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_LINK_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
-- 
2.45.2.505.gda0bf45e8d-goog

