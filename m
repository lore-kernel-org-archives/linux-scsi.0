Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA631C2DB3
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182590; cv=none; b=podiKuNOEIWd1fsrpAjR/iVeYDy03GCEun/jmA3NWnOTTmtNkTYgNF432Q+L4I7dfXkQipuDKICKOHNvH6gigMzSFABnj4dqUZaelV6EVJTlTpvLi4w7a+3ncvCnw/G3SAAafqIiefB4RoUJNa0WUKb4TCoV5l1gK0h5/9IXmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182590; c=relaxed/simple;
	bh=eXe94lKSbb33PXcCA0Zs6k17S5oE5UEvJN0Jc9wihrk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l3S9yTqrOJo5XjzE7yeJgS+V482EUCJuJJC6J36+rK234CJ2of8pmDBRi4fguFgm5SimjhcgXvsfIIFfkcfmcwGEshgI5FM3h7ZP0BctNcv3Qk6Yu4mbqv6nfE9QWnhddkbiBUarn78DDVE10NTd2m08XNhdAa2m+NrLn6cBFrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jv5zvXTs; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jv5zvXTs"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6c359c1a2fdso2704016d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182588; x=1726787388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzHkg5HGSM9ZPkC9++flHbBVNqPTP3EQyCjPGTTDhpc=;
        b=jv5zvXTsU7zrSEBApd01ulmQ5P5iXffe3omvm7A7SJdPFwF+FWdz6iXk3ve0AVTkz+
         j8+Oi9iuU2Rq3J27lEpEn4c+0D95iBYD9DhUJDMmtLtiWQgEdMhE8fiyACcpbRh2ehpf
         tQJMMDfmoyNKHTaG4kS6t1KKO7jDRRLK3valRjP9ZXaJOPFYuRZvTzuSVFrC45wa69dz
         PKC4BVSitzBVAYrj70LWQBGUMR1SxRSl2N59t/PUvAzUQOt1cNc4uD6yXWI/V5YzVm56
         UzV6FzcsQ/jQjKf6AhqPWUWyqanYltXjVNYT3VctpavSlblbktcu8oSgRQ1mkdXSbHCN
         TlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182588; x=1726787388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzHkg5HGSM9ZPkC9++flHbBVNqPTP3EQyCjPGTTDhpc=;
        b=bbVsh+aQNTR6LigCWAaF/hvqZOUo9TwumY8Cg8lJ0htRmpxU54CD+itARjeTQe0a7E
         P/fEjSqTfbhkwcybDAm0dNaISix3DmCWH2GkyfIR6/C6wNjLAtMykz4J5Zoy1nHWokQJ
         P7xwc/6KqRVno0nm1KQT5pmJ2BDFY9z/cGoGL+fZsU1SYCo2IzWhoqTfQg8ZlIk8a0UQ
         imBCSIn8VNvvLyClkryr1ldG6nqQRNmznhR78EQsH29DdVMdXwaITs6xls11g0oVIEs9
         /8DqsKntCW0eaVy9dGFfgr7so8gqRCn7irU/NtoRbFcnA8+Hj0gJLWAchyFactnRJ3W0
         qDFg==
X-Gm-Message-State: AOJu0Yxeu+p+jyiXG6E6wl+CdqIg0XhS/mYjkGmDfYn4mCKDAbPInv3C
	IltNE0mUNZMInBprxGhq/GDre4ZwJzvL+aXnv1TxMaoC9xxyDalQKJ63Ow==
X-Google-Smtp-Source: AGHT+IHHuZVN86QLXUHKaNIGkt9zJDUQibwyU6PFlh1PTeJYvu3ivq3Of0BB2gGfgJKdLCyoIbtOHQ==
X-Received: by 2002:a05:6214:3383:b0:6c3:68d0:350d with SMTP id 6a1803df08f44-6c57df2134bmr13767256d6.14.1726182588008;
        Thu, 12 Sep 2024 16:09:48 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.09.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:09:47 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/8] lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd
Date: Thu, 12 Sep 2024 16:24:40 -0700
Message-Id: <20240912232447.45607-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During HBA stress testing, a spam of received PLOGIs exposes a resource
recovery bug causing leakage of lpfc_sqlq entries from the global
phba->sli4_hba.lpfc_els_sgl_list.

The issue is in lpfc_els_flush_cmd, where the driver attempts to recover
outstanding els sgls when walking the txcmplq.  Only CMD_ELS_REQUEST64_CRs
and CMD_GEN_REQUEST64_CRs are added to the abort and cancel lists.  A check
for CMD_XMIT_ELS_RSP64_WQE is missing in order to recover LS_ACC usages of
the phba->sli4_hba.lpfc_els_sgl_list too.

Fix by adding CMD_XMIT_ELS_RSP64_WQE as part of the txcmplq walk when
adding WQEs to the abort and cancel list in lpfc_els_flush_cmd.  Also,
update naming convention from CRs to WQEs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index de0ec945d2f1..7219b1ada1ea 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9658,11 +9658,12 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED && !mbx_tmo_err)
 			continue;
 
-		/* On the ELS ring we can have ELS_REQUESTs or
-		 * GEN_REQUESTs waiting for a response.
+		/* On the ELS ring we can have ELS_REQUESTs, ELS_RSPs,
+		 * or GEN_REQUESTs waiting for a CQE response.
 		 */
 		ulp_command = get_job_cmnd(phba, piocb);
-		if (ulp_command == CMD_ELS_REQUEST64_CR) {
+		if (ulp_command == CMD_ELS_REQUEST64_WQE ||
+		    ulp_command == CMD_XMIT_ELS_RSP64_WQE) {
 			list_add_tail(&piocb->dlist, &abort_list);
 
 			/* If the link is down when flushing ELS commands
-- 
2.38.0

