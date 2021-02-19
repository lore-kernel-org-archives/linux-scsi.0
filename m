Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ABAC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 13:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1964B64EB4
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 13:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBSNaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 08:30:03 -0500
Received: from z11.mailgun.us ([104.130.96.11]:17387 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhBSNaC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Feb 2021 08:30:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613741383; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=J7rkKvMjDbSvVkJNJCMxK+Go4PTfh3Gj1Cg8D6idMxE=;
 b=uXk9B2j23oQ6jmqEsAoqKl3HDLYaLGzwku8M4wiqVYqFbj8UWkIbkUFJ5EPOp0nGxVRdTYmx
 ceQaA5p88kicHB32tK9ldzfvElkLxu12ptRdF4B7b92eSomrtFGeYRYsj4exkOY3NGbwLmZT
 jFMkwpVKat+Nl02XjXX/pWKW/Yc=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 602fbd25f33d74123fa24f86 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 19 Feb 2021 13:29:09
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 126CCC43465; Fri, 19 Feb 2021 13:29:08 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C975C433CA;
        Fri, 19 Feb 2021 13:29:07 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 19 Feb 2021 18:59:07 +0530
From:   nitirawa@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        stanley.chu@mediatek.com
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avri Altman <Avri.Altman@wdc.com>
Subject: Re: [PATCH V1 0/3] scsi: ufs: Add a vops to configure VCC voltage
 level
In-Reply-To: <DM6PR04MB65757109C5292CD42F7799EAFC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
 <DM6PR04MB6575D0348161330D21A9B6C5FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
 <48fbd86b319697fced61317bd15c4779@codeaurora.org>
 <2fb825d458fb87a522b4a64370ee83b1@codeaurora.org>
 <DM6PR04MB65757109C5292CD42F7799EAFC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <ce531f446993574b0c56d787b35fe73d@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-08 17:52, Avri Altman wrote:
>> >> The flow should be generic - isn't it?
>> >> Why do you need the entire flow to be vendor-specific?
>> >> Why not just the parameters vendor-specific?
>> >>
>> >> Thanks,
>> >> Avri
>> >
>> > Hi Avri,
>> > This vops change was done as per the below mail thread
>> > discussion where it was decided to go with vops and
>> > let vendors handle it, until specs provides more clarity.
>> >
>> > https://www.spinics.net/lists/kernel/msg3754995.html
>> >
>> > Regards,
>> > Nitin
>> 
>> Hi Avri,
>> Please let me know if you have any further comments on this.
> No further comments.
> Looks like you need an ack from Stanley or Bjorn who proposed this 
> approach.
> 
> Thanks,
> Avri

Hi Stanley/Bjorn,

Please can you review this patch and provide your input.

Regards,
Nitin
