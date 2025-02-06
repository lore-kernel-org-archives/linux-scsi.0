Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7585E157A5C;
	Thu,  6 Feb 2025 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869605; cv=none; b=HcmgrHNc3jTrmqKIZdcXOaIygbHWFrzq3CFCDDhq4MgWxwg4J2Q60lJxwLQH+/GIKSKRwc5+3RS2NgEUO4sX+7UwzaLvMTQfgSbSKkWSD7j+4DeC2mTMu/6pS77Mdx2OsD5/xtSYz6xigNUDVzgTasgSkvXeZlpovHu3pKu5Av4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869605; c=relaxed/simple;
	bh=lpceZ522M3/G2j+23ZqHSKSS/XNc3DjrXYEVrd34Eck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ncpjaXZHfn1ma+kgMPnp4ZzCGYNZOLYGi2RuMyFD6dD91pnXQDdYijp5onNfIuobzvwB29+09wJAEvnR7dr+93Jmbs8Y7XpHabPH8ZgQkI7kZ96sUxpKE7jPQ0ctWyY32oWehRHE0KH1JxgvyM0isP8IbVK5BbOoMZf1BWgpr04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qdp0xjse; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qdp0xjse"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-467a17055e6so16172841cf.3;
        Thu, 06 Feb 2025 11:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738869603; x=1739474403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcrbolGONnkzpsMRrj1p29h31Hv8IReG8unYB/3cb/8=;
        b=Qdp0xjseY0c/IP6lKLHPasAAyAPFWSK1Rah4FxghQHFaQ7UD8lsHeIU+0lBTinmthD
         3Oxe4oRxjPScdlnhXii5FSDWEGVcdEIbaHQPNGK0buhNGz0rxwg/q3ymFioGcINGH4/s
         /tjYawP4IqBriydlLWM6GDAT3BZHA0Nbfs1YCqiXp/gG4YxZpDsekUdEEsWeQxLK8Y3Q
         K02oe5ICPhr9RRq5ftkX268Jk14QLSEhcjGn1nuuYe2reiDcQKnB/lY6zwuOxqdFBipr
         egdXcm0VrLB/fo6TOucZD4PcDGEtwTKH0CLpsxJ8sZokO+rQHki7qPy0pbd0ZBNCah0l
         0JAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738869603; x=1739474403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcrbolGONnkzpsMRrj1p29h31Hv8IReG8unYB/3cb/8=;
        b=Zk1mq7OLOrO/Q32a3/ppPdHN6ywDR8WhR15UOMD4cPuaa5/yjKfO9yTAdX29IAOM6P
         4MzaN1u1iHDh4RN0fMMMJ+r8Ak3b20Vo7bgrlBVU5epYEtkJ8WkgVoBlXsg/pT77uw9s
         PQPFToYk2U1cQS5IRWVpBXX/AualICbpKVQllqkNYxLb34idqYSLUZTNaknwWNBanN/z
         CnKAkFPaHp13785WdE5xxXvLoYeQQnMRamYYJYWut6klTmxC48TrrvScrXfuM33Qa7XA
         UScOcBdr2qxOhQTYny1Gz44CgtQZd3V9qp05+HflYJ4NgU3J19sCDP9yFt9rR1nDHTys
         +xkw==
X-Forwarded-Encrypted: i=1; AJvYcCWhYMVPF9zo/8DVR2ooFLupUMPXANmulyfSGg/oBfvK9hZvcTLkJ26ZI4pFxFkqboGfKbQaOQkVG3fE73s=@vger.kernel.org, AJvYcCWzJJMYG/WDoLdRAQ0CgQX6LhOSNKbyvHpX1Q63rVDgDevQwoRXl6Qrtd16Uwh5LKwnSkCqtjSV@vger.kernel.org, AJvYcCXI0/mpGxXnknNgqxmdFQxI55fkCzrzsyZqpGl54Sm7nzSTKORrdffUFftVod6C5cku7plHn83kYTWTFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAlqlNhLJH/eOn8TEI7EMJ7TpjHjcxYWqm+REACphIpZ8GaceC
	Pzjl59FVjAqDHD14ap0bwtnfmUVbPNUJ2T7CGti9pY8QT14tG2th
X-Gm-Gg: ASbGncsTcdzaWTm6+FKfc2WaL8RQZlh03chUDa4p72Q5aVzyR835jf7MnIjI5OEyr4U
	6vRY86JMYlV1tYMTSALvbgMKkLiXg78SWn62Y2mXlMY0uo3dKWd7oYcK1V+0tb0lX8Fr8VL9YvG
	ysMahPejZ0QGg+tSIyaC7PZjVKPzJ9G3Q5LjwTkMVwB+VbV7A7mQkzcHcMI32kiq2RvMy5k13Bx
	1MwnPsWyCwfUhW1aqjQhe1H3ZBOu7Hsuf9RZIqoPzHrbdi0JwFkwYgdzzgp18vCRAAu69unVtQw
	mAFRFGwT7p8EVElZ1TjeSnnBbkIPsOJeQB4HCA==
X-Google-Smtp-Source: AGHT+IEcRLsPCYAccwqi/4g0hJA3ZEAnkWiTfxeLFqTMx/RVl+ZVNZJLt+NvBYaDZEWcgxWuIHugYA==
X-Received: by 2002:a05:622a:493:b0:46e:2a18:93b4 with SMTP id d75a77b69052e-47167bce490mr5808821cf.33.1738869603185;
        Thu, 06 Feb 2025 11:20:03 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471492763ebsm8159161cf.1.2025.02.06.11.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 11:20:02 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: gregkh@linuxfoundation.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	markus.elfring@web.de,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Thu,  6 Feb 2025 19:19:59 +0000
Message-Id: <20250206192000.17827-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2025020658-backlog-riot-5faf@gregkh>
References: <2025020658-backlog-riot-5faf@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changlog:

v1 -> v2:

1. Replace kzalloc() with kcalloc() to not reintroduce the possibility of multiplication overflow.
---
 drivers/scsi/qedf/qedf_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d52057b97a4f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

