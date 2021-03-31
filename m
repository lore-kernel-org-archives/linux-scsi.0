Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7865CC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A34A619D3
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhCaHpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:45:11 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26217 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234103AbhCaHpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 03:45:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617176706; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xtAkUmo+P2ZEM3majPxusI811uRr0ODQ7sQrrS5pU2E=;
 b=ehebkezpWXI8VXaNI+N4TdjacafOx3iTMghtwAapMPJJvgtUDeqS8URE5nCMqR8Y/b7HbOSN
 JZJrhk1U0v1P1iWH6ztjsi3LglgLEq7EB2gTrU0C9oOXJvRv8cfTtnCokFUoV3lLeDB5EFoA
 QFrR0twiFwpzubm8NsdBa62ETpc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 606428748166b7eff751d858 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 31 Mar 2021 07:44:52
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8407FC433CA; Wed, 31 Mar 2021 07:44:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2D1D0C433ED;
        Wed, 31 Mar 2021 07:44:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 31 Mar 2021 15:44:51 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
In-Reply-To: <BL0PR04MB6564DA13DF093548E599DE9BFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
 <ce9a2333-437e-143a-a0f0-c5f532a2c423@acm.org>
 <6aeb31ca744b1232808bddb7397edf4f@codeaurora.org>
 <BL0PR04MB6564DA13DF093548E599DE9BFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
Message-ID: <55059457e37f949828104b6ee7491a9a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 14:35, Avri Altman wrote:
>> On 2021-03-31 11:34, Bart Van Assche wrote:
>> > On 3/30/21 8:14 PM, Can Guo wrote:
>> >> It works like:
>> >> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 4096 >
>> >> monitor_chunk_size
>> >> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 1 > monitor_enable
>> >> /sys/bus/platform/drivers/ufshcd/*/monitor # grep ^ /dev/null *
>> >> monitor_chunk_size:4096
>> >> monitor_enable:1
>> >> read_nr_requests:17
>> >> read_req_latency_avg:169
>> >> read_req_latency_max:594
>> >> read_req_latency_min:66
>> >> read_req_latency_sum:2887
>> >> read_total_busy:2639
>> >> read_total_sectors:136
>> >> write_nr_requests:116
>> >> write_req_latency_avg:440
>> >> write_req_latency_max:4921
>> >> write_req_latency_min:23
>> >> write_req_latency_sum:51052
>> >> write_total_busy:19584
>> >> write_total_sectors:928
>> >
>> > Are any of these attributes UFS-specific? If not, isn't this
>> > functionality that should be added to the block layer instead of to the
>> > UFS driver?
>> >
>> 
>> Hi Bart,
>> 
>> I didn't think that before because we've already have the powerful
>> "blktrace"
>> tool to collect the overall statistics of each layer.
>> 
>> I add this because I find it really come handy when
>> debug/analyze/profile
>> UFS driver/HW performance. And there will be UFS-specific nodes to be
>> added later to monitor statistics like UFS scaling, gating, doorbell,
>> write
>> booster, HPB and etc.
> We are using a designated analysis tool (web-based, a lot of fancy
> graphs etc.) that relies on ftrace - upiu tracer etc.
> Once the raw data is there - the options/insights are endless.
> 

Hi Avri,

Yeah, one can dig out a lot of info from ftrace/systrace raw data.
But, most important, ftrace/systrace has below disadvantages

[1] Enabling UFS/SCSI ftrace itself can impact UFS performance (a lot) 
as per our profiling
[2] One needs a parser tool (only if they have one) to get the wanted 
results

So we usually use ftrace to analyze some sequences, e.g., cmd-response,
suspend-resume, gating and scaling, but not quite suitable for analyzing
performance, see [1].

These nodes provide us a swift method to look into statistics during 
runtime [2].

Please let me know if you have any concerns w.r.t the change.

Thanks,

Can Guo.

> Thanks,
> Avri
>> 
>> Thanks.
>> 
>> Can Guo.
>> 
>> > Thanks,
>> >
>> > Bart.
