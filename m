Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83DBC3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 22:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5DD3217F5
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 22:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DvyEsJr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfHZWdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 18:33:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35121 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfHZWdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 18:33:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id d85so12745537pfd.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2019 15:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:references:from:to:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/rzvNNsw8m3WN6vcOTggwj95MmrYEljq1jEF0qII3YM=;
        b=DvyEsJr3ER5Ouca+Qw4DJredOW7WG8ObpSvvu/W9lPQnEzH6nVoNsOB4b9qWRS1NIN
         OFYEzZ7PN+BHzq4AmkORHQiiMGC1B9QbIpc3FzLOQyJL5Hh/CBw8n3JHDd8jYHFuNFPk
         44fh83FCL7aV3s+fFGq2Op0nDBI2DtjC/RDz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:from:to:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/rzvNNsw8m3WN6vcOTggwj95MmrYEljq1jEF0qII3YM=;
        b=XNlHA9NZ7krp6seKTRoqpCTL5PoWfm8Pwx5SjIx7jK4X9PvkUQSyGiKIxCfTfdLtEB
         A1ed79Qmpg5vTtBTAHhdV5F4/dV53oeipeu5ztcR8Tqwj+EfbwqZy9E818wM3B7EJ1WQ
         6gIQHnxWib8BnMXd2oSfyjfN9n/dDg8syDVebVRry2v1nW7uuoT4bX/ecj9P1lxHVdFc
         JddXpuB99ZEvWXa/nrXmpalhfDN6xlmFRyLh5dz04f23T776pi8oqBS935s1VUy04vsw
         pxqkNFzjROc4p2V9zSAUUJ4X8SwcLmdA3czpAK5h3Tfx/pv+sEMABSA1XnaI5puynS7I
         VyQQ==
X-Gm-Message-State: APjAAAWuDIikO112ZWmkB0YVP6pf+2mM4QHzZJNm0I0zTa/yrZgpvSJ1
        o1+gPm7n4JdvYD1ao/rtydeVbQ==
X-Google-Smtp-Source: APXvYqxXG4MwZNHm4iTsddvoAsvDFiXRcUvjNd+b7O7nx+hLrH1D6PlZcuNF849gW8kDtDy29Fj8Lw==
X-Received: by 2002:a17:90a:3847:: with SMTP id l7mr21242793pjf.99.1566858822523;
        Mon, 26 Aug 2019 15:33:42 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a1sm11525298pgh.61.2019.08.26.15.33.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 15:33:41 -0700 (PDT)
Subject: Fwd: Re: [PATCH] lpfc: Fix Buffer Overflow Error
References: <d1e549e4-7488-0220-63b9-412d4b072136@broadcom.com>
From:   James Smart <james.smart@broadcom.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>
X-Forwarded-Message-Id: <d1e549e4-7488-0220-63b9-412d4b072136@broadcom.com>
Message-ID: <9965492b-c097-3c85-ab9e-fb42b6fe1cc8@broadcom.com>
Date:   Mon, 26 Aug 2019 15:33:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d1e549e4-7488-0220-63b9-412d4b072136@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/16/2019 7:48 AM, KyleMahlkuch wrote:
> Power and x86 have different page sizes so rather than allocate the
> buffer based on number of pages we should allocate space by using
> max_sectors. There is also code in lpfc_scsi.c to be sure we don't
> write past the end of this buffer.
>
> Signed-off-by: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
> ---
> drivers/scsi/lpfc/lpfc_init.c | 41 
> +++++++----------------------------------
> drivers/scsi/lpfc/lpfc_scsi.c | 14 ++++++++++++--
> 2 files changed, 19 insertions(+), 36 deletions(-)

Kyle,

After looking at this code, there are several issues:
- why the 2^10 (4MB @ 4k pgsz) buffer size (horribly named as pagecnt)
- didn't comprehend pagesizes > 4k
- corresponding dif buffer doesn't need to be the same size
- no checking of exceeding buffer length when copying
- allocation even when debugfs wasn't configured
- could the entity downloading identify which phba loaded the buffer ?

Given this was added a decade ago with initial DIF support and has 
rarely been used, we're going to remove the debugfs bg buffer mechanism 
completely.

- james

