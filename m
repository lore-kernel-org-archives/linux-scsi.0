From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH v2] scsi: qla4xxx: Use dma_pool_zalloc
Date: Fri, 13 Jan 2017 11:45:30 +0000
Message-ID: <D49EBA4A.43ECD%nilesh.javali@cavium.com>
References: <20161222121258.GA8278@gnr743-HP-ZBook-15>
 <CAFqt6zaGvYZ3ncdXtbrSphCMtyj+F=xtM5_dma3uEvDKODgdBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0054.outbound.protection.outlook.com ([104.47.36.54]:64224
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751406AbdAMLpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 06:45:33 -0500
In-Reply-To: <CAFqt6zaGvYZ3ncdXtbrSphCMtyj+F=xtM5_dma3uEvDKODgdBw@mail.gmail.com>
Content-Language: en-US
Content-ID: <0891F6B83C9E194E8769E943F11C5A0C@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Rameshwar Sahu <sahu.rameshwar73@gmail.com>



On 02/01/17, 11:10 AM, "Souptick Joarder" <jrdr.linux@gmail.com> wrote:

>Hi Nilesh,
>
>On Thu, Dec 22, 2016 at 5:42 PM, Souptick Joarder <jrdr.linux@gmail.com>
>wrote:
>> We should use dma_pool_zalloc instead of dma_pool_alloc/memset
>>
>> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
>> ---
>> v2 changes:
>>    - Address comment from Nilesh to make same change in
>>      all applicable places inside qla4xxx source
>>
>>  drivers/scsi/qla4xxx/ql4_mbx.c | 6 ++----
>>  drivers/scsi/qla4xxx/ql4_os.c  | 4 +---
>>  2 files changed, 3 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
>>b/drivers/scsi/qla4xxx/ql4_mbx.c
>> index c291fdf..8f97839 100644
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
>> @@ -1651,13 +1650,12 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha,
>>char *username, char *password,
>>         uint32_t chap_size =3D 0;
>>         dma_addr_t chap_dma;
>>
>> -       chap_table =3D dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL,
>>&chap_dma);
>> +       chap_table =3D dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL,
>>&chap_dma);
>>         if (chap_table =3D=3D NULL) {
>>                 ret =3D  -ENOMEM;
>>                 goto exit_set_chap;
>>         }
>>
>> -       memset(chap_table, 0, sizeof(struct ql4_chap_table));
>>         if (bidi)
>>                 chap_table->flags |=3D BIT_6; /* peer */
>>         else
>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c
>>b/drivers/scsi/qla4xxx/ql4_os.c
>> index 01c3610..0c91c89 100644
>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>> @@ -825,12 +825,10 @@ static int qla4xxx_delete_chap(struct Scsi_Host
>>*shost, uint16_t chap_tbl_idx)
>>         uint32_t chap_size;
>>         int ret =3D 0;
>>
>> -       chap_table =3D dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL,
>>&chap_dma);
>> +       chap_table =3D dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL,
>>&chap_dma);
>>         if (chap_table =3D=3D NULL)
>>                 return -ENOMEM;
>>
>> -       memset(chap_table, 0, sizeof(struct ql4_chap_table));
>> -
>>         if (is_qla80XX(ha))
>>                 max_chap_entries =3D (ha->hw.flt_chap_size / 2) /
>>                                    sizeof(struct ql4_chap_table);
>> --
>> 1.9.1
>>
>
>Any further comment on this patch ?

Any reason for handling this only for CHAP related code and not take care
at all other places within ql4_os.c and ql4_init.c.
According to me the change should be consistent across all the affecting
files unless you think otherwise.

Thanks,
Nilesh

