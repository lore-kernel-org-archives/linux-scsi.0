From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 05/10] megaraid_sas: move endianess conversion into caller
 of megasas_get_seq_num
Date: Tue, 13 Jan 2015 12:53:50 +0530
Message-ID: <8c13640f4bbb98a34482802bb4057bb0@mail.gmail.com>
References: <1420909883-19479-1-git-send-email-hch@lst.de> <1420909883-19479-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:58968 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbbAMHaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2015 02:30:02 -0500
Received: by mail-qa0-f46.google.com with SMTP id j7so994150qaq.5
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 23:29:58 -0800 (PST)
In-Reply-To: <1420909883-19479-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@lst.de]
>Sent: Saturday, January 10, 2015 10:41 PM
>To: Sumit.Saxena@avagotech.com; kashyap.desai@avagotech.com
>Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org
>Subject: [PATCH 05/10] megaraid_sas: move endianess conversion into
caller
>of megasas_get_seq_num
>
>Converting structure fields in place is always a bad idea, and in this
case by
>moving it into the only caller we also only have to do a single byte swap
as
>most fields of this structure are never used.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index a6556ea..548d033 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4823,11 +4823,11 @@ megasas_get_seq_num(struct megasas_instance
>*instance,
> 		/*
> 		 * Copy the data back into callers buffer
> 		 */
>-		eli->newest_seq_num = le32_to_cpu(el_info-
>>newest_seq_num);
>-		eli->oldest_seq_num = le32_to_cpu(el_info-
>>oldest_seq_num);
>-		eli->clear_seq_num = le32_to_cpu(el_info->clear_seq_num);
>-		eli->shutdown_seq_num = le32_to_cpu(el_info-
>>shutdown_seq_num);
>-		eli->boot_seq_num = le32_to_cpu(el_info->boot_seq_num);
>+		eli->newest_seq_num = el_info->newest_seq_num;
>+		eli->oldest_seq_num = el_info->oldest_seq_num;
>+		eli->clear_seq_num = el_info->clear_seq_num;
>+		eli->shutdown_seq_num = el_info->shutdown_seq_num;
>+		eli->boot_seq_num = el_info->boot_seq_num;
> 	}
>
> 	pci_free_consistent(instance->pdev, sizeof(struct
>megasas_evt_log_info), @@ -4991,7 +4991,7 @@ static int
>megasas_start_aen(struct megasas_instance *instance)
> 	class_locale.members.class = MR_EVT_CLASS_DEBUG;
>
> 	return megasas_register_aen(instance,
>-			eli.newest_seq_num + 1,
>+			le32_to_cpu(eli.newest_seq_num) + 1,
> 			class_locale.word);
> }
>
Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>1.9.1
