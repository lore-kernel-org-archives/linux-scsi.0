Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BE2C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 12:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0215A2077B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 12:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SgyG+3pL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jaMs4OJk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKOM12 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 07:27:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57670 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfKOM12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 07:27:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C99B46149A; Fri, 15 Nov 2019 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573820846;
        bh=nn641KuPlVJ7M03lH48vK72IKsPONDRXYZbuLdODP+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SgyG+3pLBf/epYtaBAk0ZRB50L2a8+58nD2VcCuqJ4KjPImZYadXXmTNp350yi0jj
         QLsECcs55VPRM+eZbluH6JjBKPn/XtgCfFptwNXkffw1oqnjdi+BPX817W9GbuG2rI
         KllDQKb3u7th/v9QKlr/JKUuSn4dxVCdN1XNO+8I=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E5CFC61494;
        Fri, 15 Nov 2019 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573820839;
        bh=nn641KuPlVJ7M03lH48vK72IKsPONDRXYZbuLdODP+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jaMs4OJkRDvrjtvA6b7JIjzUo1PVR1a9YeKe4NoVjt578d3wMaxMuiOj+l6brL5Nb
         Teae1FX11ODMVsu13jt+iZP7Mp/KjuWL2Q1Ye+4MtB6gddDjRJpKjvVnSAXVcjL5u7
         YP3akQeyW7AwCQRayChFmcUNP2zZMSoAwLg7w+hg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 15 Nov 2019 20:27:18 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/7] scsi: ufs: Fix up auto hibern8 enablement
In-Reply-To: <1573802311.4956.8.camel@mtkswgap22>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
 <1573798172-20534-4-git-send-email-cang@codeaurora.org>
 <1573799728.4956.5.camel@mtkswgap22>
 <2a925548b8ead7c3b5ddf2d7bf3de05d@codeaurora.org>
 <1573802311.4956.8.camel@mtkswgap22>
Message-ID: <433afef33c8ca61aa299fa453c0d25d3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-15 15:18, Stanley Chu wrote:
> Hi Can,
> 
> On Fri, 2019-11-15 at 15:03 +0800, Can Guo wrote:
>> On 2019-11-15 14:35, Stanley Chu wrote:
>> > Hi Can,
>> >
>> > On Thu, 2019-11-14 at 22:09 -0800, Can Guo wrote:
>> >> +	if (hba->ahit != ahit)
>> >> +		hba->ahit = ahit;
>> >>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> >> +	if (!pm_runtime_suspended(hba->dev)) {
>> >
>> > Always do pm_runtime_get_sync() here could avoid possible racing?
>> >
>> > And thus AH8 could be enabled regardless of runtime status.
>> >
>> >> +		pm_runtime_get_sync(hba->dev);
>> >> +		ufshcd_hold(hba, false);
>> >> +		ufshcd_auto_hibern8_enable(hba);
>> >> +		ufshcd_release(hba);
>> >> +		pm_runtime_put(hba->dev);
>> >> +	}
>> >>  }
>> >
>> > Thanks,
>> > Stanley
>> 
>> Hi Stanley,
>> 
>> if !pm_runtime_suspended() is true, hba->dev's runtime status, other
>> than RPM_ACTIVE,
>> may be RPM_SUSPENDING or RPM_RESUMING. So, here for safty, do
>> pm_runtime_get_sync() once
>> before access registers, in case we hit corner cases in which powers
>> and/or clocks are OFF.
>> 
> 
> Thanks for explanation.
> 
> I fully understand the intention of this patch.
> 
> Just wonder if "if (!pm_runtime_suspended(hba->dev))" could be removed
> and then always do pm_runtime_get_sync() here.
> 
> This could avoid possible racing and enable AH8 regardless of current
> runtime status.
> 
>> Thanks,
>> Can Guo.
> 
> Thanks,
> Stanley


Hi Stanley,

Actually, I thought about the way you reommand.

But I guess the author's intention here is to update the AH8 timer
only when current runtime status is RPM_ACTIVE. If it is not RPM_ACTIVE,
we just update the hba->ahit and bail out, because the AH8 timer will be
updated in ufshcd_reusme() eventually when hba is resumed. This can 
avoid
frequently waking up hba just for accessing a single register.
How do you think?

Thanks,
Can Guo.


