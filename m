Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B554019E999;
	Sun,  9 Mar 2025 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741531851; cv=none; b=Ll1w+0SBxW2iNEdMcbToTGH6CN+qhU0QsfTOawY8JHw718ng4+wCD2b/JlNiGPPRpagffH7gIYohhIInpV58ycsmmNrnsZsnyKtm5SRjaPsAOAW2fuIRdOcqYBA0Pal75Msj1CQMR2Cq8Ngg0eaACbxmsQFCreZESKl8nhCm+BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741531851; c=relaxed/simple;
	bh=PHkWvIpbR70ggHECt3ri06vC6jmvSrjkfvWoW7QrqQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bodHAxN5y5Xtg71+xQLKYpvol+C4Nfb+ydsMtZ8XXniqai6VgG29NWXPYU6sX0pdUgl5OQtqOmKr3gKfPPVgy2NQlYo0DfVZpwN5Hx9/aMFyH3182Mm0GxAwhb6Ds5xRblzHRpX2qU8phiVyRnbuWXj0tLKjF0X0HbkhVx5xtnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=WhQf9h8h; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="WhQf9h8h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=wgaqx3L4bEmUAqdYIOiSTVQ/pNV4iVErt3TrM4quJB8=; b=WhQf9h8hRjftQbMi
	op/1uazhXArZKwIIL6FGEGhwNK/R5Na0VFCSfuSBtySW2DRQ3MzTiXZiT0NLf+icmZbmz2B7xSoOU
	jaqlVBZ64nG/RwsKLZKUqDOjtDmzH7zLreaKVoCFidocXZU4t7hP7uxFADNAb5NNLM1lz+LcTB5DL
	qlJ6YHrZmCXcafXHuUJTZpGY7CqW/NJBZs7FHVpvcSO3VAlDpIhVbZDc1+872UMYnctgCtf//h7E2
	MkLJGlWztdLJn/YEM9xXavVaXTzT8FIvUtoZIvsDdIJRINCxPgEikX2C+z7raHXFm4Joq4TmNao37
	PpA0kPV9ceNByGWkdw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1trHzI-003iVd-2H;
	Sun, 09 Mar 2025 14:50:44 +0000
From: linux@treblig.org
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: isci: static most module parameters
Date: Sun,  9 Mar 2025 14:50:44 +0000
Message-ID: <20250309145044.38586-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Most of the module parameters are only used locally in the same
C file; so static them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/isci/init.c | 14 +++++++-------
 drivers/scsi/isci/isci.h |  7 -------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 73085d2f5c43..acf0c2038d20 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -91,31 +91,31 @@ MODULE_DEVICE_TABLE(pci, isci_id_table);
 
 /* linux isci specific settings */
 
-unsigned char no_outbound_task_to = 2;
+static unsigned char no_outbound_task_to = 2;
 module_param(no_outbound_task_to, byte, 0);
 MODULE_PARM_DESC(no_outbound_task_to, "No Outbound Task Timeout (1us incr)");
 
-u16 ssp_max_occ_to = 20;
+static u16 ssp_max_occ_to = 20;
 module_param(ssp_max_occ_to, ushort, 0);
 MODULE_PARM_DESC(ssp_max_occ_to, "SSP Max occupancy timeout (100us incr)");
 
-u16 stp_max_occ_to = 5;
+static u16 stp_max_occ_to = 5;
 module_param(stp_max_occ_to, ushort, 0);
 MODULE_PARM_DESC(stp_max_occ_to, "STP Max occupancy timeout (100us incr)");
 
-u16 ssp_inactive_to = 5;
+static u16 ssp_inactive_to = 5;
 module_param(ssp_inactive_to, ushort, 0);
 MODULE_PARM_DESC(ssp_inactive_to, "SSP inactivity timeout (100us incr)");
 
-u16 stp_inactive_to = 5;
+static u16 stp_inactive_to = 5;
 module_param(stp_inactive_to, ushort, 0);
 MODULE_PARM_DESC(stp_inactive_to, "STP inactivity timeout (100us incr)");
 
-unsigned char phy_gen = SCIC_SDS_PARM_GEN2_SPEED;
+static unsigned char phy_gen = SCIC_SDS_PARM_GEN2_SPEED;
 module_param(phy_gen, byte, 0);
 MODULE_PARM_DESC(phy_gen, "PHY generation (1: 1.5Gbps 2: 3.0Gbps 3: 6.0Gbps)");
 
-unsigned char max_concurr_spinup;
+static unsigned char max_concurr_spinup;
 module_param(max_concurr_spinup, byte, 0);
 MODULE_PARM_DESC(max_concurr_spinup, "Max concurrent device spinup");
 
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 4e6b1decbca7..f6a8fe206415 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -473,13 +473,6 @@ static inline void sci_swab32_cpy(void *_dest, void *_src, ssize_t word_cnt)
 		dest[word_cnt] = swab32(src[word_cnt]);
 }
 
-extern unsigned char no_outbound_task_to;
-extern u16 ssp_max_occ_to;
-extern u16 stp_max_occ_to;
-extern u16 ssp_inactive_to;
-extern u16 stp_inactive_to;
-extern unsigned char phy_gen;
-extern unsigned char max_concurr_spinup;
 extern uint cable_selection_override;
 
 irqreturn_t isci_msix_isr(int vec, void *data);
-- 
2.48.1

