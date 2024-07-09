Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304F74A02
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720540844; cv=none; b=lVPMCMjIEtSn3nh4UvDDyld2e3Fl2FxoGtz9OX3AfFxUE7VrCQ7yiKHqCM/y0JsRpzDcZ5tOwRClaWDcrhRUSNmIc/U0n7tDo4HputKnoD/3GEiGWPchfnnLRoQeIeG5xPzCMDzUDSkDNARhmK0nfW5WvJ/d5TPGtesKMNd9tgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720540844; c=relaxed/simple;
	bh=EADrzDGkE5255NQqwAYoJHuh2ZZ74HUptIuyct3xezw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=k4UWn9plttRwMc6j9xZYcmdRLMR97gLH1K9a/LMAljZHS45kTM1CcHdKFXP8Yomfcmd1X9SsD5pz/28tzR3aLWyL+NJK5IWdLNylH0MiFSrS19cYIULf9jwT+YoiS53m1l86VwDOgdVFtPpCE2JcYBjkhb5jwo8ZmUbgoVEEyX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0n4jxK6z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0n4jxK6z"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-64b49f4232eso81600897b3.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jul 2024 09:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720540842; x=1721145642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ngDjlVaF8v7sv5bAjkzKl4Op2nALhKGKwrU4Pph8/BQ=;
        b=0n4jxK6zKihGW9VotsO8MW1S90BDsBVqCj737893wbkHaf19EESuiD5vRlePlsJa1S
         wW66exZiCS5qY1Tygk70l4M8/ckNWrHTuRDy/BQ/EmJl2Eo3bgxS7CWo8CCRbu2RBb0C
         yB2F0iEaD2ZFRQ/n6W9jkPedpb9NtNeuPZQ+N5y3zTzG3DO/BSAN+BxGr7J6Tu1FvdQ4
         Z6bhcPGGmQcF8UAucG38yAvMfrb8qP9stFakIelsgjmxAVrBI7OJuTfnsBXmIXVD8cri
         kAggcR1s2AJ3vmtZuxCDkn7cBY/DrxW94y4MyAP/Op/C3nsGDvOhzxFCgvuweWyznxF5
         Od8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720540842; x=1721145642;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ngDjlVaF8v7sv5bAjkzKl4Op2nALhKGKwrU4Pph8/BQ=;
        b=iQDUhNhwJ+saZrN53Zz2uFouZgTy1OLj1IAclsL/JeSmwSk4q4QNdbqJBhR8lRRgdP
         h6yiRsnEz7vCU3SKd+YXDrGSLIIontAzRZ8l1ZNtJ3v1/vBKovWhYfZGNo9ozxyOcg6M
         liC/tWXoGRN8J4E1iZbOHOCktg/k/7YeApAQ7C4ZfVsoijAT/Yv0Sw7XFmzG2lAoci/u
         I+Wge9bc7byYf9KsFGFPPN7vaxAv6SyZ7XVy6brFxJqb9uS9ahMB3P/i/fx71T4vs84U
         5oJ1LAaJs+cqgP0LvEGyss1bN8UAtVALxI8ItVPjAsqGcS9qRKkDSHUxryFOEuzlS0Fh
         1+jA==
X-Gm-Message-State: AOJu0Yxj6lfOQ1WzKF/Y9ZG/Bw36FJfOjab9Y1NjMlNVDsVRWPY7PQRq
	uL6vkqeDGSiAOvMlQDsMGKhu8DVcXjXglIoo2kuPOBm9zwm+0MPJR4zCpatm60P6ChIaMA7DYjs
	JR2OI4oOC4A==
X-Google-Smtp-Source: AGHT+IGZ1NCoisbeTLsLpo/X5VPW/CXhcfiq+eOQ0Xf/LzqyQD0jzaYrPITCYcro3gnXPMfrn/QMGHExioj8Hg==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:690c:60c8:b0:630:28e3:2568 with SMTP
 id 00721157ae682-658eeb6df10mr151767b3.3.1720540842268; Tue, 09 Jul 2024
 09:00:42 -0700 (PDT)
Date: Tue,  9 Jul 2024 09:00:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <20240709160013.634308-1-tadamsjr@google.com>
Subject: [PATCH] scsi: pm80xx: Remove msleep() loop from pm8001_dev_gone_notify()
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, TJ Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

It's possible to end up in a state where pm8001_dev->running_req never
reaches zero. In that state we will be sleeping forever.

sas_execute_internal_abort_dev() can wait for a response for
up to 60 seconds (3 retries x 20 seconds). 60 seconds should be enough
for pm8001_dev->running_req to get to zero.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: TJ Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a5a31dfa4512..513e9a49838c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -712,8 +712,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		if (atomic_read(&pm8001_dev->running_req)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			sas_execute_internal_abort_dev(dev, 0, NULL);
-			while (atomic_read(&pm8001_dev->running_req))
-				msleep(20);
+			if (atomic_read(&pm8001_dev->running_req)) {
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "device_id: %u: Failed to abort %d requests!\n",
+					   device_id, atomic_read(&pm8001_dev->running_req));
+			}
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
-- 
2.45.2.803.g4e1b14247a-goog

