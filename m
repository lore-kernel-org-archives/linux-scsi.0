Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B211C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E942561440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhENETa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 00:19:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28674 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhENET2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 00:19:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620965898; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uqj54DykBKkGvq8sPKZliQtP//zOrXCAaysz9V6pI8E=;
 b=cgfRDPvJBGWJTdAnbFEJ3H1dzxHscE6aiY/YAhUvz4C+oeAVvT22Jr5jmpIo/PcTlPFYq+oh
 fM9VaAzvAUWncg0s7T06vBQ9QytjUF0zwoX4WCw4DszeVLg+X3VW3VpKEKIeI1p5H1oS/ZXl
 ciYlDsoTHu6wpp3798DUASsxJ5k=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 609df9f3ff1bb9beece912e7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 May 2021 04:17:55
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4F412C4338A; Fri, 14 May 2021 04:17:54 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DFF43C433F1;
        Fri, 14 May 2021 04:17:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 May 2021 12:17:52 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 6/6] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
In-Reply-To: <a124700a-e507-e593-d6f5-2da452f3ae7e@acm.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
 <1620885319-15151-8-git-send-email-cang@codeaurora.org>
 <a124700a-e507-e593-d6f5-2da452f3ae7e@acm.org>
Message-ID: <4fba6bc358b293de345258c48fc61f79@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-14 12:05, Bart Van Assche wrote:
> On 5/12/21 10:55 PM, Can Guo wrote:
>> If PM requests fail during runtime suspend/resume, RPM framework saves 
>> the
>> error to dev->power.runtime_error. Before the runtime_error gets 
>> cleared,
>> runtime PM on this specific device won't work again, leaving the 
>> device
>> in either suspended or active state permanently.
>> 
>> When task abort happens to a PM request sent during runtime 
>> suspend/resume,
>> even if it can be successfully aborted, RPM framework anyways saves 
>> the
>> (TIMEOUT) error. But we want more and we can do better - let error 
>> handling
>> recover and clear the runtime_error. So, let PM requests take the fast
>> abort path in ufshcd_abort().
> 
> The only RQF_PM requests I know of are START STOP UNIT and SYNCHRONIZE
> CACHE. Are there devices for which these commands can time out or do
> these commands perhaps only time out as the result of error injection?

There are also REQUEST SENSE requests sent with RQF_PM flag set from
pm ops. And they do time out (device does not respond in 60s) in real
cases, at least I have seen quite a lot of related issues reported
from customers these years.

> 
>> -	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
>> +	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN ||
>> +	    (cmd->request->rq_flags & RQF_PM)) {
> 
> Which are the RQF_PM commands that are not sent to a WLUN? Are these
> START STOP UNIT and SYNCHRONIZE CACHE only?
> 

There are also REQUEST SENSE cmds sent to the RPMB W-LU, in 
ufshcd_add_wlus(),
ufshcd_err_handler() and ufshcd_rpmb_resume() and/or ufshcd_wl_resume().

And SYNCHRONIZE CACHE cmd is only sent to general LUs, but not W-LUs.

Thanks,
Can Guo.

> Thanks,
> 
> Bart.
