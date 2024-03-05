Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312C45C607
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668150; cv=none; b=WieHUqJknhm1+ifHrHO+ly7fOrmqGt0l3ozB4W7YiGm/gEExaRrbnE+gyKZBaBka6V3QiWKZjATWEIa/Oxwn/CXF1Sc2Yezxxc1U6/cAD05bzXRFHUpIDQ90KpYzPmb8i6dM++HPMaNMMG1m/OVZduP1naWwPZOrppg269vJLf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668150; c=relaxed/simple;
	bh=GLFEQgE+JWw38+5XkSoZ2TdrYTWeO6y63BuaXydgmZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U0P8cUUCLLtxUxgPpJtzRjO5a/82g2OSMv9S0AIzeYGzCtaS3XCUtcv1ujEhrnfgO2yvL3JOWhXg0WoIBY80i7zk+0/Aay0/xL/o+oFUuVUa5zBO8Za5cBvmeOMGvWfXY+llDcD5NGqVpBp0XjK248UyDqWe/6A/IfgpyEKhbOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZPahEOKm; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPahEOKm"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5a13ecfb6b8so207921eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668148; x=1710272948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mAgFthZgucsTp/Ggl0Ae96uDLL2cRRODY9YYTDhP9A=;
        b=ZPahEOKmkTqWLsysHVW8AOrnPkMVKOLjIssXe2Eh5NhDScEiGvKPf4LeaMD5i35i0c
         YM3bpl9FLX3EN1/OxYwpwu2krGd7klUxE7Uf2nW29spe4U4WSQ4UWl/DgXcpZlKlO8op
         ICTLIcKorU9GHUnMyBJp+oUYhTHVJLno8nHO9nZzkuCqZye+QcFlmqrjeFDMjOTUi7WW
         pYFab0HX2c35xmcMXNKAzg9jnKz4c4I3se0s9pOQOFpilUFQS1fOmGyZit/IFYx7H4oD
         Gyaz0U3S8hfa0cKRkLiSOBMT1mrXte7+ew/bALckD52BFH4SOHJqj8hXF9vkBUtE2zAn
         eh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668148; x=1710272948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mAgFthZgucsTp/Ggl0Ae96uDLL2cRRODY9YYTDhP9A=;
        b=MZIK5DqmwkmB7p4aGFQV/w42ICzZUZ52NU85UZH4EBGld12y8aTtE+Ro/0janXLlIm
         IjdRMP8+orgE0VL3KvU9+IU96oEqZXk40LcwXtHDNyROyYYS9Nt2PpmIUfCbdhx/U5bF
         BzKCCf1+RqrmSDCae9lQXvDqs7i9418JXAa09AkW+rKTYvt/HRed9Ffz+lNLFq7DzTZx
         0U+mIlm3wTv2mJ5ESoFapZOvnu9QYH6coz67PgDbH6RVze24NCted+nw0ng5ZkqIRa/5
         rjSmT5UN/7C0ts4WyHvKXsAou3+XGBj9sJeuN9MQ81ZDu5yK8OyM+7EEKlONnBlWWbCC
         tV5g==
X-Gm-Message-State: AOJu0YxQAKsVbABcRCwMND2dK84rcH1UiJgLEY90n4bx5XaabZwyEocC
	opNf35nwDNvdivUC1QAOXGMx2dMjDi7H4P9chQfX7znHjuFzw39ZDZFD6K3G
X-Google-Smtp-Source: AGHT+IH1BbPZtAn01hEsEZ1GBCDqK4BhG/l6He8YbzKg54Aard+QwkKSo+0nGE6xerQ2rcu0eHwwhQ==
X-Received: by 2002:a05:6358:5926:b0:178:9f1d:65e4 with SMTP id g38-20020a056358592600b001789f1d65e4mr1767081rwf.3.1709668148029;
        Tue, 05 Mar 2024 11:49:08 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:07 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/12] lpfc: Move NPIV's transport unregistration to after resource clean up
Date: Tue,  5 Mar 2024 12:04:53 -0800
Message-Id: <20240305200503.57317-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are cases after NPIV deletion where the fabric switch still believes
the NPIV is logged into the fabric.  This occurs when a vport is
unregistered before the Remove All DA_ID CT and LOGO ELS are sent to the
fabric.

Currently fc_remove_host, which calls dev_loss_tmo for all D_IDs including
the fabric D_ID, removes the last ndlp reference and frees the ndlp rport
object.  This sometimes causes the race condition where the final DA_ID and
LOGO are skipped from being sent to the fabric switch.

Fix by moving the fc_remove_host and scsi_remove_host calls after DA_ID and
LOGO are sent.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 0f79840b9498..9850080ee33d 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -674,10 +674,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	lpfc_free_sysfs_attr(vport);
 	lpfc_debugfs_terminate(vport);
 
-	/* Remove FC host to break driver binding. */
-	fc_remove_host(shost);
-	scsi_remove_host(shost);
-
 	/* Send the DA_ID and Fabric LOGO to cleanup Nameserver entries. */
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp)
@@ -721,6 +717,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 skip_logo:
 
+	/* Remove FC host to break driver binding. */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+
 	lpfc_cleanup(vport);
 
 	/* Remove scsi host now.  The nodes are cleaned up. */
-- 
2.38.0

