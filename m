From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH] scsi: qla4xxx: Use dma_pool_zalloc
Date: Tue, 13 Dec 2016 10:41:15 +0000
Message-ID: <D475CBED.43667%nilesh.javali@cavium.com>
References: <20161206202304.GA6884@jordon-HP-15-Notebook-PC>
 <CAFqt6zZ6uAEt4yxbbQKSGnCrOKmAtToKZvBRYwHWVp8=b6aifQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0085.outbound.protection.outlook.com ([104.47.40.85]:6659
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752056AbcLMK4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Dec 2016 05:56:51 -0500
In-Reply-To: <CAFqt6zZ6uAEt4yxbbQKSGnCrOKmAtToKZvBRYwHWVp8=b6aifQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <5162472D5616F94797C9A9971E701546@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On 12/12/16, 10:16 AM, "linux-scsi-owner@vger.kernel.org on behalf of
Souptick Joarder" <linux-scsi-owner@vger.kernel.org on behalf of
jrdr.linux@gmail.com> wrote:

>On Wed, Dec 7, 2016 at 1:53 AM, Souptick Joarder <jrdr.linux@gmail.com>
>wrote:
>> We should use dma_pool_zalloc instead of dma_pool_alloc/memset
>>
>> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
>> ---
>>  drivers/scsi/qla4xxx/ql4_mbx.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
>>b/drivers/scsi/qla4xxx/ql4_mbx.c
>> index c291fdf..f2edfd7 100644
>> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
>> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
>> @@ -1587,12 +1587,11 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha,
>>char *username, char *password,
>>         struct ql4_chap_table *chap_table;
>>         dma_addr_t chap_dma;
>>
>> -       chap_table =3D dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL,
>>&chap_dma);
>> +       chap_table =3D dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL,
>>&chap_dma);
>>         if (chap_table =3D=3D NULL)
>>                 return -ENOMEM;
>>
>>         chap_size =3D sizeof(struct ql4_chap_table);
>> -       memset(chap_table, 0, chap_size);
>>
>>         if (is_qla40XX(ha))
>>                 offset =3D FLASH_CHAP_OFFSET | (idx * chap_size);
>> --
>> 1.9.1
>>
>
>Any comment on this patch?

There are multiple other places where dma_pool_alloc needs to be replaced
by dma_pool_zalloc.

Can you please take care within a single patch.

Thanks,
Nilesh

