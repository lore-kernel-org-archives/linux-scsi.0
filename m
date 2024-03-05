Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410DD12E1C1
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709681688; cv=none; b=pVWYORPFTboZhIyNQW6pLalAZ1QkmwyegkVBkoVNBrELpCCVU4YE8/4qI5KqIILfZdSnDWKO9fnr8VDgw/x8RBf7DwidbURyT2hrJYUMed2ASipmdQ2k+7br/jIrEvTk1ucqdTvBN3DgahiXAwA/ckCTeHZF618q4KyysrveTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709681688; c=relaxed/simple;
	bh=oKHJz8KX639JHaY4FxkGeuRgysM8ixCYP31PDePvR/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B5qB/cPyJB1FSrB3lBPPYydbnH6E+TH3l9EYXoNPpSFsMFG6sxVwmQei8obnh30HRoKbsKS8/Hy4AQN6xzjeOA+i/78AlOWXg2BD8sF8AkpEzu7CQx6R1efJgd1MoiK4xSfvY3NvJ40+nzOXztdGyIZYojXjjmKA78h7xhCA39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ht2ltYkY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ht2ltYkY"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60957b52eecso98514857b3.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709681684; x=1710286484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/Gd0jRGfWXRd5LSFgmnGhf286BOGmU7x4htLcq4bds=;
        b=ht2ltYkYovKDw+rkhfKf8Wo+0OReFa20ICI9kZuXwFDMwVBueoyUI2Co2xDjAT9IYI
         lDc6J1WERayjV/yvNVmXpUSk87eJjeHbTTQYQM2IuRmRqh5cD3DmgEaSLNpzUZ0Zohx3
         94mzdXh9Tnpu2qyEAQJvnTjScRK8M2LbLg0/sT+DkfrsKFn9tnhUvuuBzkXhHZEI5ifV
         /tfgs2mMWdRuoqTbhcQeXrKvn6nFJkPGNPJL3kcIHPgJbU+e42nQAmcTcYfCZNIxrnyV
         8rY5yq8cB8M5gerkAwrXS4tKg2FbeTf1dW9BW/413/2T9IC4K1EoOUrEjsGb5nRTp2Ck
         Jq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709681684; x=1710286484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/Gd0jRGfWXRd5LSFgmnGhf286BOGmU7x4htLcq4bds=;
        b=KHlLOTOnekc95ZdHHGXx+XFVnu3MZDmcMvMnNP4ptFJGCoAaIsUbX8qLcVJffxVEXR
         jQ30oy630mhycOGNEe9QLBx52idMab7YcEEpGoFbNS4p/pg08rrhFtZkELzc6wpsPM82
         wK0SBka4b3hj61sCHWXXUZjjDE1VKzqqZHlqdCwDg6KmEDXZqMnULet0xdGYMpAHH670
         G9J+kMpmqHML6l2uAOTKiPtDH+QQwNPwCuXo1vXhzcNgHkLRHTSYU6JFQ3NJ9Qy5XCUL
         P7Aypcmlpe7XW/ktPySh5mFa1rdEPdqAl2qJHqx87grT0hLW4cuwTKr8qHCdGKp+Mm95
         vdHw==
X-Forwarded-Encrypted: i=1; AJvYcCWWAwo6g8RXkQLbOIcrhShmOT2bwMHaz3QnSfWXaJeaEsgaf9XCYeW3j4LUXa3pfKtU/GMr6FHe44Ru2KyQDRXl+vBEFytm7v/v5Q==
X-Gm-Message-State: AOJu0Yypk35oFlGeqVLYAx3yFFBZoqBx/I3oZKh6jrHdFOT8ZO2RyQKD
	ro5attXfqZ/rBGmrv1RwKoc898o6aw/iDspmNGGvPEjHYc2GZ+2dIitSECsraoQjmafa4hzCChk
	SEaOmksJrNB5pec0phxJ32A==
X-Google-Smtp-Source: AGHT+IGAp9/lowPpevoGgxO6AVRrNKa1EDrxjPg50w1kHJVDcThAxX6KQnG119Aw9qN/A+OBNDlix25FOCb265goww==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a81:7947:0:b0:609:359a:9313 with SMTP
 id u68-20020a817947000000b00609359a9313mr2995157ywc.1.1709681684397; Tue, 05
 Mar 2024 15:34:44 -0800 (PST)
Date: Tue, 05 Mar 2024 23:34:38 +0000
In-Reply-To: <20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-0-5b78a13ff984@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-0-5b78a13ff984@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1709681680; l=2333;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=oKHJz8KX639JHaY4FxkGeuRgysM8ixCYP31PDePvR/I=; b=it20B8oEmrPPFj34tDnAo4Ojh4hPjBzwi2qKfmpt/w+DdvBX6HYJceOYTm/Cy2VY/qxpBA2UD
 lqH/vh4t55GDuJiu/Zvhhq9hXwO+V8wMcpojq7qCbWnxBJHE5ZwhMEb
X-Mailer: b4 0.12.3
Message-ID: <20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-3-5b78a13ff984@google.com>
Subject: [PATCH v3 3/7] scsi: qedf: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>, MPT-FusionLinux.pdl@broadcom.com, 
	netdev@vger.kernel.org, storagedev@microchip.com, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

We expect slowpath_params.name to be NUL-terminated based on its future
usage with other string APIs:

|	static int qed_slowpath_start(struct qed_dev *cdev,
|				      struct qed_slowpath_params *params)
...
|	strscpy(drv_version.name, params->name,
|		MCP_DRV_VER_STR_SIZE - 4);

Moreover, NUL-padding is not necessary as the only use for this slowpath
name parameter is to copy into the drv_version.name field.

Also, let's prefer using strscpy(src, dest, sizeof(src)) in two
instances (one of which is outside of the scsi system but it is trivial
and related to this patch).

We can see the drv_version.name size here:
|	struct qed_mcp_drv_version {
|		u32	version;
|		u8	name[MCP_DRV_VER_STR_SIZE - 4];
|	};

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 2 +-
 drivers/scsi/qedf/qedf_main.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index c278f8893042..d39e198fe8db 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1351,7 +1351,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 				      (params->drv_rev << 8) |
 				      (params->drv_eng);
 		strscpy(drv_version.name, params->name,
-			MCP_DRV_VER_STR_SIZE - 4);
+			sizeof(drv_version.name));
 		rc = qed_mcp_send_drv_version(hwfn, hwfn->p_main_ptt,
 					      &drv_version);
 		if (rc) {
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a58353b7b4e8..fd12439cbaab 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3468,7 +3468,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
 	slowpath_params.drv_rev = QEDF_DRIVER_REV_VER;
 	slowpath_params.drv_eng = QEDF_DRIVER_ENG_VER;
-	strncpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
+	strscpy(slowpath_params.name, "qedf", sizeof(slowpath_params.name));
 	rc = qed_ops->common->slowpath_start(qedf->cdev, &slowpath_params);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");

-- 
2.44.0.278.ge034bb2e1d-goog

