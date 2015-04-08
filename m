From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 2/2] target/rd: Don't pass imcomplete scatterlist
 entries to sbc_dif_verify_*
Date: Wed, 8 Apr 2015 23:25:25 +0900
Message-ID: <CAC5umyh7HrDZekc6uhM_jvybyL3mYzG=1DaHDHngOPLM4CuvSw@mail.gmail.com>
References: <1428245979-5432-1-git-send-email-akinobu.mita@gmail.com>
	<1428245979-5432-2-git-send-email-akinobu.mita@gmail.com>
	<1428470039.18203.29.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36081 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbbDHOZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 10:25:27 -0400
In-Reply-To: <1428470039.18203.29.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2015-04-08 14:13 GMT+09:00 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> On Sun, 2015-04-05 at 23:59 +0900, Akinobu Mita wrote:
>> The scatterlist for protection information which is passed to
>> sbc_dif_verify_read() or sbc_dif_verify_write() requires that
>> neighboring scatterlist entries are contiguous or chained so that they
>> can be iterated by sg_next().
>>
>> However, the protection information for RD-MCP backends could be located
>> in the multiple scatterlist arrays when the ramdisk space is too large.
>> So if the read/write request straddles this boundary, sbc_dif_verify_read()
>> or sbc_dif_verify_write() can't iterate all scatterlist entries.
>>
>> This fixes it by allocating temporary scatterlist if it is needed.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> Cc: target-devel@vger.kernel.org
>> Cc: linux-scsi@vger.kernel.org
>> ---
>> * No change from v1
>>
>>  drivers/target/target_core_rd.c | 39 +++++++++++++++++++++++++++++++++++----
>>  1 file changed, 35 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
>> index ac5e8d2..6e25eaa 100644
>> --- a/drivers/target/target_core_rd.c
>> +++ b/drivers/target/target_core_rd.c
>> @@ -390,11 +390,12 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
>>       struct se_device *se_dev = cmd->se_dev;
>>       struct rd_dev *dev = RD_DEV(se_dev);
>>       struct rd_dev_sg_table *prot_table;
>> +     bool need_to_release = false;
>>       struct scatterlist *prot_sg;
>>       u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
>> -     u32 prot_offset, prot_page;
>> +     u32 prot_offset, prot_page, prot_npages;
>>       u64 tmp;
>> -     sense_reason_t rc;
>> +     sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>
>>       tmp = cmd->t_task_lba * se_dev->prot_length;
>>       prot_offset = do_div(tmp, PAGE_SIZE);
>> @@ -404,10 +405,40 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
>>       if (!prot_table)
>>               return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>
>> -     prot_sg = &prot_table->sg_table[prot_page -
>> -                                     prot_table->page_start_offset];
>> +     prot_npages = DIV_ROUND_UP(prot_offset + sectors * se_dev->prot_length,
>> +                                PAGE_SIZE);
>> +
>> +     /* prot pages straddles multiple scatterlist tables */
>> +     if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
>> +             int i;
>> +
>> +             prot_sg = kcalloc(prot_npages, sizeof(*prot_sg), GFP_KERNEL);
>> +             if (!prot_sg)
>> +                     return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> +
>> +             need_to_release = true;
>> +             sg_init_table(prot_sg, prot_npages);
>> +
>> +             for (i = 0; i < prot_npages; i++) {
>> +                     if (prot_page + i > prot_table->page_end_offset) {
>> +                             prot_table = rd_get_prot_table(dev,
>> +                                                             prot_page + i);
>> +                             if (!prot_table)
>> +                                     goto out;
>> +                             sg_unmark_end(&prot_sg[i - 1]);
>> +                     }
>> +                     prot_sg[i] = prot_table->sg_table[prot_page + i -
>> +                                             prot_table->page_start_offset];
>> +             }
>> +     } else {
>> +             prot_sg = &prot_table->sg_table[prot_page -
>> +                                             prot_table->page_start_offset];
>> +     }
>>
>
> Mmm, how about just explicitly doing sg_link() at prot_table scatterlist
> creation time instead..?

Yeap, that would be an optimal solution.  But some architectures don't
support sg chaining (i.e. !CONFIG_ARCH_HAS_SG_CHAIN).

> That would save the extra allocation above, and AFAICT make for simpler
> code.

Do you prefer fixing it conditionally with using #ifdef ? (i.e.
sg chaining at creating time if CONFIG_ARCH_HAS_SG_CHAIN is defined,
otherwise do the extra allocation above) If so, I'll resubmit the
patch with such changes.
