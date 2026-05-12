Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061C023EA84
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 01:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778548266; cv=none; b=XUSijgBGubcOnromuyM2s2B1RuXS3j0WueLfE1sr/Ryk8Mo4UphV3tPKqZC9jOqr8DT+aBWebkDjIbZZfbVpo0iM7TWWOk+KNXO9rprIwBPoyl73K8B620ZnljqrBRQ/gK/EzFE53Lq6VU/WDGbqCHnS1FA2zHPdYxbeKJcvX0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778548266; c=relaxed/simple;
	bh=mWcCfhFVZdMSk7hgl7IU/C8CT04KrAi09FJiS0JXTZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lat2UfuhVLCGdRFq5USDsDxnjaWNB7w+qxZlPd1DpZuDRYium5LR4Ano1wCdFBrhk4wFIGxEzZBg/77eWEzGH1d5Th8Qo9/4D3812KaZhoPhbCY5r2xA1sWTlrnr2Fg78j3S+8mYGhzgYoACJl7TwPTn2hTiW/ztBuFFhLmXbR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UqTjfYrT; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqTjfYrT"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c80227c9572so2209019a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 18:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778548264; x=1779153064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PzneIhsJ+GqLAUgHEm1t+tJA3syS+ySdYEZpRXAWIxM=;
        b=UqTjfYrT2vhqyIrGpD9HF3NtRypT9jeflVetRpD7Zt5FXZZK6IbJQMb2+Tn9+EX6o4
         TnstHjft/EIEnhzT/RmrERI5JW6gQBmlx2jUBbSDwWw4tQY+dBbSb6QsQdst+XlVapYQ
         KvUpits3ghs15Tj8v6kxtsQnIRwVtVj4kDX93jh5Fp3EiyUi7MnCWxKG3Vl2j0G/ifkG
         bGcNBMaKWQ6F1Br7RpVTvIn4pDuR5y/BHghO/ueYv8O6AopxuzHy8aPJh286b6RMPM+/
         uoHeoaxzVwzX6bzr8Fa36hpTJtZFgKnEDYTi/8twFyihUwL51CmsB96CRpJ9QQ4/jC5E
         hVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778548264; x=1779153064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzneIhsJ+GqLAUgHEm1t+tJA3syS+ySdYEZpRXAWIxM=;
        b=KtB7dObPSXz01ukbdvBWfvvOoUMyC+Py3xUnR9LWOjqGO9t+67+YZxFjY9Yi/Brbh/
         xcuqxVcBBMb1UNUIIfsJdEOwwxjEoU9pnQb0fTLs5fRfQAQl0jbkscXVMboa5Oo3hAYt
         is8BKav4CxgrXt8FWRwi+i2tk/MI4QxO1SltMItVZEJ/v/j5Wwv6sG2knbG6c7+5DxPz
         sasALLy/3zP+IijtuXcfHiP9CCcuJPuStXxsEydF7XKdm3wx8m0dzsVJaCZFmyWYO2op
         XJbukehqgybKyVaVKpVhWDIqXAe6bEQnkt+fTz69w9RbcUrBJiWdMY4YtN3RJueExe8W
         6h1A==
X-Gm-Message-State: AOJu0YwBxpu7pZlb/faweZJRPYCPJxtD2f5RU2CtFq13jIqKg2eZpAC9
	9IsvlP53GNUD6/pTrGFwHfFcgxrzX0EFrcezRorAL0+cz1DXjyFOSTiXsp5hAsGZ
X-Gm-Gg: Acq92OGOwn6HgfBo0TYZK8LgrW5USNEX+FwWedjH9XgeMbXdf78plFPsUQSh0JybLax
	scYKgt5V9Zb14pnQNo4ytF6I9vud//+xE1sw1ut2IRqU0q4WIPBYeBZaERlVXpX+NbPtQAZd4ah
	5bzJ7F6lIzSxQ/BMSd+91YImO/ql3KKpDvFXtmsGap/dfuAa149+i46ArFQV6/VEQlsWtiVz2Xi
	steZF3+vdKsGTNBUSHZ6hQJU5zUK3QqOxz6ZDd+zldgoIeugMq/XtyLnLcC03cjd3u5w9NscBli
	eINqbikx/UqPrZfcQfRfVJxTso8SbRa16ajwkK2Vi4VLv8hHFqZQqUadP9W6zIc1YpDLdl6hn+r
	HQaooJRVMDm1wEOwT7lc3teP+Mq2iCl5tOb4oLvNCGz0lnxcuoHJnxndGcrptef0qGiSzapgETr
	GWVstLt7gqU4515Om8/VYRpa5UDxrI6Bsy41EX1/2zDCR0sqUI2fGROvxkyBao8dpHBfMxwXbpq
	+uznhMKZA+u3DecrBM6SooLDZ10XqV3R5w=
X-Received: by 2002:a05:6a21:32a6:b0:3a2:e0d3:37d1 with SMTP id adf61e73a8af0-3aa5aa7857emr29011585637.41.1778548263838;
        Mon, 11 May 2026 18:11:03 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c80e7sm26497848b3a.31.2026.05.11.18.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 18:11:03 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: qla2xxx: Use flexible array for qpair hints
Date: Mon, 11 May 2026 18:10:46 -0700
Message-ID: <20260512011046.41368-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the qpair hints as trailing storage in struct qla_tgt instead of
allocating and freeing them separately.

This keeps the hints tied to the target allocation and simplifies the
error and release paths.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 +-----------
 drivers/scsi/qla2xxx/qla_target.h |  2 +-
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e47da45e93a0..8acbd45f96dc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1590,7 +1590,6 @@ static void qlt_release(struct qla_tgt *tgt)
 			h->qpair = NULL;
 		}
 	}
-	kfree(tgt->qphints);
 	mutex_lock(&qla_tgt_mutex);
 	list_del(&vha->vha_tgt.qla_tgt->tgt_list_entry);
 	mutex_unlock(&qla_tgt_mutex);
@@ -7458,26 +7457,17 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 
 	BUG_ON(base_vha->vha_tgt.qla_tgt != NULL);
 
-	tgt = kzalloc_obj(struct qla_tgt);
+	tgt = kzalloc_flex(*tgt, qphints, ha->max_qpairs + 1);
 	if (!tgt) {
 		ql_dbg(ql_dbg_tgt, base_vha, 0xe066,
 		    "Unable to allocate struct qla_tgt\n");
 		return -ENOMEM;
 	}
 
-	tgt->qphints = kzalloc_objs(struct qla_qpair_hint, ha->max_qpairs + 1);
-	if (!tgt->qphints) {
-		kfree(tgt);
-		ql_log(ql_log_warn, base_vha, 0x0197,
-		    "Unable to allocate qpair hints.\n");
-		return -ENOMEM;
-	}
-
 	qla2xxx_driver_template.supported_mode |= MODE_TARGET;
 
 	rc = btree_init64(&tgt->lun_qpair_map);
 	if (rc) {
-		kfree(tgt->qphints);
 		kfree(tgt);
 		ql_log(ql_log_info, base_vha, 0x0198,
 			"Unable to initialize lun_qpair_map btree\n");
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 61072fb41b29..575c10269a67 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -794,7 +794,6 @@ struct qla_tgt {
 	struct scsi_qla_host *vha;
 	struct qla_hw_data *ha;
 	struct btree_head64 lun_qpair_map;
-	struct qla_qpair_hint *qphints;
 	/*
 	 * To sync between IRQ handlers and qlt_target_release(). Needed,
 	 * because req_pkt() can drop/reaquire HW lock inside. Protected by
@@ -834,6 +833,7 @@ struct qla_tgt {
 	atomic_t tgt_global_resets_count;
 
 	struct list_head tgt_list_entry;
+	struct qla_qpair_hint qphints[];
 };
 
 struct qla_tgt_sess_op {
-- 
2.54.0

