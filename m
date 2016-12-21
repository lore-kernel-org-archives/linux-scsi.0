From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: qla4xxx: Use dma_pool_zalloc
Date: Wed, 21 Dec 2016 18:54:15 +0530
Message-ID: <CAFqt6zZeHSkfJMwywxU5xw2pp3tXVE2AGa4uph21MT_sze0shQ@mail.gmail.com>
References: <20161206202304.GA6884@jordon-HP-15-Notebook-PC>
 <CAFqt6zZ6uAEt4yxbbQKSGnCrOKmAtToKZvBRYwHWVp8=b6aifQ@mail.gmail.com>
 <D475CBED.43667%nilesh.javali@cavium.com> <CAFqt6zaZ0cJJU1a7Bq=LbbdF24iHSRheBCH2+yii3EJpMXN-Og@mail.gmail.com>
 <D48066D7.438B8%nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35279 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757742AbcLUNYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2016 08:24:33 -0500
Received: by mail-io0-f195.google.com with SMTP id f73so25657048ioe.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2016 05:24:16 -0800 (PST)
In-Reply-To: <D48066D7.438B8%nilesh.javali@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Cc: "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Dec 21, 2016 at 5:13 PM, Javali, Nilesh
<Nilesh.Javali@cavium.com> wrote:
>
>
> On 13/12/16, 6:35 PM, "Souptick Joarder" <jrdr.linux@gmail.com> wrote:
>
>>On Tue, Dec 13, 2016 at 4:11 PM, Javali, Nilesh
>><Nilesh.Javali@cavium.com> wrote:
>>>
>>>
>>> On 12/12/16, 10:16 AM, "linux-scsi-owner@vger.kernel.org on behalf of
>>> Souptick Joarder" <linux-scsi-owner@vger.kernel.org on behalf of
>>> jrdr.linux@gmail.com> wrote:
>>>
>>>>On Wed, Dec 7, 2016 at 1:53 AM, Souptick Joarder <jrdr.linux@gmail.com>
>>>>wrote:
>>>>> We should use dma_pool_zalloc instead of dma_pool_alloc/memset
>>>>>
>>>>> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
>>>>> ---
>>>>>  drivers/scsi/qla4xxx/ql4_mbx.c | 3 +--
>>>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
>>>>>b/drivers/scsi/qla4xxx/ql4_mbx.c
>>>>> index c291fdf..f2edfd7 100644
>>>>> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
>>>>> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
>>>>> @@ -1587,12 +1587,11 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha,
>>>>>char *username, char *password,
>>>>>         struct ql4_chap_table *chap_table;
>>>>>         dma_addr_t chap_dma;
>>>>>
>>>>> -       chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL,
>>>>>&chap_dma);
>>>>> +       chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL,
>>>>>&chap_dma);
>>>>>         if (chap_table == NULL)
>>>>>                 return -ENOMEM;
>>>>>
>>>>>         chap_size = sizeof(struct ql4_chap_table);
>>>>> -       memset(chap_table, 0, chap_size);
>>>>>
>>>>>         if (is_qla40XX(ha))
>>>>>                 offset = FLASH_CHAP_OFFSET | (idx * chap_size);
>>>>> --
>>>>> 1.9.1
>>>>>
>>>>
>>>>Any comment on this patch?
>>>
>>> There are multiple other places where dma_pool_alloc needs to be
>>>replaced
>>> by dma_pool_zalloc.
>>
>>
>> are you asking to do this for SCSI subsystem?
>> If yes, I can do that.
>>
>>>
>>> Can you please take care within a single patch.
>>
>> But the same changes are applicable in other subsystems as well.
>> I think I shouldn't send those changes in a single patch as
>>maintainers are different
>> for different modules.
>
> I'm referring to multiple other files within qla4xxx source which uses
> dma_pool_alloc.
> The current patch takes care only of ql4_mbx.c and qla4xxx_get_chap
> function.
> There is qla4xxx_set_chap function as well. Also ql4_init.c and ql4_os.c
> files also use dma_pool_alloc.
> I was requesting to make all these changes related to qla4xxx module
> within a single patch.

Well I will do that.
>
> Thanks,
> Nilesh
>
