Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D7CC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 18:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9825D222AE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 18:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfKRSNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 13:13:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40429 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfKRSNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 13:13:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so10758984pfl.7
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 10:13:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2qMysSAQ8fxOf4n1sFjhmasH32mtLrEVR5KNWuo8zzA=;
        b=PgeahcGcYeyhWKXRTBWtSlHiR8gkg5HwudZq1A5tAf2ZpQWcEA4Nb5YcPNOshW5Hc0
         f6h3YsddDF9tSKD/Xe7iJNcW4/YTpeYVC9KFlWIlHprNMi/fwu/LdHLfnuZrC3jCiJ8j
         bL2Utjj+Bn27ADJEZhXfnKKLKLYhBfzPfw8AgBDquBBNzEKtsE1SY0A9zelIa0rr/p5f
         bYiHza1wPe1/umoiuj2+g4t2Hu0z7WCeGmsHLzEa2ecXtlHkY0/8eRbm260HC+EDDjTG
         J8IOOYQ6Ql0y8UuiAOIzDKG+MjrGRVYkx6QuM7xOfYXbPiC0Cm8PXU2vaD+jbb1GTkNF
         BdIg==
X-Gm-Message-State: APjAAAVZI1flulozLneNbAiD5ZzpBtxw/xgoxVlUIepVeh5HU5McjANe
        XlTVPD5zpsWq+pAVl4Goaec=
X-Google-Smtp-Source: APXvYqyugmuT6Qt3he8nL96JAg4Vsry1q+W+t5F9tRo6cXPpdkU2UIjq3IBuSW4yH7ITCiolmTfmPQ==
X-Received: by 2002:aa7:90d0:: with SMTP id k16mr638330pfk.131.1574100820398;
        Mon, 18 Nov 2019 10:13:40 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id y24sm23447358pfr.116.2019.11.18.10.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:13:39 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
To:     Can Guo <cang@codeaurora.org>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
 <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5659ab82-a087-4cfb-088e-e25d7f5515a3@acm.org>
Date:   Mon, 18 Nov 2019 10:13:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/19 10:01 PM, Can Guo wrote:
> On 2019-11-15 00:11, Bart Van Assche wrote:
>> On 11/13/19 8:03 AM, Bean Huo (beanhuo) wrote:
>>> I think, you are asking for comment from Can.  As for me, attached 
>>> patch is better.
>>> Removing ufshcd_wait_for_doorbell_clr(), instead of reading doorbell 
>>> register, Now
>>> using block layer blk_mq_{un,}freeze_queue(), looks good. I tested 
>>> your V5 patches,
>>> didn't find problem yet.
>>>
>>> Since my available platform doesn't support dynamic clk scaling, I 
>>> think, now seems only
>>> Qcom UFS controllers support this feature. So we need Can Guo to 
>>> finally confirm it.
>>
>> Do you agree with this patch series if patch 4 is replaced by the
>> patch attached to my previous e-mail? The entire (revised) series is
>> available at https://github.com/bvanassche/linux/tree/ufs-for-next.
>
> After ufshcd_clock_scaling_prepare() returns(no error), all request 
> queues are frozen. If failure
> happens(say power mode change command fails) after this point and error 
> handler kicks off,
> we need to send dev commands(in ufshcd_probe_hba()) to bring UFS back to 
> functionality.
> However, as the hba->cmd_queue is frozen, dev commands cannot be sent, 
> the error handler shall fail.

Hi Can,

My understanding of the current UFS driver code is that
ufshcd_clock_scaling_prepare() waits for ongoing commands to finish but 
not for SCSI error handling to finish. Would you agree with changing 
that behavior such that ufshcd_clock_scaling_prepare() returns an error
code if SCSI error handling is in progress? Do you agree that once that 
change has been made that it is fine to invoke blk_freeze_queue_start() 
for all three types of block layer request queues (SCSI commands, device 
management commands and TMFs)? Do you agree that this would fix the 
issue that it is possible today to submit TMFs from user space using 
through the BSG queue while clock scaling is in progress?

Thanks,

Bart.
