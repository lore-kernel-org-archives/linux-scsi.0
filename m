Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9F546A5F8
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 14:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785852025; cv=none; b=sFL8lGEBczV3ULCjn4m5rW5Jrf5dXLI8MmhldoovfBV3487EB/MajLkxu2bXk/SNKRI+G1JqGgQ+nv7bJ8zgS4Tt5apJVTEOMJPCRbtYbfmoMh2laFRVWxclpZoqCX6Yi0irgA7xEIO5dCSYYi99MxUJaUsy5LnkOJXxbn32tQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785852025; c=relaxed/simple;
	bh=Zzf4GBcaHRkdwdNLecVrXUEDo085F5X2K1Y6OucS1Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=agi84OFtiJV9Fy03x/4iI/Av/Y2fzEJ6m1B76Tidx+O1/F47gY3VizvEp4Twl10iuecuJsoY4Kp6shNRM8TDIaneTol8xExHn3aLeNn5qPvMOxkbP/BDh7NaOBhmO6adYpEin6WUELJjtxp2LHuFA2+FiPLrllFfB+8d4YCPynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XoAXK58+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XoAXK58+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-495635a85d2so29956125e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 07:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785852022; x=1786456822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iRhJ2aYZNtm2kCJIVYQl1pK7YdCm7CzHtYjyN2QbDAU=;
        b=XoAXK58+RgcsWpBeJqjTJLXX331987BJAL/AsbXT1CrmwqxtcFEPrVFWb2ggQVAupA
         gKpi3aBqK1Ghvi52xgOowUJI0JCGEJ92L2lUmcmZcrMT2kmaqZGYxx1PEAQPXpUvN8Yx
         OdDdnI0aMuKuc23VuM8Ofyiyar1WpdZr9v7qlBpRscBItxf3yxE8hsRgZjwItRQiePpo
         0RPb0pZh9sUSPrShaP1zXLtr+LL1Bm6wgIexEaWJKDvoFPFz28wrrsP4oFJuHxDUyJ7I
         5AYPeMT687+PbdDl86vV1Q0X5mAO6eYOasAVlH1PET1L26QdS8mytQuGdlazInXXai2X
         vXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785852022; x=1786456822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iRhJ2aYZNtm2kCJIVYQl1pK7YdCm7CzHtYjyN2QbDAU=;
        b=tBUWp9V+V6FLdmfuapCLe9QQCDDuyn/u6QNDOA/DmkUZh54FNi8/aMGmR9619Na2Dk
         Yd9M3oB8cMOBPqCLzR2EmBuDKJEglIT5OwG+YYfaSHrMHklrV4ZcHN8vyc62bqVn9Xd9
         A5sFKhghNOq85ArFFGsuIVxcBjpHoouHeJUUvn22VnjKsXQnq1dE4Lj5E0cqOxY2oAPG
         79y+PH0KpnGVXAw77ANzhB4YfXaRKHhBhnHbHooOUFEewbSIsRbITOwXBaOSTrcI4uzl
         nIr4pzJf7ku5I5g8k3Z4AiCn2uP1vHMx5rvFfBrnOZWiw6Uaz7YLUPnAyPpjULydao3q
         16ow==
X-Gm-Message-State: AOJu0Yxs2XvL41lbUFUZj21YAH5nFBiCa5V+MLGjJNTq9jhISbss5Zv2
	fG6ElBO9ANhlEALGWFnsigrnw/RcSznHTkXo7eLX7jiVPBCnQZ69ySo3HEqSAY5pgwFcXw==
X-Gm-Gg: AR+sD10PYzDziPkrLb7iHvrqCnxUWm282tbaeUZ72xO96dhuB2pkEZ0YH0nhVrtzJOM
	MpjEVhtumh5//S8ChMRHUWFq4Q0PBvG2GXeFsznNTi1kNoPm+67wFg5P1pX9Fp0B7r8rxqw44Jr
	nTsdJPdnypYxe/F4szSZ6P6OuJ7x97jykiBY8AoSjrd9nL1rZLkwjr7AFcb35JSyFeq9bM/Ovqe
	cEPMJkw5RYQcVtQWrJjfxUShi4tVpAZWBS3tq7ZmOF93Co+aYmuslpwcDhIqEx743dfjA0zQAAP
	Vbx8IDYaCBImFkCWA/ej3QQcrFC5fK1ttDsJnjxDEo9BJOZtkl13Lu5QayfB8wbIqYc0jHvNnwu
	0Iw8kj4eAg04s9zj0Fo2oBuWYcq9injGhDHqRWOwi3HyKExWljBRxoeM7yuqc9haY4Ddhy+94ZF
	Ikn5B0FcSJ+QjnkhRMN1qZ33hd6/hrz915cWqb2l7fWq8D7whaYbA0dGJx8ThbdIQuU7Vu/1Hzn
	GSEDA==
X-Received: by 2002:a05:600c:1d0a:b0:495:5dcc:52b4 with SMTP id 5b1f17b1804b1-4994d9ef0b5mr21226785e9.3.1785852021154;
        Tue, 04 Aug 2026 07:00:21 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41d0064sm42848941f8f.5.2026.08.04.07.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:00:20 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: make SAS port PHY masks 64-bit safe
Date: Tue,  4 Aug 2026 17:00:04 +0300
Message-ID: <20260804140004.4004-1-khomyakovilya@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes 64-bit PHY-mask handling in the Broadcom MPI3 Storage
Controller driver under drivers/scsi/mpi3mr/.

struct mpi3mr_sas_port stores phy_mask as u64, but several paths
construct the mask with the signed-int expression 1 << phy_id or 1 << i.
The shift is evaluated as int before the result is converted to u64.

The operation therefore has undefined behavior when the PHY identifier
reaches the sign bit or width of int. The same code uses ffs() to find the
lowest set bit, but ffs() accepts int and truncates bits 32 through 63.

The issue was reproduced with UBSAN during SAS port creation:

  UBSAN: shift-out-of-bounds in mpi3mr_transport.c
  Workqueue: mpi3mr0_fwevt_wrkr mpi3mr_fwevt_worker
  mpi3mr_sas_port_add
  mpi3mr_update_links
  mpi3mr_report_tgtdev_to_sas_transport

The reproduced topology contains a controller host node with 39 PHYs and
an expander with 46 PHYs. Such a topology is sufficient to exercise PHY
identifiers above 31 during normal discovery.

Add a helper that validates the firmware PHY identifier and constructs the
mask bit with BIT_ULL(). Add a separate helper that handles an empty mask
and otherwise finds the lowest bit with __ffs64(). Use the helpers in the
PHY add and remove paths, initial port construction, and reset-refresh port
grouping. Also initialize lowest_phy when the first PHY is dynamically
added to an empty port.

The patch was tested in an out-of-tree mpi3mr 8.17.1.0.0 build. The driver
successfully discovered a 39-PHY host node and a 46-PHY expander, created
expander PHY objects through PHY 45, and completed device discovery without
a shift-out-of-bounds or other UBSAN report.

The boot test directly exercised initial high-PHY port construction. The
same helpers are used in the add, remove, and reset-refresh paths to remove
the identical 32-bit operations from those paths as well.
Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>

---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 58 ++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a..d6492dd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -11,6 +11,42 @@
 
 #include "mpi3mr.h"
 
+/**
+ * mpi3mr_sas_phy_bit - build a bit for a firmware PHY identifier
+ * @phy_id: Firmware PHY identifier to represent in a 64-bit port mask
+ *
+ * The port mask is a u64, so every shift must be performed in a 64-bit
+ * unsigned type. Reject identifiers that cannot be represented before the
+ * shift to avoid undefined behavior.
+ *
+ * Return: BIT_ULL(@phy_id) for a representable identifier, otherwise zero.
+ */
+static u64 mpi3mr_sas_phy_bit(u8 phy_id)
+{
+	if (WARN_ON_ONCE(phy_id >= sizeof(u64) * 8))
+		return 0;
+
+	return BIT_ULL(phy_id);
+}
+
+/**
+ * mpi3mr_sas_port_lowest_phy - find the lowest PHY in a port mask
+ * @phy_mask: 64-bit bitmap of PHY identifiers assigned to the port
+ *
+ * Use a 64-bit find-first-set operation so PHY identifiers 32 through 63
+ * are not truncated to int. Keep -1 as the empty-mask sentinel used by the
+ * surrounding port bookkeeping.
+ *
+ * Return: lowest set PHY identifier, or -1 when the mask is empty.
+ */
+static int mpi3mr_sas_port_lowest_phy(u64 phy_mask)
+{
+	if (!phy_mask)
+		return -1;
+
+	return __ffs64(phy_mask);
+}
+
 /**
  * mpi3mr_post_transport_req - Issue transport requests and wait
  * @mrioc: Adapter instance reference
@@ -610,10 +646,11 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 	mr_sas_port->num_phys--;
 
 	if (host_node) {
-		mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
+		mr_sas_port->phy_mask &= ~mpi3mr_sas_phy_bit(mr_sas_phy->phy_id);
 
 		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+			mr_sas_port->lowest_phy =
+				mpi3mr_sas_port_lowest_phy(mr_sas_port->phy_mask);
 	}
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
@@ -641,10 +678,12 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
 	mr_sas_port->num_phys++;
 	if (host_node) {
-		mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
+		mr_sas_port->phy_mask |= mpi3mr_sas_phy_bit(mr_sas_phy->phy_id);
 
-		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+		if (mr_sas_port->lowest_phy < 0 ||
+		    mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
+			mr_sas_port->lowest_phy =
+				mpi3mr_sas_port_lowest_phy(mr_sas_port->phy_mask);
 	}
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
@@ -1396,7 +1435,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
 		if (mr_sas_node->host_node)
-			mr_sas_port->phy_mask |= (1 << i);
+			mr_sas_port->phy_mask |= mpi3mr_sas_phy_bit(i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1406,7 +1445,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (mr_sas_node->host_node)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+		mr_sas_port->lowest_phy =
+			mpi3mr_sas_port_lowest_phy(mr_sas_port->phy_mask);
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
@@ -1738,7 +1778,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		found = 0;
 		for (j = 0; j < host_port_count; j++) {
 			if (h_port[j].handle == attached_handle) {
-				h_port[j].phy_mask |= (1 << i);
+				h_port[j].phy_mask |= mpi3mr_sas_phy_bit(i);
 				found = 1;
 				break;
 			}
@@ -1765,7 +1805,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		port_idx = host_port_count;
 		h_port[port_idx].sas_address = le64_to_cpu(sasinf->sas_address);
 		h_port[port_idx].handle = attached_handle;
-		h_port[port_idx].phy_mask = (1 << i);
+		h_port[port_idx].phy_mask = mpi3mr_sas_phy_bit(i);
 		h_port[port_idx].iounit_port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
 		h_port[port_idx].lowest_phy = sasinf->phy_num;
 		h_port[port_idx].used = 0;
