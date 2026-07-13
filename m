Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E51382397
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783924607; cv=none; b=CC+Z6fnWAZW7OBfdfnDvEShd2tcZn9Dmy7PaCI2hw+jrUXjRSTLnOx77uhTmsNi06833/BEvbuRNSyo2MvDaLIikBAxWPoLamQLR11GVG6A1CVy+ECGntPDC1ylAKIISIlqwi5DhrM1STnMVztIa93Lw6tK44GH/0NWyT9YdNQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783924607; c=relaxed/simple;
	bh=tapKB0OdfQ2qsJPh7f83iC6X0lGIx0sRdPmA5A7DH6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IBzswejQ9qDqwlDhV5um5uCmcAVHnMr7GXUM+j8v+cHr/zDqFbDB/TU539C/M26cnlXNeIt3ED/T8p/7o5QvjR3cvUke3MsTHLqiVUDUxPBknH5in8KRhS/7LtbV8IwGXaq5rYtI28FzrgMy6o6zkCAX2S3xLOXdZZpeh8bg3hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QNeL9yHp; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNeL9yHp"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeae350e0aso3242028e87.1
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 23:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783924604; x=1784529404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VMkqWgex1B+1V2DB5qYbUsGcW2IFuOY8YL+iXrC+I8Q=;
        b=QNeL9yHpMbso0RCbt7dMuv+w3a5QirU0Tfhu2zettiw5/dGrICUh8784g6oMVMMdPo
         wA5uP18DZWKkNtjVX2FcXShcHQ94PuBLxWBiZn8crELpHQ3TtnmAO6h4chrKgSoM4Mdc
         QPbMmTzwEjEpQ5zcQNqrUuaA3xk5uzq3/DuOgxk/u//Z7HWv3X7gYKaHtCohDd91hAfL
         KKRJc7oiHWHJWKSI91ojR+/IatwQq6Uyikz4vODKf5MffYAKZ1SeY18LBOoYM/uj76Fv
         LKgDHLl6iRZGMybm60nzGAbGzGrzCFxXN8s/xc1wAaz9R94vmvxo/5S6TFvV6zoy53Uv
         NYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783924604; x=1784529404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VMkqWgex1B+1V2DB5qYbUsGcW2IFuOY8YL+iXrC+I8Q=;
        b=TNi3F5bte/gO3ozi0gIwSAvxG8M+mmyxsdFZbu31OYE3qfOeQDO2E911KKOTXpreN/
         Mt0wSK0Vb9whOQtJrAupqWz8SIM3J1+u32pDQyo5CsusCexM9DFCPz/RBIS3LtcixKoF
         Cq87VafiAprbWAa5XRTDMdCSbphMxQGSueUHp0fPIBkgPAnVHQtqRJ/tON6GOGxwLX+J
         2+QndjE1u/1J3lX4FrcX5+pG3ohH5cZ7CmSPQBOS2CnZA+GQKwtE27wXlGdCTW1ypzUU
         qNxFtjkWwPUe0fS7zvLpjd6P4173isu5AX3R1r5H1WyCdg6eJSd0LfVYm22OZ3kC2Hum
         unGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrWIdomuwJa0DQ0VEqeTmlZIafBBSXsVfgopJ6gdWQls5ixwRWkA9CFttO9p6zhmXW+vV9/HqsSuqn2@vger.kernel.org
X-Gm-Message-State: AOJu0YzRxjoJAa+7uri7RGsuwT2lPB7Cz6r9O2gjhqce4zQRnbR0pk1R
	cVURKEDBlURQLte89P6vwZ4v25Q1E3qpB+vnFrEOr1lyi+n+tQ1fqxA0
X-Gm-Gg: AfdE7cku0KG1YhTCS8pRdAlyRWEJj+dsyOf3V+KDo0xGv+9yldb5bpxZBDt2MV7HPSI
	0vbz+59FQ3eC7CUmB0jCgfgn+rvhblKmRzEX8L1aTgxcHPV/jkSJEGQYFFR5quVaWHTkAhnUNuX
	7s9eIflEbpwkIIglv8j7TvcWho7bgyObd1uI7ELdZ6JWdxDoZ3HQgh1KzzN6Kbauc28XzsvviMk
	jxs13SxUyJVjmvoFW/FuKLvnB19EFaDJW72/leHdZozfLYiFGF8GAFA1cny+PgO3o1ETLR0Vxiv
	b/PjGXqkvfB+iLKs9I0qAtJnXvcilUo5z4QlZmhX1UvrYhu6nx08kumm1y5YFY4WpKO5IZah3lo
	QuEHLHiiimlxNdKIRzbXhcqqgSj7/BBeM/b294YZTmSexiLNWHgOLtHJ/UDvFdzObE+nsbZ/WYh
	pSgKo1JWBgLCGGqOvpzkYG7hR9A2obgnkk34U+ZFWF0UIbEIj58m5MCOQDRXbUn0PO
X-Received: by 2002:a05:6512:12d4:b0:5ae:b764:3ba5 with SMTP id 2adb3069b0e04-5b0236c84f6mr1460633e87.64.1783924603562;
        Sun, 12 Jul 2026 23:36:43 -0700 (PDT)
Received: from SC-WS-02986.corp.sbercloud.ru ([5.18.235.145])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39c84b83a84sm26001371fa.26.2026.07.12.23.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 23:36:42 -0700 (PDT)
From: Aleksey Shishkin <demonaxsh@gmail.com>
To: 
Cc: linux-kernel@ispras.ru,
	Aleksey Shishkin <aishishkin@cloud.ru>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_dh_rdac: fix NULL pointer dereference in error handling
Date: Mon, 13 Jul 2026 09:36:28 +0300
Message-ID: <20260713063640.3081603-1-demonaxsh@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aleksey Shishkin <aishishkin@cloud.ru>

There is a critical logic error in error handling. If get_controller()
fails and returns NULL, the function sets err = SCSI_DH_RES_TEMP_UNAVAIL.
However, immediately after spin_unlock(), the code unconditionally
overwrites err with SCSI_DH_OK.

This causes the kernel to falsely report a successful initialization,
leading to an inevitable Null Pointer Dereference (Kernel Panic) later
when the driver attempts to use the uninitialized h->ctlr.

Fix this by moving the assignment err = SCSI_DH_OK inside the else block
so it is only set when the controller is successfully acquired.

Signed-off-by: Aleksey Shishkin <aishishkin@cloud.ru>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 88c8e36b221e..ed02e1737bd7 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -455,9 +455,9 @@ static int initialize_controller(struct scsi_device *sdev,
 		else {
 			h->sdev = sdev;
 			list_add_rcu(&h->node, &h->ctlr->dh_list);
+			err = SCSI_DH_OK;
 		}
 		spin_unlock(&list_lock);
-		err = SCSI_DH_OK;
 	}
 	return err;
 }
-- 
2.47.3

