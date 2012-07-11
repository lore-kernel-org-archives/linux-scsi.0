From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH RESUBMIT 1/3] qla4xxx: remove unnecessary read of
 PCI_CAP_ID_EXP
Date: Wed, 11 Jul 2012 06:16:56 -0700
Message-ID: <CC237A4B.10192%vikas.chaudhary@qlogic.com>
References: <1341957477-30946-2-git-send-email-jdmason@kudzu.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:14516 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab2GKNRE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 09:17:04 -0400
In-Reply-To: <1341957477-30946-2-git-send-email-jdmason@kudzu.us>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Mason <jdmason@kudzu.us>, James Bottomley <JBottomley@Parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>



-----Original Message-----
From: Jon Mason <jdmason@kudzu.us>
To: James Bottomley <JBottomley@Parallels.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>,
Vikas <vikas.chaudhary@qlogic.com>, Dept-Eng iSCSI Driver
<Dept-iSCSIDriver@qlogic.com>
Subject: [PATCH RESUBMIT 1/3] qla4xxx: remove unnecessary read of
PCI_CAP_ID_EXP

>The PCIE capability offset is saved during PCI bus walking.  It will
>remove an unnecessary search in the PCI configuration space if this
>value is referenced instead of reacquiring it.
>
>Signed-off-by: Jon Mason <jdmason@kudzu.us>
>Cc: Ravi Anand <ravi.anand@qlogic.com>
>Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>Cc: iscsi-driver@qlogic.com
>---
> drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
>index 228b670..939d726 100644
>--- a/drivers/scsi/qla4xxx/ql4_nx.c
>+++ b/drivers/scsi/qla4xxx/ql4_nx.c
>@@ -1590,7 +1590,7 @@ qla4_8xxx_start_firmware(struct scsi_qla_host *ha,
>uint32_t image_start)
>       }
>
>       /* Negotiated Link width */
>-      pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
>+      pcie_cap = pci_pcie_cap(ha->pdev);
>       pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
>       ha->link_width = (lnk >> 4) & 0x3f;

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>



This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

