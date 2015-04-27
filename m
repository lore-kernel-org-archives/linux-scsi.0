From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 5/5] target/file: enable WRITE SAME when protection
 info is enabled
Date: Mon, 27 Apr 2015 22:02:06 +0900
Message-ID: <CAC5umygSWWQW9kb+dp1nQvxfgxrX_HZKikTiO96Aq+RBQYTZ_w@mail.gmail.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<1429972410-7146-6-git-send-email-akinobu.mita@gmail.com>
	<553CB6BF.8090601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35461 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784AbbD0NCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2015 09:02:07 -0400
In-Reply-To: <553CB6BF.8090601@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: target-devel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2015-04-26 18:58 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/25/2015 5:33 PM, Akinobu Mita wrote:
>>
>> Now we can generate correct PI for WRITE SAME command, so it is
>> unnecessary to disallow WRITE SAME when protection info is enabled.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> Cc: Sagi Grimberg <sagig@mellanox.com>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> Cc: target-devel@vger.kernel.org
>> Cc: linux-scsi@vger.kernel.org
>> ---
>> * No change from v2
>>
>>   drivers/target/target_core_file.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/target/target_core_file.c
>> b/drivers/target/target_core_file.c
>> index 829817a..fe98f58 100644
>> --- a/drivers/target/target_core_file.c
>> +++ b/drivers/target/target_core_file.c
>> @@ -376,16 +376,12 @@ fd_execute_write_same(struct se_cmd *cmd)
>>         struct bio_vec *bvec;
>>         unsigned int len = 0, i;
>>         ssize_t ret;
>> +       sense_reason_t rc;
>>
>>         if (!nolb) {
>>                 target_complete_cmd(cmd, SAM_STAT_GOOD);
>>                 return 0;
>>         }
>> -       if (cmd->prot_op) {
>> -               pr_err("WRITE_SAME: Protection information with FILEIO"
>> -                      " backends not supported\n");
>> -               return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> -       }
>>
>>         if (cmd->t_data_nents > 1 ||
>>             cmd->t_data_sg[0].length !=
>> cmd->se_dev->dev_attrib.block_size) {
>> @@ -397,6 +393,10 @@ fd_execute_write_same(struct se_cmd *cmd)
>>                 return TCM_INVALID_CDB_FIELD;
>>         }
>>
>> +       rc = sbc_dif_verify(cmd, cmd->t_task_lba, nolb, 0, cmd->t_prot_sg,
>> 0);
>> +       if (rc)
>> +               return rc;
>> +
>>         bvec = kcalloc(nolb, sizeof(struct bio_vec), GFP_KERNEL);
>>         if (!bvec)
>>                 return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> @@ -418,6 +418,14 @@ fd_execute_write_same(struct se_cmd *cmd)
>>                 return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>         }
>>
>> +       if (cmd->prot_op) {
>> +               ret = fd_do_rw(cmd, fd_dev->fd_prot_file,
>> se_dev->prot_length,
>> +                               cmd->t_prot_sg, cmd->t_prot_nents,
>> +                               cmd->prot_length, 1);
>> +               if (ret < 0)
>> +                       return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> +       }
>> +
>>         target_complete_cmd(cmd, SAM_STAT_GOOD);
>>         return 0;
>>   }
>>
>
> This looks good,

As you pointed out in the other mail, this change doesn't work with
a real HW fabric because it doesn't generate multiple same protection
fields for a single data block currently.

So I'm considering dropping this from this patch series for now.

> iblock is needed too though. I think you just need a missing call to
> iblock_alloc_bip() and you're good to go (you can use scsi_debug with
> dif/dix to test it). I think it belongs in the same patch.

Thanks for the information.  I'll take a look.
