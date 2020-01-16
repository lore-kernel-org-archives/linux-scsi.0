Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC76C33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 23:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F5E42072B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 23:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="efgYRKPk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390236AbgAPXDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:03:23 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:17089 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390224AbgAPXDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 18:03:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579215802; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=JFrlslqOPY+Or7IJG3FwTPI5aLmDB7PbhDVncuMzPps=; b=efgYRKPkyahxA9qeR6hQk+iKxiznMAVduNHgt0hGJ1naY6+fX8fB8cgJkEOXSErzeILrJDJF
 86gRx/k8IGnGRDwpgtTTYN1Qvv1f2HgC/FFY4UPB04sO4brpnh72MGrGeVZi8k897Gn0uQQ7
 wv+g/RbUYnVVnyrLDxcFp/Ox/NU=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e20ebb7.7fa929ca3e30-smtp-out-n02;
 Thu, 16 Jan 2020 23:03:19 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4A7D4C447AB; Thu, 16 Jan 2020 23:03:18 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A8A6C433A2;
        Thu, 16 Jan 2020 23:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9A8A6C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
To:     Bjorn Andersson <bjorn.andersson@linaro.org>, cang@codeaurora.org
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
References: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
 <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
 <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <01eb3c55e35738f2853fbc7175a12eaa@codeaurora.org>
 <20191029054620.GG1929@tuxbook-pro>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <b7de9358-b8ba-3100-a3f2-ebed8aaab490@codeaurora.org>
Date:   Thu, 16 Jan 2020 15:03:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191029054620.GG1929@tuxbook-pro>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/2019 10:46 PM, Bjorn Andersson wrote:
> On Mon 28 Oct 19:37 PDT 2019, cang@codeaurora.org wrote:
> 
>> On 2019-10-23 18:33, Avri Altman wrote:
>>>>
>>>>> Add the necessary infrastructure to keep timestamp history of
>>>>> commands, events and other useful info for debugging complex issues.
>>>>> This helps in diagnosing events leading upto failure.
>>>>
>>>> Why not use tracepoints, for that?
>>> Ack on Tomas's comment.
>>> Are there any pieces of information that you need not provided by the
>>> upiu tracer?
>>>
>>> Thanks,
>>> Avri
>>
>> In extreme cases, when the UFS runs into bad state, system may crash. There
>> may not be a chance to collect trace. If trace is not collected and failure
>> is hard to be reproduced, some command logs prints would be very helpful to
>> help understand what was going on before we run into failure.
>>
> 
> This is a common problem shared among many/all subsystems, so it's
> better to rely on a generic solution for this; such as using tracepoints
> dumped into pstore/ramoops.
> 
> Regards,
> Bjorn
> 

Reviving this discussion.

Another issue with using ftrace is that several subsystems use it.
Consider a situation in which we store a history of 64 commands, 
responses and some other required info in ftrace.

Say there's a command that's stuck for seconds until the software times 
out. In this case, the other ftrace events are still enabled and keep 
writing to ftrace buffer thus overwriting some/most of the ufs's command 
history; thus the history is more or less lost. And there's a need to 
reproduce the issue with other tracing disabled.

So what we need is a client specific logging mechanism, which is 
lightweight as ftrace and can be parsed from ramdumps.

I'm open to ideas but ftrace in its current form may not be suitable for 
this.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
