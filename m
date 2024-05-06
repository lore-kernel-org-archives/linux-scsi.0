Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2CA6D1AE;
	Mon,  6 May 2024 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714999134; cv=none; b=XxsNdyjfu9cLnk4DZ18i2Kzb4mL4/O/Ek+WRCVQXiW0VtJL1p07Y8lLw4RB+lR46zdrjx0YE7w3hcL7EKCO17tQpCq8EtjotcIOWi83NiN6YfKCPk4FO+K2FGozzzmfMjObCNMGixeIU8LsQc6C3nBOXm/N0posKZRyvumPFajA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714999134; c=relaxed/simple;
	bh=sPTIC6nV8SFxWIhmUEK7axZd9dNmSKGsvS59vAVuZrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KNUeoIySHPNjOxUTXf4kj6sL9QvjH52gQxmS8wz5DiCl+u83srlz7oOSfXL6zUgpetdyTTedYmbGdNaQol+gIjFgsBgHEQHMR8kx+U2GcJyA1i5riLcERHymINrcPfN8WoO6ISoC0j/MClLeB6TndXLPkCoMcnAxehTf+dL+8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A+W34BYK; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+W34BYK"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f460e05101so989518b3a.1;
        Mon, 06 May 2024 05:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714999133; x=1715603933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogvRpvfHRpVd7OHXkJkp6+RPq3FZxpMxszDa78eRG34=;
        b=A+W34BYK4e7iU9781W65Fb6UoZ1avD8T4E603ZC7J1/a4P/1gbtdVgdddPwjjsqwgG
         B5iWR6jfeWwzbK5maBL0ccMSAE3fW08Vjzaw4IfY9UHj0Sks+EYGJ2yHPFTym1y7/gCf
         3k0wTDAORxvYtLUKalJzp0AqkdfZDxK6us8hWmjVVBAU2iNQuWvkKPRmtDEWXF3V5ptK
         vshgX8hi0D5W3rcjji7Fya2tieO+eLRNovCweesD4mx2Dg57IykvvXQpeMYubARMxcmJ
         o/ieVEQuilhVgPVjEF4WbnYOSxuIkEBWmjVxk4yss3JSN3AMgdj6KnnLog3+XJgPIhIp
         l4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714999133; x=1715603933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogvRpvfHRpVd7OHXkJkp6+RPq3FZxpMxszDa78eRG34=;
        b=VPjNlE8fnXqHw29eYV8DqNRVr4wq/27MGgeDfiNXtANFH0qOHPxvx0vc+iOO//8vsV
         1arDM8EqSr2V0fQ+GUfcKWsAq83UaBHqxLO0YLe9eE3zMt2XaFPbC+D5NTWUv6MZV0J6
         WBZn0Od1z8oRjpezGxOLHw3xv2wtm/mfPbHNIB2r/tLpVFRBIL6GN6/p2gyTD1zuQ/6x
         irg2+K8q2WaemSQzdkdX8/BNc3w4Eqd8yJgKdsFfB0zJvdLtBfFyUHo3BW8m7l4cR2Qk
         UUaoYHvpRAusre8CdhBdC153H02V9bP5rTgh9EoLwPiU4dVo484AP17zUH2oyufjLDOJ
         Nw4w==
X-Forwarded-Encrypted: i=1; AJvYcCU1Ye+4E1CzeRle4RGnGmSAa86/1aD45h4Yo6/d4hffrgOxi1808wzkL1aloAydbErb8b4GOY1m/WOEZPnyLg9WAhYrOALDJjw2iWVSRolvdcDP7jJ2WDEKyvXJOeBQPX2Ra2FR/Tk2xg==
X-Gm-Message-State: AOJu0YzEWvTfzogC1uBmvG7Sli3YGAhGAMXlsk4rVA2fQkSZx8qiMSZM
	H8H3GQitSwHQRrljZsG3NnzdyvTNAMu7ngn3mIoENzQuzSyM8vtu
X-Google-Smtp-Source: AGHT+IEx3fb+7CZAdI2HFwkeSLYJo/LvRwcZTbPcVmho9H+x5RnGiZdks67LuE4ECCLmjLmlv5lePQ==
X-Received: by 2002:a05:6a20:72a0:b0:1af:ab23:82ce with SMTP id o32-20020a056a2072a000b001afab2382cemr6275075pzk.3.1714999132652;
        Mon, 06 May 2024 05:38:52 -0700 (PDT)
Received: from VM-147-239-centos.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id w6-20020a634746000000b005dc4829d0e1sm7940433pgk.85.2024.05.06.05.38.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2024 05:38:52 -0700 (PDT)
From: Yongzhi Liu <hyperlyzcs@gmail.com>
To: skashyap@marvell.com,
	Markus.Elfring@web.de,
	njavali@marvell.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: himanshu.madhani@oracle.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jitxie@tencent.com,
	huntazhang@tencent.com,
	Yongzhi Liu <hyperlyzcs@gmail.com>
Subject: [PATCH V4 1/2] scsi: qla2xxx: Fix double free of fcport in qla24xx_els_dcmd_iocb()
Date: Mon,  6 May 2024 20:38:34 +0800
Message-Id: <20240506123835.17527-2-hyperlyzcs@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20240506123835.17527-1-hyperlyzcs@gmail.com>
References: <230af978-c834-423b-8d42-78c164be40b9@web.de>
 <20240506123835.17527-1-hyperlyzcs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dma_alloc_coherent() or qla2x00_start_sp() returned an error,
the callback function qla2x00_els_dcmd_sp_free in qla2x00_sp_release
called qla2x00_free_fcport() to free "fcport". We shouldn't call
qla2x00_free_fcport() again in the error handling paths, and thus
delete the duplicate qla2x00_free_fcport() calls.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Signed-off-by: Yongzhi Liu <hyperlyzcs@gmail.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0b41e8a06602..faec66bd1951 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.36.1

