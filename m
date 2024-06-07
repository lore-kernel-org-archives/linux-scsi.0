Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D94019B5A8
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783073; cv=none; b=hH0md/iRtjUKaE2UeDKZlnwz7oSFMlGHchOpZIZN4Mqcs/a3ZaOA/6dFsnzu9R86l67HGyN8xLY2O8UW3nYZaSbWkmggrcJQMZA9KMsAprh2z/rRbFUlFBW6zqD+UGiqng7r4CJdRLK3mHEWN/3Pa1/L16kgNjewuDklSkXJcZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783073; c=relaxed/simple;
	bh=77RomTbxoT5IvK9cD9wwGOCTWkN2mvquDo1FazG6ADk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j262SjYTdlTpkxkkUQIrFRsZsxV9TF5ijYM5X+ZC8LmxwnUkNHYSyooCT/jTGYs9Gd8pHbjSgd3YvhoV2NqTlXFbAq+Q8ITjaN05f1Cs2fSEOxfbR6YFG04O4O3iZm6lmS724Ead2DHo9Gr9L84EiUyKmbFG5k2kta4pMCSOAGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z5+BBEM3; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z5+BBEM3"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa56e1a163so4241623276.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717783071; x=1718387871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu46/3S2zZA6k5Oex8T+jABLwZXyDcysB54lkLA/uRc=;
        b=z5+BBEM35CAisqPQ8iOIkk3zM+3f4OaBQWVsgWIXteJ9sqIeOOryNZzKAIS5UngGnh
         QAYDdC+8f/+mbuRiEbR9x6A+OJhwToQyjvgrjM3g/f+3Czhx2lTw+INa2aM89BDdK62y
         ADyoazOy502P5IIivIBaD77Ojh2UWvIovoCxR7OvuYj1r/GEetMpyYBu9V3PGpFBs25O
         +skTXMyD1WiXms61Zs0eI1p8XIo4BIENA5E7vr8+cZVD9rU3Rq/05FqWig0jHcloFniT
         fq5AXfCHXQ3W+mupsXsfzFUTCvFwA/11FOCXGOS4Gdulbbpp1Jd+2oEKrzZlDGW4Euq9
         BT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783071; x=1718387871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu46/3S2zZA6k5Oex8T+jABLwZXyDcysB54lkLA/uRc=;
        b=gFT99tYwc4acOCGifBNcTmrvVDNVGBid6Erci4ajcPCeE5RwD1IyzeEqhjwKt36I6M
         eA7YIBdGzgWUovKhC1rfOTQtTcSeqakoGVP3hoWpkH9Ws4DpCtSmxQbt7AM+hBZO2sO5
         kJk8TbwgFZTUVoKDYF6AkGbx/CMKmUDgt8RpUCxjgpKUILvbp5QEV/2QGT6DOsd6dNfG
         qRrbMxt9mGCo5syXbyh3cpifmQvDe6vgCJ9jbaM5woKNenYuuOSmkiOoqXMcudUUztWi
         Yvw/EhjNfvzIJlzwe09adA63hyd4BpeX6cc/vi8yb/BDc9iWDLqS0eHWHCuIBzchcyMD
         w2tQ==
X-Gm-Message-State: AOJu0YxusMGdZK4EaWVHteyfM4Bd4+dd3ZMgNoC5b1Ksarcjf3yhphkR
	nXntVJvqeLXBszMjyfDI4vERcrm9wQ2WWlupdnHUTqpArIbcYKdF7IGE+f/pIFoLVAe2F7rYJCz
	53UJGAGUEeQ==
X-Google-Smtp-Source: AGHT+IERE/EYXtc8MUrFi8tAzHgVN6/66kMWeUDhMDvzhrkKK4ZBgSlyAwdYRCe+7vczJj8PruT3vRNLZRsyaA==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:6902:c04:b0:dfa:59bc:8857 with SMTP
 id 3f1490d57ef6-dfaf66268a4mr939243276.9.1717783071064; Fri, 07 Jun 2024
 10:57:51 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:57:42 +0000
In-Reply-To: <20240607175743.3986625-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607175743.3986625-1-tadamsjr@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607175743.3986625-3-tadamsjr@google.com>
Subject: [PATCH 2/3] scsi: pm80xx: Do not issue hard reset before NCQ EH
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

v6.2 commit 811be570a9a8 ("scsi: pm8001: Use sas_ata_device_link_abort()
to handle NCQ errors") removed duplicate NCQ EH from the pm80xx driver
and started relying on libata to handle the NCQ errors. The PM8006
controller has a special EH sequence that was added in v4.15 commit
869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.").
The special EH sequence issues a hard reset to a drive before libata EH
has a chance to read the NCQ log page. Libata EH gets confused by empty
NCQ log page which results in HSM violation. The failed command gets
retried a few times and each time fails with the same HSM violation.
Finally, libata decides to disable NCQ due to subsequent HSM vioaltions.

To avoid unwanted hard resets we can initiate abort all from the driver
to prevent libsas EH from calling lldd_abort_task()/pm8001_abort_task().

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index dec1e2d380f1..f19f76dc6e1c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1672,7 +1672,18 @@ void pm8001_work_fn(struct work_struct *work)
 	break;
 	case IO_XFER_ERROR_ABORTED_NCQ_MODE:
 	{
+		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
 		dev = pm8001_dev->sas_device;
+		/*
+		 * pm8001_abort_task() issues a hard reset to a drive
+		 * before libata EH has a chance to read the NCQ log page.
+		 *
+		 * Initiate abort all from the driver to prevent libsas EH
+		 * from calling lldd_abort_task() / pm8001_abort_task().
+		 */
+		if (pm8001_ha->chip_id == chip_8006)
+			sas_execute_internal_abort_dev(dev, 0, NULL);
+
 		sas_ata_device_link_abort(dev, false);
 	}
 	break;
-- 
2.45.2.505.gda0bf45e8d-goog

