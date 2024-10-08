Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2708813A40D
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 07:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728373669; cv=none; b=jMDvH8hhHHg/OKvz2n2pVzqD30XCWiYcEGJlMOvu2+mbtYBdhozZJ5o9GimNgqCFglwVH5ZFbJUnPQM6iOGxqYCGEzm1xGXYk0Il+ELpQPcw6U2zKs/tc8u3mmEAuvjNZHgH98ZXeGCjlKoE141Ay1GyD/iLYd5u85Eoaq1q06M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728373669; c=relaxed/simple;
	bh=tCv/7mhipd7WQOFWDu5wytCySq5oguUqWbVzOY5daOM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ULyxRBBC4OAfhkiYl6Si6vNXuKXefh4mGQhnbgVHE7O+tmFzx/8wFx4hfT+JJDg7HIJBLdBhkcZXeYhBmXGiWgtAi3EVLe8VBBaeTW1x17+DhaPLHkgH2Xmfzn0SfUIpDTrd64i8qhJEvDRKqt0ozEyq2JdiUI8SatWD28Fn6vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aLkENXaI; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aLkENXaI"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3e033e66a31so2664061b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2024 00:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1728373665; x=1728978465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Es5a3SaOdE2aGjaLKoPJpJw7Ue4TmpSKGBflwGeF01U=;
        b=aLkENXaID4WyYDu1/Lj2gVfordfIsjcpbppkiE7u7msN+DWqVPc6rNz9ouoj5ANHFD
         U2nQjNZB0qkOuDJu2wom53s7kKhA4uNV5X/gC5jB5d6uup55HHifpIZUO2tMer1bzfSb
         RNhmiVmCdG9Yxl/7Q8jiKw3dKJbnm1JkcYsxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728373665; x=1728978465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Es5a3SaOdE2aGjaLKoPJpJw7Ue4TmpSKGBflwGeF01U=;
        b=UizuTjoZL7K6sKW+HH2tZVkC6dZFlfUjnmsLMh2bV/XfFY0qsHdZRUAuZcikHZmRN4
         oDfh9IawoBRzr9o5qgC3P8KVJYMbz/3oGOwYXa19F/ChnX9iMeGmAKt5Hxbcy8fCqkv2
         2smlQzzzqvP8ycQ2ncolg4EsgBL0VE3sBY3xMdO7FDIVzpzr5i9zxG2eRnKa4T52IW8o
         GXWH2+9GjaYqCsZfry+ptfeVqU8W8Qpizv077f9ZYwEDarcYKNBNpLyP8UVfOdqou4Bb
         Rk+UjS72Vhkg3z5homeXZIizbv9SPKQrA9sHcOOvni6VCkd4RThhbbSrOOqgQlxWmprC
         pA4g==
X-Gm-Message-State: AOJu0YxTImXGJ7/xInQ6u0A6BeHKAhsCuWKrm50MsG5CiVXvGkKrQIru
	8oNg46V/brvdRM8ofLQK7AA+0VFA6PtZs64/MW9B/1ALe6jyaB1VDwrmecCsWW5a1gsNFDB1tnU
	301OuB/BdZLbLAhgJcus4+X17rpkOiegBBRIHDJFUhZpxMSvys9flV9c0f45VmP5g7CGiJiINEH
	rbul8kfIkn2K2TpwNXNnvxiP3vOA8oyBuy6LhqwfCXGd7aqA==
X-Google-Smtp-Source: AGHT+IHcU90bO2mwisFuDqHClHaBqkqjJ5WQ3QaW2yhyT6648XzcBDWFAijqjwcFcv9VNXNf+TZGeg==
X-Received: by 2002:a05:6808:23c9:b0:3e0:6809:ab18 with SMTP id 5614622812f47-3e3c1326016mr10038627b6e.13.1728373665150;
        Tue, 08 Oct 2024 00:47:45 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d452b7sm5596039b3a.108.2024.10.08.00.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 00:47:44 -0700 (PDT)
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
	stable@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2] mpi3mr: Validating SAS port assignments
Date: Tue,  8 Oct 2024 13:13:53 +0530
Message-Id: <20241008074353.200379-1-ranjan.kumar@broadcom.com>
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
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410051943.Mp9o5DlF-lkp@intel.com/
Reported-by: Alexander Motin <mav@ixsystems.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  4 +--
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 42 +++++++++++++++++---------
 2 files changed, 29 insertions(+), 17 deletions(-)

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
index ccd23def2e0c..0ba9e6a6a13c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -590,12 +590,13 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
  * @mrioc: Adapter instance reference
  * @mr_sas_port: Internal Port object
  * @mr_sas_phy: Internal Phy object
+ * @host_node: Flag to indicate this is a host_node
  *
  * Return: None.
  */
 static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_port *mr_sas_port,
-	struct mpi3mr_sas_phy *mr_sas_phy)
+	struct mpi3mr_sas_phy *mr_sas_phy, u8 host_node)
 {
 	u64 sas_address = mr_sas_port->remote_identify.sas_address;
 
@@ -605,9 +606,13 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 
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
@@ -617,12 +622,13 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
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
 
@@ -632,9 +638,12 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 
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
@@ -675,7 +684,7 @@ static void mpi3mr_add_phy_to_an_existing_port(struct mpi3mr_ioc *mrioc,
 			if (srch_phy == mr_sas_phy)
 				return;
 		}
-		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy);
+		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy, mr_sas_node->host_node);
 		return;
 	}
 }
@@ -736,7 +745,7 @@ static void mpi3mr_del_phy_from_an_existing_port(struct mpi3mr_ioc *mrioc,
 				mpi3mr_delete_sas_port(mrioc, mr_sas_port);
 			else
 				mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
-				    mr_sas_phy);
+				    mr_sas_phy, mr_sas_node->host_node);
 			return;
 		}
 	}
@@ -1028,7 +1037,7 @@ mpi3mr_alloc_hba_port(struct mpi3mr_ioc *mrioc, u16 port_id)
 /**
  * mpi3mr_get_hba_port_by_id - find hba port by id
  * @mrioc: Adapter instance reference
- * @port_id - Port ID to search
+ * @port_id: Port ID to search
  *
  * Return: mpi3mr_hba_port reference for the matched port
  */
@@ -1367,7 +1376,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
 	    mr_sas_port->remote_identify.sas_address, hba_port);
 
-	if (mr_sas_node->num_phys >= sizeof(mr_sas_port->phy_mask) * 8)
+	if (mr_sas_node->host_node && mr_sas_node->num_phys >=
+			sizeof(mr_sas_port->phy_mask) * 8)
 		ioc_info(mrioc, "max port count %u could be too high\n",
 		    mr_sas_node->num_phys);
 
@@ -1377,7 +1387,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		    (mr_sas_node->phy[i].hba_port != hba_port))
 			continue;
 
-		if (i >= sizeof(mr_sas_port->phy_mask) * 8) {
+		if (mr_sas_node->host_node && (i >= sizeof(mr_sas_port->phy_mask) * 8)) {
 			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
@@ -1385,7 +1395,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
-		mr_sas_port->phy_mask |= (1 << i);
+		if (mr_sas_node->host_node)
+			mr_sas_port->phy_mask |= (1 << i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1394,7 +1405,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		goto out_fail;
 	}
 
-	mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+	if (mr_sas_node->host_node)
+		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
-- 
2.31.1

