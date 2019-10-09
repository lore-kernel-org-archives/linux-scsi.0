Return-Path: <SRS0=LfzD=YC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7560FECE58D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 16:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA62206BB
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 16:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfJIQbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:31:32 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:38578 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIQbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 12:31:31 -0400
Received: by mail-pg1-f174.google.com with SMTP id x10so1741432pgi.5
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2019 09:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TRrgGAU3uIdTjazPEvdPrOBWBErZwRaofNYpzZyg9Q=;
        b=mY7gZgB8PBb0jrH+1W+9c/f9uZL8ZPOQOB5cJ85A5nlg3hTDtFqUHZDhvUdVIbZTPo
         9kSClL8056YKSwMeFPsv2/7xeA5dAOCTEcHrXWAgjA3axpR0/txKDhPmUmLFTCdH7/5X
         lrFH2olVGo8Lf3IxT7T96EJAxFoVZ63Ri+TrBwPcTSadpZXEDp5afKijFHVzUWahx7/b
         dFmysOsF0C40nHPA/5LjyBJWnXXM7VxuUDUAAhmMAElkgtYx+bbCdagAIbg55OTZRmjt
         WmLrJ7Y08jatyKJG9mLz+Tv3GUsHWkxyMRwcOybgBmRJDVOTjM9Yw/V6K7UxOZZ04Zlh
         L3sw==
X-Gm-Message-State: APjAAAXjv3vD0CUnWp1sXkNY0RzrzurRC4B2eZpNFNURTWlsLRfqsZWX
        h+0XzWXJrv+eMWhe3AoCvS8=
X-Google-Smtp-Source: APXvYqyIMBtJU+n4HSDPkKB9eSluIgX7szf9fGR9kcQI28vu3fCfG93NO/ZbFRs7eOnEmaOf4E48Ew==
X-Received: by 2002:a65:5503:: with SMTP id f3mr5300515pgr.351.1570638690659;
        Wed, 09 Oct 2019 09:31:30 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j26sm3317174pgl.38.2019.10.09.09.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 09:31:29 -0700 (PDT)
Subject: Re: [PATCH] scsi_dh_alua: handle RTPG sense code correctly during
 state transitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191007135701.32389-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d7304922-3163-64ea-5a95-4fc2dd1270f8@acm.org>
Date:   Wed, 9 Oct 2019 09:31:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007135701.32389-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/19 6:57 AM, Hannes Reinecke wrote:
> Some arrays are not capable of returning RTPG data during state
> transitioning, but rather return an 'LUN not accessible, asymmetric
> access state transition' sense code. In these cases we
> can set the state to 'transitioning' directly and don't need to
> evaluate the RTPG data (which we won't have anyway).

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
