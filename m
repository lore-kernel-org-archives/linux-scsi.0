From: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Subject: [PATCH] fixed invalid assignment of 64bit mask to host dma_boundary
 for scatter gather segment boundary limit.
Date: Mon, 9 Feb 2015 18:54:09 +0000
Message-ID: <e20a4b22-45bf-4c2e-9e5e-cdd2a238effd@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:22936 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbbBISzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2015 13:55:19 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Mike Christie (michaelc@cs.wisc.edu)" <michaelc@cs.wisc.edu>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>, Sony John-N <Sony.John-N@Emulex.Com>

In reference to bug https://bugzilla.redhat.com/show_bug.cgi?id=1097141
Assert is seen with AMD cpu whenever calling pci_alloc_consistent.

[   29.406183] ------------[ cut here ]------------ 
[   29.410505] kernel BUG at lib/iommu-helper.c:13!

Signed-off-by: Minh Tran <minh.tran@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..9cc047b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -586,7 +586,6 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
                        "beiscsi_hba_alloc - iscsi_host_alloc failed\n");
                return NULL;
        }
-       shost->dma_boundary = pcidev->dma_mask;
        shost->max_id = BE2_MAX_SESSIONS;
        shost->max_channel = 0;
        shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
--
1.8.3.1
