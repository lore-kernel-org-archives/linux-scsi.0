Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1870B2D78A
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609082; cv=none; b=ET0MJMDJppoNt1aqkZhMop6oeEDAcpPY9KEnrOw8oHFtF7mL5oSinPDcTSMuQgcxMxedBpLjGuGZivPpJC7rCqut5Ca40j3VN3DchaBbvhup3Mg3jmPSWKoOh96KEcFFFru30tpATY0g2pp6kF/mjyGMS4vt6HAnBTMgSfy3GZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609082; c=relaxed/simple;
	bh=1vvf2itwTJXKaPDj70/eseYsNtW02QwEwRvoVRybkv4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXJAKszYzjWuB3afl9hsOqT+Q7YyPFK4QHUr1zgG7OMQyxNAa9ECUT8bUxqwZCqeM7wkyNTWDaGq4q8ACyXv/MB3XcPEUHaiZkI+A5YcPc0sHcJNIqljp0ENPOoOUvzh8fZPPMGQA1Domy1PSthAoohy0olqmaEB+uvPDRrt6NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Di8P4aPS; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Di8P4aPS"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736ab1c43c4so2632152b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609080; x=1746213880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zdwHaMdXdc0coCr5oJlzKBFV+fIyFUUnEZCNnt/3dQ=;
        b=Di8P4aPSAlkJcCI8yGii2zqV6yy+MFF1qSOma56f/0E9dXg1puMGMJ0X8E4YEETVOZ
         /r1YGQDlyDiNj3vJ9WMW95p3VrYxw1l1X103Isp6EieQfXUDlAPRYQK8TkPOLy3XCOTa
         dOQWbjSrrZoIs7Bhd8PlxOq8r6D46Uuth+rNl5J4f4KEZ8CX5KP2XdEi20OLccC70SKE
         vYGIJdaQYxnaLdOH3r5luaIyNOG0NzZyIm5WfUeZeJaVCCo1zUOlyIKy/3AFKfdLblzX
         UyfsI15+4iOG52B3w+GcfDsv5MedQRjXGVUyPDgyf0UMilN6RkR15qUNwPgcX5avMn7T
         8ADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609080; x=1746213880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zdwHaMdXdc0coCr5oJlzKBFV+fIyFUUnEZCNnt/3dQ=;
        b=a9KoZ17sNmR7cR2M90xbB8fHO04dmbPjmV/8dc/th+k6Bv+0726x1bSq1C3cbh1Ozm
         16cjEBhvJJC/q1RcEsTB/FQJDRW5Z1ns++HEVkFIUCXvxdF1kuZt/1kzuxWwul/5nb47
         B6AZd4tzC1PnKIDlcGuCFKk7/R7FSrXP3Bh1Oou/PhDCUrUBbmBBTgks1wGZlQMEtYxZ
         CXVT9fpycLhExte6HbCldyLT3kdrt7QOdGfNg2alZmI2TUo+NKge4my91nA07WpD7qje
         FGvj6Zo5OVG+0hAyxxuErNtUC4OZ0ceO2+YfpPWhOzuysPHlCg2tZTSKyY9uskBAxB/4
         3vxQ==
X-Gm-Message-State: AOJu0Yx1tlPPsLi2lPhfT7UPhpqpJq8FoT4nlZLn8EihnxnhHJzKa22Y
	pDec3XtR7TxypiCQCWKNP61wBAE98QvoZZEAUU9L0Obl/k7n0RPVT9e5/w==
X-Gm-Gg: ASbGncs/v/PwLoaqb4+HDW/pKoFy+QHKIT92+uN5zisZfQQLe9qEdQT/O+NdOrsHUpe
	fA+qADTHyJwYG5M01f6cTdHBQih7X9rVgn9ArMA8F+i3TMAdeVEk/c/pecLPPtbVe5CW9XU0+su
	xir1yQPOS7VnfKc0GJQIhavcXTqvIwVOQbsIEhlBB0AKmleo4Q62OEABKJl59OedznQ8RK/fM7U
	/qbFnuUUun/t8t51P6TrdDdipkuRrtCIkVlF77RBbtm5hmIIry6w3GneuDNJDqoxzWvUZF2K8DZ
	cL7OqHERjYbwG0jm2Y3eEV0OPIa1cXSeKlCdf+xwZDYzzdElPFs0x7affM2IZ9vSWhxSlg271Ip
	yAtyGlh/zvN0fiXm4iFq78dpVhg==
X-Google-Smtp-Source: AGHT+IHO9bVmoIiuuHpGwkzXw2KQf41cMoti7Va/NWvMAJsyYPhmlzu88WkTsjswHCnmkFW49KIqBQ==
X-Received: by 2002:a05:6a00:b8a:b0:730:9752:d02a with SMTP id d2e1a72fcca58-73ff7255affmr867828b3a.4.1745609080166;
        Fri, 25 Apr 2025 12:24:40 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:39 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/8] lpfc: Restart eratt_poll timer if HBA_SETUP flag still unset
Date: Fri, 25 Apr 2025 12:48:01 -0700
Message-Id: <20250425194806.3585-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reschedule the eratt_poll timer if the HBA_SETUP flag isn’t set yet.  The
eratt_poll timer should only be cancelled if FC_UNLOADING flag is set or if
lpfc_stop_hba_timers is called as part of error, reset, or offline
handling.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a335d34070d3..b582728d9e48 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3926,12 +3926,19 @@ void lpfc_poll_eratt(struct timer_list *t)
 	uint64_t sli_intr, cnt;
 
 	phba = from_timer(phba, t, eratt_poll);
-	if (!test_bit(HBA_SETUP, &phba->hba_flag))
-		return;
 
 	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"0663 HBA still initializing 0x%lx, restart "
+				"timer\n",
+				phba->hba_flag);
+		goto restart_timer;
+	}
+
 	/* Here we will also keep track of interrupts per sec of the hba */
 	sli_intr = phba->sli.slistat.sli_intr;
 
@@ -3950,13 +3957,16 @@ void lpfc_poll_eratt(struct timer_list *t)
 	/* Check chip HA register for error event */
 	eratt = lpfc_sli_check_eratt(phba);
 
-	if (eratt)
+	if (eratt) {
 		/* Tell the worker thread there is work to do */
 		lpfc_worker_wake_up(phba);
-	else
-		/* Restart the timer for next eratt poll */
-		mod_timer(&phba->eratt_poll,
-			  jiffies + secs_to_jiffies(phba->eratt_poll_interval));
+		return;
+	}
+
+restart_timer:
+	/* Restart the timer for next eratt poll */
+	mod_timer(&phba->eratt_poll,
+		  jiffies + secs_to_jiffies(phba->eratt_poll_interval));
 	return;
 }
 
-- 
2.38.0

