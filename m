Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB05FC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 07:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9382B2073B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 07:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NyUEhUv8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iATKS7ia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOHDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 02:03:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfKOHDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 02:03:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E06AD61069; Fri, 15 Nov 2019 07:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573801418;
        bh=cXKB7/z8hKIcCs1csnbwGGQvhJZYZrYw+Be56PBlCDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NyUEhUv8ts/nDu7Q0ClZ8xWYm4i9KztgjtFhp/gP9xiBba/jknAtjhEppiq592i2B
         HDJUwjlAc6etxqE+O32/g0egtG28sgeG5UNzu8J/ZJbj5wR76MZyJ23sww9zO1U3Xx
         m4nYgR7vbhlwsBvulvgjD8uSf8WZig3/aljjTCLw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B18CE60F79;
        Fri, 15 Nov 2019 07:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573801417;
        bh=cXKB7/z8hKIcCs1csnbwGGQvhJZYZrYw+Be56PBlCDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iATKS7iaEVRZOR1zD2uYbDqyi9VL7LHTyD+b44EEKNeZQoyLmbL/NK64TBzFlXNz6
         t/BFWUgmCcUsDhjGCHS3tjTPGEV9NHxjhcO5pM9V5KaKr1WaPKur+mZjRXFdvdGwyG
         eFCuCurus72s1f3Axmxtmxgo/UkJkw4MaMjml8Dk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 15 Nov 2019 15:03:37 +0800
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
In-Reply-To: <1573799728.4956.5.camel@mtkswgap22>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
 <1573798172-20534-4-git-send-email-cang@codeaurora.org>
 <1573799728.4956.5.camel@mtkswgap22>
Message-ID: <2a925548b8ead7c3b5ddf2d7bf3de05d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-15 14:35, Stanley Chu wrote:
> Hi Can,
> 
> On Thu, 2019-11-14 at 22:09 -0800, Can Guo wrote:
>> +	if (hba->ahit != ahit)
>> +		hba->ahit = ahit;
>>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +	if (!pm_runtime_suspended(hba->dev)) {
> 
> Always do pm_runtime_get_sync() here could avoid possible racing?
> 
> And thus AH8 could be enabled regardless of runtime status.
> 
>> +		pm_runtime_get_sync(hba->dev);
>> +		ufshcd_hold(hba, false);
>> +		ufshcd_auto_hibern8_enable(hba);
>> +		ufshcd_release(hba);
>> +		pm_runtime_put(hba->dev);
>> +	}
>>  }
> 
> Thanks,
> Stanley

Hi Stanley,

if !pm_runtime_suspended() is true, hba->dev's runtime status, other 
than RPM_ACTIVE,
may be RPM_SUSPENDING or RPM_RESUMING. So, here for safty, do 
pm_runtime_get_sync() once
before access registers, in case we hit corner cases in which powers 
and/or clocks are OFF.

Thanks,
Can Guo.
