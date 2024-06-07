Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C819AA77
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717780015; cv=none; b=L4QsZT+d5w6sFVEEZFs09XUAhemEVDleyCQxm2lEg8ywj1AqP3SvZo1NnNrMczs9tquhET34EGUIdBVy+efbeFXI9qo0Vyn3TF6OBRTp2vVwUrFKCUcomUbtRip7M5B8SHJbnlCkYy49cmFfEeFGQ5ikIwIWCVvBS+bsm2FIFOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717780015; c=relaxed/simple;
	bh=77RomTbxoT5IvK9cD9wwGOCTWkN2mvquDo1FazG6ADk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZLNRo0X+axfl3/yMfjBsIAKOYAjkG0aaxe6jhhlSUsJ6QXVT/kN6LNU3UbRMdTaTk1sNOsVDLmi1xmvDp58r3WQcNsX3f3myAXRKCYsyUhSDvBb4iD5alZ30urEFg8V85Bc//0A5rsNTKYLSIT8Os4vA/yrc54SBeFLD3zMmtkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gj1NYkkH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gj1NYkkH"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62c7a4f8cd6so45191257b3.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717780013; x=1718384813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu46/3S2zZA6k5Oex8T+jABLwZXyDcysB54lkLA/uRc=;
        b=gj1NYkkHKOiXOYBlKK0ynGMiOI3U6HcVpjwOkaz+3hfNpV7vN5C2lAioyCCr1YhQZL
         f7C69lClVVPFw1mMQM7GreJ0avxuhQuYsMB5Ixt/TyBAD3uDkPf4o3Vyqu0jL41sO1SR
         G5Uf8EtJyeNmdUDjH21tjtDSWhHCyIyHYQ7WtrW47huwat15r4SxUt5R/vW4NFDKX+Qm
         V5cL18dZebAf47CghP3V9+SjAhniFB3Vh9uLlfp4otSGCQ180NE5awz6hgDrkw2xMAzZ
         pVCkygxxKkClQdutOI16S+l2YFlonT36/d7SdMgl3upBf+PIydSkLh62+cISnZtMOX4j
         WvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717780013; x=1718384813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gu46/3S2zZA6k5Oex8T+jABLwZXyDcysB54lkLA/uRc=;
        b=rwbO/IovNuKn21ZvUJ9tfeI2JzhySkrYhoCN8+swY6u0CZ8EnX0qCbMufg1oCOoL5I
         wucIiqAQt7LYoa5A7VTLsuTOZSqoiWAdYmnyA8+zlL8hnu7KJ6COxEJPBfxtY3m9R325
         GaGzzcOFurpJb54VmWiOcW5mKbql71NAeBAphYXowq9rVtihwgZoH47nwkebnWNrjBYr
         +UgthU4ZukMw/isChMRQlRwYry8GrpA3elwyIqygGz4hfsfsIPZ7MBasVTx05/QZuTZ3
         8JQHVI5CRo2GH8V08j80+mWOxoMuobLPReVjbJoS8nkaapFf4TJfY89vCDBPVPBk7zpc
         mVOA==
X-Gm-Message-State: AOJu0YxlAV9ougrogyLHHXFfdXtqeR9P2E4ajHJWDM1owAd69ZinWL1h
	GLtLKsSmHl+NzwPrVeceLurWp2012qPfkFsjprx8yMVdcGf5/aQUp1r69z0ofxPJ6AR0MoP0hFf
	OhlZ3oWk67g==
X-Google-Smtp-Source: AGHT+IEBUs3uUV5tTDdeJVp0mGVtfQhaJBiNAC5D5idG3gpWD28gJrfuM1uQfFzs/ISfUztDpKhEvtBJna4YAQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a25:6f08:0:b0:deb:88f5:fa10 with SMTP id
 3f1490d57ef6-dfaf652eb7bmr616555276.5.1717780013124; Fri, 07 Jun 2024
 10:06:53 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:06:38 +0000
In-Reply-To: <20240607170639.3973949-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607170639.3973949-1-tadamsjr@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607170639.3973949-3-tadamsjr@google.com>
Subject: [PATCH 2/3] scsi: pm80xx: Do not issue hard reset before NCQ EH
From: TJ Adams <tadamsjr@google.com>
To: jinpu.wang@cloud.ionos.com
Cc: linux-scsi@vger.kernel.org, ipylypiv@google.com, 
	Terrence Adams <tadamsjr@google.com>
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

