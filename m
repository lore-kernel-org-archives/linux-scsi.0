Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5561BC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3999661059
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFOCh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:37:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:22167 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhFOCh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 22:37:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623724524; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=1CSVPIUD022Ta/9Vf9NQ1f8jm47mR5cSiNNU8/yR7mo=;
 b=qVH9dUkV55LH8FbLIBcUutnV1p25kxScnpueEl7taMUcbBD8vqOk1KSjI7JAQY6Yx8UBYqHm
 kg3rRLY2XxdnUZk7Tu1WgreW8meFt0gbeLVBu8iEQKVAkeW8aBIkohYmcNfDRp0/FbUPEmSZ
 Gy3D1kkljTvtKYA9yMpEylkmVJo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60c7fdc251f29e6baeb5f557 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 01:09:22
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE68CC4338A; Tue, 15 Jun 2021 01:09:21 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 301A9C433D3;
        Tue, 15 Jun 2021 01:09:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Jun 2021 09:09:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, 'Bart Van Assche' <bvanassche@acm.org>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Bean Huo' <beanhuo@micron.com>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>
Subject: Re: Question about coherency of comand context between ufs and scsi
In-Reply-To: <000001d76103$06c3cb50$144b61f0$@samsung.com>
References: <CGME20210614095245epcas2p2e8512382423332786f584d5ef1e225d3@epcas2p2.samsung.com>
 <000001d76103$06c3cb50$144b61f0$@samsung.com>
Message-ID: <69eaab403c178024dd45ac3c27f2c1bf@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kiwoong,

On 2021-06-14 17:52, Kiwoong Kim wrote:
> Dear All
> 
> I saw one symptom and started wondering on how a command context is
> synchronized between ufs and scsi.
> In the situation where the following log happened, the lrb structure
> for tag 10 didn't have a command context.
> That is, lrbp->cmd was null, so it led to this kernel panic.
> 
> lrbp->cmd is set when a command is issued, and cleared when the
> command is completed.
> But what if the command is timed-out and it's completed because its
> response comes in at the same time?
> 
> If scsi added it into its error command list and wakes-up scsi_eh
> though the command is actually completed, scsi_eh will invoke
> eh_abort_handler and the symptom will be duplicated, I think
> 
> Otherwise, is there anyone who know how to guarantee the coherency?
> 
> 
> [78843.058729] [3:  kworker/u16:1:27018] exynos-ufs 13100000.ufs:
> ufshcd_abort: cmd was completed, but without a notifying intr, tag =
> 10
> [78843.058775] [3:  kworker/u16:1:27018] exynos-ufs 13100000.ufs:
> ufshcd_abort: Device abort task at tag 10
> [78843.058793] [3:  kworker/u16:1:27018] Unable to handle kernel NULL
> pointer dereference at virtual address 0000000000000160
> ..
> [78843.075421] [3:  kworker/u16:1:27018] pc : 
> scsi_print_command+0x24/0x340
> [78843.075436] [3:  kworker/u16:1:27018] lr : ufshcd_abort+0x180/0x674
> [78843.075444] [3:  kworker/u16:1:27018] sp : ffffffc038ea3c00
> [78843.075453] [3:  kworker/u16:1:27018] x29: ffffffc038ea3c10 x28:
> 0000000000000400
> [78843.075464] [3:  kworker/u16:1:27018] x27: ffffff8934c0a680 x26:
> ffffff8931560000
> [78843.075474] [3:  kworker/u16:1:27018] x25: 000000000002000a x24:
> ffffff88a0dd4910
> [78843.075485] [3:  kworker/u16:1:27018] x23: 0000000000000000 x22:
> ffffff8930f258f0
> [78843.075495] [3:  kworker/u16:1:27018] x21: ffffff8934c0a080 x20:
> 000000000000000a
> [78843.075505] [3:  kworker/u16:1:27018] x19: ffffff8931560cf8 x18:
> ffffffc037557030
> [78843.075516] [3:  kworker/u16:1:27018] x17: 0000000000000000 x16:
> ffffffc010eeba70
> [78843.075526] [3:  kworker/u16:1:27018] x15: ffffffc01187d88f x14:
> 2067617420746120
> [78843.075536] [3:  kworker/u16:1:27018] x13: 6b7361742074726f x12:
> 6261206563697665
> [78843.075546] [3:  kworker/u16:1:27018] x11: 44203a74726f6261 x10:
> 00000000ffffffff
> [78843.075556] [3:  kworker/u16:1:27018] x9 : 0000000000000090 x8 :
> ffffff8934c0a620
> [78843.075566] [3:  kworker/u16:1:27018] x7 : 0000000000000000 x6 :
> ffffffc0102a7d6c
> [78843.075576] [3:  kworker/u16:1:27018] x5 : 0000000000000000 x4 :
> 0000000000000080
> [78843.075585] [3:  kworker/u16:1:27018] x3 : 0000000000000000 x2 :
> ffffffc0102a7d80
> [78843.075595] [3:  kworker/u16:1:27018] x1 : ffffffc0102a7d80 x0 :
> 0000000000000000
> [78843.075606] [3:  kworker/u16:1:27018] Call trace:
> [78843.075617] [3:  kworker/u16:1:27018]  scsi_print_command+0x24/0x340
> [78843.075627] [3:  kworker/u16:1:27018]  ufshcd_abort+0x180/0x674
> [78843.075643] [3:  kworker/u16:1:27018]  
> scmd_eh_abort_handler+0x80/0x15c
> [78843.075660] [3:  kworker/u16:1:27018]  process_one_work+0x290/0x4e4
> [78843.075669] [3:  kworker/u16:1:27018]  worker_thread+0x258/0x534
> [78843.075681] [3:  kworker/u16:1:27018]  kthread+0x178/0x188
> [78843.075696] [3:  kworker/u16:1:27018]  ret_from_fork+0x10/0x18
> 

In 5.13 kernel, it is scsi_print_command(cmd) in ufshcd_abort(),
while in 5.12 and earlier kernel, it is 
scsi_print_command(hba->lrb[tag].cmd).
Which kernel are you using here?

Thanks,
Can Guo.

> Thanks.
> Kiwoong Kim
