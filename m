From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] qla2xxx: fix rwlock recursion
Date: Wed, 14 Oct 2015 10:33:08 -0700
Message-ID: <561E91D4.8030307@sandisk.com>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
 <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0088.outbound.protection.outlook.com ([207.46.100.88]:2092
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753818AbbJNRdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 13:33:18 -0400
In-Reply-To: <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 10/14/2015 08:57 AM, Himanshu Madhani wrote:
> This patch fixes rwlock recursion introduced for ISP82XX by
> commit 8dfa4b5a ("qla2xxx: Fix sparse annotations")

Hello Himanshu,

Would it be possible to test whether the (untested) patch below also 
fixes the observed rwlock recursion ?

Thanks,

Bart.



[PATCH] qla2xxx: Fix rwlock recursion

Fixes: 8dfa4b5a9b44 ("qla2xxx: Fix sparse annotation")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reported-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
  drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index eb0cc54..b6b4cfd 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -433,7 +433,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, 
ulong off_in,
  	if (off_in < QLA82XX_PCI_CRBSPACE)
  		return -1;

-	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
+	off_in -= QLA82XX_PCI_CRBSPACE;

  	/* Try direct map */
  	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
@@ -443,6 +443,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, 
ulong off_in,
  		return 0;
  	}
  	/* Not in direct map, use crb window */
+	*off_out = (void __iomem *)off_in;
  	return 1;
  }

-- 
2.1.4


