Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863B2486436
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 09:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586045; cv=none; b=Y4lCtQ+FFiVJ9XWXG6PoFViMXHJRfkgIQIWGLhMDVXNPHp6QP5pbnsfmxwwr5WB4/ONw0zq16BrFXJqPM0Ie2AVnDh8m/aU9eeWlUHzURJLd9oS/SqTGrlkHz6J89a3/ldnsXBjM0XLcbXkoB1Y89ZTmBnexxlA/2ey1ncvyfyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586045; c=relaxed/simple;
	bh=LKlCoviJ12VgG5jnRcP5Hso1CrjmmA02TTiTGOaT5l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV5a0k2IdhTaf5vmusJ+nUbUoKRxgj971nGOyxW67lLOXp2dEkVdXrXlKV9yKuGAzdrpmBX9EiOVFtrP/AtUfAG9eiNUmUnzyKEkZEutBMR2CWITOowSL6V7cpA1jQUNTKaVRHXyDixBBGTHt90+IUymoBXHN7xY0okd7In4FT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D07nw3re; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D07nw3re"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33c24422d4dso3353121eec.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 02:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790586042; x=1791190842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B4As3nxVg8g8B3dLip3XefSLbWFq/mZSzoIcZeIzSfg=;
        b=D07nw3reiH69EjzEim6t0FoUB0kuO8Ntc/ZYaWRhvyG1BEsYBZhtjGN1TzYjMZWxqt
         E6JfKJQ/8UwzkWRsxo5YsjleoHjO9v5ru6FXUKrI83WWKPc34MdKVaqX3BXraObYyK4t
         1qRvdKoRTvkIDHifXQBOoidhe9vBSktiMR3eItJyWcezkuObT03GK+lT/Wbn1z1dlww3
         7zVNImKzDVKL8kpFTK1o3kDTsGzg5U2yOJju+QOjvky7OXBHxAFII03PbV5UM94uXk0o
         +SzE/GJ6npDB26DOUnriQni6S15X6CjvtKf5lzkEgGBgWkVI+dsC02JYyKBZNTtam2CM
         RgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790586042; x=1791190842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B4As3nxVg8g8B3dLip3XefSLbWFq/mZSzoIcZeIzSfg=;
        b=bqa5Kj6BjKQv39gIaACTNHnTH0+TkfWwp4l5NEeavz3DGMU9YZeXB+2/Mf4YXXmwxV
         ca2WfFyGUOsqwnfFxoXaGzMTGzlUyv35i/mB2vRCHusKDBso2mLtEj7iYHzOXRWohB6Q
         7h0fKJDfql2QcgL0B7j2qfzHOwl2r5EyRGwgt4MOSDLUt0+8tGdk7F+YUUoPxCYqnasG
         VjY4Q0UaGW9bqfUPcNcmz2aXKSwwnqQJWk3MMZ5m6NP53O6sq50qtevG1LvzuJSSi571
         6xW+Jl9kU/nmZuLHp0Ot8B8Po8AvwgiwD5Arkqh5Zu6JMXqx9ZuxjIUtxTpTpNvJjU79
         HXKg==
X-Gm-Message-State: AFq9FYKxtL1yvjGtqe4RtPZZMwpcxvkbTXKeU/jR2KyioXfUPmGBSm9K
	WOSixt0ddSjtHiRbbKzbOfvNKN3nBBIOB+3E31TcnNNWu6ohQsgZ/SeX
X-Gm-Gg: AYBFou1oddwDWsN1e/0ztxcKeGvGq0UctZYSHEt8hXN0vPwt3tFgGCCJI+lpctFlo4v
	k8KFAD1f/NR//TmXUCQbehtWz+zOAUTbfznUnlUzI2vHiR5uixCghMWKw5oy7BUzqadPC1mM1ci
	HQ4Q68IoSZRdyssLZ7ul/Mt6BOG4jUNn16CTyCPzQCb6z+NZOh2nGoPynJIAxf6cjDGIVqqfLeW
	lm7wnGpWkIPX9GD5GcLN15XtYVo/9Wg7FotgfKa2VPzscvM6h0T5gSYsbsxLpoFw+ZhbC2800bm
	1/oLVnNRfXFYmhD1g3O2XDVl5lUQYD9RchRSw1tk118IlCtSUWyMkEESDNSezFw/+xfN7JRsW07
	5talCBsIr2iqRENBXpli4ahCL5arf9wWx/MNVNQ2emTPAUua01JWs5pNKorImBux3haAcuqxU2c
	F487aBIyuyAurBdbAnSnKlsTsbMysMgUIF9buhlagAWt3m459Tih6BCDv0DXmgiI+xFy64kUTcU
	76kl2Hkby7T7Hwmn/vxWjGSLTyM
X-Received: by 2002:a05:7300:8250:b0:342:94ae:98f8 with SMTP id 5a478bee46e88-34294ae9cd0mr9071212eec.33.1790586041380;
        Mon, 28 Sep 2026 02:00:41 -0700 (PDT)
Received: from homik.search.charter.net ([2603:8002:ad40:56f0:3430:2ac1:d99f:94d7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144172de6sm43351473eec.9.2026.09.28.02.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 02:00:40 -0700 (PDT)
From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	morbo@google.com,
	kees@kernel.org,
	justinstitt@google.com,
	codemender-patching+linux@google.com,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Subject: [PATCH v2 1/2] scsi: bfa: Use snprintf() in bfa_fcs_fabric_nsymb_init()
Date: Mon, 28 Sep 2026 02:00:29 -0700
Message-ID: <20260928090031.712418-2-nikitash.mariiaw@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
References: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill Wendling <morbo@google.com>

bfa_fcs_fabric_nsymb_init() constructs the node symbolic name using
strscpy() followed by five strlcat() calls and explicit NUL-termination.

In preparation for removing the deprecated strlcat() API[1], replace the
chained string copies with a single snprintf() call.

Link: https://github.com/KSPP/linux/issues/370 [1]
Cc: codemender-patching+linux@google.com
Assisted-by: LLM
Signed-off-by: Bill Wendling <morbo@google.com>
Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
---
 drivers/scsi/bfa/bfa_fcs.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 9b57312f43f5..7a4e0e8c7182 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -821,30 +821,13 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric)
 
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
-	/* Model name/number */
-	strscpy(port_cfg->node_sym_name.symname, model,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->node_sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-	/* Driver Version */
-	strlcat(port_cfg->node_sym_name.symname, (char *)driver_info->version,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->node_sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-	/* Host machine name */
-	strlcat(port_cfg->node_sym_name.symname,
-		driver_info->host_machine_name,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->node_sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-	/* null terminate */
-	port_cfg->node_sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
+	/* Model name/number, Driver Version, Host machine name */
+	snprintf(port_cfg->node_sym_name.symname, BFA_SYMNAME_MAXLEN,
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		 model, (char *)driver_info->version,
+		 driver_info->host_machine_name);
 }
 
 /*
-- 
2.43.0

