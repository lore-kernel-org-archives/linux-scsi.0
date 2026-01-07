Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD282877CD
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 21:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819728; cv=none; b=Jtx3YhGR0csFVTyloowMBkt9FdBSC4GVTOsQchzEo0dZMAMw43Y3E0VETIYMJ/baZFDfaq/HKiu2z04EkQPoGAH7y+gJOJlPCJIyBdnfPs46Kgp2woLpWv6e/NDvOB9TjnSUi6v+K/XfvkdG/8Ws3TJiAdMAY9zlxHYE4r4xSXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819728; c=relaxed/simple;
	bh=dYJiYxc8TDDZEbRixOBxZlJVkZZcmVq1ISxf7Xs2UAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kQg42pg2YSneycECI5dZA4RR3GEhqf5FEgL7NG5X+k6c71NnVcyh0WLgbwGgpZfB2sJ/rxTjvvWtqDkiTH4DAmm8RYvMQSRqHzQjnYdmrxzNBTmICmcG7QBejRkxBcl1gGl+0ZHIJZ9j5CkvwUovE/YLfojMraXMtVV4o1+OIjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOmPxWFA; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOmPxWFA"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-450b5338459so1563220b6e.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 13:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767819726; x=1768424526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9m0TCOaNZ91xSyJqRZyTLI40e0R3ipS6SIhgg8D8jd4=;
        b=AOmPxWFA3+upPZVKqmlPY45HC9kzzQvLNSsDw0XO43R2QToaosJPQd5Ojoro4KTFsn
         vr3B23c0Y8CBOwfnsDeaa7783fz6Au3I5HhwrXHG9wHtCq+gf6BXvSQLvtCurVNwS+AR
         7C25dy4H4v7oX1JDkKKG8ECYt0fZiJQbwj0pbDKyHJqf9+gTacNkU7k0yFCnPOJuEECt
         m4SlhzOKiXRuc5MMGbJ2IKqbZ+JTfrpT/XRTcpYVMUDF5hzQ8DwwP7zK2LH/7dZpCy/f
         zBhuiaIFHoF2gKeNu4tZVPVC8Pakkfl0+yvldKdGDyH2YWbgYnWanav7vuSl9PMjoaw7
         r8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819726; x=1768424526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9m0TCOaNZ91xSyJqRZyTLI40e0R3ipS6SIhgg8D8jd4=;
        b=SeK74Y+lv+kC/qP9MeTp+drhSaRhPCuzZpifS059ucFbLDnoBcI5npCUmE/6ojE32G
         wmso2QM9Mg9e37Wd4d58koyFbElWXgCqRclBidKvOFvI4sgsSz3azI0swKattvOpnVCY
         E9M+x0EUCxpcpEpNzoEub4LCJqtZHYy6fqwBaNz8erQxlqLb04zc2HAAXBuKqlqjM16Y
         AvyBWw0ax1puxYi6s2Ok9g5SIwCZJzM8BYHP2FEenPpKp07UIkMkR3eupbdqeszKGY72
         bAc127UGNIQRnm9PGYAqSmvfPko105Pu4sBXxk8hsZstBKsRjmnz4x+hSYxKSvph86l6
         KPEg==
X-Gm-Message-State: AOJu0YwNzYq0xj+bMR7oCSMyIbsJ8TCc1Bnjj2TzMyqAKKD0GotV0rUK
	EEsvFJ9jRORHErnMIH7L0KN9hGGRfMM3Hnl9/5m7SFJkRG7RHH1QyyWJ
X-Gm-Gg: AY/fxX6FFV60cBJ51iTGDVhXTSD7Y8dQg2WiMa/W4KbzmU/PRu8sSTVBS03GcE0TtY0
	wcB7lhfEMVjpV4FtjGmTW20nhy3RooaJ3nWg3anJBjinY72uKWvRMyuMioSTL/7Ak0Z6+R2rcrb
	wToDgc5UNRq6/n0iE9tcOLg19Oul6MwQ7sSXfvDFJ7LosSF5ezK8xyaSLUEi/zVT2wcOlg3O7eM
	Tt+pddJnlhKCQrcI/7s7FSHCv/tPxLp5qkXm8Zuw7RuT1mbSG71K5jY1jsDfWFMrJOjSBRr3U7r
	Af6jC7CXmsy+bFaOCQuTUfnwzT1je/v5OO0T5c0hyfI+Bt4brlqQv56kV3gyCRsPoPOdRdm+ACa
	kRsQQ6L5urDVpF31HCIcO9rp5paw6cgwslKb75PyVnUKVyGeZbcphIEfiQfbkqln24cDFdTMsr6
	bh0zgbltfkQ3c0N8dgbgECRgvIsFQcSqTM
X-Google-Smtp-Source: AGHT+IH9CIe32A7vpxFuhsj0I+GnQTGQY8+uNKa4Ka1YIPCGIcKQxaoEUSD7QmnzgIM5BmvscSIzLg==
X-Received: by 2002:a05:6808:3c45:b0:450:d504:9281 with SMTP id 5614622812f47-45a6bec55a5mr1899246b6e.59.1767819726241;
        Wed, 07 Jan 2026 13:02:06 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288d5fsm2916695b6e.14.2026.01.07.13.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:02:05 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: tcm_qla2xxx: initialize cmd->offset in tcm_qla2xxx_write_pending
Date: Wed,  7 Jan 2026 21:02:02 +0000
Message-Id: <20260107210202.36203-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the tcm_qla2xxx fabric driver, command structures (struct qla_tgt_cmd)
are often recycled from a command pool to improve performance. Failure
to reset the internal 'offset' member can lead to incorrect DMA offsets
when a command is reused.

Differential analysis shows that while tcm_qla2xxx_queue_data_in and
tcm_qla2xxx_queue_status both explicitly initialize 'cmd->offset = 0'
before passing the command to the lower-level QLA2xxx driver,
tcm_qla2xxx_write_pending fails to do so.

If a recycled command with a stale non-zero offset is passed to
qlt_rdy_to_xfer, it may result in data corruption or IOMMU faults due
to the hardware attempting to transfer data to or from an incorrect
memory offset.

Fix this by explicitly initializing 'cmd->offset' to 0 in
tcm_qla2xxx_write_pending to ensure consistency with other command
queuing paths.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2fff68935338..282689bb6750 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -415,6 +415,7 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 
 	cmd->sg_cnt = se_cmd->t_data_nents;
 	cmd->sg = se_cmd->t_data_sg;
+	cmd->offset = 0;
 
 	cmd->prot_sg_cnt = se_cmd->t_prot_nents;
 	cmd->prot_sg = se_cmd->t_prot_sg;
-- 
2.25.1

