From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH] hptiop: wrong register used in hptiop_reset_hba()
Date: Mon, 24 Jul 2006 15:48:54 +0800
Message-ID: <200607241548.54593.linux@highpoint-tech.com>
References: <200606111706.52930.linux@highpoint-tech.com> <200606141650.57740.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stats.hypersurf.com ([209.237.0.12]:3854 "EHLO
	stats.hypersurf.com") by vger.kernel.org with ESMTP
	id S1751435AbWGXHbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 03:31:50 -0400
In-Reply-To: <200606141650.57740.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org

IOP reset message should be posted to inbound message register
instead of outbound message register.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index ab2f8b2..74d4d22 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -577,7 +577,7 @@ static int hptiop_reset_hba(struct hptio
 	if (atomic_xchg(&hba->resetting, 1) == 0) {
 		atomic_inc(&hba->reset_count);
 		writel(IOPMU_INBOUND_MSG0_RESET,
-				&hba->iop->outbound_msgaddr0);
+				&hba->iop->inbound_msgaddr0);
 		hptiop_pci_posting_flush(hba->iop);
 	}
 

