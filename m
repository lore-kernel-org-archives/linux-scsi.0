Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716FEC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D3ED610CA
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhDAHSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:18:16 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:22873 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhDAHSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 03:18:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617261480; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=vlZ+vMQlZRuL8LM8chZeMjq7xPyflEjD//VALE5QuZ8=;
 b=WFS/SqLjGOWmc71G7q+jewe6FZGw/68RVRt8f/4/m7clhb+OI3/+ZsjPQBSU8P2givmi9Um4
 EawY7j925U9eIMQW0EymztU1nR7W/ZSB54Pnu8waKSCVURHuYARncqLpoC/wpAp5xoB7OanE
 gUGDYSFNgVpq/QpGmlNkzUoY9kM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6065739c0a4a07ffda8cb161 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Apr 2021 07:17:48
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AA19FC43462; Thu,  1 Apr 2021 07:17:47 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 170D0C433CA;
        Thu,  1 Apr 2021 07:17:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 01 Apr 2021 15:17:46 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>, asutoshd@codeaurora.org,
        avri.altman@wdc.com, beanhuo@micron.com, hongwus@codeaurora.org,
        jaegeuk@kernel.org, jejb@linux.ibm.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, nguyenb@codeaurora.org,
        stanley.chu@mediatek.com, sthumma@codeaurora.org,
        vinholikatti@gmail.com, ygardi@codeaurora.org
Subject: Re: [PATCH v4 2/2] scsi: ufs: Fix wrong Task Tag used in task
 management request UPIUs
In-Reply-To: <1891546521.01617260402234.JavaMail.epsvc@epcpadp3>
References: <CGME20210401064419epcms2p6b289c9ba573d15883e3e92ddcd233e11@epcms2p6>
 <1891546521.01617260402234.JavaMail.epsvc@epcpadp3>
Message-ID: <f49aadb6083a0e4623e06dcc4b07acde@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-01 14:44, Daejun Park wrote:
> Hi, Can Guo
> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> ...
>> 
>>  	req->end_io_data = &wait;
>> -	free_slot = req->tag;
>>  	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
> I think this line should be removed.
> 

Oh, yes, will remove it in next version.

Thanks,
Can Guo.

> Thanks,
> Daejun
