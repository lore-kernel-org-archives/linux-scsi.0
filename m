Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63ACBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiBISWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiBISWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:22:40 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E02C05CB86
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:22:43 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id i6so3818492pfc.9
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hISYYlBfLXBy2JOsnq/GXdYXs6z+NkOMOoyNCFKtUAo=;
        b=eGxEIouF5Nh/DG/Eedwz2CNqHwbI+WkLijgCoMY0xOtnowetNwbfzNW9ei/DwN2Xpk
         wtP0tQd1MZ8CmQxu2inEFhboAx/NSHwP25CFXk9vDoUl5UbLleqasbl9UtKI+qg6xflp
         hkiyfl/cxFFLlSlf6oWptRTutvDO1DEgcuI2Y2RVDlhpF2DnjMWfkOd5BdmkGc97g5IG
         O/5PXEKtYUamHlcfoveNT7HMmq7KIsa+L0FKMTIQbV3/ZFP6Ka9P4iX1ZmfodnhMOnra
         jFrMn2pFAXeEIaW3egW3j+91x3IdrhsPk4+4mFneRHgLkmVTXEkrBHXsBLZ/oG+n8xWM
         Z2Gw==
X-Gm-Message-State: AOAM530OGAzHriWAvokJZm2uNaB4+P6pUJsjbAVstStv8egzsZabJht0
        55JW6+gHs2AU2OpAvvzDHq8=
X-Google-Smtp-Source: ABdhPJyk/SdDNDVUEgKiHepct+vcBOkvhEGZZRfIOYEZKM6btf+ptjTGAS9mH6xaAa22urGjJHJ8Nw==
X-Received: by 2002:a05:6a00:15d0:: with SMTP id o16mr3580848pfu.19.1644430962505;
        Wed, 09 Feb 2022 10:22:42 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q17sm20678408pfu.160.2022.02.09.10.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:22:41 -0800 (PST)
Message-ID: <7c12ca60-d062-924d-4d6a-dff978cdb175@acm.org>
Date:   Wed, 9 Feb 2022 10:22:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 19/44] fnic: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-20-bvanassche@acm.org>
 <4f1ff3c2-0365-5a26-2391-e735b2ed4951@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4f1ff3c2-0365-5a26-2391-e735b2ed4951@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 23:56, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
>> from struct scsi_cmnd. This patch prepares for removal of the SCSI 
>> pointer
>> from struct scsi_cmnd.
>>
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/fnic/fnic.h      |  27 +++-
>>   drivers/scsi/fnic/fnic_main.c |   1 +
>>   drivers/scsi/fnic/fnic_scsi.c | 289 +++++++++++++++++-----------------
>>   3 files changed, 163 insertions(+), 154 deletions(-)
>>
>> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
>> index b95d0063dedb..aa07189fb5fb 100644
>> --- a/drivers/scsi/fnic/fnic.h
>> +++ b/drivers/scsi/fnic/fnic.h
>> @@ -89,15 +89,28 @@
>>   #define FNIC_DEV_RST_ABTS_PENDING       BIT(21)
>>   /*
>> - * Usage of the scsi_cmnd scratchpad.
>> + * fnic private data per SCSI command.
>>    * These fields are locked by the hashed io_req_lock.
>>    */
>> -#define CMD_SP(Cmnd)        ((Cmnd)->SCp.ptr)
>> -#define CMD_STATE(Cmnd)        ((Cmnd)->SCp.phase)
>> -#define CMD_ABTS_STATUS(Cmnd)    ((Cmnd)->SCp.Message)
>> -#define CMD_LR_STATUS(Cmnd)    ((Cmnd)->SCp.have_data_in)
>> -#define CMD_TAG(Cmnd)           ((Cmnd)->SCp.sent_command)
>> -#define CMD_FLAGS(Cmnd)         ((Cmnd)->SCp.Status)
>> +struct fnic_cmd_priv {
>> +    struct fnic_io_req *io_req;
>> +    enum fnic_ioreq_state state;
>> +    u32 flags;
>> +    u16 abts_status;
>> +    u16 lr_status;
>> +};
>> +
>> +static inline struct fnic_cmd_priv *fnic_priv(struct scsi_cmnd *cmd)
>> +{
>> +    return scsi_cmd_priv(cmd);
>> +}
>> +
>> +static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
>> +{
>> +    struct fnic_cmd_priv *fcmd = fnic_priv(cmd);
>> +
>> +    return ((u64)fcmd->flags << 32) | fcmd->state;
>> +}
>>   #define FCPIO_INVALID_CODE 0x100 /* hdr_status value unused by 
>> firmware */
>> diff --git a/drivers/scsi/fnic/fnic_main.c 
>> b/drivers/scsi/fnic/fnic_main.c
>> index 44dbaa662d94..9161bd2fd421 100644
>> --- a/drivers/scsi/fnic/fnic_main.c
>> +++ b/drivers/scsi/fnic/fnic_main.c
>> @@ -124,6 +124,7 @@ static struct scsi_host_template 
>> fnic_host_template = {
>>       .max_sectors = 0xffff,
>>       .shost_groups = fnic_host_groups,
>>       .track_queue_depth = 1,
>> +    .cmd_size = sizeof(struct fnic_cmd_priv),
>>   };
>>   static void
>> diff --git a/drivers/scsi/fnic/fnic_scsi.c 
>> b/drivers/scsi/fnic/fnic_scsi.c
>> index 549754245f7a..3c00e5b88350 100644
>> --- a/drivers/scsi/fnic/fnic_scsi.c
>> +++ b/drivers/scsi/fnic/fnic_scsi.c
>> @@ -497,8 +497,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd 
>> *sc)
>>        * caller disabling them.
>>        */
>>       spin_unlock(lp->host->host_lock);
>> -    CMD_STATE(sc) = FNIC_IOREQ_NOT_INITED;
>> -    CMD_FLAGS(sc) = FNIC_NO_FLAGS;
>> +    fnic_priv(sc)->state = FNIC_IOREQ_NOT_INITED;
>> +    fnic_priv(sc)->flags = FNIC_NO_FLAGS;
> Why not keep the macros?
> Would be less churn with the driver, no?

Keeping the macros would indeed make this patch smaller. My opinion is 
that the CMD_STATE() and CMD_FLAGS() macro definitions are too short to 
keep them and that expanding these macros makes the driver code easier 
to read.

Thanks,

Bart.
