Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B7DC4332B
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 333392070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vQkncLU+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCUAw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:52:26 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:33913 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgCUAwZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Mar 2020 20:52:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584751945; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: References: To: From:
 Subject: Sender; bh=DJ3+vXSzlFBX5tfzrKTWN/+JnEJF8AQalFHcKHWndFA=; b=vQkncLU+CyDXgeYoWeUmGB2uwtF/UGpZhOu6qlcndfDhFFPdd2fPmcSBjxP92orZyJYqSQPN
 8YsGMWN/mq1/edDHLe8mi7G/85X67ALNONxAAIRcitNLWL6tXZFhh/IaKAFc9QYEGThKajkJ
 VtUKpyNxVsRZPrDYVtszCWljIao=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e756545.7ff84bf98618-smtp-out-n03;
 Sat, 21 Mar 2020 00:52:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1B9F5C433BA; Sat, 21 Mar 2020 00:52:21 +0000 (UTC)
Received: from [192.168.8.111] (cpe-70-95-153-89.san.res.rr.com [70.95.153.89])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B35CFC433D2;
        Sat, 21 Mar 2020 00:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B35CFC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [<RFC PATCH v2> 0/3] WriteBooster Feature Support
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
To:     asutoshd@qti.qualcomm.com, linux-scsi@vger.kernel.org
References: <cover.1584750888.git.asutoshd@codeaurora.org>
Message-ID: <c532097e-c9a1-379a-247b-7c9de258549f@codeaurora.org>
Date:   Fri, 20 Mar 2020 17:52:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cover.1584750888.git.asutoshd@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/20/2020 5:48 PM, Asutosh Das wrote:
> Still a RFC patch, because I'm still expecting some comments
> on the design.
> 
> v1 -> v2:
> - Addressed comments on v1
> 
> - Supports shared buffer mode only
> 
> - Didn't use exception event as suggested.
>    The reason being while testing I saw that the WriteBooster
>    available buffer remains at 0x1 for a longer time if flush is
>    enabled all the time as compared to an event-based enablement.
>    This essentially means that writes go to the WriteBooster buffer
>    more. Spec says that the if flush is enabled, the device would
>    flush when it sees the command queue empty. So I guess that'd trigger
>    flush more than an event based approach.
>    Anyway the Vcc would be turned-off during system suspend, so flush
>    would stop anyway.
>    In this patchset, I never turn-off flush.
>    Hence the RFC.
> 
> Asutosh Das (3):
>    scsi: ufs: add write booster feature support
>    ufs-qcom: scsi: configure write booster type
>    ufs: sysfs: add sysfs entries for write booster
> 
>   drivers/scsi/ufs/ufs-qcom.c  |   7 ++
>   drivers/scsi/ufs/ufs-sysfs.c |  39 ++++++-
>   drivers/scsi/ufs/ufs.h       |  37 ++++++-
>   drivers/scsi/ufs/ufshcd.c    | 238 ++++++++++++++++++++++++++++++++++++++++++-
>   drivers/scsi/ufs/ufshcd.h    |   9 ++
>   5 files changed, 324 insertions(+), 6 deletions(-)
> 

Hi,
Please ignore this patch, I'll send the proper series.


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
