Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C98DC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 07:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67184214AF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 07:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="wpiKwBt/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBFHre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 02:47:34 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:34606 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbgBFHrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 02:47:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580975253; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=p8o8+EdJB+GW+JVSbgpsXmSs4iniZDrh/iwwUuYph6U=;
 b=wpiKwBt/VHOWXY5oQYaRObiqHDj0pet3KR2/vfF4E3PLnfn1jwFpH5hFWa5D0AuqeAgvWLqv
 xa7nFJG/DL9Vv71shMWQ/zecFTQArrvfPSFFb3eS++V66eLITpEEdKPkqC3Z9DQf2tEsEyI8
 wjhiYKrrjxKnP9+DhcfH3Fu4hM8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3bc48c.7f4ec4a95ed8-smtp-out-n02;
 Thu, 06 Feb 2020 07:47:24 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2D6F6C43383; Thu,  6 Feb 2020 07:47:24 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EDCB8C433CB;
        Thu,  6 Feb 2020 07:47:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Feb 2020 15:47:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
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
Subject: Re: [PATCH 6/8] scsi: ufs: Add dev ref clock gating wait time support
In-Reply-To: <1580974242.27391.13.camel@mtksdccf07>
References: <1580972212-29881-1-git-send-email-cang@codeaurora.org>
 <1580972212-29881-7-git-send-email-cang@codeaurora.org>
 <1580974242.27391.13.camel@mtksdccf07>
Message-ID: <217e1286a9fa272646e0fe466f30fc8e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-06 15:30, Stanley Chu wrote:
> Hi Can,
> 
> On Wed, 2020-02-05 at 22:56 -0800, Can Guo wrote:
>> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime 
>> defines
>> the minimum time for which the reference clock is required by device 
>> during
>> transition to LS-MODE or HIBERN8 state. Make this change to reflect 
>> the new
>> requirement by adding delays before turning off the clock.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
>> Reviewed-by: Bean Huo <beanhuo@micron.com>
> 
> Thanks for the fix.
> 
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

Thank you for your review. :)

Can Guo
