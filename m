From: Chaitra Basappa <chaitra.basappa@avagotech.com>
Subject: RE: [PATCH] mpt3sas: a correction in unmap_resources
Date: Mon, 4 Jan 2016 16:51:38 +0530
Message-ID: <b29633fa704eab7219d60014ebc17cd9@mail.gmail.com>
References: <1450876907-3913-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:34631 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbcADLVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2016 06:21:40 -0500
Received: by mail-yk0-f172.google.com with SMTP id a85so166721485ykb.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2016 03:21:40 -0800 (PST)
In-Reply-To: <1450876907-3913-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, mlombard@redhat.com

Hi,
 Please consider this patch as Ack-by: Chaitra P B
<chaitra.basappa@avagotech.com>

Thanks,
 Chaitra

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com]
Sent: Wednesday, December 23, 2015 6:52 PM
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@avagotech.com; chaitra.basappa@avagotech.com;
mlombard@redhat.com
Subject: [PATCH] mpt3sas: a correction in unmap_resources

It might happen that we try to free an already freed pointer.

Tomas

Reported-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
b/drivers/scsi/mpt3sas/mpt3sas_base.c
index d4f1dcdb83..3b09b3d09f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1827,8 +1827,10 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER
*ioc)
 	_base_free_irq(ioc);
 	_base_disable_msix(ioc);

-	if (ioc->msix96_vector)
+	if (ioc->msix96_vector) {
 		kfree(ioc->replyPostRegisterIndex);
+		ioc->replyPostRegisterIndex = NULL;
+	}

 	if (ioc->chip_phys) {
 		iounmap(ioc->chip);
-- 
2.4.3
