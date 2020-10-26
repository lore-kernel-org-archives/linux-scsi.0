Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405B7C55178
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE5220809
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="wpGd44or"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421886AbgJZDT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 23:19:58 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:28863 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1421879AbgJZDT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 23:19:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603682397; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=OSXsVLrma060OniBpnUdo6WkNY5oB43KMgRGs3wI2Mg=;
 b=wpGd44orEp8uaJ7rek2tNJuETrTX6jVJlRKJRnbkgKp1ESE4TwlR4ru79Lc4WCf4Ldrow9+L
 nrCYasVk0oT3GKagsJdhzjEEVG+x7l1Kp86vYZeLM3lB9nzrS0n9Cn/BvayIEE/VmpG9cOII
 0MQVC8fmKjA5TPUhq23NoUi8sZE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f9640505ac36f7b89a02ebf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Oct 2020 03:19:44
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57681C433A1; Mon, 26 Oct 2020 03:19:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89741C433F0;
        Mon, 26 Oct 2020 03:19:43 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Oct 2020 11:19:43 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
In-Reply-To: <BY5PR04MB6705D719530D5E188ECB724EFC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
 <BY5PR04MB6705D719530D5E188ECB724EFC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
Message-ID: <5271e570f2e38770da3b23f13e739e41@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On 2020-10-22 14:37, Avri Altman wrote:
>> Since WB feature has been added, WB related sysfs entries can be 
>> accessed
>> even when an UFS device does not support WB feature. In that case, the
>> descriptors which are not supported by the UFS device may be wrongly
>> reported when they are accessed from their corrsponding sysfs entries.
>> Fix it by adding a sanity check of parameter offset against the actual
>> decriptor length.s
> This should be a bug fix IMO, and be dealt with similarly like
> ufshcd_is_wb_attrs or ufshcd_is_wb_flag.
> Thanks,
> Avri

Could you please elaborate on ufshcd_is_wb_attrs or ufshcd_is_wb_flag?
Sorry that I don't quite get it.

Thanks,

Can Guo.
