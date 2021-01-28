Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207D9C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C340B64E0C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhA1QlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 11:41:10 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:26509 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbhA1QlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 11:41:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611852038; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=v4QZtcN/NF44ksO02JGpPju7+31t5OKRwBwUNKC9wfw=; b=txFqJRPD6lMVygyKDbtG9vI1yJCCUqrM6pVcVGYcNu6n+nIGC9W1nfNYeLkb1cn1fuo6Zwk2
 KohSQJbYuiOcLpLt7Qwvnu47SIsaR/3f4iVZh36oNCQ+Q+I3weO+mQjelKDw6y8prIIThBCz
 M9bra2K4d6iqoHEqlEqqLbKC1pk=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6012e8e783b274b0af8f9823 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Jan 2021 16:40:07
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3DA3C43465; Thu, 28 Jan 2021 16:40:06 +0000 (UTC)
Received: from stor-presley.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0696C433CA;
        Thu, 28 Jan 2021 16:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C0696C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Date:   Thu, 28 Jan 2021 08:39:59 -0800
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "cang@codeaurora.org" <cang@codeaurora.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "Bao D . Nguyen" <nguyenb@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/2] scsi: ufs: Fix deadlock while suspending ufs
 host
Message-ID: <20210128163959.GA32780@stor-presley.qualcomm.com>
References: <b1db5394aa3f6cf44cd9adb9c8d569caa0c9e4f5.1611803264.git.asutoshd@codeaurora.org>
 <d50e7620c47109ea7664dd9ca4144fc0c7c8502d.1611803264.git.asutoshd@codeaurora.org>
 <DM6PR04MB657577E28BEDC95DC5FFCA96FCBA9@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM6PR04MB657577E28BEDC95DC5FFCA96FCBA9@DM6PR04MB6575.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 28 2021 at 04:21 -0800, Avri Altman wrote:
>>
>> During runtime-suspend of ufs host, the scsi devices are
>> already suspended and so are the queues associated with them.
>> But the ufs host sends SSU to wlun during its runtime-suspend.
>Do you possible meant: "sends request-sense while clearing UAC to...."
>

The idea was to show that there's a scsi command that's sent during
suspend which may deadlock.

Yes, I agree to your comment and would change the message to reflect it in
the next version.

>
>Thanks,
>Avri
