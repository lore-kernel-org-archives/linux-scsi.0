Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CCE31D375
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281748; cv=none; b=NaTUcRdpbkQ+LoATw1FUnaNS/jzv7sRa0Or7wsncDcTUzKU3Pq8jZ+2x1OfVmmHuUhL6ITO5snirU1OpCBf4a2s3uAdm9W1/xajJR3zML5cF7hslkRM51e5vjEbMaN1JZZXdeyk7TuFXOPjoOv3sZooTpwga2nRj+uluqoIX86c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281748; c=relaxed/simple;
	bh=BSb64EzeNe+LAdM46kkrVWOCt/FZCzWzgFhyw7921go=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TDooqBqILk5RemTAAsDbYynovRwwwhqWu8pp6Jzi229Qj55rSrDmPb3QUE683nUKLnTRA6Nwtu2rDz+Hjlao1RfOzUJ4tddIL2b0cJ9XsAwW99HPd9xJKQoUFSNbtl1NxC1FCrL3kG3FAJhp4w4C2PsPBW4IF01i+uOmXsaMBPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kXOm7Twv; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kXOm7Twv"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82f4a53ae20so7277272b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777281747; x=1777886547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wFZBmc0iscSfAT4VB9ZbI38DRL/+YXPqj1yfGMlW+m4=;
        b=kXOm7TwvUgOcQHjq2B2ixLP51P7p0GEoG9nOepzjYAMPKFTaXJpLBWPVjoOdaabd4D
         Qjt+W/K38lTf+9UpFJFrN5SMxAs+wMCg9mkJLKBvVJGoXQPWEkHU8FwqM9/A4TpUxYhT
         n3aUD5XZq9GnfbP7Gxu1unzqm86jaiJhdHYK5YBYqekZMY8WUEtO0B9H5hA0Ojm/9jzl
         8pEnXm4+HKCK/u4jf8tUAMNFtFUJ9lE46aKP0hl1SWBvpzBKhbyBwU1lV+1d/wyyzKyd
         VNPvC4LGxgpU+qzB/GQFLZEBybyDAD50vE7T7/akSCWj4b86rQDtEaC/dKuiWmg1hrwc
         Eahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281747; x=1777886547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wFZBmc0iscSfAT4VB9ZbI38DRL/+YXPqj1yfGMlW+m4=;
        b=QsyOcuOtRLq0ypVSjRgrhOCvC5UgKfuPfFeJX3GEKZfNdn2fK0gv7GdhqDmXJ5PUH1
         QZvaOmwc6sXvwSrpovA4iP6NrUvaio6Dmfn3bFH2gTpsieGy5WQxBFifT+epiO+kp6lp
         /SbmpermAELciyoiMFUPk1L8WV+3zM5KxUp43uVAd1dVYEvViFv8ui1T+adg84qWpHQh
         daP1AC1skygqDDs0xb0ndA8tylgQ9fkfPuRqeprt/qdiw3GXMyGIdLfsCpv/RgBH0+Vb
         9rBxRkRFZ+P70DcJAw8YYsLiolNGxXe8tAaEO8CMoSn1AFgHcxufUFskGKn9EAkS7BTN
         HL3Q==
X-Forwarded-Encrypted: i=1; AFNElJ9Naw8b7SCJDADm+BM/eCKdcLbODghr4lr+v1VdkHO4plItk5DPYdlN4QoELiref3HF59/q92lbgqvk@vger.kernel.org
X-Gm-Message-State: AOJu0YznabFa5eQXaa0eEtUVdRoolOJhto3LRrWKsxZwdf5IYR7Pny7/
	YfVDoFrh7oJ7iRB2o7rng3z4tkZ4exNnCV3OkuJ2V0cPsqX0l0zDTO8=
X-Gm-Gg: AeBDieuAoHK3zU2K9kTCyDtAqDGIeH4fnEsvhJV0IOnnv3rEa6qSfW9ynQmnq2FBWGK
	GjQjm3OIcef96Zte8tDYK1WZc5zMMHvzVAUl8R608GvhR/REgzfi5eA7Uszp8BTiBP1eMFC4O4w
	po1Qx303ejZS5qE/+xhfqhqBgINAnAph2lebx0XRfiwWdTjxwEz3+/yD1Az2W0RYxPmjpF8HlrX
	RTVsKAhELCVBJ3VGiBgOAeexjpfHezHDjz13NXHs8Eq2+jsEqhU1k/B7N9zqn/eJF+WPJq4D1YA
	5V3AzBLdnUXRIvVxRISoppD06WyT4BNXYHK7cJd+YlI/YcWDivhJmq1uJA/CraJY5DAHC+nbOyk
	X6NABSvJ22hu+a0Y1+Fxy43968S24iuHEnj4nnNZ7A4gtp8VZ/MyCju1slVMFjqAv9oP3XzamPY
	XAGbhPmlkQjLkTjwVSZzURGGBrrRX0s2mFE2Cv8WQGoRrw8HNWB7Q5hmDXUYZnzwosONCfDCw9C
	SCCp600YhWZ0YNA4Tko1HHm/fVxwMFy4VPsxjKLrZLW69c=
X-Received: by 2002:a05:6a00:4094:b0:82a:955:50d3 with SMTP id d2e1a72fcca58-82f8c937b36mr43641207b3a.45.1777281747016;
        Mon, 27 Apr 2026 02:22:27 -0700 (PDT)
Received: from localhost.localdomain ([1.226.165.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9fbb85sm36364449b3a.22.2026.04.27.02.22.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Apr 2026 02:22:26 -0700 (PDT)
From: "=?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?=" <mhun512@gmail.com>
X-Google-Original-From: =?UTF-8?q?=EB=B0=95=EB=AA=85=ED=9B=88?= <pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
To: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com
Cc: Myeonghun Pak <mhun512@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] scsi: qedf: Free exchange manager on probe failure
Date: Mon, 27 Apr 2026 18:22:14 +0900
Message-ID: <20260427092220.58365-1-pakmyeonghun@bagmyeonghun-ui-MacBookPro.local>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Myeonghun Pak <mhun512@gmail.com>

qedf_lport_setup() allocates a libfc exchange manager that is normally
released from qedf_remove(). If probe fails after the lport setup has
completed, the driver core does not call .remove(), so the exchange
manager and lport stats are left allocated.

Release the lport resources from the probe error path and also drop the
exchange manager if stats allocation fails inside qedf_lport_setup().

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 drivers/scsi/qedf/qedf_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index da429b3a42..499d42e46c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1765,8 +1765,10 @@ static int qedf_lport_setup(struct qedf_ctx *qedf)
 	fc_exch_mgr_alloc(lport, FC_CLASS_3, FCOE_PARAMS_NUM_TASKS,
 			  0xfffe, NULL);
 
-	if (fc_lport_init_stats(lport))
+	if (fc_lport_init_stats(lport)) {
+		fc_exch_mgr_free(lport);
 		return -ENOMEM;
+	}
 
 	/* Finish lport config */
 	fc_lport_config(lport);
@@ -3306,6 +3308,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	struct qed_slowpath_params slowpath_params;
 	struct qed_probe_params qed_params;
 	u16 retry_cnt = 10;
+	bool lport_setup = false;
 
 	/*
 	 * When doing error recovery we didn't reap the lport so don't try
@@ -3625,6 +3628,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 			    "qedf_lport_setup failed.\n");
 			goto err7;
 		}
+		lport_setup = true;
 	}
 
 	qedf->timer_work_queue = alloc_workqueue("qedf_%u_timer",
@@ -3704,6 +3708,10 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		destroy_workqueue(qedf->ll2_recv_wq);
 	fc_remove_host(qedf->lport->host);
 	scsi_remove_host(qedf->lport->host);
+	if (lport_setup) {
+		fc_exch_mgr_free(qedf->lport);
+		fc_lport_free_stats(qedf->lport);
+	}
 #ifdef CONFIG_DEBUG_FS
 	qedf_dbg_host_exit(&(qedf->dbg_ctx));
 #endif
-- 
2.50.1
