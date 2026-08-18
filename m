Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E458945FFAC
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075895; cv=none; b=Iba8TcqAKCGbkvUmQ7+HrDBj6SkF9sl+dIGhfO5tiVVHR22ezNB9vg3ZtdlvQ5/BfMDzwyuXPDnJbCbEWg94uTa9k40s9BNeOAFdfAyQFik/tp/uoS+O15X8rJ4YE9730F0ZnChR2fWhCXbYXL4lR9myD/hndhxD2Xhjv6v2hxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075895; c=relaxed/simple;
	bh=J2JnceeOqrww6pASqA/qHXYRrGohzTWIGBm1b/lJpAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prhdbC1IBTkTrHXjEs8PFdwry/zQbz7UkGiQjli0ajsLC14oc9ras7BkSn1mOAmGZB4lrOqA3j2BH8YqPKVCRd1wjB6bHuUC8Q/V0TMoe7E4uU56Qrz+BPlsfcTSW2WXaNRTXrKneXBtMIibzbzTcH0ryelcv22xCgJLoNij8e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CQ366Yup; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CQ366Yup"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2d01663d816so978385ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075893; x=1787680693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=13VK9z0RP64dI9ZZPzpGRxpYFOENXBIvRm93woih9Rg=;
        b=n5O2PF1WTRouMRADMeKbMs7xj/jom7AUhYS2YnoVYNwieu6++mgx3ET0Qmos/fuJVW
         HjUWRLQqVcx2OheKkvS8JXe13uZYhbwkBuriZBTKCkE5pEuqTQYNilbcfBokSKDD9cZn
         ki8PN3tu4im3nIvz8VyfJqPf9cj15vzWw3HiiyOLOmQGXjVb1NDN0Ou3fIxU8VgH9ux9
         ZYdaq0SrdAMBLEZs4Njz5FO7A46reahTivCqrfEjD/V7Y3pVFlNc0NX5cnjJHqYCexAR
         AW4hjygoYRNYX+PUXUv+BZkVDQSyA8W27q0xD+k+arzhTEVwYocVI87zNPt4U+EfAB7k
         /RsQ==
X-Gm-Message-State: AOJu0YxStkCzi6o6WWR74NODatE32UL/9uy3Ei1jsMp5+Aa2t9yY3gC9
	D3pYBRgmnYW65JgrfSUsWcG+n1W3J4zqY8woMwVGgkSbb1cBUDBjr+XLnCa2WT9WU7vK/po/epj
	6ocABIgaSbsnFKmhupyfTxhUlrLEhkoLuZBezuQPZ3dicxnMRHFOuykaB4HLENuNvvykgl2jbli
	X5VuVI6lX6ORn7rVopZYF8IVbxUFo80FWDUSA8gTh4wdEsaCV+8Q9iWyxhkOvnH+wPE6rk5souw
	IuCeo7M7rDIO4EO5o+1abB/
X-Gm-Gg: AR+sD13Z2eX49Ol5+snUmgQUoMAWszMp4QLjvsLgbDAvyhI383DJeUi7JHxWMduIHyV
	MsAXOcTHcupSLbar7NZltYS/1vId/KlMERW0aDcHqlDQRl+rj1GqemxpOM91YR5kbZfskQVg4tE
	LZia8vBvZ/k7EvZ1pddqiTd2b9DvWk/HkMb7zCO9urWuu3MtMBQQXyQwI2TZ699uslkZqMzgp9T
	/RCoeEH++SXSXs9Kd1MsxjsJJY1Uz3cM3sJCSvHFMsFEwMSU5oB3SYTkH70laUmfQS4b/6Gxb2Q
	ODWklqZhP/xoC5veoY+cODkrUWQl1lI11Ykj8s/+mQv/DCxWsSoXyKRf7LTSSnsS8inlpEgS2pi
	MGjsIJbLKAuDMuIXDa7276pMW6qcvdh6XindAcrxvdZ+vDicF/bYLchZGb4qjYo7QlbOkBmkrEV
	pkgeitkCCmoEgC1mVzM7VBOWYbKpsI636e7m/TA0+PvmY=
X-Received: by 2002:a17:903:1850:b0:2ca:f21a:a6c5 with SMTP id d9443c01a7336-2d3b0aeeb01mr460814295ad.1.1787075893066;
        Tue, 18 Aug 2026 10:58:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2d5c1e913fbsm824375ad.36.2026.08.18.10.58.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:58:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso241905a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075891; x=1787680691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=13VK9z0RP64dI9ZZPzpGRxpYFOENXBIvRm93woih9Rg=;
        b=CQ366Yup1y7hhZMjv9XPeBeYp2amNWM11CssWq5Wi+sWVdvtZwtreKlbOq4pTrjw/g
         0/XDFgrQt3EBvunnAGSGxDg23iZow9FzdyNhoswQkQzvXo9h02iqYrrQmWXRO05r53Ho
         CrseuHhozH8q9ZJXMBBLncrl7FzaW3gRHGXqc=
X-Received: by 2002:a17:90b:4a89:b0:38e:ad9d:1151 with SMTP id 98e67ed59e1d1-3933b714d58mr36209074a91.4.1787075891059;
        Tue, 18 Aug 2026 10:58:11 -0700 (PDT)
X-Received: by 2002:a17:90b:4a89:b0:38e:ad9d:1151 with SMTP id 98e67ed59e1d1-3933b714d58mr36209007a91.4.1787075890454;
        Tue, 18 Aug 2026 10:58:10 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:58:10 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 16/17] mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 19 Aug 2026 04:44:25 +0530
Message-ID: <20260818231426.58105-17-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The enqueue path reads the workqueue pointer before taking the event
lock, while the remove path clears that pointer and destroys the
workqueue while holding it. The enqueue can therefore reach
queue_work() after the workqueue is gone.

Move the check inside the lock.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 00bd654d7f24..c740a64164e5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
 {
 	unsigned long flags;
 
-	if (!mrioc->fwevt_worker_thread)
-		return;
-
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!mrioc->fwevt_worker_thread) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		return;
+	}
 	/* get fwevt reference count while adding it to fwevt_list */
 	mpi3mr_fwevt_get(fwevt);
 	INIT_LIST_HEAD(&fwevt->list);
