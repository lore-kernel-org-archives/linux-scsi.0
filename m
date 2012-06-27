From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/3 -resend] [SCSI] pmcraid: cpu_to_le32() => cpu_to_le64()
Date: Wed, 27 Jun 2012 12:04:29 +0300
Message-ID: <20120627090428.GK31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33694 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2F0JEi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2012 05:04:38 -0400
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

The cpu_to_le32() truncates the address to 32 bits.  All the other
places that set .address use cpu_to_le64().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
What about if dma_addr_t is 32 bits on a big endian system?  Can that
happen?

This patch was originally sent on Fri, 16 Dec 2011 and I sent a second
reminder on Mon, Apr 30, 2012.  I was silently ignored both times.

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d81a159..a38dade 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1242,7 +1242,7 @@ static struct pmcraid_cmd *pmcraid_init_hcam
 
 	ioadl[0].flags |= IOADL_FLAGS_READ_LAST;
 	ioadl[0].data_len = cpu_to_le32(rcb_size);
-	ioadl[0].address = cpu_to_le32(dma);
+	ioadl[0].address = cpu_to_le64(dma);
 
 	cmd->cmd_done = cmd_done;
 	return cmd;
