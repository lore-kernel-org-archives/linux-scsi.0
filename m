Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E011F2369
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280704; cv=none; b=sp4k7FlC8RPkttxnJGLo44eR3hVFf07Gsbj8yYt5cDny8bmMGJlKTttSdq21vxNnEUfEJBW8sqz90I7X2M1Ypvi8ggDiVbYzWUwmV778b0oc/qHZPuRC9VgVfUVPJAT/KlqKrZAs44D5uF9meMM7BmCVp2j+gO3TuH5fBsg+0pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280704; c=relaxed/simple;
	bh=gzJip65xZjec0drMH7dqT5XxsCA78/QTyS7bX/mq3LA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XY5JCopzVYiDd9geDQZcCt0kOxIVrd03JhiftbI5w+NZejTRscB7k15wkKazBic6onm6U+ynaB85wHbEB5moxQBahPYv4br6fQeo8gczxDF9palbzc4od4iwSqs0t6dPDbpT7DsKt/aGXvsCR92qWYbrdO8KsTqKiI4cJI8EN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aueG52ZW; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aueG52ZW"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-723442fd88aso389926a34.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280701; x=1738885501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XmHXyg58/lgk0Dnz/bDC6q6A+46DlmgBOdeNFrLZBc=;
        b=aueG52ZWDXZrXWsZLHc2syJopoXcxFyWyVdwlQROi93nOZZruFhajne3fQwiBFptA3
         aC/cU/L7Y78WtcbM0qbDUtNSRsKWNqZqIFIn04ZEw6iwH2jnXhrf2AU5eoH4CSXadwGT
         UCs6nLJapsm2v6773XHVAFLi4OUf2T/RDgL6UpYjzxZl5pCgcZt7enPzAkp4N4L+ha+4
         6VzypsfaQIKAJgsLORX828p5gCz0S0I9XZqYL0H7iys3lOyMzmAbvo/jD/q+H7Xk8LwR
         uQHY1tPzoGfzLGoSxcYCAlj1aZSyyMG+okWv7eTgrkd9kJTMgxZ3qxvxZfxHymkyblJF
         5zFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280701; x=1738885501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XmHXyg58/lgk0Dnz/bDC6q6A+46DlmgBOdeNFrLZBc=;
        b=jMvh9gk05HlJYZ1KqGzOL6Rc5ZPjGRXL0sIS9PFinSOfEz94sralk28pARWvL/XQ+h
         vHASSBFHimID8I5517B6HHUrG781n8LXE2RgBrv47XSR5A+zwVMjydN1+BnxlqfF+vm+
         /d6GGX9UEAjcGA/r387aSqBYVdGs6HHHBK0SFMOAYRDfGYah4h/VokL5Iqk/wCMJ+TV2
         tnl12EHELusstUzGQ9xYiUY2tbrP8meU8+5hYcjn8a49DQqqZUqzKvPM6ywPIa9wJasA
         zwGwKv13bQ13ZMJyxCCDFVWCqV2Nu4mwdxN7i7stN1HTLzsHLajtQhJe0Y6dGoYL9BNn
         yw8g==
X-Gm-Message-State: AOJu0YxKg9VEnnyqcYIrQRxAql+k4apQLUCj7KO1ZXWGKQRoa/Pdw0+f
	OA3G8wyHaUQ2yTGVhdETuw/tJ9g3G+F1OgWYajKOLHxImNhdxZuO81zA4w==
X-Gm-Gg: ASbGncuHsEcOGXVV2+YyZxrDXxjJc4WJdXzqPQ4tPSlHgijiJphe4tQhSXJhgxBUxGq
	fAsjam6D47JcE68ukBXATjwiMiHeItOB6Qwepuqw004dq23K+0F14cVL6h+A6M2leuRbbxQ16vj
	zbXYJT1AT8SIoZJT3mOE6UqlETSrvAorNr2QnzK0ltUJegv+ek8QKZToHWxxnoU4FWrhqwYuYtT
	EzwLlI+5Cl/jckvqQ8pt7MkBrYwdUQFqucEhX2fTLMh3idOfLo/wXzCDuffBST5zTQUFq4/hR0q
	PqUfN1aQEXQhMBiGS3nJnubE09huIbhjsDe4kdn5wAA3Kl91Ig0KWr7LCIfaAIqu3QMzbZcQCPG
	Z
X-Google-Smtp-Source: AGHT+IH2HszCvRrbVtsbpF6c8bNQnEjT+tNDjT1d/6UXU7ZqUt6jtkbRs8mZ5t4UR+GDHR5d7kso4A==
X-Received: by 2002:a05:6830:6481:b0:721:bede:f369 with SMTP id 46e09a7af769-7265673472amr6398400a34.5.1738280701227;
        Thu, 30 Jan 2025 15:45:01 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.45.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:45:00 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/6] lpfc: Reduce log message generation during ELS ring clean up
Date: Thu, 30 Jan 2025 16:05:19 -0800
Message-Id: <20250131000524.163662-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A clean up log message is output from lpfc_els_flush_cmd for each
outstanding ELS I/O and repeated for every NPIV instance.  The log message
should only be generated for active I/Os matching the NPIV vport.  Thus,
move the vport check to before logging the message.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1d7db49a8fe4..318dc83e9a2a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9569,18 +9569,16 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	mbx_tmo_err = test_bit(MBX_TMO_ERR, &phba->bit_flags);
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
+		if (piocb->vport != vport)
+			continue;
+
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "2243 iotag = 0x%x cmd_flag = 0x%x "
-				 "ulp_command = 0x%x this_vport %x "
-				 "sli_flag = 0x%x\n",
+				 "ulp_command = 0x%x sli_flag = 0x%x\n",
 				 piocb->iotag, piocb->cmd_flag,
 				 get_job_cmnd(phba, piocb),
-				 (piocb->vport == vport),
 				 phba->sli.sli_flag);
 
-		if (piocb->vport != vport)
-			continue;
-
 		if ((phba->sli.sli_flag & LPFC_SLI_ACTIVE) && !mbx_tmo_err) {
 			if (piocb->cmd_flag & LPFC_IO_LIBDFC)
 				continue;
-- 
2.38.0

