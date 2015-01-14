From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 06/10] megaraid_sas: bytewise or should be done on native
 endian variables
Date: Wed, 14 Jan 2015 16:31:36 +0530
Message-ID: <b19b32918b2006044e58416092fcfbe7@mail.gmail.com>
References: <1420909883-19479-1-git-send-email-hch@lst.de> <1420909883-19479-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:54085 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbANLBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 06:01:38 -0500
Received: by mail-qa0-f53.google.com with SMTP id n4so6015549qaq.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 03:01:37 -0800 (PST)
In-Reply-To: <1420909883-19479-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@lst.de]
>Sent: Saturday, January 10, 2015 10:41 PM
>To: Sumit.Saxena@avagotech.com; kashyap.desai@avagotech.com
>Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org
>Subject: [PATCH 06/10] megaraid_sas: bytewise or should be done on native
>endian variables
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index 82439f9..b1e053b 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -673,7 +673,9 @@ megasas_ioc_init_fusion(struct megasas_instance
>*instance)
>
> 	frame_hdr = &cmd->frame->hdr;
> 	frame_hdr->cmd_status = 0xFF;
>-	frame_hdr->flags |=
>cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
>+	frame_hdr->flags = cpu_to_le16(
>+		le16_to_cpu(frame_hdr->flags) |
>+		MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
>
> 	init_frame->cmd	= MFI_CMD_INIT;
> 	init_frame->cmd_status = 0xFF;

Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>1.9.1
