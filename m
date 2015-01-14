From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 09/10] megaraid_sas: swap whole register in megasas_register_aen
Date: Wed, 14 Jan 2015 16:37:41 +0530
Message-ID: <162d850ac5be3a34f98577d6f0caca50@mail.gmail.com>
References: <1420909883-19479-1-git-send-email-hch@lst.de> <1420909883-19479-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og129.obsmtp.com ([64.18.2.122]:42045 "EHLO
	exprod7og129.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbANLHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 06:07:43 -0500
Received: by mail-qg0-f42.google.com with SMTP id q108so6383964qgd.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 03:07:42 -0800 (PST)
In-Reply-To: <1420909883-19479-10-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@lst.de]
>Sent: Saturday, January 10, 2015 10:41 PM
>To: Sumit.Saxena@avagotech.com; kashyap.desai@avagotech.com
>Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org
>Subject: [PATCH 09/10] megaraid_sas: swap whole register in
>megasas_register_aen
>
>Swap the whole 32 bits we read from the hardware instead of swapping just
>the 16bits we care about in place later.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 5350e18..3d4a080 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4882,8 +4882,9 @@ megasas_register_aen(struct megasas_instance
>*instance, u32 seq_num,
>
> 	if (instance->aen_cmd) {
>
>-		prev_aen.word = instance->aen_cmd->frame-
>>dcmd.mbox.w[1];
>-		prev_aen.members.locale =
>le16_to_cpu(prev_aen.members.locale);
>+		prev_aen.word =
>+			le32_to_cpu(instance->aen_cmd->frame-
>>dcmd.mbox.w[1]);
>+		prev_aen.members.locale = prev_aen.members.locale;
>
> 		/*
> 		 * A class whose enum value is smaller is inclusive of all

Looks good to me.
Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>1.9.1
