From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mptfusion: release resources in error return path
Date: Mon, 26 Jul 2010 16:41:13 +0200
Message-ID: <4C4D9E89.3020307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0GZOlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 10:41:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

We should release the resources in error return code path.
The requested pci bars should be released under an error condition,
when mpt_mapresources fails.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e319abc..ea12663 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1632,6 +1632,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		} else {
 			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
 			    ioc->name, pci_name(pdev));
+			pci_release_selected_regions(pdev, ioc->bars);
 			return r;
 		}
 	} else {
@@ -1645,6 +1646,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		} else {
 			printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
 			    ioc->name, pci_name(pdev));
+			pci_release_selected_regions(pdev, ioc->bars);
 			return r;
 		}
 	}
@@ -1675,6 +1677,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	if (mem == NULL) {
 		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
 			" memory!\n", ioc->name);
+		pci_release_selected_regions(pdev, ioc->bars);
 		return -EINVAL;
 	}
 	ioc->memmap = mem;


