Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641E6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473C16187F
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350796AbhKOXOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 18:14:24 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38698 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243737AbhKOXMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 18:12:17 -0500
Received: by mail-pj1-f54.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so531635pju.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 15:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OoMA7VKuIgYXl8JEmeSwcajHYATY9/of0PJ+olVDp+w=;
        b=DxJsnWVcg2mvCEbLA6bUPehAGFCd00pX51ccVzWep1+IrZqIUSfStOnMM347uLpX+h
         /DHNl/5jpR9PnDbbd6cMD9WOpc7T1O2fakg3i3aEUMkUbYOcp5tnrZMCYwc+Gb5kHZRE
         s0c/DtK9f9wRFl2MGhWQA6qEwWKxvvO0T8zIwevMezDCHZmStvBmopSd1UsUCHO188IW
         QwIH73tO3TMIfHV1g5G9LsLapYotgK7WIoeHPQmj2xvC3dBgR4LoypART7H8vq6K/0V9
         AiHXEJ7m06ldsaH4Shy8/t/TT4xbO0pQMAiEBFobgkvBOhOosSta+Vv8+8ZS1zMefPXV
         JSkg==
X-Gm-Message-State: AOAM532s0OmsKXwmWaPOXsXuyCTUjrAFXiHFZ46ReSq47GRhKA+YD3/2
        GX/htUnuO6UaEUcuj3PXBKA=
X-Google-Smtp-Source: ABdhPJwGW940XJSb3uGih+MXQoA5/UlbvcGu2rpClm0wRPHXMzCjYicAtbMOpzp8fz8pVFO8iIje5Q==
X-Received: by 2002:a17:90a:e7d0:: with SMTP id kb16mr2971652pjb.22.1637017761366;
        Mon, 15 Nov 2021 15:09:21 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id g1sm15911162pfm.25.2021.11.15.15.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 15:09:20 -0800 (PST)
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <509e2b2c-689a-04e3-e773-b8b99d9f6d0e@intel.com>
 <aac7b8c8-7474-4317-c342-1714cc61a331@acm.org>
 <985b86c5-e45f-8d07-31e3-7eed1c7c894c@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9ebeec91-ff62-3dcd-a377-1d6f98bd7c32@acm.org>
Date:   Mon, 15 Nov 2021 15:09:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <985b86c5-e45f-8d07-31e3-7eed1c7c894c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/21 2:56 AM, Adrian Hunter wrote:
> On 10/11/2021 20:56, Bart Van Assche wrote:
>> On 11/10/21 12:57 AM, Adrian Hunter wrote:
>>> Seems like something ufshcd_clear_cmd() should be doing instead?
>>
>> I'm concerned that would break ufshcd_eh_device_reset_handler()
 >> since that reset handler retries SCSI commands by calling
 >> __ufshcd_transfer_req_compl() after having called ufshcd_clear_cmd().
> Whenever an outstanding_reqs bit transitions 1 -> 0, then
> __ufshcd_transfer_req_compl() must be called.

I will look further into this.

> As a separate issue, in ufshcd_abort() there is:
> 
> 	/* If command is already aborted/completed, return FAILED. */
> 	if (!(test_bit(tag, &hba->outstanding_reqs))) {
> 		dev_err(hba->dev,
> 			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
> 			__func__, tag, hba->outstanding_reqs, reg);
> 		goto release;
> 	}
> 
> which seems wrong. FAILED should only be returned to escalate the
> error handling, so if the slot has already successfully been
> cleared, that is SUCCESS.  scsi_times_out() has already blocked
> the scsi_done() path (by setting SCMD_STATE_COMPLETE), so any use
> after free must be being caused by SCSI not the ufs driver.

scmd_eh_abort_handler() would trigger a use-after-free if ufshcd_abort() 
would return SUCCESS for completed commands. Hence the choice for the 
return value FAILED for completed commands.

BTW, can this code path ever be reached since scsi_done() sets the 
SCMD_STATE_COMPLETE bit before it calls blk_mq_complete_request() and 
since scsi_times_out() tests that bit before it schedules a call of 
ufshcd_abort()?

Thanks,

Bart.

