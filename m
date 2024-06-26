Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA0E176AAA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396875; cv=none; b=W7EFtgJQb0oD5FkxcrCGvqPrfb8ZmCh00lzdcgTvt6ClEkV4uJqXSlo+/WBQEUFi+5cBIMXHxsx+mCR4DG3SLYDpHFTsbnaZ8Uc1kXVkkJSHH6Qb2bASJQZ8v9de1YvPZu/iVp9P39PwHcNhmZDnAlhvpX6LxqlwycvTke73ZCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396875; c=relaxed/simple;
	bh=2wYgW3ZpZSEs5F7pUdRwCkgpyS6Vs4XB9SF5ViilxC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIz289lszfQLFIwcfUJTmfADvXgLYtLCQLjpobIZEEn3hIWnNxGqbef2xdlp/1vMzkMCBo41L+CdfHH4rwcKFfjdnDlvbUZH0aO9R4I56/FlSvBd+UJMah2x8DVrd3NO8fKxTiG0npt4xu7SCTWAFrnyKgH/DiPWR/6QS/bakh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1vZCvfx; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1vZCvfx"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f9b523a15cso3095435ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396874; x=1720001674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0KzABPdBcuNpebTqLJrv15Sl0P8Ui5ihmud7hRVD60=;
        b=N1vZCvfxfdGKNhKKBq1cJVQ4nRENAOh+TJq7F7tOzCf4QO/rYdg/NZHVbYD5qsDHUi
         6zWvTJYvQmcUlh5C2WdL1ZhrPijN9Uu2i2tV2wakr7EyswuSh8ryaJ1xBBBX4Gva9iWT
         7JpJPeztArjTnczO3Y544KPcsZkcxUe/0KKPGHeSJJpfHq4IOsOwAVrwcUCLeeMuoND/
         1/cxKkk4ReVwZBcmGcDNnhHpqj25GkfHsxi9VIOywl8Uw7gu+OoUcSrtiuJxx/+Y0CXP
         /o3Hhttjsx8qARsOc5jaVuwXIIiukwvyN4LVDXZNbHPJo+CuAMbTleldHvNjho5dI5IK
         ZQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396874; x=1720001674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0KzABPdBcuNpebTqLJrv15Sl0P8Ui5ihmud7hRVD60=;
        b=A1+pUYn5UOY4gJfziPZwlVETbjqz2mudYJui6iq1fna5nMGEUCMAGyFvXaNmQRlW7g
         QrWhZZh0f7rBzZAdInoqL/Z5Y2diJEmoboTYNntGFgaSCLzGnEqE1Ru39TsSwiqZSKqP
         71rFMLrwaUpj5q+QJuUOdbrxRwNDftjZDB/Y0gh4DwNF5JIwrc9SFTYZIRveNfU6wNfd
         UKAvV5hUYdNonYCkD4twA+Nl7nYhktBSrVHwSslqEe9otoNpaLcKEUEwB7jJMN+p9iYQ
         bVXJNEWzG3SAtewBQqrU6T7HPGYJquL8HEuUqhZu1MnDg7rhK7KKYO99G/KYnc89jdOt
         R+xA==
X-Gm-Message-State: AOJu0YydgJrzl9ZBfYxWCmAXCWikAUb2rrhjgRi5/rRAbMW6nYAZhUpI
	tmUko81MtXIq2IsK+freQZJNmeKFLPG3VY5nvfB3oqe3I5zbQ5/+xivPKg==
X-Google-Smtp-Source: AGHT+IHfrxIwD8Oy8HZhZ3gFn8L9kABYacTHOLqRSowI/xCq/FKZixm8FnKKl7K54/OsJaaAP8A7iA==
X-Received: by 2002:a17:903:1110:b0:1fa:918e:ec2 with SMTP id d9443c01a7336-1fa918e10f4mr15006905ad.57.1719396873213;
        Wed, 26 Jun 2024 03:14:33 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:32 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 11/14] scsi: qla2xxx: Simplified outstanding commands calculation in qla2x00_alloc_outstanding_cmds and qla24xx_read_fcp_prio_cfg
Date: Wed, 26 Jun 2024 06:13:39 -0400
Message-ID: <20240626101342.1440049-12-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 ++----
 drivers/scsi/qla2xxx/qla_sup.c  | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8377624d76c9..9caaaf25de64 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3999,10 +3999,8 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *ha, struct req_que *req)
 	if (!IS_FWI2_CAPABLE(ha))
 		req->num_outstanding_cmds = DEFAULT_OUTSTANDING_COMMANDS;
 	else {
-		if (ha->cur_fw_xcb_count <= ha->cur_fw_iocb_count)
-			req->num_outstanding_cmds = ha->cur_fw_xcb_count;
-		else
-			req->num_outstanding_cmds = ha->cur_fw_iocb_count;
+		req->num_outstanding_cmds = min(ha->cur_fw_xcb_count,
+						ha->cur_fw_iocb_count);
 	}
 
 	req->outstanding_cmds = kcalloc(req->num_outstanding_cmds,
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c092a6b1ced4..2703408c60e7 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -3625,7 +3625,7 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
 	max_len = FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE;
 
 	ha->isp_ops->read_optrom(vha, &ha->fcp_prio_cfg->entry[0],
-			fcp_prio_addr << 2, (len < max_len ? len : max_len));
+			fcp_prio_addr << 2, min(len, max_len));
 
 	/* revalidate the entire FCP priority config data, including entries */
 	if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 1))
-- 
2.45.1

