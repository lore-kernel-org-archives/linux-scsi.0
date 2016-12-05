From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Mon, 5 Dec 2016 11:56:22 +0530
Message-ID: <CAFqt6zbx45Gx4fN4Hv6PZLGsQB8FEK=mjxwAYVNDEpKbOZR+7g@mail.gmail.com>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15> <CAFqt6zbQn4YivsKG3X5Y2OWK92LaUk5nbe+oUheF111ZONULOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32834 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbcLEG0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 01:26:24 -0500
Received: by mail-io0-f195.google.com with SMTP id j92so20545459ioi.0
        for <linux-scsi@vger.kernel.org>; Sun, 04 Dec 2016 22:26:23 -0800 (PST)
In-Reply-To: <CAFqt6zbQn4YivsKG3X5Y2OWK92LaUk5nbe+oUheF111ZONULOw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

Hi Martin,

Any comment on this patch?

On Thu, Dec 1, 2016 at 11:34 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> On Mon, Nov 28, 2016 at 4:56 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
>> replaced by pci_pool_zalloc()
>>
>> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
>> ---
>>  drivers/scsi/mvsas/mv_sas.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
>> index 86eb199..681e5f7 100644
>> --- a/drivers/scsi/mvsas/mv_sas.c
>> +++ b/drivers/scsi/mvsas/mv_sas.c
>> @@ -790,10 +790,9 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
>>         slot->n_elem = n_elem;
>>         slot->slot_tag = tag;
>>
>> -       slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
>> +       slot->buf = pci_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
>>         if (!slot->buf)
>>                 goto err_out_tag;
>> -       memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
>>
>>         tei.task = task;
>>         tei.hdr = &mvi->slot[tag];
>> --
>> 1.9.1
>
> Any Comment on this patch?
>>

Regards
Souptick
