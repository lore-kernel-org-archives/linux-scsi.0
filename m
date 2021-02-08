Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ED7C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 10:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 908BD64E54
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 10:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhBHKeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 05:34:31 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:45505 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232342AbhBHKbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 05:31:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612780288; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/UDWVXp1aV6QxsVm4lZslyXiXsVQduZouKiblUKIWPs=;
 b=PpdFgelyczujR6hK8OgveEiNgPL7RpeDtHNbWByzSY65/Ym7MjTNnlEDZgpk6e+dnNPIS37T
 4G//VvrV50+vxE1oQQfYvqwdPkRJkb5lKqofr++isRY2VjkLxyToCMmrdlWU11AE++pot3fu
 Ga82d5IhJblpddF+tMgD8AuGHhc=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 602112d9f112b7872c21e70d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 10:30:49
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B202C433C6; Mon,  8 Feb 2021 10:30:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1428AC433CA;
        Mon,  8 Feb 2021 10:30:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Feb 2021 16:00:47 +0530
From:   nitirawa@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 0/3] scsi: ufs: Add a vops to configure VCC voltage
 level
In-Reply-To: <48fbd86b319697fced61317bd15c4779@codeaurora.org>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
 <DM6PR04MB6575D0348161330D21A9B6C5FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
 <48fbd86b319697fced61317bd15c4779@codeaurora.org>
Message-ID: <2fb825d458fb87a522b4a64370ee83b1@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-01 14:01, nitirawa@codeaurora.org wrote:
> On 2021-01-31 19:32, Avri Altman wrote:
>>> 
>>> UFS specification allows different VCC configurations for UFS 
>>> devices,
>>> for example,
>>>         (1)2.70V - 3.60V (For UFS 2.x devices)
>>>         (2)2.40V - 2.70V (For UFS 3.x devices)
>>> For platforms supporting both ufs 2.x (2.7v-3.6v) and
>>> ufs 3.x (2.4v-2.7v), the voltage requirements (VCC) is 2.4v-3.6v.
>>> So to support this, we need to start the ufs device initialization 
>>> with
>>> the common VCC voltage(2.7v) and after reading the device descriptor 
>>> we
>>> need to switch to the correct range(vcc min and vcc max) of VCC 
>>> voltage
>>> as per UFS device type since 2.7v is the marginal voltage as per 
>>> specs
>>> for both type of devices.
>>> 
>>> Once VCC regulator supply has been intialised to 2.7v and UFS device
>>> type is read from device descriptor, we follows below steps to
>>> change the VCC voltage values.
>>> 
>>> 1. Set the device to SLEEP state.
>>> 2. Disable the Vcc Regulator.
>>> 3. Set the vcc voltage according to the device type and reenable
>>>    the regulator.
>>> 4. Set the device mode back to ACTIVE.
>>> 
>>> The above changes are done in vendor specific file by
>>> adding a vops which will be needed for platform
>>> supporting both ufs 2.x and ufs 3.x devices.
>> The flow should be generic - isn't it?
>> Why do you need the entire flow to be vendor-specific?
>> Why not just the parameters vendor-specific?
>> 
>> Thanks,
>> Avri
> 
> Hi Avri,
> This vops change was done as per the below mail thread
> discussion where it was decided to go with vops and
> let vendors handle it, until specs provides more clarity.
> 
> https://www.spinics.net/lists/kernel/msg3754995.html
> 
> Regards,
> Nitin

Hi Avri,
Please let me know if you have any further comments on this.

Regards,
Nitin
