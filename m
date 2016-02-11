From: "Jitendra Bhivare" <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH] be2iscsi: Fix memory leak in beiscsi_alloc_mem()
Date: Thu, 11 Feb 2016 04:59:31 -0800
Message-ID: <026a01d164cc$0eed1720$2cc74560$@broadcom.com>
References: <1443689785-13712-1-git-send-email-mlombard@redhat.com> <CAJRCtXfbT9OrVVDrnC=1V1B4iFUm+FHN4fxQV1CUCY3pXRHq2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36387 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbcBKM7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 07:59:37 -0500
Received: by mail-pa0-f46.google.com with SMTP id yy13so28633559pab.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2016 04:59:37 -0800 (PST)
In-Reply-To: <CAJRCtXfbT9OrVVDrnC=1V1B4iFUm+FHN4fxQV1CUCY3pXRHq2Q@mail.gmail.com>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mlombard@redhat.com
Cc: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, James.Bottomley@hansenpartnership.com

In case of error, the memory allocated for phwi_ctrlr was not freed.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/be2iscsi/be_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..360aa88 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2706,8 +2706,10 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
        phwi_ctrlr->wrb_context = kzalloc(sizeof(struct hwi_wrb_context) *
                                          phba->params.cxns_per_ctrl,
                                          GFP_KERNEL);
-       if (!phwi_ctrlr->wrb_context)
+       if (!phwi_ctrlr->wrb_context) {
+               kfree(phba->phwi_ctrlr);
                return -ENOMEM;
+       }

        phba->init_mem = kcalloc(SE_MEM_MAX, sizeof(*mem_descr),
                                 GFP_KERNEL);
--
Maurizio Lombardi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Thanks,

JB


