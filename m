Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C59C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 16:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C51A20672
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 16:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ZCD7Hhh3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgINQfg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 12:35:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14266 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgINQey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 12:34:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600101293; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ObHJxhWnQ6Id1CMXMXxijV0dvfRIEHq6RwO9EgQfuVY=;
 b=ZCD7Hhh3/5pgssIKBltNNmzQpehRPk4lyb5iNdcrJTD+yd8/+5iaLZeic486Vd60dU2syhVR
 zIKJs9w6PvDHIx3CIPsJVbH0KgWSdfYioZlqzNqusGoCYujLPOJjw7EpHps/nr2wCxLnaVum
 lX1r2oyXjVTToH9IbVm9xwlyiew=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f5f9ba44ba82a82fdbafb39 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Sep 2020 16:34:44
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2DA8DC43382; Mon, 14 Sep 2020 16:34:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 613BAC433C8;
        Mon, 14 Sep 2020 16:34:43 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 14 Sep 2020 09:34:43 -0700
From:   nguyenb@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] scsi: ufshcd: Properly set the device Icc Level
In-Reply-To: <BY5PR04MB6705A865E35CDA367249DC4EFC270@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <5c9d6f76303bbe5188bf839b2ea5e5bf530e7281.1598923023.git.nguyenb@codeaurora.org>
 <0101017475a11d00-6def34a7-db5d-472c-9dcc-215a80510402-000000@us-west-2.amazonses.com>
 <BY5PR04MB6705A865E35CDA367249DC4EFC270@BY5PR04MB6705.namprd04.prod.outlook.com>
Message-ID: <e1b4e9f5eab891fa6615e7a4b2ed29e6@codeaurora.org>
X-Sender: nguyenb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-10 03:02, Avri Altman wrote:
>> 
>> On 2020-08-31 18:19, Bao D. Nguyen wrote:
>> > UFS version 3.0 and later devices require Vcc and Vccq power supplies
>> > with Vccq2 being optional. While earlier UFS version 2.0 and 2.1
>> > devices, the Vcc and Vccq2 are required with Vccq being optional.
>> > Check the required power supplies used by the device
>> > and set the device's supported Icc level properly.
> Practically you are correct - most flash vendors moved in UFS3.1 to
> 1.2 supply instead of 1.8.
> However, the host should provide all 3 supplies to the device because -
> a) A flash vendor might want to still use 1.8 in its UFS3.1 device, and
> b) We should allow a degenerated configurations, e.g. 3.1 devices,
> that are degenerated to 2.1 or 2.2
Thank you for your comment.
The host can provide all 3 power supplies. However, the change is to 
ensure
we do not exit early and fail to properly set the Icc level because the 
optional power
supply is not provided.
> 
> That said, I think we can entirely remove the check in the beginning
> of the function,
> But not because the spec allows it, but because each supply is
> explicitly checked later on,
> before reading its applicable max current entry in the power 
> descriptor.
We need these checks to prevent NULL pointer access subsequently in this 
function.
> Thanks,
> Avri

