Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C28C48BE5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D996611CD
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFKVAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:00:24 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43687 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKVAW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 17:00:22 -0400
Received: by mail-pf1-f175.google.com with SMTP id m7so5414919pfa.10;
        Fri, 11 Jun 2021 13:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O8H3BiBJNzajncxIY4TGfWZDVXxaN+VXYPDuuK50WWM=;
        b=oIiwrCaPO07zRTdbkEdjAsfPglZu853uM6z1GMJXnPqNFrLKxtclPup7KpunMktBsn
         75lYV579wX72pO6KwmheAJRlhNKANSQAUiESmvvJvt8O34j1gMdTl0T1HL9/6AzhjMcN
         rtjaDyngglOoxI9XiwKwwC7LKYvioBwlZqJ78nFagR8ACvhPMwvNVbE769X5cfoHoJGj
         LVqfHQ/034nZW3R1Lj7dJBrQrGRhN6YGvlICqypJlpCUg85GTULtrJzZwNzkokv/KzoT
         R7oXLJJ2TsziWMcO6TNN9rkCh+RRhMFIgjyY07R0rwy2+J/WIAdj+wm/Ra8g4PmnlCLa
         bAew==
X-Gm-Message-State: AOAM531fY+0F1VlTW3LvX8/Xddjd/v3tbogE2zDc360fC6rimWIw+BA8
        Ah6OnmFiJeMp69I8DH53olOj03h/lr4=
X-Google-Smtp-Source: ABdhPJzdbbmZ6Ec1B/2Nqw3W6A4DhaMfGUT1Ib3k//Bmy8wlbCPm0DZ1m4ZSre/fpbpIDK7boJ7DgA==
X-Received: by 2002:aa7:8b4f:0:b029:2bd:ea13:c4b4 with SMTP id i15-20020aa78b4f0000b02902bdea13c4b4mr9949524pfd.48.1623445092184;
        Fri, 11 Jun 2021 13:58:12 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id m1sm5883416pfc.63.2021.06.11.13.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 13:58:11 -0700 (PDT)
Subject: Re: [PATCH v3 5/9] scsi: ufs: Simplify error handling preparation
To:     Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-6-git-send-email-cang@codeaurora.org>
 <6abb81f6-4dd2-082e-9440-4b549f105788@intel.com>
 <f0ae504bccc428fa674a183608174bdd@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4f6ea52f-308e-8252-5a19-3911eb9b99b1@acm.org>
Date:   Fri, 11 Jun 2021 13:58:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <f0ae504bccc428fa674a183608174bdd@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/10/21 8:01 PM, Can Guo wrote:
> Previously, without commit cb7e6f05fce67c965194ac04467e1ba7bc70b069, 
> ufshcd_resume() may turn off pwr and clk due to UFS error, e.g., link
> transition failure and SSU error/abort (and these UFS error would
> invoke error handling).  When error handling kicks start, it should
> re-enable the pwr and clk before proceeding. Now, commit 
> cb7e6f05fce67c965194ac04467e1ba7bc70b069 makes ufshcd_resume()
> purely control pwr and clk, meaning if ufshcd_resume() fails, there
> is nothing we can do about it - pwr or clk enabling must have failed,
> and it is not because of UFS error. This is why I am removing the
> re-enabling pwr/clk in error handling prepare.

Why are link transition failures handled in the error handler instead of
in the context where these errors are detected (ufshcd_resume())? Is it
even possible to recover from a link transition failure or does this
perhaps indicate a broken UFS controller?

>> but what I really wonder is why we don't just do recovery directly
>> in __ufshcd_wl_suspend() and  __ufshcd_wl_resume() and strip all 
>> the PM complexity out of ufshcd_err_handling()?

+1

> For system suspend/resume, since error handling has the same nature
> like user access, so we are using host_sem to avoid concurrency of
> error handling and system suspend/resume.

Why is host_sem used for that purpose instead of lock_system_sleep() and
unlock_system_sleep()?

Thanks,

Bart.
