Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A30C433ED
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 11:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4095E6139E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 11:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbhDELvh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Apr 2021 07:51:37 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.231]:11147 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234066AbhDELvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2021 07:51:37 -0400
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2021 07:51:36 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id F05CE11BFD
        for <linux-scsi@vger.kernel.org>; Mon,  5 Apr 2021 06:28:00 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id TNOilFKZl1cHeTNOilasOm; Mon, 05 Apr 2021 06:28:00 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HaWJIx9QeSqGp2WKMyVfEtnUrLjEtHZaXIhZVm4fNpc=; b=eHKvRnIe33xRix7VMunTV+PXV3
        okw/dXK3ZaF5dNLdTBX2EYLAaLi8U0w5t9m0i5mvBgjTF3IO9o6XAMeuc+ZaMwll0JPbzN9ULFuo6
        p97YiDoosS94JVaqI64vktrUYTNRZGwthrI0QOiv1zeccTo8ES1//QtPBVkLyaBf/Z4VBRMhIvsxg
        sOl/nPQXgtWFyqU9e/0clGT167Ix7T0jUnhs+ivFAc+N1TnfmQtZQMtHD2kci58tujgH9MdqVFpSY
        zHFLa4ILMzjEtSLZzjZjEuMM+azESedOZKTKeKq/bucDtGXyFJmeOSwxspIW9Wt2eTkCEEFfGCZCf
        hHTlwm6Q==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:55772 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lTNOi-0010hM-Fz; Mon, 05 Apr 2021 06:28:00 -0500
Subject: Re: [PATCH][next] scsi: ufs: Fix out-of-bounds warnings in
 ufshcd_exec_raw_upiu_cmd
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
References: <20210331224338.GA347171@embeddedor>
 <DM6PR04MB65751397A9CCA9B677875B3EFC799@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <60291521-2f71-8933-e90d-95b84c5f0be8@embeddedor.com>
Date:   Mon, 5 Apr 2021 06:27:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65751397A9CCA9B677875B3EFC799@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lTNOi-0010hM-Fz
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:55772
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/3/21 14:44, Avri Altman wrote:
>>
>> Fix the following out-of-bounds warnings by enclosing
>> some structure members into new structure objects upiu_req
>> and upiu_rsp:
>>
>> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [29,
>> 48] from the object at 'treq' is out of the bounds of referenced subobject
>> 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bounds]
>> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [61,
>> 80] from the object at 'treq' is out of the bounds of referenced subobject
>> 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bounds]
>> arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset
>> [29, 48] from the object at 'treq' is out of the bounds of referenced subobject
>> 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bounds]
>> arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset
>> [61, 80] from the object at 'treq' is out of the bounds of referenced subobject
>> 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bounds]
>>
>> Refactor the code by making it more structured.
>>
>> The problem is that the original code is trying to copy data into a
>> bunch of struct members adjacent to each other in a single call to
>> memcpy(). Now that a new struct _upiu_req_ enclosing all those adjacent
>> members is introduced, memcpy() doesn't overrun the length of
>> &treq.req_header, because the address of the new struct object
>> _upiu_req_ is used as the destination, instead. The same problem
>> is present when memcpy() overruns the length of the source
>> &treq.rsp_header; in this case the address of the new struct
>> object _upiu_rsp_ is used, instead.
>>
>> Also, this helps with the ongoing efforts to enable -Warray-bounds
>> and avoid confusing the compiler.
>>
>> Link: https://github.com/KSPP/linux/issues/109
>> Reported-by: kernel test robot <lkp@intel.com>
>> Build-tested-by: kernel test robot <lkp@intel.com>
>> Link:
>> https://lore.kernel.org/lkml/60640558.lsAxiK6otPwTo9rv%25lkp@intel.com/
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>

Thanks, Avri. :)

--
Gustavo

> 
> Thanks,
> Avri
> 
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++------------
>>  drivers/scsi/ufs/ufshci.h | 22 +++++++++++++---------
>>  2 files changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 7539a4ee9494..324eb641e66f 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -336,11 +336,15 @@ static void ufshcd_add_tm_upiu_trace(struct
>> ufs_hba *hba, unsigned int tag,
>>                 return;
>>
>>         if (str_t == UFS_TM_SEND)
>> -               trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
>> -                                 &descp->input_param1, UFS_TSF_TM_INPUT);
>> +               trace_ufshcd_upiu(dev_name(hba->dev), str_t,
>> +                                 &descp->upiu_req.req_header,
>> +                                 &descp->upiu_req.input_param1,
>> +                                 UFS_TSF_TM_INPUT);
>>         else
>> -               trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_header,
>> -                                 &descp->output_param1, UFS_TSF_TM_OUTPUT);
>> +               trace_ufshcd_upiu(dev_name(hba->dev), str_t,
>> +                                 &descp->upiu_rsp.rsp_header,
>> +                                 &descp->upiu_rsp.output_param1,
>> +                                 UFS_TSF_TM_OUTPUT);
>>  }
>>
>>  static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
>> @@ -6420,7 +6424,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
>> *hba,
>>         spin_lock_irqsave(host->host_lock, flags);
>>         task_tag = hba->nutrs + free_slot;
>>
>> -       treq->req_header.dword_0 |= cpu_to_be32(task_tag);
>> +       treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
>>
>>         memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
>>         ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
>> @@ -6493,16 +6497,16 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
>> *hba, int lun_id, int task_id,
>>         treq.header.dword_2 = cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
>>
>>         /* Configure task request UPIU */
>> -       treq.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
>> +       treq.upiu_req.req_header.dword_0 = cpu_to_be32(lun_id << 8) |
>>                                   cpu_to_be32(UPIU_TRANSACTION_TASK_REQ << 24);
>> -       treq.req_header.dword_1 = cpu_to_be32(tm_function << 16);
>> +       treq.upiu_req.req_header.dword_1 = cpu_to_be32(tm_function << 16);
>>
>>         /*
>>          * The host shall provide the same value for LUN field in the basic
>>          * header and for Input Parameter.
>>          */
>> -       treq.input_param1 = cpu_to_be32(lun_id);
>> -       treq.input_param2 = cpu_to_be32(task_id);
>> +       treq.upiu_req.input_param1 = cpu_to_be32(lun_id);
>> +       treq.upiu_req.input_param2 = cpu_to_be32(task_id);
>>
>>         err = __ufshcd_issue_tm_cmd(hba, &treq, tm_function);
>>         if (err == -ETIMEDOUT)
>> @@ -6513,7 +6517,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>> int lun_id, int task_id,
>>                 dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
>>                                 __func__, ocs_value);
>>         else if (tm_response)
>> -               *tm_response = be32_to_cpu(treq.output_param1) &
>> +               *tm_response = be32_to_cpu(treq.upiu_rsp.output_param1) &
>>                                 MASK_TM_SERVICE_RESP;
>>         return err;
>>  }
>> @@ -6693,7 +6697,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
>> *hba,
>>                 treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
>>                 treq.header.dword_2 =
>> cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
>>
>> -               memcpy(&treq.req_header, req_upiu, sizeof(*req_upiu));
>> +               memcpy(&treq.upiu_req, req_upiu, sizeof(*req_upiu));
>>
>>                 err = __ufshcd_issue_tm_cmd(hba, &treq, tm_f);
>>                 if (err == -ETIMEDOUT)
>> @@ -6706,7 +6710,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
>> *hba,
>>                         break;
>>                 }
>>
>> -               memcpy(rsp_upiu, &treq.rsp_header, sizeof(*rsp_upiu));
>> +               memcpy(rsp_upiu, &treq.upiu_rsp, sizeof(*rsp_upiu));
>>
>>                 break;
>>         default:
>> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
>> index 6795e1f0e8f8..235236859285 100644
>> --- a/drivers/scsi/ufs/ufshci.h
>> +++ b/drivers/scsi/ufs/ufshci.h
>> @@ -482,17 +482,21 @@ struct utp_task_req_desc {
>>         struct request_desc_header header;
>>
>>         /* DW 4-11 - Task request UPIU structure */
>> -       struct utp_upiu_header  req_header;
>> -       __be32                  input_param1;
>> -       __be32                  input_param2;
>> -       __be32                  input_param3;
>> -       __be32                  __reserved1[2];
>> +       struct {
>> +               struct utp_upiu_header  req_header;
>> +               __be32                  input_param1;
>> +               __be32                  input_param2;
>> +               __be32                  input_param3;
>> +               __be32                  __reserved1[2];
>> +       } upiu_req;
>>
>>         /* DW 12-19 - Task Management Response UPIU structure */
>> -       struct utp_upiu_header  rsp_header;
>> -       __be32                  output_param1;
>> -       __be32                  output_param2;
>> -       __be32                  __reserved2[3];
>> +       struct {
>> +               struct utp_upiu_header  rsp_header;
>> +               __be32                  output_param1;
>> +               __be32                  output_param2;
>> +               __be32                  __reserved2[3];
>> +       } upiu_rsp;
>>  };
>>
>>  #endif /* End of Header */
>> --
>> 2.27.0
> 
