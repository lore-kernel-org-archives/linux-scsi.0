Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416A6CDD6
	for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 22:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406683; cv=none; b=ObgmrX/jkZWxcz2hww3hoIQVm9pZlcSQlqABpZZzuX1i/hgj4ezimnC7CDekpzjvoMLuXTN+0SqaSGfl/Is/mBogfLuCNcUc7aH6OPyxT3TjkJnyoDIdNmgPN+c6BqWPpfhA8m99xLvdP2gcBSNZzPWNI8h3jmVUhbt4vbXW+08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406683; c=relaxed/simple;
	bh=C42VOmOpF5DtmWIfORUCeHxL+xyabRJclh9/scaMvNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n96eqNQccdgMJrtaUxcrMXB9py7bDvXvbIiOCrwBd8yCYn9NuhQFI31xdZWsS6rdsP9fdSoYo9W+sQEvE3Bmp7cURVq2qLFTJzKFmree7qeyzIMuy6UGPRzdvGSv8OMNQHFIePmTa57Vc1B0kDIqp59u4MM/wiCKgBqZzDPSIos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dff837d674so38380645ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 15:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711406681; x=1712011481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bAnksngLgDYikyjJU6IiEAf/l5KFWT3Dlq0yGeFDO2A=;
        b=jaFWC+POKWU9PAK7Chpp47L/VHPWPBM0okbBJk+c90uRZtMwxqf8Ibf8O3qBeTOpLx
         nbO7VLOqsH1bjIoQVN3visL7ZMfbKftdqaGvkc76MJ3DX50RPL8WaYuikGu/p7nTUAq1
         e+qiykHf4QSy/Orhm5owEXFJjSFYJcT9ORMJcs5zUCpp8fyruTq1PNnjRjvO64399rBs
         bDcTqVmOIotGWzbtwfdqMSAXea2NOCDb13BIKK7eyVjiATDYc1wFcyejUC4JnSx8gCrt
         CMjpLE/s4gEd/k7Xv4TgFRR8mWgHiU+NZoPHy3+4Y4n9eSBWMId4A5Yp3/aUoF5ZOgwk
         11Zg==
X-Gm-Message-State: AOJu0YwtYm++PKTd2B+zQG8KXO3wk6EBJlJhkfUxH/HosGkqVj4Wq5BV
	HhK5vrwz8JEuaLWF5TmYkSXzB39h+FCYd28LmH36J9+kc1Jkw7iv
X-Google-Smtp-Source: AGHT+IEdoIHVuODXhitHTPSFdOJHwvzS2SK+zVvrThShWXfeE31ST3B4+Iy1dA0w93lLraKy9R0O4A==
X-Received: by 2002:a17:902:daca:b0:1e0:d9da:b126 with SMTP id q10-20020a170902daca00b001e0d9dab126mr1864164plx.15.1711406681248;
        Mon, 25 Mar 2024 15:44:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id x19-20020a170902821300b001dffa622527sm5246285pln.225.2024.03.25.15.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 15:44:40 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: mpi3mr: Reduce stack usage
Date: Mon, 25 Mar 2024 15:44:34 -0700
Message-ID: <20240325224435.1477229-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.396.g6e790dbe36-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the following build error:

drivers/scsi/mpi3mr/mpi3mr_transport.c:1818:1: error: the frame size of 1640 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Fixes: cb5b60894602 ("scsi: mpi3mr: Increase maximum number of PHYs to 64 from 32")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c0c8ab586957..0fe6f0c108e9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1671,7 +1671,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 void
 mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 {
-	struct host_port h_port[64];
+	struct host_port *h_port;
 	int i, j, found, host_port_count = 0, port_idx;
 	u16 sz, attached_handle, ioc_status;
 	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
@@ -1679,6 +1679,9 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 	struct mpi3_device0_sas_sata_format *sasinf;
 	struct mpi3mr_sas_port *mr_sas_port;
 
+	h_port = kcalloc(64, sizeof(*h_port), GFP_KERNEL);
+	if (!h_port)
+		goto out;
 	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
 		(mrioc->sas_hba.num_phys *
 		 sizeof(struct mpi3_sas_io_unit0_phy_data));
@@ -1815,6 +1818,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 	}
 out:
 	kfree(sas_io_unit_pg0);
+	kfree(h_port);
 }
 
 /**
