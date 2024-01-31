Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E312118634
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726251; cv=none; b=pKh33rVcB6PpMV5PNo/MfNY8KVPLSYd6CuVUC+Cl8D1oDZLqur73Ftg/AIB3cXeaaYCNtgv+WPiR7YF1G/9/YZZH2wcJqWa2vMbD6noPE2cE4mmnIzUrIbnMFPbPALA9LtQHi2WWgmCk2KL7GVr6fskPlEfl/bDqLReC0vzi/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726251; c=relaxed/simple;
	bh=3uN9K4Ly14euOREQO8Y6lyyJQgy+p37EO/Yl5ScpU14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OHb9lZ79dyAMd7Fhc7wpHfexhubZRFuPGU0j8b/3HoBVEENVgMdFD4YsQ6aOrxlnFsHskDr+JN+8nGMUi2TUsu0m9LYIukPvmy7HNLbg4666CNNbHw6wcjzB2Bu9svlgKauvU4Ur9YLiL6g9Y1tVsnCu/l2IcIvbrC6UkGUp3ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbCaFYDs; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbCaFYDs"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7d3029b5e1fso23927241.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726248; x=1707331048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMk2d5ntinQ+7BXRy82249JP296pqt5tzgwd635B3Z4=;
        b=DbCaFYDslUwMOaGJFkTpJHZ8oejXpUW5P+TPo+Ry7HrvXxZqDGiEQdEx1y3Xn91MN5
         Sp6v9RmUTX3rfXSxYsn34EMAd+KQJafRHUPnhkH/GmAUbjFN6V+tNi+3W+q/ml+RcTLl
         F8fO26lJpAFK8+AtFQhxs2aGn0rIp4XGNyu7VVnqVyoCkxFL/uPI6bApXBq6IWWPgznj
         JIrLHWQ+sRvda4AX+tWOnX2mn2DCx4nye7+tpnPYFodlSg54xlfTOGgpRE/pBahyG/a3
         IeRVAe0XAbpejz9M7mBgG7Avx0EDlcoh3sD2k5TPg78jP5LObgNLd/8/DEAdCYRTNWmj
         xioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726248; x=1707331048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMk2d5ntinQ+7BXRy82249JP296pqt5tzgwd635B3Z4=;
        b=el85WK/j1zyncNR8W/8CYBW/ob5pHJ5EJxq0csGoEsZNMN5NTwhIYjZrIWP3vN+mRj
         dJFVuCoE/adT9MRpm3ZmzaKDWM+MYpJFu5aud0ixFYdjbOvThjP4aCb3mc4n1OfF/Pce
         WGOv/y960TnCzCo6awT037yt0Dtv9+e/rn7GhSVkc9bEP2pNEN90ClRztED6+XAqpeSh
         Otrfo5yyQrw4QBweuWJEc+KU8UISJeVHxdsvhDay0vRb+7UMuelKAJLQHrOTrtVphwOn
         gQQVMex3kR7lYpfFrlRbxwTWyAhVfpuEJtak5rbwDoP2abNVi40HluIDpN0sOD4XGFs7
         frig==
X-Gm-Message-State: AOJu0YyIK8AKXZHVhRl1qMoLLwQm7qJVQj/InvWMnakIpz7SVO626Atr
	O3WN9SMGOZd5rWceTfoUqxIK4Od/4SrMgE8pfAjAHnUmcAhc4zBjvqb21TgL
X-Google-Smtp-Source: AGHT+IFElXa1M7Kp+dBnJAnoPQjtB3bTL97224copNY9ZRHCwy54acR8KoiGPlEX45aozXd6fodM1w==
X-Received: by 2002:a05:6122:2704:b0:4b7:3417:b5a4 with SMTP id ej4-20020a056122270400b004b73417b5a4mr429810vkb.1.1706726248405;
        Wed, 31 Jan 2024 10:37:28 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:28 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 07/17] lpfc: Fix failure to delete vports when discovery is in progress
Date: Wed, 31 Jan 2024 10:51:02 -0800
Message-Id: <20240131185112.149731-8-justintee8345@gmail.com>
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

