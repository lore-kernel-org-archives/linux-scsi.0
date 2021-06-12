Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33024C48BE5
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 09:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0878F611CC
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 09:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFLJvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 05:51:36 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35134 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhFLJvf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2021 05:51:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623491376; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=h+lKHMirYOo4CZO75qbhiOYJsV8XQqazDat76Bs0AYM=;
 b=B/ui3EZyULBJewoZFt3Xs80hfNP8LHGW/8RZIJF8yVa0C42C6leIC3MhFojjIhLdcdFhb11G
 dp222SvEXtF+qfRKVIF6VansswiKayltg1EGKXY10gBV3dK/gg/uCssOstWcNVFr+37kSLWL
 I7xu3dolczX5PpkKb7f9wtuYrtA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60c483278491191eb3373ff3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 09:49:27
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D0CC2C43460; Sat, 12 Jun 2021 09:49:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC8DEC433D3;
        Sat, 12 Jun 2021 09:49:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 12 Jun 2021 17:49:26 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] scsi: ufs: Simplify error handling preparation
In-Reply-To: <645c0e3c83c8917a8fd5c0493c5815a0@codeaurora.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-6-git-send-email-cang@codeaurora.org>
 <6abb81f6-4dd2-082e-9440-4b549f105788@intel.com>
 <f0ae504bccc428fa674a183608174bdd@codeaurora.org>
 <4f6ea52f-308e-8252-5a19-3911eb9b99b1@acm.org>
 <645c0e3c83c8917a8fd5c0493c5815a0@codeaurora.org>
Message-ID: <d3c57c8e52f7a251b5c536a893b1f101@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-12 14:46, Can Guo wrote:
> On 2021-06-12 04:58, Bart Van Assche wrote:
>> On 6/10/21 8:01 PM, Can Guo wrote:
>>> Previously, without commit cb7e6f05fce67c965194ac04467e1ba7bc70b069,
>>> ufshcd_resume() may turn off pwr and clk due to UFS error, e.g., link
>>> transition failure and SSU error/abort (and these UFS error would
>>> invoke error handling).  When error handling kicks start, it should
>>> re-enable the pwr and clk before proceeding. Now, commit
>>> cb7e6f05fce67c965194ac04467e1ba7bc70b069 makes ufshcd_resume()
>>> purely control pwr and clk, meaning if ufshcd_resume() fails, there
>>> is nothing we can do about it - pwr or clk enabling must have failed,
>>> and it is not because of UFS error. This is why I am removing the
>>> re-enabling pwr/clk in error handling prepare.
>> 
>> Why are link transition failures handled in the error handler instead 
>> of
>> in the context where these errors are detected (ufshcd_resume())? Is 
>> it
>> even possible to recover from a link transition failure or does this
>> perhaps indicate a broken UFS controller?
> 
> Basically, almost all UFS failures are caused by errors in underlaying 
> layers,
> i.e., UIC errors, including link transition failures. And according to 
> UFSHCI
> spec, SW should do a full reset to recover it, just like handle any 
> other
> fatal UIC errors. All UIC errors are detected by HW and reported by IRQ 
> handler.
> 
> UFSHCI Spec Ver. 31
> 8.2.7 Hibernate Enter/Exit Error Handling
> Hibernate Enter/Exit Error occurs when the UniPro link is broken. When
> this condition occurs,
> host software should reset the host controller by setting register HCE
> to ‘0’, re-initialize the host
> controller by setting register HCE to ‘1', and then start link startup
> sequence as shown in Figure 16.
> 
>> 
>>>> but what I really wonder is why we don't just do recovery directly
>>>> in __ufshcd_wl_suspend() and  __ufshcd_wl_resume() and strip all
>>>> the PM complexity out of ufshcd_err_handling()?
>> 
>> +1
> 
> I've explained why I chose not to do this in my last reply to Adrian.
> Please kindly check it.
> 
>> 
>>> For system suspend/resume, since error handling has the same nature
>>> like user access, so we are using host_sem to avoid concurrency of
>>> error handling and system suspend/resume.
>> 
>> Why is host_sem used for that purpose instead of lock_system_sleep() 
>> and
>> unlock_system_sleep()?
>> 
> 
> I was aware of it, but the situation is that host_sem is also used to
> avoid concurrency among user access, error handling and shutdown, so
> I think just use host_sem anyways to simply the lockings, otherwise
> user access and error handling would have to take both 
> system_transition_mutex
> and host_sem

On second thought, I will take your suggestion to use 
lock_system_sleep()
and unlock_system_sleep() in error handler and remove the host_sem used
in suspend/resume, which can make the code more readable by keeping the
changes within error handler itself. However, please note that host_sem
will still be used to avoid concurrency of user access, error handler 
and
shutdown.

Thanks,
Can Guo.

> 
> Thanks,
> 
> Can Guo.
> 
>> Thanks,
>> 
>> Bart.
