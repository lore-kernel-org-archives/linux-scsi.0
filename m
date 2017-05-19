From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 1/7] qedi: Fix bad pte call trace when iscsiuio is stopped.
Date: Fri, 19 May 2017 01:33:15 -0700
Message-ID: <20170519083321.18030-2-manish.rangankar@cavium.com>
References: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0087.outbound.protection.outlook.com ([104.47.32.87]:32544
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751329AbdESIdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:37 -0400
In-Reply-To: <20170519083321.18030-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

From: Arun Easi <arun.easi@cavium.com>

munmap done by iscsiuio during a stop of the service triggers a "bad
pte" warning sometimes. munmap kernel path goes through the mmapped
pages and has a validation check for mapcount (in struct page) to be
zero or above. kzalloc, which we had used to allocate udev->ctrl, uses
slab allocations, which re-uses mapcount (union) for other purposes that
can make the mapcount look negative. Avoid all these trouble by invoking
one of the __get_free_pages wrappers to be used instead of kzalloc for
udev->ctrl.

 BUG: Bad page map in process iscsiuio  pte:80000000aa624067 pmd:3e6777067
 page:ffffea0002a98900 count:2 mapcount:-2143289280
     mapping: (null) index:0xffff8800aa624e00
 page flags: 0x10075d00000090(dirty|slab)
 page dumped because: bad pte
 addr:00007fcba70a3000 vm_flags:0c0400fb anon_vma: (null)
     mapping:ffff8803edf66e90 index:0

 Call Trace:
     dump_stack+0x19/0x1b
     print_bad_pte+0x1af/0x250
     unmap_page_range+0x7a7/0x8a0
     unmap_single_vma+0x81/0xf0
     unmap_vmas+0x49/0x90
     unmap_region+0xbe/0x140
     ? vma_rb_erase+0x121/0x220
     do_munmap+0x245/0x420
     vm_munmap+0x41/0x60
     SyS_munmap+0x22/0x30
     tracesys+0xdd/0xe2

Signed-off-by: Arun Easi <arun.easi@cavium.com>
Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 92775a8..997e305 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -151,6 +151,11 @@ static int qedi_uio_close(struct uio_info *uinfo, struct inode *inode)
 
 static void __qedi_free_uio_rings(struct qedi_uio_dev *udev)
 {
+	if (udev->uctrl) {
+		free_page((unsigned long)udev->uctrl);
+		udev->uctrl = NULL;
+	}
+
 	if (udev->ll2_ring) {
 		free_page((unsigned long)udev->ll2_ring);
 		udev->ll2_ring = NULL;
@@ -169,7 +174,6 @@ static void __qedi_free_uio(struct qedi_uio_dev *udev)
 	__qedi_free_uio_rings(udev);
 
 	pci_dev_put(udev->pdev);
-	kfree(udev->uctrl);
 	kfree(udev);
 }
 
@@ -208,6 +212,11 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 	if (udev->ll2_ring || udev->ll2_buf)
 		return rc;
 
+	/* Memory for control area.  */
+	udev->uctrl = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!udev->uctrl)
+		return -ENOMEM;
+
 	/* Allocating memory for LL2 ring  */
 	udev->ll2_ring_size = QEDI_PAGE_SIZE;
 	udev->ll2_ring = (void *)get_zeroed_page(GFP_KERNEL | __GFP_COMP);
@@ -237,7 +246,6 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 static int qedi_alloc_uio_rings(struct qedi_ctx *qedi)
 {
 	struct qedi_uio_dev *udev = NULL;
-	struct qedi_uio_ctrl *uctrl = NULL;
 	int rc = 0;
 
 	list_for_each_entry(udev, &qedi_udev_list, list) {
@@ -258,21 +266,14 @@ static int qedi_alloc_uio_rings(struct qedi_ctx *qedi)
 		goto err_udev;
 	}
 
-	uctrl = kzalloc(sizeof(*uctrl), GFP_KERNEL);
-	if (!uctrl) {
-		rc = -ENOMEM;
-		goto err_uctrl;
-	}
-
 	udev->uio_dev = -1;
 
 	udev->qedi = qedi;
 	udev->pdev = qedi->pdev;
-	udev->uctrl = uctrl;
 
 	rc = __qedi_alloc_uio_rings(udev);
 	if (rc)
-		goto err_uio_rings;
+		goto err_uctrl;
 
 	list_add(&udev->list, &qedi_udev_list);
 
@@ -283,8 +284,6 @@ static int qedi_alloc_uio_rings(struct qedi_ctx *qedi)
 	udev->rx_pkt = udev->ll2_buf + LL2_SINGLE_BUF_SIZE;
 	return 0;
 
- err_uio_rings:
-	kfree(uctrl);
  err_uctrl:
 	kfree(udev);
  err_udev:
-- 
1.8.3.1
