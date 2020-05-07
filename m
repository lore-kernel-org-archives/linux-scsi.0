Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15405C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 17:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B3A216FD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 17:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEGR1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 13:27:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44427 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgEGR1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 13:27:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id b8so2202010plm.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2020 10:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AKAUo2hDVNZwLJQKku3hqaFIc8jCIvPrbLAo8vppp/E=;
        b=ESL61FYfT5V0SFc3rKPR1Va88STlXtlr5pnrYOqNCbvVFlsx0dHWfju4PnmImhg5rf
         97hv7a02/KuFl3wfIRYG317jgJveBfDgAsoi7xXVru/JaM3H+hpD/DDeIyiK+Y8iKiik
         tS3Q7mY+YpubnIOIK+rFuk+kLpcUu6Ya2LJ9PTTRix9gDKm1y/IBuleSUHGAMt9tEQOO
         g3ISp3xCtDBDy39XahTdvHkblxx7OMhyHsmVv8a4CNdCvNkuoi+c5yIKbtE5swKIxpeB
         KaI1ZBs3mDkz1rsFVv+druPfL7Vl9RLNDGJlE3ei4LgCEf0EhvEFi0Jh+nlupalE9wh8
         p9iA==
X-Gm-Message-State: AGi0PuZV3WYFQ3syhudgZKMNqmbff7kkpU7NsePKRpdP4oA+8aKgUjRP
        9PUXhra/mghzMSuy9N4gfPg=
X-Google-Smtp-Source: APiQypI/GG0hbePOIgD6cBbyoRPshv1QYpBQlgcWY1vKgw5IKgF7tiihc3Ap8zcyU+I58O+MO5JZ8g==
X-Received: by 2002:a17:90b:1498:: with SMTP id js24mr1213887pjb.214.1588872465159;
        Thu, 07 May 2020 10:27:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id x12sm5391206pfo.62.2020.05.07.10.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 10:27:44 -0700 (PDT)
Subject: Re: [PATCH v5 11/11] qla2xxx: Fix endianness annotations in source
 files
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200507042835.9135-1-bvanassche@acm.org>
 <20200507042835.9135-12-bvanassche@acm.org>
 <6c52c7a8-6625-69c3-095b-146a300e94a5@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <a653092b-3212-dc46-8bca-a391ca929a68@acm.org>
Date:   Thu, 7 May 2020 10:27:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6c52c7a8-6625-69c3-095b-146a300e94a5@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-07 02:05, Hannes Reinecke wrote:
> On 5/7/20 6:28 AM, Bart Van Assche wrote:
>> @@ -2679,8 +2680,8 @@ qla24xx_els_logo_iocb(srb_t *sp, struct
>> els_entry_24xx *els_iocb)
>>       els_iocb->sys_define = 0;
>>       els_iocb->entry_status = 0;
>>       els_iocb->handle = sp->handle;
>> -    els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
>> -    els_iocb->tx_dsd_count = 1;
>> +    els_iocb->nport_handle = sp->fcport->loop_id;
>> +    els_iocb->tx_dsd_count = cpu_to_le16(1);
>>       els_iocb->vp_index = vha->vp_idx;
>>       els_iocb->sof_type = EST_SOFI3;
>>       els_iocb->rx_dsd_count = 0;
> 
> Why did you drop the cpu_to_le16 for the loop_id?
> I was under the impression we'll store it in machine-native format,
> don't we?

Thanks for having pointed this out. I will restore the cpu_to_le16()
call and annotate els_iocb->nport_handle as little endian.

>> @@ -3022,7 +3023,7 @@ qla24xx_els_iocb(srb_t *sp, struct
>> els_entry_24xx *els_iocb)
>>           els_iocb->sys_define = 0;
>>           els_iocb->entry_status = 0;
>>           els_iocb->handle = sp->handle;
>> -        els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
>> +    els_iocb->nport_handle = sp->fcport->loop_id;
>>       els_iocb->tx_dsd_count =
>> cpu_to_le16(bsg_job->request_payload.sg_cnt);
>>       els_iocb->vp_index = sp->vha->vp_idx;
>>           els_iocb->sof_type = EST_SOFI3;
> 
> Same here.

I will restore this cpu_to_le16() call too.

>> @@ -1817,23 +1817,22 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha,
>> struct req_que *req,
>>       }
>>         comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
>> -    fw_status[1] = le16_to_cpu(((struct els_sts_entry_24xx
>> *)pkt)->error_subcode_1);
>> -    fw_status[2] = le16_to_cpu(((struct els_sts_entry_24xx
>> *)pkt)->error_subcode_2);
>> +    fw_status[1] = le32_to_cpu(ese->error_subcode_1);
>> +    fw_status[2] = le32_to_cpu(ese->error_subcode_2);
>>         if (iocb_type == ELS_IOCB_TYPE) {
>>           els = &sp->u.iocb_cmd;
>>           els->u.els_plogi.fw_status[0] = fw_status[0];
>>           els->u.els_plogi.fw_status[1] = fw_status[1];
>>           els->u.els_plogi.fw_status[2] = fw_status[2];
>> -        els->u.els_plogi.comp_status = fw_status[0];
>> +        els->u.els_plogi.comp_status = cpu_to_le16(fw_status[0]);
> 
> ???
> Why only this line?
> fw_status is kept in host-endianness; shouldn't all of the above
> assignments being done with cpu_to_le16?

Will fix this too.

>> @@ -1842,8 +1841,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha,
>> struct req_que *req,
>>           ql_dbg(ql_dbg_user, vha, 0x503f,
>>               "ELS IOCB Done -%s error hdl=%x comp_status=0x%x error
>> subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
>>               type, sp->handle, comp_status, fw_status[1], fw_status[2],
>> -            le16_to_cpu(((struct els_sts_entry_24xx *)
>> -            pkt)->total_byte_count));
>> +            le32_to_cpu(ese->total_byte_count));
>>           goto els_ct_done;
>>       }
>>   
> 
> Switch from 16 to 32 bits?

total_byte_count is a 32-bits variable, hence le32_to_cpu() instead of
le16_to_cpu(). Sparse checks whether the proper conversion function is used.

>>               ql_dbg(ql_dbg_user, vha, 0x5040,
>>                   "ELS-CT pass-through-%s error hdl=%x
>> comp_status-status=0x%x "
>>                   "error subcode 1=0x%x error subcode 2=0x%x.\n",
>>                   type, sp->handle, comp_status,
>> -                le16_to_cpu(((struct els_sts_entry_24xx *)
>> -                pkt)->error_subcode_1),
>> -                le16_to_cpu(((struct els_sts_entry_24xx *)
>> -                    pkt)->error_subcode_2));
>> +                le32_to_cpu(ese->error_subcode_1),
>> +                le32_to_cpu(ese->error_subcode_2));
>>               res = DID_ERROR << 16;
>>               bsg_reply->reply_payload_rcv_len = 0;
>>           }
> 
> Same here.

As you may know error_subcode_1 and 2 are 32-bits variables.

>> @@ -3110,8 +3109,8 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha,
>> struct link_statistics *stats,
>>       mc.mb[6] = MSW(MSD(stats_dma));
>>       mc.mb[7] = LSW(MSD(stats_dma));
>>       mc.mb[8] = dwords;
>> -    mc.mb[9] = cpu_to_le16(vha->vp_idx);
>> -    mc.mb[10] = cpu_to_le16(options);
>> +    mc.mb[9] = vha->vp_idx;
>> +    mc.mb[10] = options;
>>         rval = qla24xx_send_mb_cmd(vha, &mc);
>>   
> 
> Why has the converstion been dropped here?
> 'vp_idx' surely is in machine-native endianness?

I think that his has been explained in the description of this patch:
"Annotate the mb[] arrays as CPU-endian because communication of the
mb[] values with the hardware happens through the readw() and writew()
functions. readw() converts from __le16 to u16 and writew() converts
from u16 to __le16."

>> @@ -4743,7 +4742,7 @@ qla82xx_set_driver_version(scsi_qla_host_t *vha,
>> char *version)
>>       mcp->mb[1] = RNID_TYPE_SET_VERSION << 8;
>>       mcp->out_mb = MBX_1|MBX_0;
>>       for (i = 4; i < 16 && len; i++, str++, len -= 2) {
>> -        mcp->mb[i] = cpu_to_le16p(str);
>> +        mcp->mb[i] = le16_to_cpup(str);
>>           mcp->out_mb |= 1<<i;
>>       }
>>       for (; i < 16; i++) {
> 
> That looks _soo_ wrong.
> The mailbox is most likely in firmware/HBA endianness, so why the
> conversion?

Same explanation as above: rd_reg_word() is used to read mailbox
registers. Hence, mcp->mb[] has CPU-endianness.

>>           break;
>>         case MBA_REJECTED_FCP_CMD:
>>           ql_dbg(ql_dbg_tgt_mgt, vha, 0xf017,
>>               "qla_target(%d): Async event LS_REJECT occurred
>> (m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)",
>>               vha->vp_idx,
>> -            le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
>> -            le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
>> +            mailbox[0], mailbox[1], mailbox[2], mailbox[3]);
>>   -        if (le16_to_cpu(mailbox[3]) == 1) {
>> +        if (mailbox[3] == 1) {
>>               /* exchange starvation. */
>>               vha->hw->exch_starvation++;
>>               if (vha->hw->exch_starvation > 5) {
> 
> I would argue that we should keep the conversions here; otherwise the
> mailbox contents will be really hard to read on big endian.

Doesn't rd_reg_word() convert already from little endian to CPU endian?

>> @@ -6729,7 +6729,7 @@ qlt_init_atio_q_entries(struct scsi_qla_host *vha)
>>           return;
>>         for (cnt = 0; cnt < ha->tgt.atio_q_length; cnt++) {
>> -        pkt->u.raw.signature = ATIO_PROCESSED;
>> +        pkt->u.raw.signature = cpu_to_le32(ATIO_PROCESSED);
>>           pkt++;
>>       }
>>   @@ -6764,7 +6764,7 @@ qlt_24xx_process_atio_queue(struct
>> scsi_qla_host *vha, uint8_t ha_locked)
>>                   "corrupted fcp frame SID[%3phN] OXID[%04x] EXCG[%x]
>> %64phN\n",
>>                   &pkt->u.isp24.fcp_hdr.s_id,
>>                   be16_to_cpu(pkt->u.isp24.fcp_hdr.ox_id),
>> -                le32_to_cpu(pkt->u.isp24.exchange_addr), pkt);
>> +                pkt->u.isp24.exchange_addr, pkt);
>>                 adjust_corrupted_atio(pkt);
>>               qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
> 
> Why did you drop the conversion for the exchange address?
> Is it in machine native format already?

I will restore that conversion and I will annotate the exchange
addresses as little endian. Apparently that got overlooked.

>> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c
>> b/drivers/scsi/qla2xxx/qla_tmpl.c
>> index 3f52d5af3e8a..d241929d6dd5 100644
>> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
>> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
>> @@ -922,9 +922,9 @@ qla27xx_firmware_info(struct scsi_qla_host *vha,
>>       tmp->firmware_version[0] = vha->hw->fw_major_version;
>>       tmp->firmware_version[1] = vha->hw->fw_minor_version;
>>       tmp->firmware_version[2] = vha->hw->fw_subminor_version;
>> -    tmp->firmware_version[3] = cpu_to_le32(
>> +    tmp->firmware_version[3] = (__force u32)cpu_to_le32(
>>           vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
>> -    tmp->firmware_version[4] = cpu_to_le32(
>> +    tmp->firmware_version[4] = (__force u32)cpu_to_le32(
>>         vha->hw->fw_attributes_ext[1] << 16 |
>> vha->hw->fw_attributes_ext[0]);
>>   }
>>  
> In general this is really hard to review, as you move the function
> arguments around together with the missing/wrong annotations.
> Can't you split it off into one patch for the missing annotations and
> another one which moves the function argument (and annotations)?
> (Or, maybe, the other way around; the first one moving the function
> arguments and annotations touched by this, and the second one for
> the remaining fixes...)

Did I really move function arguments around in this patch? This patch
should only includes changes related to endianness.

Thanks for the review,

Bart.

