From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 1/5] target: ensure se_cmd->t_prot_sg is allocated
 when required
Date: Sun, 26 Apr 2015 12:44:33 +0300
Message-ID: <553CB381.6090409@dev.mellanox.co.il>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com> <1429972410-7146-2-git-send-email-akinobu.mita@gmail.com> <553CAF32.2030904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <553CAF32.2030904@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/26/2015 12:26 PM, Sagi Grimberg wrote:
> On 4/25/2015 5:33 PM, Akinobu Mita wrote:
>> Even if the device backend is initialized with protection info is
>> enabled, some requests don't have the protection info attached for
>> WRITE SAME command issued by block device helpers, WRITE command with
>> WRPROTECT=0 by SG_IO ioctl, etc.
>>
>> So when TCM loopback fabric module is used, se_cmd->t_prot_sg is NULL
>> for these requests and performing WRITE_INSERT of PI using software
>> emulation by sbc_dif_generate() causes kernel crash.
>>
>> To fix this, introduce SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC for
>> se_cmd_flags, which is used to determine that se_cmd->t_prot_sg needs
>> to be allocated or use pre-allocated protection information by scsi
>> mid-layer.
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
>>   drivers/target/target_core_transport.c | 30
>> ++++++++++++++++++------------
>>   include/target/target_core_base.h      |  1 +
>>   2 files changed, 19 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/target/target_core_transport.c
>> b/drivers/target/target_core_transport.c
>> index 7a9e7e2..fe52883 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -1450,6 +1450,7 @@ int target_submit_cmd_map_sgls(struct se_cmd
>> *se_cmd, struct se_session *se_sess
>>       if (sgl_prot_count) {
>>           se_cmd->t_prot_sg = sgl_prot;
>>           se_cmd->t_prot_nents = sgl_prot_count;
>> +        se_cmd->se_cmd_flags |= SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC;
>>       }
>>
>>       /*
>> @@ -2181,6 +2182,12 @@ static inline void
>> transport_reset_sgl_orig(struct se_cmd *cmd)
>>
>>   static inline void transport_free_pages(struct se_cmd *cmd)
>>   {
>> +    if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
>> +        transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
>> +        cmd->t_prot_sg = NULL;
>> +        cmd->t_prot_nents = 0;
>> +    }
>> +
>
> Hi Akinobu,
>
> Any reason why this changed it's location to the start of the function?
>
>>       if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
>>           /*
>>            * Release special case READ buffer payload required for
>> @@ -2204,10 +2211,6 @@ static inline void transport_free_pages(struct
>> se_cmd *cmd)
>>       transport_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
>>       cmd->t_bidi_data_sg = NULL;
>>       cmd->t_bidi_data_nents = 0;
>> -
>> -    transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
>> -    cmd->t_prot_sg = NULL;
>> -    cmd->t_prot_nents = 0;
>>   }
>>
>>   /**
>> @@ -2346,6 +2349,17 @@ transport_generic_new_cmd(struct se_cmd *cmd)
>>       int ret = 0;
>>       bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
>>
>> +    if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
>> +        if (cmd->prot_op != TARGET_PROT_NORMAL) {
>
> This seems wrong,
>
> What will happen for transports that will actually to allocate
> protection SGLs? The allocation is unreachable since
> SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC is not set...

Umm, actually this is reachable... But I still think the condition
should be the other way around (saving a condition in some common
cases).

>
> I'd say this needs to be:
>
> if (cmd->prot_op != TARGET_PROT_NORMAL &&
>      !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
>
>> +            ret = target_alloc_sgl(&cmd->t_prot_sg,
>> +                           &cmd->t_prot_nents,
>> +                           cmd->prot_length, true);
>> +            if (ret < 0)
>> +                return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> +        }
>> +
>> +    }
>> +
>>       /*
>>        * Determine is the TCM fabric module has already allocated
>> physical
>>        * memory, and is directly calling
>> transport_generic_map_mem_to_cmd()
>> @@ -2371,14 +2385,6 @@ transport_generic_new_cmd(struct se_cmd *cmd)
>>                   return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>           }
>>
>> -        if (cmd->prot_op != TARGET_PROT_NORMAL) {
>> -            ret = target_alloc_sgl(&cmd->t_prot_sg,
>> -                           &cmd->t_prot_nents,
>> -                           cmd->prot_length, true);
>> -            if (ret < 0)
>> -                return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> -        }
>> -
>>           ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
>>                          cmd->data_length, zero_flag);
>>           if (ret < 0)
>> diff --git a/include/target/target_core_base.h
>> b/include/target/target_core_base.h
>> index 480e9f8..13efcdd 100644
>> --- a/include/target/target_core_base.h
>> +++ b/include/target/target_core_base.h
>> @@ -167,6 +167,7 @@ enum se_cmd_flags_table {
>>       SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
>>       SCF_COMPARE_AND_WRITE        = 0x00080000,
>>       SCF_COMPARE_AND_WRITE_POST    = 0x00100000,
>> +    SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
>>   };
>>
>>   /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
>>
>
