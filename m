Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17435C48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 08:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF4BC611BE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 08:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhFOIJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 04:09:51 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:36716 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhFOIJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 04:09:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623744467; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=eH1nngH+lCXsKEmZqgF9jy1pkdMjytdsrtorEbe65Cs=;
 b=nU0M3etafNCEjKYsT/XuJ0ZJTy9Gm/ZsK8v9HqJXeFJ2U2PJLhPWIZyq41C99yigut1gEvom
 vkOrWumcWxp+7LxP/c+l/7SloENg16t461TY9JlNaM8etLsFqIQs80O0K6oCar4QhIcwiOsT
 cePcXswJk179LcBmXGgVuxckDhM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60c85fb5e27c0cc77f9955fc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 08:07:17
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39FF5C4323A; Tue, 15 Jun 2021 08:07:16 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD986C433D3;
        Tue, 15 Jun 2021 08:07:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Jun 2021 16:07:15 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, 'Bart Van Assche' <bvanassche@acm.org>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Bean Huo' <beanhuo@micron.com>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>
Subject: Re: Question about coherency of comand context between ufs and scsi
In-Reply-To: <001301d761bc$03eb57e0$0bc207a0$@samsung.com>
References: <CGME20210614095245epcas2p2e8512382423332786f584d5ef1e225d3@epcas2p2.samsung.com>
 <000001d76103$06c3cb50$144b61f0$@samsung.com>
 <69eaab403c178024dd45ac3c27f2c1bf@codeaurora.org>
 <001301d761bc$03eb57e0$0bc207a0$@samsung.com>
Message-ID: <4c0d76848b42aff5c9a2364f97086841@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-15 15:56, Kiwoong Kim wrote:
>> If scsi added it into its error command list and wakes-up scsi_eh
>> though the command is actually completed, scsi_eh will invoke
>> eh_abort_handler and the symptom will be duplicated, I think
>> 
>> Otherwise, is there anyone who know how to guarantee the coherency?
> 
>> In 5.13 kernel, it is scsi_print_command(cmd) in ufshcd_abort(), while 
>> in
>> 5.12 and earlier kernel, it is scsi_print_command(hba->lrb[tag].cmd).
>> Which kernel are you using here?
>> 
>> Thanks,
>> Can Guo.
> 
> Thank you for your information. I'm seeing 5.4.
> Yes, for null pointer, you're right.
> Then, what do you think?
> In the situation I told, is there still the possibility that I 
> suggested?

You can make the code change to that line in your project same as 5.13.

Thanks,

Can Guo.

> 
> Thanks.
> Kiwoong Kim
