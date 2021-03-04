Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74261C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 15:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6C664F39
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 15:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbhCDPdI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 10:33:08 -0500
Received: from z11.mailgun.us ([104.130.96.11]:14826 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234923AbhCDPdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 10:33:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614871963; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=yw6X0hE3R/LaSfjE+hVC/k0iGKiHH/AiRqtO+CmPa8M=; b=HplxyOffidVBt80UMyiiT9o52WFBvCafzWZ+zBYbS+FvLaYD7mU6xJ5mcxpXclFsU+hPKZJ9
 TnO+6JuIU9Ht7nB5m+zI+2oLXiuPCgznL6KRLm+Pp1CUjy99uUFB2gc38sXgSGmx9QcJulPp
 tc7HAnQdnFovQUJ5Fm/CGf9Xxk4=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6040fd772a5e6d1bfa9e1bb4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 04 Mar 2021 15:32:07
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 213A5C43465; Thu,  4 Mar 2021 15:32:07 +0000 (UTC)
Received: from stor-presley.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0A27C43461;
        Thu,  4 Mar 2021 15:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C0A27C43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Date:   Thu, 4 Mar 2021 07:32:04 -0800
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     cang@codeaurora.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 2/2] ufs: sysfs: Resume the proper scsi device
Message-ID: <20210304153204.GI12147@stor-presley.qualcomm.com>
References: <cover.1614725302.git.asutoshd@codeaurora.org>
 <5d7c0cd1ff4bc5295015244f057d252fe9040993.1614725302.git.asutoshd@codeaurora.org>
 <9edf7047-4845-5bb5-3307-fa6e11e5c923@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9edf7047-4845-5bb5-3307-fa6e11e5c923@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 04 2021 at 23:45 -0800, Adrian Hunter wrote:
>On 3/03/21 12:52 am, Asutosh Das wrote:
>> Resumes the actual scsi device the unit descriptor of which
>> is being accessed instead of the hba alone.
>
>Since "scsi: ufs: ufs-debugfs: Add user-defined exception_event_mask"
>is now in linux-next, a similar change is needed for ufs-debugfs.c.
>Probably best it is a separate patch though.
>
Ok Sure, I'll push a separate patch.
If there're not any other concerns, please can you ack these changes.

Thanks,
-asd
