Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com [209.85.208.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6477F400E05
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805793; cv=none; b=ucOi4oCOZ4kLCPVzCCPnwB8rShVRn1/bK7fJAUdcdFVUfmnFuJyDcfQCOIO9dbDSCWx1P/5z38ztMlqiyKXx2JGlCykMgPaTq1DpzlIBUrBMO+fYdOOSuSQI8iNEPS453Y43neN8mjwA8QTsxX6DKXmq5QitzidjaOaU3qUD/PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805793; c=relaxed/simple;
	bh=lM1U7NDEVUxoUgjU6ZWJkKgeycM4+CYRnq2yIpcFeSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G6MoUkglBKEplNJHeWW+9hyQdov4Fv+iMliEXvUbdeP7E+CYpRrCdOLalC45xkp088/lYi/9FihqIEllQBjQ7zfzS0EZ1XlJeRZXRjaWBfKlKViax1Gtc8Qg7VeLLrdy0jecgy+8p22PLYyNYl8qF8VtNNfcnTfKaw9bNonEGCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rnj.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z9Q63C2s; arc=none smtp.client-ip=209.85.208.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rnj.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z9Q63C2s"
Received: by mail-lj1-f202.google.com with SMTP id 38308e7fff4ca-38e83c25d24so52910601fa.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 07:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779805790; x=1780410590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T7NFUbUyx8UkNyIRhDm6VYLpxHnlnNi3FgbihS8m/SI=;
        b=Z9Q63C2srpk2jtLP94rq4CajaEessCH5zXv6RiqFfM8Bknbyog7zNR/EBuQOBx8neM
         LUZ0/mDyPljddF3Ke7d36GVUx4NuKEYzHD3uY8R18u0bm+0FTGgDHWCJ5cMELx+OMiYE
         M8oPSGSfDSB7dwi5JpqlVblqSDEiw4+cEwttyp01oR9nK+IaxWLJFs3TvuRlFmSdXvfH
         5FC0bCtUwJR4D1sCNmCNcuYCgHYoJKd1XOcM6sgCWFTqKFuqwMBZNUJPFy8P7bJED5IU
         Ws9Q+yXdOOTyFPJPgkT/iBOBM/dDsRmfruQAfR89rr+UH2ZQ0aaY2uULIGXGf8PE6njj
         Mnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805790; x=1780410590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7NFUbUyx8UkNyIRhDm6VYLpxHnlnNi3FgbihS8m/SI=;
        b=LsXDdXMrgKEjFtQrZv83hfXTzs7O49smWVqw8yXJKLaIRbDzCF0kJmZSvR54VXsbzU
         zOH89bF3//R97aL7Q62a73+CMzxqejx49/Vo2OXeCi9ozxCMTEK/2zIMMxE/1Y7dPvvp
         HN1Du2P9MbkNuX6TgV6nhZv4aABLUGz/s7XaXx4IMzCufYiWMR8vmXQVOmm1HFR00v25
         nX7tBdRB+9G7q35oJqNM1kpYcBv3pXlDcMaGzeDnRvOwY7btrJG2PPLEZbyFUyiY3VVH
         bWSvwjoto2YAEQ8o5bXA+1zuPK8kp/XtKJ299ddH2AaX6Xhs6GFYRooXWTKWtZu+Jglx
         o5hg==
X-Forwarded-Encrypted: i=1; AFNElJ8/Nxg2hvX0bUshrBuqNTLIiNNfRNF3FzoTroUcMR4Tn4ucI3G31CRl3WmBUWISgE92M6EvCazywnb3@vger.kernel.org
X-Gm-Message-State: AOJu0YylNdCwLhpMjf7N7lWZq5o19XEX6fCwolPFUUXn9E3w3BjbkFrl
	QYMdUPWovq9iA79JHaoxzRjCex4fH1vSfv2/FFSdVaBrV3bmbtvoZ6xw7c2jPs/Ge43w9A==
X-Received: from ljck14-n2.prod.google.com ([2002:a05:651c:20ce:20b0:391:fcf:3171])
 (user=rnj job=prod-delivery.src-stubby-dispatcher) by 2002:a05:651c:1586:b0:38e:d18:4d0
 with SMTP id 38308e7fff4ca-395d89263f9mr65278791fa.13.1779805789321; Tue, 26
 May 2026 07:29:49 -0700 (PDT)
Date: Tue, 26 May 2026 14:29:44 +0000
In-Reply-To: <20260526-fortify_pm80-v2-0-359b743eb97a@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260526-fortify_pm80-v2-0-359b743eb97a@google.com>
X-Developer-Key: i=rnj@google.com; a=ed25519; pk=QwUkB1OONd7dk9zV4pLRQRehoWHHsLcRZD2QcswqHTc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779805783; l=7499;
 i=rnj@google.com; s=20260515; h=from:subject:message-id; bh=lM1U7NDEVUxoUgjU6ZWJkKgeycM4+CYRnq2yIpcFeSY=;
 b=2Et7omVZmBjmwAvTpoLHGUFGqqG6SLNqHQoDNbruaHSNZV6PG65wYj0KGkKd3zBXzeWJA53nc QsKs9n8EDG2C1rZZqafXnOhjXLEKSvTzOyKOtZeM6r3aq4wN6cximWr
X-Mailer: b4 0.14.3
Message-ID: <20260526-fortify_pm80-v2-2-359b743eb97a@google.com>
Subject: [PATCH v2 2/2] scsi: pm8001: Match hw_event_resp to HBA data layout
From: Ronja Meyer <rnj@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Tom Peng <tom_peng@usish.com>, 
	Kevin Ao <aoqingyun@usish.com>, Lindar Liu <lindar_liu@usish.com>, 
	James Bottomley <James.Bottomley@suse.de>
Cc: jack wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ronja Meyer <rnj@google.com>, stable@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"

Correct the hw_event_resp and phy_start_req struct definitions to match
the layout of data sent by the HBA. Remove pointer arithmetics working
around the previously incorrect struct definitions.

Looking at the struct definition before this patch:
  struct hw_event_resp {
           [...]
           struct	sas_identify_frame sas_identify;
           struct dev_to_host_fis	sata_fis;
   } __attribute__((packed, aligned(4)));

Previously the memcpy() in hw_event_sata_phy_up() crossed reading
from the sas_identify struct over into the sata_fis struct. This was
necessary, because the hw_event_resp struct definition didn't align
properly with what the HBA actually sent. The member sas_identify right
before the member sata_fis was 4 bytes too long, causing the first
4 bytes of the sata_fis to be shifted into the last 4 bytes of
sas_identify. The code worked around this by subtracting 4 bytes from
both the sata_fis pointer, as well as sizeof(sas_identify), when they
were used.

FORTIFY_SOURCE detected this deliberate choice to cross struct member
boundaries as an out-of-bounds read, even though in this case it didn't
lead to a vulnerability. Hence the following fortify-panic was
triggered:

  kernel BUG at lib/string_helpers.c:1044!
  RIP: 0010:__fortify_panic+0x9/0x10
  hw_event_sata_phy_up+0xea/0x120 [pm80xx]
  process_one_iomb+0x634e/0x6360 [pm80xx]
  process_oq+0x391/0x430 [pm80xx]
  pm80xx_chip_isr+0x78/0x100 [pm80xx]
  tasklet_action_common+0x16a/0x2b0
  handle_softirqs+0xcd/0x2a0
  __irq_exit_rcu+0x50/0x100
  common_interrupt+0x89/0xa0

Furthermore hw_event_resp was 64 bytes before this patch, which is
4 bytes too long. Messages exchanged between the pm8001 and the host
kernel can be a maximum of 64 bytes, as defined in iomb_size. The
message structs defined in pm8001_hwi.h must have a size of 60 bytes,
in order to leave space for a 4 byte header that implicitly precedes
each message.

Luckily the code interacting with hw_event_resp doesn't ever seem to
read or write the last 4 bytes of the struct and doesn't seem to use
the incorrect size of the struct in a copy operation. Hence it doesn't
overflow in practice. Further the pm80xx driver was unaffected by this
bug. While the pm80xx struct was also 64 bytes, the message size on
pm80xx is 128 bytes. Hence it is able to fit the 68 byte header and
message without overflowing.

This is not security critical AFAICT.

Cc: stable@vger.kernel.org
Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Ronja Meyer <rnj@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 6 +++---
 drivers/scsi/pm8001/pm8001_hwi.h | 6 +++---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
 drivers/scsi/pm8001/pm80xx_hwi.h | 4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index fff8d877abb9..e90f2d98d8ed 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3164,8 +3164,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
-		sizeof(struct sas_identify_frame)-4);
-	phy->frame_rcvd_size = sizeof(struct sas_identify_frame) - 4;
+		sizeof(struct sas_identify_frame_local));
+	phy->frame_rcvd_size = sizeof(struct sas_identify_frame_local);
 	pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	if (pm8001_ha->flags == PM8001F_RUN_TIME)
@@ -3208,7 +3208,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index f1ce8df082b0..395be4fdbf81 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -153,8 +153,8 @@ struct mpi_msg_hdr{
 struct phy_start_req {
 	__le32	tag;
 	__le32	ase_sh_lm_slr_phyid;
-	struct sas_identify_frame sas_identify;
-	u32	reserved[5];
+	struct sas_identify_frame_local sas_identify;	/* _local to omit CRC field */
+	u32	reserved[6];
 } __attribute__((packed, aligned(4)));
 
 
@@ -229,7 +229,7 @@ struct hw_event_resp {
 	__le32	lr_evt_status_phyid_portid;
 	__le32	evt_param;
 	__le32	npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;	/* _local to omit CRC field */
 	struct dev_to_host_fis	sata_fis;
 } __attribute__((packed, aligned(4)));
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 954f307352e6..03293e9b84e6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3241,8 +3241,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
-		sizeof(struct sas_identify_frame)-4);
-	phy->frame_rcvd_size = sizeof(struct sas_identify_frame) - 4;
+		sizeof(struct sas_identify_frame_local));
+	phy->frame_rcvd_size = sizeof(struct sas_identify_frame_local);
 	pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	if (pm8001_ha->flags == PM8001F_RUN_TIME)
@@ -3289,7 +3289,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 2fa54b901a2e..41f10c970125 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -255,7 +255,7 @@ struct mpi_msg_hdr {
 struct phy_start_req {
 	__le32	tag;
 	__le32	ase_sh_lm_slr_phyid;
-	struct sas_identify_frame_local sas_identify; /* 28 Bytes */
+	struct sas_identify_frame_local sas_identify;	/* _local to omit CRC field */
 	__le32 spasti;
 	u32	reserved[21];
 } __attribute__((packed, aligned(4)));
@@ -331,7 +331,7 @@ struct hw_event_resp {
 	__le32	lr_status_evt_portid;
 	__le32	evt_param;
 	__le32	phyid_npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;	/* _local to omit CRC field */
 	struct dev_to_host_fis	sata_fis;
 } __attribute__((packed, aligned(4)));
 

-- 
2.54.0.746.g67dd491aae-goog

