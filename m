Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C917C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 04:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E4F9613EA
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 04:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhEGEt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 00:49:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22430 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhEGEt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 May 2021 00:49:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620362908; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=EABI+CEJWh3VaV18/+gd8thZW7mI9RgBZSaQ25Wgi0k=;
 b=JUcuHOtc5/X2Btw1G8nVskq+gmVcPqgj38/mL6h1JztxFwEdcYzUZqWoiMLP2ftTA6p//T6m
 MfHZoBLfw7E6xPg7iXt4jXMtCKzLk0alqwBiBz1sqfHeVDKYPV8nJ75BSpUO5wueCXOQ3s66
 lyaMXoAUpnAnaNOs6SbtTT74nhg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6094c6948807bcde1da5fff6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 May 2021 04:48:20
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B4FBAC433D3; Fri,  7 May 2021 04:48:20 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A36CFC4338A;
        Fri,  7 May 2021 04:48:18 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 12:48:18 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>, Yue Hu <huyue2@yulong.com>
Subject: Re: [PATCH 102/117] ufs: Convert to the scsi_status union
In-Reply-To: <a27ca7e4-ba70-9ea7-1871-c11962dac520@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-12-bvanassche@acm.org>
 <aa572642ad49f5c3642b026b97e8a58d@codeaurora.org>
 <a27ca7e4-ba70-9ea7-1871-c11962dac520@acm.org>
Message-ID: <051fd148bc7d3e52b2ab410cbe6335c7@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-05-07 11:35, Bart Van Assche wrote:
> On 5/6/21 5:09 PM, Can Guo wrote:
>> Thanks for the change, do you miss ufshcd_send_request_sense()?
> 
> Hi Can,
> 
> That's a good question. I can change the type of the
> ufshcd_send_request_sense() return value but I'm not sure whether it's
> worth it since that function only has one caller and that caller does
> not care about the subcomponents of the SCSI status value. All it cares
> about is whether or not ufshcd_send_request_sense() returns 0.
> 
> Thanks,
> 
> Bart.

I agree.

Reviewed-by: Can Guo <cang@codeaurora.org>
