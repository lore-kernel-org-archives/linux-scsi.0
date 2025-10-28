Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC04723C8AE
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761663351; cv=none; b=W+WlVFV5oi74qqX6Mk3HZEaScArt1ZMWnf1ovvU5dF3VnYnnD3JutHP0eelcNF2PEqJgqdc3ddgbAEq5m898vtxW2v94chdvCKBH1ozTJwdHIst2tDNxbCSSUdhtx/M1uiEC3jP9RREp4dKAuL+kfqxSzwV2c5I2POUEhBtGto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761663351; c=relaxed/simple;
	bh=4DfI7OcUnB+kIuMTQXNdtCg+eWdy+FCdGYX959o/v1g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=KXwBS1jH/PIRD8Uh3z8MrIvJv1fTnq9lcoJ9A3LZo6u36N/vJurHTrKYFN+cQvYa1AmJ84X/1JQnae8VBxLVkBZuyta8KYJX1tbETZIELI51fGV5nMZKPozQqq5TDCjGDCb0S2GTHIAvDefNbAOQ26H0yRN/dAzOeG8EnaPOOzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hHXhqDL3; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHXhqDL3"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-378d50e1c77so55385891fa.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 07:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761663348; x=1762268148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cxgC3Ar205SePZa68q9SjHUQRYO31L1UuAjDONdLHVE=;
        b=hHXhqDL3w0Vx6kMG51Fjk8jFxIYahWeolRhcGDxl+8U1LvwlXinDUdnMXcSe3tk74v
         lXAVT9iEYfr+8eTv2+h+HL1LzQ5DxMA3NXV7w/cHcbuk4wtwhN5hR6qQAI50cfIce2bO
         1+6VRN7oa4Kw15FR5RBiIxwInxGbbc8uh+Fuu817GPf/neeYeqmQWRwjBLMkf4RacqVF
         QrfCJjpt8/ZMyhV0eZHJ3bY8Icqtqwae79eG53QTXu68q1fomyZLYtTesr9kKvPXiZb8
         5TrfHPh+0J+hUR5T75LseO91sDCWUq46+k5IugS7brnGxKwyaRdlQ5Da/MHKw3SOGCHs
         8BJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761663348; x=1762268148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxgC3Ar205SePZa68q9SjHUQRYO31L1UuAjDONdLHVE=;
        b=jAG+w12NeMKh9aCNmrH/VUTP/Ra4V5umUX/L9YCP+7FXTrgHXXQi2nh702nGYTkRbU
         Oj2V3e7MdQNTDiNYuwx3/rl+srQ412I5ZdzalCHxZ4DZ/59la1ADDpwb2RjOgLoujaEL
         zX1dG4CsWLjYKG9HDGPFM79+1CNob7z/nkRWgSYlwsUVyMv1tW6jTDain0qVv79WUAh8
         I3jFpqaHR6dVntMmClqLoxpvYfCqauhtfUhZRACHI5trGKKyxlTptdiZZdwCFQey6qOh
         yhPgTBE8dGB10IDIyBNs33UrBIADT1EaHmj1OraDs5OQCqxGmS82QmYJ4QdMhbxBXdjl
         l+dA==
X-Forwarded-Encrypted: i=1; AJvYcCVE64iN6UbLSCUg2GfZRHzuxMMgTcSLra95lyLTxhYDSrV53OCuFePHDgYcCqBsJUoi6CPgg8VIOH1y@vger.kernel.org
X-Gm-Message-State: AOJu0YyZX5LtwYNNANuY7ANitTArpQiPVo9JVWAXe8FpimbtX6hyvtya
	0Vr20qxz7u7Gr3txi+EwIS/mlhrcSIwReey/89AQ/vkmVoRzrLv427Qd
X-Gm-Gg: ASbGncsqAUPfvCnDyH7l+tQUFiR8akdFTQLtIKKo79oRwPUipPPM+5+uKjomeYhW1wz
	lHv1+1IAwIqLH83s/h+b6A0nO+Lsnj9f+nIURfGho8m3BZDr6q3yyFPnNZSrP2IZWuAjtP4hWJs
	/Ek/YLha1lx7ref5i7Q6vxJpqxWb0UE6g9iMVjsKDzsOHofv9iytehI2s4r6mUTnSfw19HsPDq4
	C7lWtEsvn75CWudac9r6kAkKFuMeeaWD3ptNQySVvJ7xB3OX8tewtgs+lpkpsxm1MfQ7Lmn8n8s
	LyxrMrrkgBERCDqjTuGgaCLlBvhchk+JYojvKJ1GBPjivw3JPGfeVkgtsOKagPxtsxChd+LsBLj
	XZMx73W+2t9SHNUnY6/uvyaxQxVdDf2iSoRus4NXMTCdrQdZaSmiZOmKQzBFiSkMMzpoobdSgh7
	K2uPI5LiQl7TG/YwtnAje2F6/2eaYaM5ew1Eiqtm1iUPH4JB61Bw50h0TZQ9zEDe6dZqNJULyer
	86CPUJRg03lYc8W78eCl8L2n1GEUEE=
X-Google-Smtp-Source: AGHT+IEYtMFNcBTkx5BcQJAnt4IjKAPptrA7hwRAVKe8cUNymnzw27KPZxunv/Xg4w6rE9Z8xlhI2Q==
X-Received: by 2002:a05:6512:b05:b0:592:f9f4:7932 with SMTP id 2adb3069b0e04-5930e9cb1ebmr1304002e87.33.1761663347674;
        Tue, 28 Oct 2025 07:55:47 -0700 (PDT)
Received: from localhost.localdomain (host194.safe-lock.net. [195.20.212.194])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59302878849sm3082988e87.80.2025.10.28.07.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 07:55:47 -0700 (PDT)
From: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com
Cc: martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	skhan@linuxfoundation.org,
	khalid@kernel.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Subject: [PATCH RFT v2] driver/scsi/mpi3mr: Fix build warning for mpi3mr_start_watchdog
Date: Tue, 28 Oct 2025 15:55:34 +0100
Message-Id: <20251028145534.95457-1-kubik.bartlomiej@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

GCC warning:
drivers/scsi/mpi3mr/mpi3mr_fw.c:2872:60: warning: ‘%s’ directive
output may be truncated writing up to 63 bytes into a region of size
41 [-Wformat-truncation=]

Change MPI3MR_WATCHDOG_NAME_LENGTH define to properly clarify
the required buffer size.

The mrioc->watchdog_work_q_name buffer in
the mpi3mr_start_watchdog() function no longer requires adding mrioc->id,
since mrioc->name already includes it.

mrioc->name is built using:
sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id)

Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
---

I do not have the hardware to full tests it.
Tests only built kernel without warning and run kernel.

Changelog:
Changes since v1:
- Add define MPI3MR_WATCHDOG_NAME_LENGTH (MPI3MR_NAME_LENGTH + 15)
- Change watchdog_work_q_name buffer from size 50 to MPI3MR_WATCHDOG_NAME_LENGTH

Link to v1
https://lore.kernel.org/all/20251002063038.552399-1-kubik.bartlomiej@gmail.com/

 drivers/scsi/mpi3mr/mpi3mr.h    | 3 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6742684e2990..be15d5ec8b58 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -66,6 +66,7 @@ extern atomic64_t event_counter;

 #define MPI3MR_NAME_LENGTH	64
 #define IOCNAME			"%s: "
+#define MPI3MR_WATCHDOG_NAME_LENGTH (sizeof("watchdog_") + MPI3MR_NAME_LENGTH + 1)

 #define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)

@@ -1265,7 +1266,7 @@ struct mpi3mr_ioc {
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;

-	char watchdog_work_q_name[50];
+	char watchdog_work_q_name[MPI3MR_WATCHDOG_NAME_LENGTH];
 	struct workqueue_struct *watchdog_work_q;
 	struct delayed_work watchdog_work;
 	spinlock_t watchdog_lock;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8fe6e0bf342e..18b176e358c5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2879,8 +2879,7 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc)

 	INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
 	snprintf(mrioc->watchdog_work_q_name,
-	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
-	    mrioc->id);
+	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s", mrioc->name);
 	mrioc->watchdog_work_q = alloc_ordered_workqueue(
 		"%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
 	if (!mrioc->watchdog_work_q) {
--
2.39.5

