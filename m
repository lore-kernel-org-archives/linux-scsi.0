Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644D53B14C4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785853753; cv=none; b=QmV+oZveBPZp8x521MXHD135IooRSJ4+OY7QidRB3yd8astelzr8W3oOaFvr7hyl2OKirCu0eP8bb8t1h+xUsxHJgWWKZZ7E1bCoB94BC+Ml/dXXIOPPj0rqlYyjpmT7CJRKjEptFhMZ4u4KKBIimjf+jFrM0F7LTGBpYAGhHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785853753; c=relaxed/simple;
	bh=Zzf4GBcaHRkdwdNLecVrXUEDo085F5X2K1Y6OucS1Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N/iqG0JVe3906GD9zb368W3Pj4wgtw6H8ubpV+N4GoSy/mksHQWi/oQkgk2RxrvZGfgKkT4L4S1jvTilJdG4RXMkb9yCugnGZsnY84cTnRYroAtBGNHl07aJvYczOZaBCvHsYDMWovk53O+lFj32iGodpfOvONVdqxKIBgn1dhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=casRjeyC; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="casRjeyC"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so1324423e87.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 07:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785853733; x=1786458533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iRhJ2aYZNtm2kCJIVYQl1pK7YdCm7CzHtYjyN2QbDAU=;
        b=casRjeyClWFMlKltNYW2NaVYp0MWskTm87BXlt1dKvwmmw/4Huq0XXdmwNmyLyx8hY
         UMi/F6jW9SknOL8B6SgsXw7bzO6LLphRDLkypm4XnG/m+Oz0TA+3EFDrFZ81VIidoHlH
         oBsvAp42HbOIOlxtv1rAkT30up+L3vgF5KnFsjcZvkx1iQkpSMS2YTSRNSYcf0v8N5cU
         brm8XdyZoCKxwlEMvzQwE6ZGxVyWkuM55FElims4TK5qWZXHneiI2D/Buzw9xdGmSkf7
         kYrQrlRKXzLWxS/OKY8Z5gFUSG14x5svrgGVbav6M2qf3h79q6G65KDtyVKf2L3HPir/
         Gx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785853733; x=1786458533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iRhJ2aYZNtm2kCJIVYQl1pK7YdCm7CzHtYjyN2QbDAU=;
        b=cDJP93SUEtZkzvop96xhFNzW1vaDY1WGYUj5u2E06Xcjb2FNfUglGiLe8FhbFz4yaJ
         W2EZMOlisihkkdObNh3MyfibadoPO4O6ally6oON+TboxmslTaMJLzM5Kmg1lQPpxi6U
         c0mNi8br10MSZ+MXbwEtt6UpA2asHpJOXdipv7T20cfxyaDVfi2uChlX6vUtsCLxAHrB
         n6Y/r5mkzWPGYfG6xeesdDw+Lh88T/PaD5+DGQKd4/uU1zDYvyj8xim1w+9vIYpoXQUo
         ZEpjb039q76GemBohOaGy6HX0o14v0I6g0whkg+4iy3TxNhyCl2u/6PToBwv13A5W5Nk
         YSDA==
X-Forwarded-Encrypted: i=1; AHgh+RosjLRMevA/JFGswP22oGRrtkFyEt61c5BS/qyfsNfuSfDY26cKFNFnrx5M1GZKclCYRgttYbJWpDE+@vger.kernel.org
X-Gm-Message-State: AOJu0YzNcN0jTg4ZP83K85B0trnBcfR4SwXKc30kbZYFxDT5EDclOUwL
	rt0ljFxgfnsfi2D96CDfh5nrxAihVd9ZHgR74VotfVdbvoOzdjzgOiBn
X-Gm-Gg: AR+sD11G3/3/Zcsrf2sIl8dhEqg37+9IQQHn1ZAFbURh2iDu7afZq4Y3obdstmU+98p
	icJ473vbowDQeGdb37YcBFHnc/Y5l820QmMAqqE/ZTeOBr/tTCVR9ympM21EoMeDCcJpSGBPgxF
	ywPdaccMLjPUHXpGg9YwUr9OpJiwlhFTYvbTdIYg9Cspliqyj1uu+Er6rArn7r9sTSi2VcHobVk
	FRIaIeQclyggo5U64rk6BfFkx2K1RxOmKiSMonaP/TCT9zGI3hyU0ljG0lLaf32VVXCs68UYYm8
	ib+I9xButqebpmBevVSx6grRErHnLLk3KCSGAzewp24jMxt0Uyyn3ubsM5HkLV5SJ2DTNCwqEn4
	l3FXKCNTBbw1zL08kghVCj7+z4T8OP6pwuPmI0yDn7ahbsJ6jO/LIpLjrlCbM+i2v3EX3urar5Y
	ZlaKCMuvDVcyu4Wyep9+nVOb3rEmR7q1HPdajEF4mcpanQlNPoOtZu+YPnka0FZXs6HUaXMa/BB
	zWV2Q==
X-Received: by 2002:ac2:4e14:0:b0:5b0:1186:fdf with SMTP id 2adb3069b0e04-5b2f281c00emr918624e87.11.1785853733048;
        Tue, 04 Aug 2026 07:28:53 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e2441e96sm2650558e87.42.2026.08.04.07.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:28:52 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: make SAS port PHY masks 64-bit safe
Date: Tue,  4 Aug 2026 17:28:31 +0300
Message-ID: <20260804142831.4365-1-khomyakovilya@gmail.com>
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
