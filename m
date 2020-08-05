Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93507C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 00:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F2320792
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 00:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aYjVfEoM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHEAkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 20:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgHEAkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 20:40:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E456C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 17:40:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p20so4112556wrf.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 17:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hJW6wAkuoQDVAepJ5Cv3gWI6qzML2AhmW89J2ZpCvBI=;
        b=aYjVfEoMZdXH24qlnS3M7VKdM/4CrIuQbZ1Ctm3utrbCjdxibrVgB9Re+wkQQ6Yag3
         ZE4EkRYx0N2q4Y3A9/bPb9KlY3FK71K9PU7gQgvT1OqdIe57mYFjilbUb0ZM6N4yIUBL
         O0QRk6O7dPBVXkYu8ztrFsUD2ZboBTjeJ+SAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hJW6wAkuoQDVAepJ5Cv3gWI6qzML2AhmW89J2ZpCvBI=;
        b=bm8HNsrB+exc3xp2zyrVlInobjhAspyHLsO6CVBPIF8S9Ynlvl5H0Fa+dkKBJHoRAx
         3xoHfgfVFZCKtvycsKabHPX6E3iSxkBlPw4dYA4CC0a0jMKUjUo91oq+EAkXeDqB5Xss
         6zXHOPT1vPiFrsCkemnFsM8uhjCD/fbW7RhaPNbF1NmVCIJ0508VYntgl8Mbt2koXV0D
         /orPZtAzGCWdwNkh0kqZg/LsMZVM+etVDaQvQRXiOPcLeR4TV6/aQsp8Vbb8DVn6C0VV
         Q3bpuj/WPFZszIrC8SjIqLu1zB7SpMNB3TlHHpq7QaBNjHG6RqQ3r+SeNZr1ituIIhJd
         2h3A==
X-Gm-Message-State: AOAM530MRh8tcUKWljlfTyNgcOpG5NS7LGH0Hcq/uPdkFe/Z5DRs3zCv
        MFIgX/kfvH2QFI7WBJamClcqBA==
X-Google-Smtp-Source: ABdhPJxKkNX69AKXiUthEHMB6Dol3OWroWIMuU5IyuxNcQhTiTyAkCPxkDdFLyDUt8qOnMHGouuU0A==
X-Received: by 2002:adf:efcc:: with SMTP id i12mr411064wrp.308.1596588002977;
        Tue, 04 Aug 2020 17:40:02 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g188sm608229wma.5.2020.08.04.17.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 17:40:02 -0700 (PDT)
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio
 controller
To:     Tejun Heo <tj@kernel.org>, Daniel Wagner <dwagner@suse.de>
Cc:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
 <20200804142123.GA4819@mtj.thefacebook.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com>
Date:   Tue, 4 Aug 2020 17:39:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804142123.GA4819@mtj.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/2020 7:21 AM, Tejun Heo wrote:
> Hello,
>
> On Tue, Aug 04, 2020 at 01:31:30PM +0200, Daniel Wagner wrote:
>> Hi,
>>
>> [cc Tejun]
>>
>> On Tue, Aug 04, 2020 at 07:43:01AM +0530, Muneendra wrote:
>>> This Patch added a unique application identifier i.e
>>> blkio.app_identifier knob to  blkio controller which
>>> allows identification of traffic sources at an
>>> individual cgroup based Applications
>>> (ex:virtual machine (VM))level in both host and
>>> fabric infrastructure.
> I'm not sure it makes sense to introduce custom IDs for these given that
> there already are unique per-host cgroup IDs which aren't recycled.
>
> Thanks.
>

If the VM moves to a different host, does the per-host cgroup IDs 
migrate with the VM ?   If not, we need to have an identifier that moves 
with the VM and which is independent of what host the VM is residing on.

-- james


