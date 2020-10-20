Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703EDC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 12:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB8722283
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 12:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="onjcZ8Ar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406119AbgJTMdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 08:33:20 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:33496 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406096AbgJTMdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 08:33:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603197199; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BzMND/VoGzDdfPCIU+mlALzQkIfAWtsITfgqnGQwess=;
 b=onjcZ8ArNLigyfpbGoJsVwVq9XZtnhCp8mnS2aajGMMYYNk58sPkqftwPz8QbF2ebpniFM++
 N3VBrkgh9ApAC1yvG7CSEhXHoIdWQ3eMqFHoDOB6A+Z2KgpVWo5Sop0USr1OCx/rUcYwyCgk
 TFQDJE/TGwDi24a+8DpA7JZC4Cs=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f8ed90da03b63d673cabadd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 20 Oct 2020 12:33:17
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D3D96C433FF; Tue, 20 Oct 2020 12:33:17 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 65FB6C433C9;
        Tue, 20 Oct 2020 12:33:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Oct 2020 20:33:17 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 4/4] scsi: add more contexts in the ufs tracepoints
In-Reply-To: <8170ddc084fc40a57c51501cbc29f5ea@codeaurora.org>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
 <20201005223635.2922805-4-jaegeuk@kernel.org>
 <f55c7b379283bfb90e884e9b1bdf170e@codeaurora.org>
 <CH2PR04MB6710F6367C3862F3107A78F5FC1F0@CH2PR04MB6710.namprd04.prod.outlook.com>
 <14935822cbfa6d54df34946bcb2ccef8@codeaurora.org>
 <8170ddc084fc40a57c51501cbc29f5ea@codeaurora.org>
Message-ID: <c9eeaa283f4eafdd0dece7f4f8961aa5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-20 19:57, Can Guo wrote:
> On 2020-10-20 19:02, Can Guo wrote:
>> On 2020-10-20 18:51, Avri Altman wrote:
>>>> 
>>>> On 2020-10-06 06:36, Jaegeuk Kim wrote:
>>>> > From: Jaegeuk Kim <jaegeuk@google.com>
>>>> >
>>>> > This adds user-friendly tracepoints with group id.
>>> You have the entire cdb as part of the upiu trace,
>>> Can't you parse what you need from there?
>>> 
>>> Thanks,
>>> Avri
>> 
>> Yes, but assume we have a large trace log file, having a
>> groud id allows us to filter the data by it easily, right?
>> 
>> Thanks,
>> 
>> Can Guo.
> 
> I just dobule checked WRITE(10)'s CDB, byte 6 has group
> ID ONLY. So Avri is right, we don't even need to parse it,
> we can easily filter a ftrace log file by byte 6 to get the
> WRITE(10) cmds with specific group ID - we don't need this
> change.
> 
> Thanks,
> 
> Can Guo.

Please ignore my previous mail, I misunderstood the change. :(
You have my reivewed-by tag for this change.

Regards,

Can Guo.
