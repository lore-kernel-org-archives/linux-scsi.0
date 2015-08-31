From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 03/14] lpfc: in sli3 use configured sg_seg_cnt for
 sg_tablesize
Date: Mon, 31 Aug 2015 16:48:10 -0400
Message-ID: <55e4bd8a.9Holn3dFdEAEsMk9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34345 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbbHaUs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:26 -0400
Received: by qkct7 with SMTP id t7so16740000qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:25 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id k5sm9529141qkl.15.2015.08.31.13.48.24
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Hi James,

We had some performance problems with RAID systems connected to LPe12k.
AFAICS, the reason is a small bug in lpfc.ko, causing the IO-size to
be smaller than expected.

The patch below fixes it for us.

Please CC me, I'm not on the list.

Best regards
Bodo

------------------------------------------------------

Currently the module parameter lpfc_sg_seg_count does not have effect
for sli3 devices.

In lpfc_sli_driver_resource_setup(), which is used for sli3, the code
writes the configured sg_seg_cnt into lpfc_template.sg_tablesize.
But lpfc_template is the template used for sli4 only. Thus the value should
correctly be written to lpfc_template_s3->sg_tablesize.

This patch is for kernel 4.1-rc5, but is tested with lpfc 10.2.405.26 only.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index da9b6fc..81bfb2d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4994,7 +4994,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* Initialize the host templates the configured values. */
 	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
-	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_template_s3.sg_tablesize = phba->cfg_sg_seg_cnt;
 
 	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
 	if (phba->cfg_enable_bg) {
-- 
1.7.11.7

