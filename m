Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32455D86C
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997060; cv=none; b=tE7z3LEo/Q4LVVby46+g5vEov1fSMbJcSFOtH+nyqXhgLaxzdXI5sMI3tistb1oMgxEaR6hmBG/pzRmH9SOEtMWwd7bUeVoQ4fRobguVDIy09qMWrBthUMKBixPXN+KLUhlbiB3lwPPbci1+fPt2fvU0mqrXJDiZyvm79Zt2zpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997060; c=relaxed/simple;
	bh=f6jAdHzhboSsrvnAwQk9bd8ybs7PXFPvcgnOKc54iZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9njhJg7jlhoipt2WP9nekm9xf19ALbBt8lI2iZua4lMUnbNl0TKG9AQ+BfRrXaNY2ZQ4Ub7sq6lnpxgwGj9t6NsxsinZWyzJvyb+R4SoxA0YSJcN4W9X33mMr67TYkjPelxEcpGCSSfyYhYrjzJACzde3w+gBRNNuEJlBU1oag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hvk17E8q; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hvk17E8q"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a01933b584so38345555e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 09:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791997057; x=1792601857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3qcxre9NbZoUsuxuBW1AKl0J1hEgizU6C0yp28P8CW8=;
        b=Hvk17E8qvt/FVFRq3X8fP/WwagQByVmYs4aKHGAz9Ia5GFF8zBIeb27hM3Qxp3laeZ
         HYLtLUPRvnPFfuJQtUImKG9+AyNcQDO4cSjcHNRA3NoQs0MWfC73VZJ0OUE5rm1UeD9r
         A1syYWiMRku5DxIKmlEnuoV+zUfYyYK3KuhAsbga5znKTA6MlZWmytt4nkE0RpLJu+Gr
         jRJ9s+l3EF0qpNyTXpoAmQfA7V5zvOX6qZgM2+FLhk7+QHx/5kcE20qVnEQzoASuEdtk
         u63I5S6dmHyBCugFkjBQcesEyrS0lXM4X242Bi+aS2LYw4E0wvXz5yTPOhi4x2GmPaAI
         tt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997057; x=1792601857;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3qcxre9NbZoUsuxuBW1AKl0J1hEgizU6C0yp28P8CW8=;
        b=cuSO/Qx+/jH30TnK8+qFWFoftWR6ZaABbWU31weKzFEqLSRmRQW2DVXyLM558szD+2
         gGMQhtXehTxu2noKOze8N1IhOcrWzXKcmZamY2pFgRmEYfGwY9WTZjWheE9LiCm2w2zp
         cQp1X0OJP/e0moQbQRLvKZ7DIqVvBuCKuS7pzDkcv15+bRzKddqlK3WhPlrlJeibZg0M
         JCGE7zE8VycLcPeCuqW5dKFanLjCMCQuTxV19zFaFFZR4mTyci6Z/jjriWkyAcId9sFP
         3YwRWbjPfPAlS9STRWRLFRw6FjFowR8l+iWObEsuCi/X8fHl/o6aETXkpEGpWxQ4UtGC
         Bc7w==
X-Forwarded-Encrypted: i=1; AKwUvBxDXTOqh0fIDDWt9qAtGeUEi70f+8YneR41LB0rfAdL5N3AapfKSVW0nzfplWFwCOhUiHMUbm7HFYnH@vger.kernel.org
X-Gm-Message-State: AFq9FYLCLmkIHE/pv8sKGN/OSYE3hR/UerOknqzVkoULAQF7Pfgjdyix
	e9cqtvTWhvIfQjB0ENbdiMe2ELALe7YsAPv9fUQinES8DgLUzmh79NzH
X-Gm-Gg: AYBFou37Gz1VZ8J+3pQaNTCRfun0kWnDO0oCta0UNmB/vTCm/wVm1Unng+/9+nUEqJ0
	KFYXh5gWp4yn4ji7bPiG8zl1OI6+0y4zJiq9bVhCikKjt1hi6hZrnusc7tscPHb/hO0eXvUQmwP
	Fu5/skAhEx5jcpoIlQCr/teAa7ZQsrnHCIDbdhHlOD6TJeh8ojzSauOP2oQksIdh63a3q0lxkM6
	Cx7UOaxTjcQP8MeYNANfRLFjTVu4B3zD7c6rSE/79nzn6jaJ+LxSrzvYko8AMMIJc3Eopd5Gadz
	q32Fy+O9Kir+ki/wVmRzAMdlxiY/OEN2/pcrv5s4ij7Gkodmp0+SF4ELp/VgQ4om00DI6qnYpa8
	0WOZlwgcJRD0/8mMN03XJil3xXmf93/+WOsxVQlKoptxYOTS3Z68E9rf8ZqCxbMZgkTi128znJD
	RYD0poMPZ3CgqtSnlskySAMHhdJE5IkhTBdA/Y+kaD5W86eQmYBb/7AOQm++Bh8I37aZSH2K8sk
	AhN1abTgtr3eS8ExskOnbR7PHXykGEcJdSADIGUDl9W3hPDXE5t1ZQnAJTruFOBWtvhlyWAWgTn
	e0wJo/GNe77LDI/mY1Rk5V5AB9WIlKfNmNyZUzteFlFiGsVueEjs0/NXX6x8s7zcoaI2Nd8BR0U
	3OBUYcUai8S6YNeXCwfduv9kT3LkNlfCmiXEzYQ9Niph4icG6KXfpOK1EsdM1TAfXukS8LUH3mA
	0=
X-Received: by 2002:a05:600c:3e0a:b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-4a18e49c52bmr318268005e9.15.1791997056758;
        Wed, 14 Oct 2026 09:57:36 -0700 (PDT)
Received: from localhost.localdomain ([37.167.99.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd680c83sm2701595e9.2.2026.10.14.09.57.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 09:57:35 -0700 (PDT)
From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
To: linux-usb@vger.kernel.org
Cc: oneukum@suse.com,
	stern@rowland.harvard.edu,
	gregkh@linuxfoundation.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Subject: [PATCH v3] usb: uas: validate status URB length before parsing the IU
Date: Wed, 14 Oct 2026 18:56:18 +0200
Message-ID: <20261014165618.33800-1-olivier.kaloudoff@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261013221937.41490-1-olivier.kaloudoff@gmail.com>
References: <20261013221937.41490-1-olivier.kaloudoff@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

uas_stat_cmplt() dereferences iu->tag without verifying that the
status URB actually carried a full IU header.  The transfer buffer
is a freshly-zeroed sense_iu, so a status URB that completes
successfully but with a short or empty actual_length — observed in
the wild during link-level upsets (Thunderbolt-chain xhci blips) and
on a wedging bridge — reads back as iu_id=0/tag=0 and produces the
misleading

  stat urb: no pending cmd for uas-tag 0

log spam seen e.g. on an ASMT135x enclosure and a Samsung T7, right
before the affected commands time out into the error handler.

Worse, this is not just log noise: a short packet that happens to
carry a plausible header is matched to an inflight command, and the
untouched bytes of the zeroed buffer then stand in for fields that
were never transferred — sense_iu.status reads as SAM_STAT_GOOD,
falsely completing the command, and response_iu.response_code reads
as RC_TMF_COMPLETE.

Enforce the IU header minimum before parsing the tag, then enforce
per-IU minimums before dereferencing: STATUS IUs need at least the
status byte, RESPONSE IUs need response_code; READ_READY and
WRITE_READY IUs legitimately carry only the 4-byte header.

Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
---
v3: address Sashiko review — the bare header check still let a
    4-15 byte STATUS/RESPONSE IU match an inflight tag and read the
    zeroed buffer as SAM_STAT_GOOD / RC_TMF_COMPLETE.  Now enforce
    per-IU minimums (status byte / response_code) before
    dereferencing; READ/WRITE_READY legitimately carry only the
    4-byte header.
v2: use dev_err_ratelimited() so a device emitting a stream of
    short status URBs cannot spam the kernel log (per Greg KH).

    Tested: module reload + 16 forced disconnect/re-enumerate cycles
    under write load on ASMT135x (Alpine Ridge TB path) and Samsung
    T7 (AMD onboard xhci); compile-verified on 7.3-rc5 tree.

 drivers/usb/storage/uas.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 265162981..4e099f4a3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -315,6 +315,13 @@ static void uas_stat_cmplt(struct urb *urb)
 		goto bail;
 	}
 
+	if (urb->actual_length < sizeof(struct iu)) {
+		dev_err_ratelimited(&urb->dev->dev,
+			"stat urb: short transfer (%u bytes)\n",
+			urb->actual_length);
+		goto bail;
+	}
+
 	idx = be16_to_cpup(&iu->tag) - 1;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
@@ -337,6 +344,12 @@ static void uas_stat_cmplt(struct urb *urb)
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
+		if (urb->actual_length < offsetofend(struct sense_iu, status)) {
+			dev_err_ratelimited(&urb->dev->dev,
+				"stat urb: truncated STATUS IU (%u bytes)\n",
+				urb->actual_length);
+			break;
+		}
 		uas_sense(urb, cmnd);
 		if (cmnd->result != 0) {
 			/* cancel data transfers on error */
@@ -363,6 +376,13 @@ static void uas_stat_cmplt(struct urb *urb)
 		uas_xfer_data(urb, cmnd, SUBMIT_DATA_OUT_URB);
 		break;
 	case IU_ID_RESPONSE:
+		if (urb->actual_length < offsetofend(struct response_iu,
+						     response_code)) {
+			dev_err_ratelimited(&urb->dev->dev,
+				"stat urb: truncated RESPONSE IU (%u bytes)\n",
+				urb->actual_length);
+			break;
+		}
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
 		success = uas_evaluate_response_iu((struct response_iu *)iu, cmnd);
 		if (!success) {
-- 
2.47.3

