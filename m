Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717B1C54FCF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47C4E2074D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="g6ZHAhjo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCWQ5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:57:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43216 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgCWQ5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2020 12:57:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id f206so7761954pfa.10
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2020 09:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9vQISIidvx2HC6I208asLL9LQG5D5c4JBYTE7WN0yIM=;
        b=g6ZHAhjo9gbL92ftJyIXUjnrl8Gkjl1lMi6ROa0hw8Rrq9gsvWPKeLL02f6LOMY1ED
         kn8Y1GhddqicGyeUxNhB1LlLhk9UBEAyT+BHzC3rj4YrlJzi921312R3L6Z1Em1UvsN0
         NT2nOO2sN2PLDSEA5O8WG83DsbFVTApVNvNh7aStwgtTMkC75URLlnrfievp/4gVTnNj
         Nx5KU1QmAonSTXu6EV9x/xm6W7MgnG29s2qzwZB41bABAWjY1NkEeGKSDCh6HiaaNrn6
         K8OQwIOOUkkrBVXKYhrqDfkvdlEcigOhf02mS6bYmeG6U4YP9BrXkmY0wUSpBkJ01UiN
         5hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9vQISIidvx2HC6I208asLL9LQG5D5c4JBYTE7WN0yIM=;
        b=n3KU4QBSCJo5S0khkuSVZVXqfTF4Fc/d/H7s1jLJSuWGp/VxZhPV+hUHIixY8kHXZ/
         e4tXLHvG1kFQnBlaIJDVGr9BJttcjy2RV98wQe9inMLrn9vmQtL2z0G+MvcSTe4Yvj0m
         YZHhsBYFReyoM8Jrb1Eql7K7sRoS4TBkbKVa/rssMLLDggJi/5Pm9GwT1OSufFQJRvzR
         /7x/GgK/gDqbi46dpWZn3sy2fHUu1Csrqshdb3vaNMKJFP93gsc2pr3ALPPzw3KDxFRt
         DXpKd19KgyuFlLgaXwsAxgM5gnuQxgxSnqwHrvV7XRFP8bApAVQwprUBC2fDQ3C8AoeD
         vpPA==
X-Gm-Message-State: ANhLgQ1uQ+M+CHNKv0Vn6LcboJFFyyi1LCzk7XFkwzi5Mu5kBEw3+5tp
        A1aVc5TH4CI4Gsl/tVUjyu6t1g==
X-Google-Smtp-Source: ADFU+vvjqZSyzdI96ENIy59Pb/roNaeHcXNvlD0NqRkBXXt2VcMkP4CIEl0A8IteAbgwmlJuL6lozA==
X-Received: by 2002:a63:cb:: with SMTP id 194mr23416925pga.37.1584982629945;
        Mon, 23 Mar 2020 09:57:09 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y142sm14415915pfc.53.2020.03.23.09.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:57:09 -0700 (PDT)
Subject: Re: cleanup the partitioning code
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
References: <20200312151939.645254-1-hch@lst.de>
 <20200323165234.GA29925@lst.de>
 <7b7eb188-441a-b503-d526-f5bc029891fc@kernel.dk>
Message-ID: <7bb040b9-41c5-9e11-c74d-fec7912e0e3c@kernel.dk>
Date:   Mon, 23 Mar 2020 10:57:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7b7eb188-441a-b503-d526-f5bc029891fc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/20 10:55 AM, Jens Axboe wrote:
> On 3/23/20 10:52 AM, Christoph Hellwig wrote:
>> ping?
>>
>> On Thu, Mar 12, 2020 at 04:19:18PM +0100, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> this series cleans up the partitioning code.
>> ---end quoted text---
> 
> I did take a look, looks fine to me. Doesn't apply to the 5.7/block
> branch though, I'll take a look in a bit, probably an easy reject.

Yeah, looks like a trivial conflict with:

commit e598a72faeb543599bdf0d930df3a71906404e6f
Author: Balbir Singh <sblbir@amazon.com>
Date:   Fri Mar 13 05:30:05 2020 +0000

    block/genhd: Notify udev about capacity change

-- 
Jens Axboe

