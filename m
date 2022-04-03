Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A97C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 05:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiDCE2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 00:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiDCE2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 00:28:47 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB95F39152
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 21:26:54 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id j7so2903418pjw.4
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2022 21:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4HWtew5YgzJpmm6Jcf8HMxDLTSUr/m0MOr+TpM421vI=;
        b=FaCClGxS6UcXzcwMuLJkIyXRZNkCREp7lY8z/+8oni14TfUd/9e+dNomlqhZqO8zT+
         D9fPqpdPzXdOz/rzjba6WK4iDV8KkbnfNiD3H+2fqeI4+dAN2ZtFY+rxyNKn7yKOXGNa
         TfI5vslSAOTIPAqX9BDylWO59cuhq8dy0OEJtJTO1lKRwRkuJEa3rc5NAPPtrMHQh3Mu
         e8LRiA6jdq5hFCtT8/dhAsw+PhT0dYIMhbjmwCcrKs97idjjUo153vbZnRGXYOXcFWZV
         UyM+GJ1DGASXClKg9JaCF1BR6rrD2aPdzmdfqp7d2GDeol2WmRHafZff9QZdLaYqln3L
         WrVg==
X-Gm-Message-State: AOAM533jPVmue6TKN+sggsGfmhzsIRLWxke05m2I+qIMER/Xjbvs7iLs
        D9TV3/82Qklp2cfmJ5Op11o=
X-Google-Smtp-Source: ABdhPJyTgNkiReZvtwk1lJzaqp4vz3PaJL3qQRzej9Wm2ax2+xk5p6w3G3xkBOio5yViSWOklLGkrw==
X-Received: by 2002:a17:902:d48d:b0:154:54f6:9384 with SMTP id c13-20020a170902d48d00b0015454f69384mr17346226plg.83.1648960014314;
        Sat, 02 Apr 2022 21:26:54 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x25-20020a056a000bd900b004faae43da95sm7336084pfu.138.2022.04.02.21.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 21:26:53 -0700 (PDT)
Message-ID: <ee49cbbc-e246-027e-16bd-2f1d4a5df75a@acm.org>
Date:   Sat, 2 Apr 2022 21:26:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 05/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-6-bvanassche@acm.org>
 <DM6PR04MB6575C21425DA784513E160C7FCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575C21425DA784513E160C7FCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 12:21, Avri Altman wrote:
>> ufshcd_lrb.sense_buffer is NULL if ufshcd_lrb.cmd is NULL and
>> ufshcd_lrb.sense_buffer points at cmd->sense_buffer if ufshcd_lrb.cmd
>> is set. In other words, the ufshcd_lrb.sense_buffer member is identical
>> to cmd->sense_buffer. Hence this patch that removes the
>> ufshcd_lrb.sense_buffer structure member.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 9 ++++-----
>>   drivers/scsi/ufs/ufshcd.h | 2 --
>>   2 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e52e86b0b7a3..eddaa57b6aad 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2127,15 +2127,17 @@ void ufshcd_send_command(struct ufs_hba *hba,
>> unsigned int task_tag)
>>    */
>>   static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
>>   {
>> +       u8 *sense_buffer = lrbp->cmd ? lrbp->cmd->sense_buffer : NULL;
> lrbp->cmd  is tested in __ufshcd_transfer_req_compl(),
> which is the only caller of ufshcd_transfer_rsp_status(),
> which is the only caller of ufshcd_scsi_cmd_status(),
> which is the only caller of ufshcd_copy_sense_data().

Thanks for the feedback. I will update this patch and leave out the 
lrbp->cmd test.

Bart.
