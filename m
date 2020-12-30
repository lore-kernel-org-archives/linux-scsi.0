Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43255C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 07:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1168421D1B
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 07:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgL3HuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Dec 2020 02:50:15 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:37071 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgL3HuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2020 02:50:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609314581; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=75H8H0z8rDIGmnh6ZXLqAUtDjnVvjFNe+R/xEHbD1r4=;
 b=SRl9IunwhtxSSoKvdFws7szp9MvPQfMQxawoUiRNqAcp+D8rZ9612I2iE2+2eaZ8HggixctV
 32uR6ZKvcKOSRDVuM8oKTpyBduU+4YhO9dEDWd5/VXcysre4mjFkN7gL4nAGhmBTXaTIZLqe
 3gWeh4dYPWiAHqWyFJGwqW/qrE0=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fec30f2e61d77c9713db57f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 30 Dec 2020 07:49:06
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3D51EC43468; Wed, 30 Dec 2020 07:49:05 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2DF1CC433CA;
        Wed, 30 Dec 2020 07:49:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Dec 2020 15:49:04 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Correct the lun used in
 eh_device_reset_handler() callback
In-Reply-To: <DM6PR04MB65753653372A85F4F9B57FD6FCD70@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
 <DM6PR04MB65753653372A85F4F9B57FD6FCD70@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <ebbdec35412a9020e1892c4a7d9f131b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-30 15:20, Avri Altman wrote:
>> Users can initiate resets to specific SCSI device/target/host through
>> IOCTL. When this happens, the SCSI cmd passed to eh_device/target/host
>> _reset_handler() callbacks is initialized with a request whose tag is 
>> -1.
>> So, in this case, it is not right for eh_device_reset_handler() 
>> callback
>> to count on the lun get from hba->lrb[-1]. Fix it by getting lun from 
>> the
>> SCSI device associated with the SCSI cmd.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> Btw, am surprised to see that you guys are still using sg_reset
> instead of ufs-utils?

Hi Avri,

We are not using any user layer tools at all. But I am confronted
with many customers and tons of test teams inside and outside.
I see all kinds of corner cases everyday, so not surprised at all.

Thanks,
Can Guo

> 
> Thanks,
> Avri
