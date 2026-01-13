Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E4E2D6E6C
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316244; cv=none; b=Lee1I2d20XSdQx2QyS+25hHmv/mfkt7Ekc9nPWxJuIa2OAp0W7msBRBn44iDcbyjC65U/MPlFLrHWo8zdxKTCVeWpXnbKawrjEylIQoVFE+vgAwDdNeyFMmzF5L6WoIEzcXW3F80fw9k73YfzJftX+pqfZCM7TEncziOLfshaNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316244; c=relaxed/simple;
	bh=xUVY+Dz6mtf+yKcFsJ+m8+y0vbeY6ptF4xjYL+qR6Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fWmHfwfYsaI5+HqrEGfsE982Lea9yfoncUfrTN6q+LynGt+UyN2uYgzKWHUAdSyynkNgPykRBT71geImoPRjl/lk87jojxZJEHloUwDkFggSFAMB2g8fpqsN07IB3ecYzA4MGUmkS6gI+/9+PqhK3ol3Mb5WGXoAII3+G7462Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YJ843/1R; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YJ843/1R"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47ee0291921so2940595e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 06:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768316241; x=1768921041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hFLKxCgg4DVA2BYQnPzZOCKSccnjmY1LCX1KgVFeNM=;
        b=YJ843/1Rd5vWcOwiINGbUgbELktX3nyeanKuSiOiiLWvimsu6uU/FV55bHMCXuD5Bi
         I4YzqeieiMNB29BSZZQrdc7VwhwBWKR+XV08skp7r7UmHDQhoi2VjlOjphMWFwA/H0vj
         FOB98uX6UTfeg/to0SfE3PWfOInLsqTs9ZubE/64FBiwuWbSV1YdSwHVkZAERHRCqSri
         Dve0RYUgzXtrwKTmjJKF/vuFu9JDbWcdQunpq5r4qr8w1WaHUpDWrd28QtyA3wgf9lMg
         lD1nbYCpduZuIlwCnPH6sAQwZcHm8MIrq3PdjaT+YbAxtCz1oxskf5O78ACI9COMVvoQ
         GG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316241; x=1768921041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0hFLKxCgg4DVA2BYQnPzZOCKSccnjmY1LCX1KgVFeNM=;
        b=pikbr7GGJTIk0I3FmJLZ3rOQVSxNmJ+viYMy92H6rOuc38fZoXhoedhM6zX8YATh9Z
         RX2Eg1IU6FnR8q2T0PW+zULNui4y5s1IO7f+JU4DDuyZgBs+fy7hldaz1B5B/cI511ZP
         ouOgwhziIQ3/EIX83HGf/UUrqFwLguG8QBNTwnFB5P68YIp8r1kFuDrKwVnNEK6DmlN+
         Sf2CsWmCToVakflqkf1W6MT3AOetrZYEJh8S7ptzOpaemp6Hc5lgWawjjCBaBfCOhrl6
         lIW2D8zaIeXbsLji5wvyr7eSyhCfaQ3V3uRqc3uEyGzc0PCkib4xwjfGI2sSxXsAut4Z
         yKlg==
X-Forwarded-Encrypted: i=1; AJvYcCXlw41xjbtVl37ZIxKlCyvXxwCn0i7KKmZA3EMfTu1h2nXXvF5fY3inooJ21Lk9YkTWRljTA2cFTjVS@vger.kernel.org
X-Gm-Message-State: AOJu0YzZwfa+ozSha77gZS3GylpiOQn+pO1Ti+S5q1iYmZEuwKThi8AP
	F8cSYr+5xHY5btRK26v2P3ONOP4DCzmt4YVU+fTsVpS3RjTlCu/kdOQBjUxgkGjpLZc=
X-Gm-Gg: AY/fxX5pG8giYVx7T9C3skofgYox4is1ZSNioBuAqZXK2fZ/ls8NakFkB2TiIESTrZw
	X8hKeEqHlIqsygK6ObpzX5nkVM6dODevAUr6UMJ9vqBMdk2x/G8f5E/2rtRZAQ3SVFPMpPJwUAd
	zSR+4FVjdg6ovJ989fcm+5kRlsLLSUhmBJs9n+PlfITXz6f0O520ewJiA80qwZEczd088BSOOE/
	jxjeSxHRy5w8IiiguuX0alqRG7BT+VxL+OQXdUqzMcgtpf8uSSFDHvewG5g1I8v+HJn40cHXyvK
	KZQ6MZFur8ouv5f8+rL6uiU512ETGsTiYFs2fbLPCsOAA1h079hoXQrjKweX1TJ8HkuPLlLBjD4
	JK40LoYJ2aD8fdguTvmYAR2xlWk7QBuzhF6BFCLhmSlYt67isRgWawS5E6b1sv+C02ZkocGTSyG
	a35SVu6IXpgRJNh+KLMvZ3UpqmqGVNaDWH+Tc=
X-Google-Smtp-Source: AGHT+IGMKYMnsBy5q3lHF2caHx7b+bcLkDOwakSbhNrSSUaKe0WsXPIA2WZy7D3r1wdP6LfTKyqHUg==
X-Received: by 2002:a05:600c:8b57:b0:477:54f9:6ac2 with SMTP id 5b1f17b1804b1-47d849bdfa7mr237829425e9.0.1768316240959;
        Tue, 13 Jan 2026 06:57:20 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ecf6a5466sm128498565e9.11.2026.01.13.06.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:57:20 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] scsi: qla4xxx: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 13 Jan 2026 15:57:09 +0100
Message-ID: <20260113145711.242316-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260113145711.242316-1-marco.crivellari@suse.com>
References: <20260113145711.242316-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU. For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 97329c97332f..125967e5c548 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8819,7 +8819,7 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	}
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
 
-	ha->task_wq = alloc_workqueue("qla4xxx_%lu_task", WQ_MEM_RECLAIM, 1,
+	ha->task_wq = alloc_workqueue("qla4xxx_%lu_task", WQ_MEM_RECLAIM | WQ_PERCPU, 1,
 				      ha->host_no);
 	if (!ha->task_wq) {
 		ql4_printk(KERN_WARNING, ha, "Unable to start task thread!\n");
-- 
2.52.0

