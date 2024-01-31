Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C34C210E7
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726246; cv=none; b=AoWtBzdGoT5P64nfAHU6fYwYfML2oq9omLCF7WBRwTbMdxsxJwWiZcO5jDFDftTDpJe7leiDzjnwUlFTtcjwxFmGyw4ERgqjTc6QGyLW/zuu2n+yoNioj+/pK+k8vsmXy31V8KxG8GQndHU8RCVutLkdZHLBPFZXnvVQyYa/GNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726246; c=relaxed/simple;
	bh=TeNAqG9zOciolJJDBN5JSjzR4/ZqXo8umpIExwHTF3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YI38rl12vNSNZfld9gSx7s2QQI76VRZ0/7LhhHB2z8TB3waSAgOBGnvAR4bHU6D23LIIAmz4Awh0HxMNkjIyNI9dToCMsJGk+av7104bLbRE70/EM/Un4awRfdUbp3y6rNqlc/c05ctafL/UZGbaKd2dQSQLSjnBryyveAdU6Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCwseab/; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCwseab/"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59584f41f1eso19086eaf.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726243; x=1707331043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LSdBHh8SPhtmGDloKd5oE7NACKoA/1fnSWnziyME8nQ=;
        b=gCwseab/gui3j7S9HX/qjUi3ysUdyBe5kMuF78u3bGmUyTWwrgyJ0WB1JLGYfN07mM
         ecagr5dEUcd76eueowrPLTwp+2FdPvj6xn3C3eLKCoZXxDOHw6Y17dgby5DEezqhhR6C
         LeHYny4VbFJdbnyAN1NpM5t5IaFAYbuXP93WL4t7OY9fcjEPJTFMpogvFCignGLwKbmf
         40Ia3MnfhDz+5AGNE5vmAsisbnlgrhcx8YVJXFldrSOdgWUDaFC5/Remdo3IOV0p5o9E
         bFzxg27b34BdagV7IbyXhI1YuiWRNRSSkQfU31xT5q2kS3rjzPXstLjRhtAcX+8zBtJ9
         xi3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726243; x=1707331043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LSdBHh8SPhtmGDloKd5oE7NACKoA/1fnSWnziyME8nQ=;
        b=GiS2eM5JDWdSkmDp3ot+RBzgmpu0/uKzIlkl2uByQ5nlEuwW89V1AY+prXzX9sDHTU
         VCPfLRHbNec6izoPyLLE65VTK0Xl0UW0RdMUwAk0fHw9JfsveRQT0Mhy24+e301EivSD
         0hNy1euEh/0sd76BmurAioBlG0RrYBMbw7tJVD8OniqCEARYaqxzFy8msVyio+pv3POI
         7nvGNXWUSIcY8G65D4x5geYpoXH1JHLiZW7sDfclInfsc8M4C9ymk+T5UbeAhQTEv27B
         d5nCGTwwwDm7HnZnQvdYYiDmu5gYKPWkTRFsbkAMuln4i8B3CwP1Pwl/SyWf1vGf1L46
         dwUg==
X-Gm-Message-State: AOJu0YyHT/tGqOKdDUu6OjBODQ1KCIRjhM1Rvn8pNPh6B3Fnm0nMivnv
	kTuk1bwgu3PAB/iChJpWkfSeLQx9utE8KGOZt3HoKvIAOBORKGuEm5B1HHqE
X-Google-Smtp-Source: AGHT+IGiFLjBegdrQYs6o7di7nKMtkOHA6Gfg5l8qmJgtyObW9ceZ/ZSs45ySO4eX8ND3Z/dVd30Sg==
X-Received: by 2002:a05:6820:1c96:b0:59a:bf5:a0da with SMTP id ct22-20020a0568201c9600b0059a0bf5a0damr514225oob.0.1706726243429;
        Wed, 31 Jan 2024 10:37:23 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:23 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 04/17] lpfc: Remove D_ID swap log message from trace event logger
Date: Wed, 31 Jan 2024 10:50:59 -0800
Message-Id: <20240131185112.149731-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

D_ID swaps are common during cable swaps in a SAN.  Thus, there's no reason
to log the event at a KERN_ERR level with the trace event logger.

Change the log level to KERN_INFO and the normal LOG_ELS flag.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index b147304b01fa..0bc93f346d90 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -434,7 +434,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		if (nlp_portwwn != 0 &&
 		    nlp_portwwn != wwn_to_u64(sp->portName.u.wwn))
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 					 "0143 PLOGI recv'd from DID: x%x "
 					 "WWPN changed: old %llx new %llx\n",
 					 ndlp->nlp_DID,
-- 
2.38.0

