From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: eSATA Drive Detection issues on mvsas
Date: Thu, 17 Oct 2013 12:24:33 -0700
Message-ID: <CAPcyv4jvPYz0bpVXBG2+5dFKwPHoGrAa8pd55d1J5BNo0PV0fw@mail.gmail.com>
References: <525C89D3.5090008@logicube.com>
	<525DDABB.2040906@logicube.com>
	<CAPcyv4hdCYkdxoK_1zjdRt-vDHk0K8wLV6OnpnkXVGJzKg0PMg@mail.gmail.com>
	<525ECCB5.8040104@logicube.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62755 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762570Ab3JQTYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2013 15:24:34 -0400
Received: by mail-ee0-f44.google.com with SMTP id b47so1366537eek.31
        for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2013 12:24:33 -0700 (PDT)
In-Reply-To: <525ECCB5.8040104@logicube.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

On Wed, Oct 16, 2013 at 10:28 AM, Praveen Murali <pmurali@logicube.com> wrote:
>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>> index 161c98efade9..d0fb99d5da95 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(struct
>> ata_queued_cmd *qc)
>>                  qc->tf.nsect = 0;
>>          }
>>
>> -       ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
>> +       ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1,
>> (u8*)&task->ata_task.fis);
>>          task->uldd_task = qc;
>>          if (ata_is_atapi(qc->tf.protocol)) {
>>                  memcpy(task->ata_task.atapi_packet, qc->cdb,
>> qc->dev->cdb_len);
>>
> Hi Dan,
>   I tested this patch and it works great!
>

Thanks!  I'll send it up with your Reported-by and Tested-by.

--
Dan
