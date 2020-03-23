Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8606DC54FCE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 536EF20714
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="xvQuDWUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgCWQzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:55:35 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:35125 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgCWQzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2020 12:55:35 -0400
Received: by mail-pl1-f169.google.com with SMTP id g6so6164031plt.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2020 09:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mFFLdkROuGzrX7CaN7iaKQtgyU9352EW9LOMMGLduh0=;
        b=xvQuDWUK4rppNtIXMkhgKlBEq7tXEVsdIK0ASlHSgXnCp63TynMj/BSxfgxNatZGE4
         hqYSR8fD0EMOESlN7IaxTzPFTksKxokG9SR+skwxywHSZSuczsAAnV9ob47XTgd++pDm
         /JyN115oAoDDmdme+LwUAy8/etuWG2uvIhXxt0qK5D2VurNIC1XZnoQK0+5wSwb3gOP8
         BIyoMiadjG/BKoMmdzCTbOQdSx7xXyZDkopdjvsZTf6tGlMmaG3meWzY3ERya7eDqkZ2
         6hpCIcQ+yWWyT/Zh6uGtaxTy5Sgqvt6gbv+s4gHCHIwqwfKkt5O5oucDfb3CwmEvrMJP
         DPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFFLdkROuGzrX7CaN7iaKQtgyU9352EW9LOMMGLduh0=;
        b=BYmCTrK6ucJdzCJTs4Cg7yvOexOfieDSxBm+40SH2rdDk3C1hPRe/DSDflLXghGq9u
         g4pTOO+fhzIsMy8Ghr/p373QvXh3w1hjVvq1bn5qZm3/nwGXB41fltmKP7thHeQ0DXRq
         5Ij+SkwBGl2UUViuVYQfg4U5/p3Ip8+N4/40//4KaIOXysqnlKrlsL93Gi3RxNKtOm9Y
         sYZtUYxVxS3mHqCkwD7NBLfvJz1ysVnsPYXwD0MwqdfXl/j4HYBH2OgtlDw/c6Yzm85w
         79gbaWD3woo08Fupv3cmWqF2KYQCoihlXpk0TT8x/N4sMLfNmNKFtz3Hmftj3P14vJw7
         RWSA==
X-Gm-Message-State: ANhLgQ2IarrUkEwPAZMYnMCWOCGJ0TbFUfUTcIu8KLY8zn8SpmPeynl3
        lQHqn88YKfyPeKDyWUrS4FzwYQ==
X-Google-Smtp-Source: ADFU+vuYepzjMGiCUsHvUENLWjzFpios4va2+xolhoUb5eHRh6FDeKvuNbWj1Ly2VgD2e/ww5OX2lQ==
X-Received: by 2002:a17:902:a603:: with SMTP id u3mr17911749plq.105.1584982532060;
        Mon, 23 Mar 2020 09:55:32 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id nu13sm112828pjb.22.2020.03.23.09.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:55:31 -0700 (PDT)
Subject: Re: cleanup the partitioning code
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
References: <20200312151939.645254-1-hch@lst.de>
 <20200323165234.GA29925@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7b7eb188-441a-b503-d526-f5bc029891fc@kernel.dk>
Date:   Mon, 23 Mar 2020 10:55:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200323165234.GA29925@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/20 10:52 AM, Christoph Hellwig wrote:
> ping?
> 
> On Thu, Mar 12, 2020 at 04:19:18PM +0100, Christoph Hellwig wrote:
>> Hi Jens,
>>
>> this series cleans up the partitioning code.
> ---end quoted text---

I did take a look, looks fine to me. Doesn't apply to the 5.7/block
branch though, I'll take a look in a bit, probably an easy reject.

-- 
Jens Axboe

