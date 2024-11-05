Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE601D5CC1;
	Tue,  5 Nov 2024 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730812127; cv=none; b=Z2QPZSuOsTsEGaif4Md1YavQFXwiVMyyafjEdh6dlGIy1+Xkbv7LaSRGgn8VkyaTvh5gXNGWnBDcC/zuWBOwTIhE9QRtbCekkAAu187E6esBS1ZqOLJbtz9x1GvV7WvRORNxK8Pp7ehwqvrxyX2uahajSPksBdgLNdSJHSXQSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730812127; c=relaxed/simple;
	bh=6LHO+837xjndsP4UGLKUUF8gg1xB0/7CJewvnYkqhGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YVYQHjOnRujs561np8MltgmqatyGKtA9TRJ47WPgytpnw3P5Vcj4ePyuL7d47NtN8tzKqWYQEcdd7GA60PGGbydGspn8bu/nCLVwYWZ0OCAfxP9lT3+51YkCYRBCp7iz4onZKBIqqUovBB6Tm3aSWS1QNxDdM2xXIjr9MRyRh2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SE8aNa8E; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SE8aNa8E"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-720be27db74so3632121b3a.1;
        Tue, 05 Nov 2024 05:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730812125; x=1731416925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hCLSIGJHLP62LF77LpMB59zHKu9S2DYvdZVP+cXHd8I=;
        b=SE8aNa8El3/Fl7TXal6VTCPiAXIvcAKNifeSUbbOYNc1HIy67OviyCbmo5JcFgMbOH
         rlvo/4q4k3V0pRSTN/yk8Qs+zxTzfzd6GjsO6To2rUceGEitLr3iwnLzPwNYDBwXveyR
         tjOxMRai7g6u7txqWlXIxNDHD/HK/fMJ9Iog9MroRFWVXUD3oDeBU4/1kbi6AD2z2kqi
         O1BhDta/q5gV/kTfZhSdBHNH/TAtA3w89QSQRajg7sOLH2u9Zt5Drz9uWm/AQ6HtoY/x
         wP5OyuOqinhniOsicJdg2RRmCwIHnZDC5RMGkIwWQ41ogTfraAbEeHW7DZuFa5Cw2bBh
         Oy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730812125; x=1731416925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hCLSIGJHLP62LF77LpMB59zHKu9S2DYvdZVP+cXHd8I=;
        b=G9ffZakYF61NRz68SPcI9R+ps3xXV3WjN+1Wy262WqVmZr8etOojH94RV836IPircp
         aaKS+LEzYIEZXghrD6QGrHOvV0H9sXYFGNeze1WGBEMJjMr0Bin7/6vQshZ1NUB6TRvw
         81l+fzpHTl1VDf03ompUPapu8joY6CskjO2UjTYEzTwF05zzEbIqXcglUrOl12Je4Dhy
         hAUcC3ggFz3WGUrnuKWe+kc8JlQhNNqIpyHfKTPTbtupV8y5q+V+Zg3iQNAKKq7fIo49
         fVM/LwLhB/vnrM4pqid4ZbY5Yh6s+CUF8unArrMqAPXJwrRO5lLuTn3K7a7mFxP5xPXg
         hBKA==
X-Forwarded-Encrypted: i=1; AJvYcCXdIkFKVdXJXQ1jXCQLKeel/d55/kR3DQuC5BHZZNpckoeNHysokmiQHmZJf2FU31eEXgl7zjJF6yF2REQ=@vger.kernel.org, AJvYcCXndJ2zZpF9STtcoql/sg4kRusPeooH1rktiZzWG1qzRvZQBzu++DbXWD9B3qrmvZLNJUFzjk8Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5PYkTHlV+Ko6BxHJNolYWEwSg6BzZkt72aYc4reDDm+Vp3gg1
	8DYCC3379UfSyjHHhYah+8Aq8Z9zXYlB7cY/pc2U8WeGqTQYork0
X-Google-Smtp-Source: AGHT+IFlQxCtqXO9063mjfqJQHWWf4u0598lodb03wzVhBBgA3v3zf1o8q2K1owL6eNNSkbh6oDF4A==
X-Received: by 2002:a05:6a00:4b12:b0:71e:4dc5:259a with SMTP id d2e1a72fcca58-720bcd50aabmr28200763b3a.7.1730812124865;
        Tue, 05 Nov 2024 05:08:44 -0800 (PST)
Received: from tom-QiTianM540-A739.. ([106.39.42.118])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1e6afasm9542773b3a.48.2024.11.05.05.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 05:08:44 -0800 (PST)
From: Qiu-ji Chen <chenqiuji666@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix improper handling of refcount in lpfc_bsg_hba_set_event()
Date: Tue,  5 Nov 2024 21:08:35 +0800
Message-Id: <20241105130835.4447-1-chenqiuji666@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes a reference count handling issue in the function 
lpfc_bsg_hba_set_event(). In the branch 
if (evt->reg_id == event_req->ev_reg_id), the function calls 
lpfc_bsg_event_ref(), which increments the reference count of the 
associated resource. However, in the subsequent branch 
if (&evt->node == &phba->ct_ev_waiters), a new evt is allocated, but the 
old evt should be released at this point. Failing to do so could lead to 
issues.

To resolve this issue, we added a release instruction at the beginning of 
the next branch if (&evt->node == &phba->ct_ev_waiters), ensuring that the 
resources allocated in the previous branch are properly released, thereby 
preventing a reference count leak.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and detecting potential issues where resources are not properly managed.
In this case, the tool flagged the missing release operation as a
potential problem, which led to the development of this patch.

Fixes: 4cc0e56e977f ("[SCSI] lpfc 8.3.8: (BSG3) Modify BSG commands to operate asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 85059b83ea6b..3a65270c5584 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1200,6 +1200,9 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 	if (&evt->node == &phba->ct_ev_waiters) {
+		spin_lock_irqsave(&phba->ct_ev_lock, flags);
+		lpfc_bsg_event_unref(evt);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		/* no event waiting struct yet - first call */
 		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 		if (dd_data == NULL) {
-- 
2.34.1

