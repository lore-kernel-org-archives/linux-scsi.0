Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27322148FF0
	for <linux-scsi@vger.kernel.org>; Fri,  4 Oct 2024 09:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728034531; cv=none; b=QbqMB7BG1VL5eRIp4j3CEQcA7HnwxidLDt+QLmp5tgpKuXv7vATwt5eRqo2mLvLmHaHEXp4WJOGBkE/i5iUu05ainhLbRRiJIWJzdsUNqSE9601oNuAafQ2hZRJT/GZMtjZvsB2Q78HxCjQXASt8PceW+Ami0iGoAsw+2zO3XyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728034531; c=relaxed/simple;
	bh=PquVaNejDpT66ONMjZUqzihi3zMdtA6BsB4hySvQ4LI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XWro6QvsKiDjTTLgc70NqpOKrB/gT6Qir6O89t292F8Geoc2saFH1fascCeCrj0HVU1IVb/FYx40ZSFhDzW5SBONuzAq4Vri4rXyHxbUBIlqlHmf60mIHnDo8jFjSuzJ8b9JnIkYgj8b7pLjXf9Pu0kQQkFpr3MD4BstDjWN/9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dhDBkHM1; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dhDBkHM1"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7c3e1081804so928931a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Oct 2024 02:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1728034529; x=1728639329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6IkXpLQ0vSqj8t5WW/tYmj59F4E1NuxHzkG9tqMb/4E=;
        b=dhDBkHM1XDBGYNbqk9H62I7KR6UM+jzbF+V+xwm9qA/I31FVpVcEzt+abzYPtHq/CB
         YmQZH8M4to2qdpSF3xV1D1P9sbXrOlCtd72vdq9t79sBJ0x5GpQLIc9j+3LuUTS9yVq9
         bJiDkE/1/k1t0XrpJbLvB9OEerxEtavoasdXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728034529; x=1728639329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6IkXpLQ0vSqj8t5WW/tYmj59F4E1NuxHzkG9tqMb/4E=;
        b=oyVpDEEDPJY1IHXurno5aDrCzLW1DViU6uuWpI4n5uO+K4xDltwI7U5MMsdQzXcRl6
         8iIXxMVLb+l+3PsfpAsyt9DHxg5+SdyJnSGPa9dxoDGVeQFDDO9vHDAd48ZbU+I/MPs6
         ju/84lvsGHfo63Zvqfbab24mneqQhqq4joP1ZvQVZy3U0a92g6/SUWeNsYIDepV9d1HK
         VBRyyRarDUfVKWsjnkwmuWPu/4EdpNi4fDV7KioF2JCadU5Y9gnJazj3ZGESmM6npQie
         yRoaDCPPV179AShqs0DqdePkmB2zRhv/Cjx45Iu5d4WNCC7dZiHoimCApCn2L+mEUvpN
         /6AA==
X-Gm-Message-State: AOJu0YwR2i6J/zC7Cym9989HmeIozMvqRy4fzTEYvwyRfnFPkOQ6hFdB
	ed+1zuMWoqOhLDSuM4Ojarcfbp/rTD2DgXU8nt70kdwKGX8FtlPzOXJ2gFZjhnDbNiMx4FmKc48
	of1uJDrU5n3qG1lX9os0UGTcyV6BOXRZPUbSaJ1hVg7roHggh8KSto0fOjX3HUjVoXNR5Xqx7mn
	eFTNGz+2c4Lj6bTPfi4m+hV5spKJI0CpmCvUVGcHdOOJNjNQ==
X-Google-Smtp-Source: AGHT+IErQ8t9wB8Ytgfr++u0jtep5Wi9ModoCWT5qvL3pnBVmpNfQ1Eam8miRiHGNehloNIHA5v/dQ==
X-Received: by 2002:a05:6a21:3a81:b0:1d5:2f56:9fe5 with SMTP id adf61e73a8af0-1d6dfac81dfmr2825823637.39.1728034528812;
        Fri, 04 Oct 2024 02:35:28 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e83ca284sm1095403a91.11.2024.10.04.02.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:35:28 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	thenzl@redhat.com,
	mav@ixsystems.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH v1] mpi3mr: Validating SAS port assignments
Date: Fri,  4 Oct 2024 15:01:40 +0530
Message-Id: <20241004093140.149951-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sanity on phy_mask was added by Tomas through [1].
It causes warning messages when >64 phys are
detected (expander can have >64 phys) and devices
connected to phys greater than 64 are dropped.
phy_mask bitmap is only needed for controller
phys(not required for expander phys).Controller phys
can go maximum up to 64 and u64 is good enough to contain phy_mask bitmap.

To suppress those warnings and allow devices to be discovered as
before the [1], restrict the phy_mask setting and lowest phy
setting only to the controller phys.

[1]:https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/
drivers/scsi/mpi3mr?h=6.12/
scsi-queue&id=3668651def2c1622904e58b0280ee93121f2b10b

Fixes: 3668651def2c ("mpi3mr: Sanitise num_phys")
Cc: stable@vger.kernel.org
Reported-by: Alexander Motin <mav@ixsystems.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  4 +--
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 39 +++++++++++++++++---------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dc2cdd5f0311..3822efe349e1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -541,8 +541,8 @@ struct mpi3mr_hba_port {
  * @port_list: List of ports belonging to a SAS node
  * @num_phys: Number of phys associated with port
  * @marked_responding: used while refresing the sas ports
- * @lowest_phy: lowest phy ID of current sas port
- * @phy_mask: phy_mask of current sas port
+ * @lowest_phy: lowest phy ID of current sas port, valid for controller port
+ * @phy_mask: phy_mask of current sas port, valid for controller port
  * @hba_port: HBA port entry
  * @remote_identify: Attached device identification
  * @rphy: SAS transport layer rphy object
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index ccd23def2e0c..3a685750f5cd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -595,7 +595,7 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
  */
 static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_port *mr_sas_port,
-	struct mpi3mr_sas_phy *mr_sas_phy)
+	struct mpi3mr_sas_phy *mr_sas_phy, u8 host_node)
 {
 	u64 sas_address = mr_sas_port->remote_identify.sas_address;
 
@@ -605,9 +605,13 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 
 	list_del(&mr_sas_phy->port_siblings);
 	mr_sas_port->num_phys--;
-	mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
-	if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+
+	if (host_node) {
+		mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
+
+		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
+			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	}
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
 }
@@ -617,12 +621,13 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
  * @mrioc: Adapter instance reference
  * @mr_sas_port: Internal Port object
  * @mr_sas_phy: Internal Phy object
+ * @host_node: Flag to indicate this is a host_node
  *
  * Return: None.
  */
 static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_port *mr_sas_port,
-	struct mpi3mr_sas_phy *mr_sas_phy)
+	struct mpi3mr_sas_phy *mr_sas_phy, u8 host_node)
 {
 	u64 sas_address = mr_sas_port->remote_identify.sas_address;
 
@@ -632,9 +637,12 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 
 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
 	mr_sas_port->num_phys++;
-	mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
-	if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	if (host_node) {
+		mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
+
+		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
+			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	}
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
 }
@@ -675,7 +683,7 @@ static void mpi3mr_add_phy_to_an_existing_port(struct mpi3mr_ioc *mrioc,
 			if (srch_phy == mr_sas_phy)
 				return;
 		}
-		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy);
+		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy, mr_sas_node->host_node);
 		return;
 	}
 }
@@ -736,7 +744,7 @@ static void mpi3mr_del_phy_from_an_existing_port(struct mpi3mr_ioc *mrioc,
 				mpi3mr_delete_sas_port(mrioc, mr_sas_port);
 			else
 				mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
-				    mr_sas_phy);
+				    mr_sas_phy, mr_sas_node->host_node);
 			return;
 		}
 	}
@@ -1367,7 +1375,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
 	    mr_sas_port->remote_identify.sas_address, hba_port);
 
-	if (mr_sas_node->num_phys >= sizeof(mr_sas_port->phy_mask) * 8)
+	if (mr_sas_node->host_node && mr_sas_node->num_phys >=
+			sizeof(mr_sas_port->phy_mask) * 8)
 		ioc_info(mrioc, "max port count %u could be too high\n",
 		    mr_sas_node->num_phys);
 
@@ -1377,7 +1386,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		    (mr_sas_node->phy[i].hba_port != hba_port))
 			continue;
 
-		if (i >= sizeof(mr_sas_port->phy_mask) * 8) {
+		if (mr_sas_node->host_node && (i >= sizeof(mr_sas_port->phy_mask) * 8)) {
 			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
@@ -1385,7 +1394,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
-		mr_sas_port->phy_mask |= (1 << i);
+		if (mr_sas_node->host_node)
+			mr_sas_port->phy_mask |= (1 << i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1394,7 +1404,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		goto out_fail;
 	}
 
-	mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	if (mr_sas_node->host_node)
+		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
-- 
2.31.1

