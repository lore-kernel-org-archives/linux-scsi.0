Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4A1CF5E2
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412936; cv=none; b=bSBnkZREYjMp3+j+d5HgHFA3DMaTc0jEkkmw/gzZ5IU5qUx5pQlNA2owumQIsNGdqFwJgsczw/iQpTHtCQUkysBtrZ0tfSH1D4yIYFEjpacyVSfmQSdvsDi9Ej0d4wQnrQRvz0S3tLZfEyOyJAV1jt8To2mAHxc04MCk3/VKrKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412936; c=relaxed/simple;
	bh=jD8NM65MV9tYhIr3zTcbAcSSQayphzYsGdrcFUjVPaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FvfGB/Py6uDPQk8dFEbDNgpK0YfeTwzXCPwMd10QVHhv39cAChT8+r1D2EYNv3rAZNPwKiugjcvWwoWST1uuE0SmDbBVhsV5+5uPRj15TLbAsZo3YAD+5eXxxntEyU+eBBo8weQyDUl64Cbu4zhdEN5wp2bHwvq3DlK+U+8HYyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6Y4or96; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6Y4or96"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e30116efc9so1106176a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412930; x=1731017730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ytuu5RbK4SkZo/p9wH9OWvyEemDAgnsoNI8wvwA1Yk=;
        b=k6Y4or96JO49vkQeQgQ7xJPSd7wQ69QLUqwjqKmLn9X+ZqarytZyLlyZ+f5GZum/9z
         4cA9r39CYzo1uDJUR7Ewrj/cz8F/xI5nCr/WQ6uGqi7wfWBHbeNW8wCK1gVLs1PExfOM
         Bx4A0ZtHj07ahQYE0/cjM+cqoY9OsQYJgQ1iHkfBLo9vgpyUumg0n21NmJNbSKRx8fDk
         uwzmCz/tSUqOBkx8z+z9AuzRQbzvT5rLLotaSWR71LZYj4xs1qCkKBF7O8oXKfvg4hb7
         2wpHtoU4SUwv4im4qy2Zlo5ywl9Lv1g/3u/l9ja0qM4MjV6an9HXc70k79xEtdSw7aEa
         Li0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412930; x=1731017730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ytuu5RbK4SkZo/p9wH9OWvyEemDAgnsoNI8wvwA1Yk=;
        b=LyEXU5fXeEQo6JF3tRjYyLcrOVbv5cO6Jgrk9RkT2DPbuPwmapY6A8dTlJ+kVpvF9U
         ZInVLXoX2x2j/Mcj/M3wyvdfyu+d4HjLsOqrVhW9dUpUSeuTDg5ZbJiTnti2HWPA5vut
         NresNHghYeJNbDYzxzv1a4Q0isH4YNyTNd1B0NrIXDojT5xUXCyRpR3iFkgm72OQr7Jd
         cw3EMXqWksFLZ1rouYHDtXl0DwWNG7zv8xC9S4D+XppbBOxw0tH/um1jU+3x480hNZB9
         JkylKZN37xbxHKkloP97IdQyqO0GtBKaNbdAS0/3EmVtRutsRhbOGocoM5c23l6NC6iu
         y8+w==
X-Gm-Message-State: AOJu0YwAFhdkIli0XM0QCiEIIqYThbawOqG4Zq1YxQihiQO4pqOjSMNV
	kRomfjclp6co0Sqq6BxbNlrhMeUSYqbEKffJTpbMnYamg8QjXRrQvr6TgA==
X-Google-Smtp-Source: AGHT+IE+kmIIgjBsqqA7w0AccOx5vKoRVvV7ovkv6YwuQtN6cStMGWr+PpCeL/LmU8hvLJ29JxKSJQ==
X-Received: by 2002:a17:90b:4c86:b0:2e2:c40c:6e8e with SMTP id 98e67ed59e1d1-2e8f11b961fmr23013769a91.34.1730412929988;
        Thu, 31 Oct 2024 15:15:29 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:29 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/11] lpfc: Update lpfc_els_flush_cmd to check for SLI_ACTIVE before BSG flag
Date: Thu, 31 Oct 2024 15:32:12 -0700
Message-Id: <20241031223219.152342-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During firmware errata events, the lpfc_els_flush_cmd routine is
responsible for the clean up of outstanding ELS and CT command submissions.
Thus, move the LPFC_SLI_ACTIVE flag check into the txcmplq list walk and
mark a piocb object for canceling if determined the HBA is not active.
Clean up should be regardless of application or driver layer origin.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d737b897ddd8..3d965c0fd0c6 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1236,9 +1236,9 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"6445 ELS completes after LINK_DOWN: "
-			" Status %x/%x cmd x%x flg x%x\n",
+			" Status %x/%x cmd x%x flg x%x iotag x%x\n",
 			ulp_status, ulp_word4, cmd,
-			cmdiocb->cmd_flag);
+			cmdiocb->cmd_flag, cmdiocb->iotag);
 
 	if (cmdiocb->cmd_flag & LPFC_IO_FABRIC) {
 		cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
@@ -9642,14 +9642,24 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	mbx_tmo_err = test_bit(MBX_TMO_ERR, &phba->bit_flags);
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
-		if (piocb->cmd_flag & LPFC_IO_LIBDFC && !mbx_tmo_err)
-			continue;
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "2243 iotag = 0x%x cmd_flag = 0x%x "
+				 "ulp_command = 0x%x this_vport %x "
+				 "sli_flag = 0x%x\n",
+				 piocb->iotag, piocb->cmd_flag,
+				 get_job_cmnd(phba, piocb),
+				 (piocb->vport == vport),
+				 phba->sli.sli_flag);
 
 		if (piocb->vport != vport)
 			continue;
 
-		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED && !mbx_tmo_err)
-			continue;
+		if ((phba->sli.sli_flag & LPFC_SLI_ACTIVE) && !mbx_tmo_err) {
+			if (piocb->cmd_flag & LPFC_IO_LIBDFC)
+				continue;
+			if (piocb->cmd_flag & LPFC_DRIVER_ABORTED)
+				continue;
+		}
 
 		/* On the ELS ring we can have ELS_REQUESTs, ELS_RSPs,
 		 * or GEN_REQUESTs waiting for a CQE response.
-- 
2.38.0

