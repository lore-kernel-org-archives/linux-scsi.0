Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3434C35247
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 02:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7493320659
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 02:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Qv5ntAM9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBFCkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 21:40:07 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:42747 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbgBFCkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 21:40:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580956806; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=x3250bc90bbLo/8nZIXvtLUJ7DKa2tZzcGBIY7u8bik=;
 b=Qv5ntAM929Si9SDcpTuCy9uw0QcJske/k08xOYdDv9/k8Zcb+fkYXx1uFr8+sDRp3jG8+Y71
 lPQkIj2TlnEaQIiMey1bqbqbYvHIZ2n5Gb7tq5UMvHmCIstROic+Xn5RdBEAFH5JZ5BHMahy
 sQmkAOc1auNIJRV7sRcuPAYpwvo=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3b7c80.7f99b82640a0-smtp-out-n03;
 Thu, 06 Feb 2020 02:40:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75EDEC447A4; Thu,  6 Feb 2020 02:39:58 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9CEAFC43383;
        Thu,  6 Feb 2020 02:39:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Feb 2020 10:39:57 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     kuohong.wang@mediatek.com, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
In-Reply-To: <1580950556.27391.11.camel@mtksdccf07>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-7-git-send-email-cang@codeaurora.org>
 <1580871040.21785.7.camel@mtksdccf07>
 <d37515ab264b0c46848ee2b88ba0a676@codeaurora.org>
 <1580950556.27391.11.camel@mtksdccf07>
Message-ID: <8b6603db0bb793365542c39d33a64a0e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-06 08:55, Stanley Chu wrote:
> Hi Can,
> 
> On Wed, 2020-02-05 at 12:52 +0800, Can Guo wrote:
> 
> 
>> Hi Stanley,
>> 
>> We used to ask vendors about it, 50 is somehow agreed by them. Do you
>> have a
>> better value in mind?
>> 
>> For me, I just wanted to give it 10, so that we can directly use
>> usleep_range
>> with it, no need to decide whether to use udelay or usleep_range.
> 
> Actually I do not have any value in mind because I guess the 50us here
> is just a margin time added for safety as your comments: "Give it more
> time to be on the safe side".
> 
> An example case is that some vendors only specify 1us in
> bRefClkGatingWaitTime, so this 50us may be too long compared to 
> device's
> requirement. If such device really needs this additional 50us, it shall
> be specified in bRefClkGatingWaitTime.
> 
> So if this additional delay does not have any special reason or not
> mentioned by UFS specification, would you consider move it to vendor
> specific implementations. By this way, it would be more flexible to be
> controlled by vendors or by platforms.
> 
> Thanks,
> Stanley
> 
>> 
>> Thanks,
>> Can Guo.
>> 
>> >>  				      &dev_info->model, SD_ASCII_STD);

Hi Stanley,

FYI, the default values in bRefClkGatingWaitTime from vendors are around
50 - 100.

I agree with you. I will just remove the extra delay here and let's
handle it in our own platform drivers.

Thanks,
Can Guo.
