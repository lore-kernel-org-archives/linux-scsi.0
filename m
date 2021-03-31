Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3716FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D016F619B9
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhCaDxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:53:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:31485 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhCaDxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 23:53:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617162787; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=pM5gk1m7d9T/cxQJaaS6XUE2cDFASW/yvcFJJ7/pyBs=;
 b=pvWHrS/ypYVZw3EjvennnKBcuVlETuKLGXa+ZLpaSWu+5nHYN7FmR2Z+4gXLqjQa+Qsw+aKC
 zzDWzoNYMiAfDqpPts5i/D5Qfexfcw/KWTmMA/FmsBUcy1Tp89beQZgBBH7XhalNr5QBJqL/
 0vf/CkvOUlQTTMwCkOSeUlcDdYA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6063f20d8166b7eff7c2cc66 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 31 Mar 2021 03:52:45
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AA62DC43461; Wed, 31 Mar 2021 03:52:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B0E9C433CA;
        Wed, 31 Mar 2021 03:52:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 31 Mar 2021 11:52:44 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
In-Reply-To: <ce9a2333-437e-143a-a0f0-c5f532a2c423@acm.org>
References: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
 <ce9a2333-437e-143a-a0f0-c5f532a2c423@acm.org>
Message-ID: <6aeb31ca744b1232808bddb7397edf4f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 11:34, Bart Van Assche wrote:
> On 3/30/21 8:14 PM, Can Guo wrote:
>> It works like:
>> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 4096 > 
>> monitor_chunk_size
>> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 1 > monitor_enable
>> /sys/bus/platform/drivers/ufshcd/*/monitor # grep ^ /dev/null *
>> monitor_chunk_size:4096
>> monitor_enable:1
>> read_nr_requests:17
>> read_req_latency_avg:169
>> read_req_latency_max:594
>> read_req_latency_min:66
>> read_req_latency_sum:2887
>> read_total_busy:2639
>> read_total_sectors:136
>> write_nr_requests:116
>> write_req_latency_avg:440
>> write_req_latency_max:4921
>> write_req_latency_min:23
>> write_req_latency_sum:51052
>> write_total_busy:19584
>> write_total_sectors:928
> 
> Are any of these attributes UFS-specific? If not, isn't this
> functionality that should be added to the block layer instead of to the
> UFS driver?
> 

Hi Bart,

I didn't think that before because we've already have the powerful 
"blktrace"
tool to collect the overall statistics of each layer.

I add this because I find it really come handy when 
debug/analyze/profile
UFS driver/HW performance. And there will be UFS-specific nodes to be
added later to monitor statistics like UFS scaling, gating, doorbell, 
write
booster, HPB and etc.

Thanks.

Can Guo.

> Thanks,
> 
> Bart.
