Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1B1B87EE;
	Thu, 20 Feb 2025 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740044689; cv=none; b=LNrGadGlqALuxeGHlCVUi9Q7+SBc7YoueEX+MjNvEDzWYEi32QQff0OlwbdZlKfiOKVnBOlvvVcHegxX+HzsACPgApdiJMqx2MWl2NQmXYo372HBPFInEuiaNgZQ/YLlCR34wqng+zPPvtUsBwwyeRZJrOYzyn/kIljnzUvGhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740044689; c=relaxed/simple;
	bh=O+NWxy4b1KytTcS0ZHrugC8vxmfgabRh5HNWwRO/Ks8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bANa6q0KlUg1P5WcJs9+Yy0pBuKHddboKBIAf/MR3fmfoJbor02dloK4z5OY9rpHmhYJ5UUZpblSvH3tniJBWSOwBDaLiEo5Rmp2cL+3BvJfqXMvY4b+X5VLMZSHSPy65U8LtFAQJRptRcLoyWvdMT04expkB/FWC5gX0692tGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=LxQLSg+p; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="LxQLSg+p"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.14])
	by mail.ispras.ru (Postfix) with ESMTPSA id 788AD407853D;
	Thu, 20 Feb 2025 09:44:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 788AD407853D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1740044684;
	bh=VSyXhzk/oou5dN2ui5up8lh68VSTsNSjPW0MQf8saxc=;
	h=From:To:Cc:Subject:Date:From;
	b=LxQLSg+pO5Zrb++WnEfFMOLfDZlylCRorRX+hy2M9oknFiuIyqIHGquos+7adQrwl
	 GZI7LQHFDCnKBBhOjeyUStOZWPzlz6g14FBc5mv9BAY7C04Ly/sxONUGRozxwZKcvl
	 1KKN5d5kdwuClDc0TQXyWy6rauU5cRtimHlKGk9c=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: fix invalid 64-bit phy bitmask calculation
Date: Thu, 20 Feb 2025 12:44:31 +0300
Message-ID: <20250220094431.38185-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ffs() operates on arguments of type 'int', not generally considered to be
64-bit values.

Shifts like (1 << i) can also only be helpful for calculations that are
expected to have a range equal to the width of type 'int'. When the left
operand is of type 'int', valid values of the shift argument should not
exceed the width of this type (almost always 32 bits), otherwise it is
considered as undefined behavior.

Since there is a need for manipulating the phy mask bits higher than that,
perform the calculations directly in 64 bits.

Found by Linux Verification Center (linuxtesting.org).

Fixes: cb5b60894602 ("scsi: mpi3mr: Increase maximum number of PHYs to 64 from 32")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 0ba9e6a6a13c..f0da8c0dc55d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -7,6 +7,7 @@
  *
  */
 
+#include <linux/bits.h>
 #include <linux/vmalloc.h>
 
 #include "mpi3mr.h"
@@ -608,10 +609,12 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 	mr_sas_port->num_phys--;
 
 	if (host_node) {
-		mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
+		mr_sas_port->phy_mask &= ~BIT_ULL(mr_sas_phy->phy_id);
 
-		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id &&
+		    mr_sas_port->phy_mask)
+			mr_sas_port->lowest_phy =
+				__ffs64(mr_sas_port->phy_mask) - 1;
 	}
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
@@ -639,10 +642,11 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
 	mr_sas_port->num_phys++;
 	if (host_node) {
-		mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
+		mr_sas_port->phy_mask |= BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+			mr_sas_port->lowest_phy =
+				__ffs64(mr_sas_port->phy_mask) - 1;
 	}
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
@@ -1396,7 +1400,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
 		if (mr_sas_node->host_node)
-			mr_sas_port->phy_mask |= (1 << i);
+			mr_sas_port->phy_mask |= BIT_ULL(i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1406,7 +1410,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (mr_sas_node->host_node)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+		mr_sas_port->lowest_phy = __ffs64(mr_sas_port->phy_mask) - 1;
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
@@ -1738,7 +1742,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		found = 0;
 		for (j = 0; j < host_port_count; j++) {
 			if (h_port[j].handle == attached_handle) {
-				h_port[j].phy_mask |= (1 << i);
+				h_port[j].phy_mask |= BIT_ULL(i);
 				found = 1;
 				break;
 			}
@@ -1765,7 +1769,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		port_idx = host_port_count;
 		h_port[port_idx].sas_address = le64_to_cpu(sasinf->sas_address);
 		h_port[port_idx].handle = attached_handle;
-		h_port[port_idx].phy_mask = (1 << i);
+		h_port[port_idx].phy_mask = BIT_ULL(i);
 		h_port[port_idx].iounit_port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
 		h_port[port_idx].lowest_phy = sasinf->phy_num;
 		h_port[port_idx].used = 0;
-- 
2.48.1

