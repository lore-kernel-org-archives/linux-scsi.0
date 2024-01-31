Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAEA7FA
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660516; cv=none; b=XZLjrX+uDCnr1v79uQl3z48N3nZXySdAXKJwwbiBhOKKlgZ8HXbOS8ITw9KmDVqMbqOOzdge/biMR6CFvZVjySCPxTzShM3Rx3wgFsfjBWx7BeI5PqH38mSVmr9fHYKu0ezgPAjzmJT9w05VXqkEW4zW/CA/te4GWvRxBhbrlkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660516; c=relaxed/simple;
	bh=3uN9K4Ly14euOREQO8Y6lyyJQgy+p37EO/Yl5ScpU14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LF4PbUTnutOGQTkUhBn4TIGbzN2iYstGreKtEspGwb0ZyABGq8NuU+frtH8A5gqZ6TR1OhVNg/WVxa/56vmpKueNWU6yuIqXSZi0REu6IaqdJGJGrXFnBMfYE7Py710Ef21QClRtZf7tB88n928PSy7nL89uGeEgkMCZCCf58rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFou0Hwy; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFou0Hwy"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7d3216781c5so495104241.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660511; x=1707265311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMk2d5ntinQ+7BXRy82249JP296pqt5tzgwd635B3Z4=;
        b=CFou0Hwy3/jcn5+vIGqvgpLORNe4bUUyS/Ze9wXJ4FGKjSncyM09uO/Lw/DHeIBRAs
         u2EK3mPL3nLa/v9zt8EVU/MUKLluuLShHHUc/+XJ18lGpQJZ1yDdHMyEvGoivdv9jvgr
         HqaSKEFpxJMY21XMFFmSoNNoDUDH86PS03jbt9iQrdl614thQIPwkc6zBPl6ethXJhL2
         XbPr6J/VdNtky81nMoPc0tKuP9tDpLWl9VHs4++yS2VI0B4iV/XoDyu4grwKwBP4grXM
         etGBFTYT9Ri64AlymNNxbRlENXnSZMioEjTyf5cTBlhU+oIVRkBxV9PY4LbkgxYL8Z2j
         FZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660511; x=1707265311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMk2d5ntinQ+7BXRy82249JP296pqt5tzgwd635B3Z4=;
        b=E0e0f47r2B1xlR15wXEfe23FgzlHSgcmvsMAm4DEWDt+WMhpIuM7rgeJAir8GOfTxv
         HfcAo7WW7QF5rGEKi54cOL/5Y7zRiQYaI8EZPIEwPFmi1S4VcUYfNHym86e3okIqLaf2
         nE3xhlsCkE7YJ4QR5I+SkND/84R2fCTFQ2TgXMRYUXgJ0DjyEuFpwZHAVXt0ZSvBWfUS
         1nzqybxdwCTDVXQE7mpwHkBxBIXYsZ3oI2N1gpTQ1kRK1MIJSFbnDsFZztjTY57MULYq
         ASNtN/rvTQTrZMS0IC06MAXvkqris5XKTj4nL45+csmSCMaAsS8xfEWAyaGh5dHux/8h
         wh4Q==
X-Gm-Message-State: AOJu0YwDE3YWzYFy5gnPCBHlPpzFHqwJBzqB2Jv4Q/0sqhtpgVVIoqB0
	NcPrt26FrptNHdiKsQ4kE76LFJvKSDfzEjQTtuqrwk+sDeyEMyPtKIwmBDan
X-Google-Smtp-Source: AGHT+IEhD4V7w1/2TDYgVJWiYgKqHiUJdvkXJ11ORE/5p3La7TytGeCDU8E5N6SFGO8CM5Knb7q0ZA==
X-Received: by 2002:a05:6102:54a9:b0:46c:a882:cd12 with SMTP id bk41-20020a05610254a900b0046ca882cd12mr979476vsb.3.1706660511677;
        Tue, 30 Jan 2024 16:21:51 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:51 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/17] lpfc: Fix failure to delete vports when discovery is in progress
Date: Tue, 30 Jan 2024 16:35:39 -0800
Message-Id: <20240131003549.147784-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requests to delete an NPIV port may fail repeatedly if the initial request
is received during discovery.

If the FC_UNLOADING load_flag is set, then skip CT response processing for
the physical port.  This allows discovery processing for other lpfc_vport
objects to reach their cmpl routines before deleting the vport.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index baae1f8279e0..315db836404a 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -943,8 +943,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	/* Don't bother processing response if vport is being torn down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	/* Skip processing response on pport if unloading */
+	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
 		goto out;
@@ -1166,8 +1166,8 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	/* Don't bother processing response if vport is being torn down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	/* Skip processing response on pport if unloading */
+	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
 		goto out;
-- 
2.38.0

