From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
Date: Wed, 30 Oct 2013 20:13:51 +0300
Message-ID: <20131030171351.GB4130@longonot.mountain>
References: <20131025144452.GA28451@ngolde.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3J3RRH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2013 13:17:07 -0400
Content-Disposition: inline
In-Reply-To: <20131025144452.GA28451@ngolde.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, security@kernel.org, Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>

pthru32->dataxferlen comes from the user so we need to check that it's
not too large so we don't overflow the buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Please review this carefully because I have not tested it.

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index dfffd0f..a706927 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 
 	pthru32->dataxferaddr	= kioc->buf_paddr;
 	if (kioc->data_dir & UIOC_WR) {
+		if (pthru32->dataxferlen > kioc->xferlen)
+			return -EINVAL;
 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
 						pthru32->dataxferlen)) {
 			return (-EFAULT);
