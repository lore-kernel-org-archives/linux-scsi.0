Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF8BC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F3120679
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLQEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:04:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41931 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 11:04:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id h4so12129909pgv.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2019 08:04:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u6mVgCSkU5lK0HovZ9UlB0pEs5ibW6DnrbLibe2WEl0=;
        b=a8TdSDdEXPpt3H3zK5mbI2U1s4Ew7ltC3UrH/ViMR1mcarH1FKhd24jWM/+syzfBQy
         MjKtC7C1nDlsHpirkYlWC4CxUXEToNMZqMuuXKoG6CEPXbJRPnfMudW1lI6ukO7E330K
         df173uUEZR2LR/AH9m7CN4QqWQ4HoBUXreX/3Nwt7JUOMBK9GE/h5pWeM2nmd42XNaqY
         OrRN+6S75oIk9VGKpH1JZECnn1RuBW2cUDZorEkVbk1wPhRC0sIRjyCHS57AKDpkP58Q
         UjjBWros18sNdpQcBrO9nZUBW9goLMDVGVR5Wt7Kmyd3OTgI1TqSPVOffICxoU9zywWO
         MIjw==
X-Gm-Message-State: APjAAAXzmqwyzLOxR6FKPMEyQTyhxvMrJk2W4ilOulstGdqJYkR3bGc5
        wiVIShXPKkQ8hyuwVapM7v8=
X-Google-Smtp-Source: APXvYqxQ129TuL5zBJGSaJG2UIKwGUNLcDGvZkvD0VBu4Lm6YMFUxnQlbSfOlOTGRo0H1uUqgsE6OQ==
X-Received: by 2002:aa7:8e0a:: with SMTP id c10mr36765736pfr.166.1573574691308;
        Tue, 12 Nov 2019 08:04:51 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d4sm2864453pjs.9.2019.11.12.08.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 08:04:50 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v4 3/3] ufs: Simplify the clock scaling
 mechanism implementation
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191111174841.185278-1-bvanassche@acm.org>
 <20191111174841.185278-4-bvanassche@acm.org>
 <f9432876516560c76c27184362592757@codeaurora.org>
 <BN7PR08MB5684F921576D9E73ED5A18DDDB770@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <445f55d7-1fb6-d700-3a74-7d3b926209cc@acm.org>
Date:   Tue, 12 Nov 2019 08:04:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB5684F921576D9E73ED5A18DDDB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/19 7:43 AM, Bean Huo (beanhuo) wrote:
> Can Guo wrote: 
 >> Bart Van Assche wrote:
>>>   		/* handle fatal errors only when link is functional */
>>>   		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
>>> -			/* block commands from scsi mid-layer */
>>> -			ufshcd_scsi_block_requests(hba);
>>> +			/* block all commands, incl. SCSI commands */
>>> +			ufshcd_block_requests(hba, ULONG_MAX);
>>>
>>
>> ufshcd_block_requests() may sleep, but ufshcd_check_errors is called from
>> IRQ(atmic) context.
> 
> [Bean Huo]
> Can Guo's comment is correct, I triggered an error manually, my UFS being killed.
> And removing this patch, no problem. Please take this seriously.

Hi Can and Bean,

Thank you for having reported this. I'll look into keeping 
scsi_block_requests() and scsi_unblock_requests() in this code path.

Thanks,

Bart.

