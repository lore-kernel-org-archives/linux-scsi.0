From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/2] target/rd: Don't pass imcomplete scatterlist entries
 to sbc_dif_verify_*
Date: Sun, 5 Apr 2015 21:42:46 +0900
Message-ID: <CAC5umyivMAXcO=OqSieEmTO4SVfLky29rjfcSaGa=VTi7iNHLg@mail.gmail.com>
References: <1428150268-30260-1-git-send-email-akinobu.mita@gmail.com>
	<1428150268-30260-2-git-send-email-akinobu.mita@gmail.com>
	<55210A27.5020001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55210A27.5020001@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: target-devel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2015-04-05 19:10 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/4/2015 3:24 PM, Akinobu Mita wrote:
>>
>> The scatterlist for protection information which is passed to
>> sbc_dif_verify_read() or sbc_dif_verify_write() requires that
>> neighboring scatterlist entries are contiguous or chained so that they
>> can be iterated by sg_next().
>>
>> However, the protection information for RD-MCP backends could be located
>> in the multiple scatterlist arrays when the ramdisk space is too large.
>> So if the read/write request straddles this boundary,
>> sbc_dif_verify_read()
>> or sbc_dif_verify_write() can't iterate all scatterlist entries.
>>
>> This fixes it by allocating temporary scatterlist if it is needed.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> Cc: Asias He <asias@redhat.com>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> Cc: target-devel@vger.kernel.org
>> Cc: linux-scsi@vger.kernel.org
>> ---
>>   drivers/target/target_core_rd.c | 39
>> +++++++++++++++++++++++++++++++++++----
>>   1 file changed, 35 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/target_core_rd.c
>> b/drivers/target/target_core_rd.c
>> index 4d614c9..19c893d 100644
>> --- a/drivers/target/target_core_rd.c
>> +++ b/drivers/target/target_core_rd.c
>> @@ -387,11 +387,12 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd
>> *cmd, bool is_write)
>>         struct se_device *se_dev = cmd->se_dev;
>>         struct rd_dev *dev = RD_DEV(se_dev);
>>         struct rd_dev_sg_table *prot_table;
>> +       bool need_to_release = false;
>>         struct scatterlist *prot_sg;
>>         u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
>> -       u32 prot_offset, prot_page;
>> +       u32 prot_offset, prot_page, prot_npages;
>>         u64 tmp;
>> -       sense_reason_t rc;
>> +       sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>         sense_reason_t (*dif_verify)(struct se_cmd *, sector_t, unsigned
>> int,
>>                         unsigned int, struct scatterlist *, int) =
>>                 is_write ?  sbc_dif_verify_write : sbc_dif_verify_read;
>> @@ -404,10 +405,40 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd
>> *cmd, bool is_write)
>>         if (!prot_table)
>>                 return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>
>> -       prot_sg = &prot_table->sg_table[prot_page -
>> -                                       prot_table->page_start_offset];
>> +       prot_npages = DIV_ROUND_UP(prot_offset + sectors *
>> se_dev->prot_length,
>> +                                  PAGE_SIZE);
>> +
>> +       /* prot pages straddles multiple scatterlist tables */
>> +       if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
>> +               int i;
>> +
>> +               prot_sg = kcalloc(prot_npages, sizeof(*prot_sg),
>> GFP_KERNEL);
>> +               if (!prot_sg)
>> +                       return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> +
>> +               need_to_release = true;
>> +               sg_init_table(prot_sg, prot_npages);
>> +
>> +               for (i = 0; i < prot_npages; i++) {
>> +                       if (prot_page + i > prot_table->page_end_offset) {
>> +                               prot_table = rd_get_prot_table(dev,
>> +                                                               prot_page
>> + i);
>> +                               if (!prot_table)
>> +                                       goto out;
>> +                               sg_unmark_end(&prot_sg[i - 1]);
>> +                       }
>> +                       prot_sg[i] = prot_table->sg_table[prot_page + i -
>> +
>> prot_table->page_start_offset];
>> +               }
>> +       } else {
>> +               prot_sg = &prot_table->sg_table[prot_page -
>> +
>> prot_table->page_start_offset];
>> +       }
>>
>>         rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg,
>> prot_offset);
>> +out:
>> +       if (need_to_release)
>> +               kfree(prot_sg);
>
>
> I think it is safe to free prot_sg if you just make sure to initialize
> it to NULL at declaration time, no need for 'need_to_release'.

'need_to_release' is required to avoid kfree when 'prot_sg' is
initialized to a pointer in the real prot space (i.e. "else" case above).
