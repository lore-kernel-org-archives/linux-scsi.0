Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0296DC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97CC064EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhCKIHf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:07:35 -0500
Received: from z11.mailgun.us ([104.130.96.11]:18403 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhCKIHa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 03:07:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615450050; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=JvSMnYuUYbtLBvPdwvJwOW4hM+plL832W+mXLNXZB/E=;
 b=DjXF9EOGo5B46WV5pU6gwxeg2z7sP5+V5mfIT6YHIKzK/yFXndV1L1KGYDawwivzkdWUwipE
 NeRWkdDkrUku1tYg846x41N3ylC2YU3T3OblT01R0EAfWvIabauu93EDmMr/O5SPLYF9U7kM
 ryglxZrIhIGjMb6Obqamprzhato=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6049cfc0d3a53bc38f9e82ed (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Mar 2021 08:07:28
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 69011C43467; Thu, 11 Mar 2021 08:07:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2679C433CA;
        Thu, 11 Mar 2021 08:07:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Mar 2021 16:07:26 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, stanley.chu@mediatek.com
Subject: Re: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
In-Reply-To: <DM6PR04MB6575319E8340A8AD89633CFEFC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-4-avri.altman@wdc.com>
 <838c79b39bf43e2ceaac06a190ded990@codeaurora.org>
 <DM6PR04MB6575319E8340A8AD89633CFEFC909@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <69694dccface6234ed278347889e86c5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-11 16:04, Avri Altman wrote:
>> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>> > index 044fec9854a0..a8f8d13af21a 100644
>> > --- a/drivers/scsi/ufs/ufshpb.c
>> > +++ b/drivers/scsi/ufs/ufshpb.c
>> > @@ -16,6 +16,8 @@
>> >  #include "ufshpb.h"
>> >  #include "../sd.h"
>> >
>> > +#define ACTIVATION_THRESHOLD 4 /* 4 IOs */
>> 
>> Can this param be added as a sysfs entry?
> Yes.
> Daejun asked me that as well, so the last patch makes all logic
> parameter configurable.
> 
> Thanks,
> Avri
> 

Ok, thanks. I haven't reach the last one, absorbing them one by one.

Can Guo.

>> 
>> Thanks,
>> Can Guo
