Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE66C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 05:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF5761D54
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 05:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhF2Foi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 01:44:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:25236 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhF2Foh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2021 01:44:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624945331; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=o4+eZM2Dx3GnLj8Xg6wXr6QB6hTOedtc94/YUj4qaP8=;
 b=sj8IxSgBlkvOqgPrBgF9fkWm33j0Csad9WU/kDNbSJwYWRPCU2K4AcSKKT3S/qwCZAfDU2LG
 j9uAQYdFhlfwstZijCp1dDabTffvwgmMbJu5AMREivQu2XTsWO2q6Z7lmjW4wJQtUzppC5f/
 TJiSStjHFyMuZz6nHJ3+3WjHzx0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60dab2a3ad0600eeded224d8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Jun 2021 05:41:55
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A26AAC43147; Tue, 29 Jun 2021 05:41:54 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9AFE8C433D3;
        Tue, 29 Jun 2021 05:41:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Jun 2021 13:41:53 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
In-Reply-To: <c31185f5-e816-937d-25ac-1657b6111ff8@acm.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <c31185f5-e816-937d-25ac-1657b6111ff8@acm.org>
Message-ID: <464097469b09752ce4ebb38c08f1a94a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-29 06:58, Bart Van Assche wrote:
> On 5/24/21 1:36 AM, Can Guo wrote:
>> Current UFS IRQ handler is completely wrapped by host lock, and 
>> because
>> ufshcd_send_command() is also protected by host lock, when IRQ handler
>> fires, not only the CPU running the IRQ handler cannot send new 
>> requests,
>> the rest CPUs can neither. Move the host lock wrapping the IRQ handler 
>> into
>> specific branches, i.e., ufshcd_uic_cmd_compl(), 
>> ufshcd_check_errors(),
>> ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to 
>> further
>> reduce occpuation of host lock in ufshcd_transfer_req_compl(), host 
>> lock is
>> no longer required to call __ufshcd_transfer_req_compl(). As per test, 
>> the
>> optimization can bring considerable gain to random read/write 
>> performance.
> 
> Hi Can,
> 
> Since this patch has been applied on the AOSP kernel we see 100%
> reproducible lockups appearing on multiple test setups. Examples of 
> call
> traces:
> 
> blk_execute_rq()
> __scsi_execute()
> sd_sync_cache()
> sd_suspend_common()
> sd_suspend_system()
> scsi_bus_suspend()
> __device_suspend()
> 
> blk_execute_rq()
> __scsi_execute()
> ufshcd_clear_ua_wlun()
> ufshcd_err_handling_unprepare()
> ufshcd_err_handler()
> process_one_work()
> 
> Reverting this patch and the next patch from this series solved the
> lockups. Do you prefer to revert this patch or do you perhaps want us 
> to
> test a potential fix?
> 

Hi Bart,

I am waiting for more infos/logs/dumps on Buganizor to look into it.
With above calltrace snippet, it is hard to figure out what is 
happening.
Besides, we've tested this series before go upstream and we didn't
see such problem.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
