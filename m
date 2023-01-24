Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F88DC25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 09:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjAXJh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 04:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjAXJh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 04:37:27 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD26C6E8D
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 01:37:25 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id tz11so37473837ejc.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 01:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFzBuftRJy63KmlORLoGouu9RoQag5pA7J5l5Gohg8I=;
        b=mj7L5aKxN9842sdXvuA6XgFMZuiiUe9CZ3pNm5Jto+iKkozcTxTjaz977HBj2VoOzp
         8/ahsRObZFZrnDKwu/bQ1yqmk3OqPq1Qc6XX7cI3Jx1na11+RofFuiMe5j5qtFJwehHd
         Ld7z4HMl4UjlAEke72JUha1ZZMl6M+Gc92dF7KLCyteIvs/XcJgECtt3nbZqFFSe4wT3
         LSsRLOjhzu6IKe27PIkLUjKKN/0/bMZ/UaLCZzgFj40ynYzS9eZnItpDiOhZ4DrhubDJ
         xGc5UV1bIN4IcEbogk79LT7bwkwu0QWmYl7aruVO+JQP5VKD8iADdb9/cqM0FVG6tLfC
         xHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFzBuftRJy63KmlORLoGouu9RoQag5pA7J5l5Gohg8I=;
        b=xXJUWs/6mBvAfpY0XSdR1XgAbgW0YKWsFRnyNFIfAtmbfn/OKPW6hh7y7VxRkcKVx8
         Zi9yVajihpHD4b9PP/X7NGWqzCkzUD266e7+OlAVANTYzGZV2u2YhCF26HNsUr0+HirO
         rXLUzzxInq9arSb4ofz3gChWa49li97FzDLqKTcAJm0YSj4V5egbPnxdYK4XZSnHA5nW
         xKUk/pPsLMc3eu6YfMk+NydY0DKGVX3E1SMqvIbQhaFFRXYePGnlZ03H522UOk0/FKJi
         qmZMTU8YbzJD6PObDNWVCAoTwRTknygp3XiwMJtbUp89z8izXIn0Zd5kOuuN5DK4ZxUD
         5tAg==
X-Gm-Message-State: AFqh2kr97WEyGqzkZNBfVDyfiTm7k2sa7XhLoAl46iAzZ3eAl5crVVzw
        XZl6A3liTFdD7CV8W86kDTY+s3oTlf46lQ==
X-Google-Smtp-Source: AMrXdXtHxJUZxPIy59rIdSvkLbGlo7yO0U5x7hCjx3ArNPmcDu/W9e9rPWrhK1aG+HWPr1L2lXCZ7Q==
X-Received: by 2002:a17:906:2542:b0:877:6e07:92df with SMTP id j2-20020a170906254200b008776e0792dfmr23079656ejb.15.1674553044401;
        Tue, 24 Jan 2023 01:37:24 -0800 (PST)
Received: from elende (elende.valinor.li. [2a01:4f9:6a:1c47::2])
        by smtp.gmail.com with ESMTPSA id mb17-20020a170906eb1100b007c0a7286ac8sm648525ejb.69.2023.01.24.01.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 01:37:23 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 24 Jan 2023 10:37:23 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
Message-ID: <Y8+m0w4Og2CLFImY@lorien.valinor.li>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
 <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
 <Y15lk+CPsjJ801iY@infradead.org>
 <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
 <yq1tu192iur.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1tu192iur.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Mon, Jan 02, 2023 at 08:06:41AM -0500, Martin K. Petersen wrote:
> 
> Martin,
> 
> > is anything blocking mainline inclusion of this patch?
> 
> I applied these to 6.2/scsi-fixes last week. The patches have been
> sitting in a topic branch for a bit due to the three-way conflict
> between fixes, queue, and upstream.

It landed in 6.2-rc4 recently in fact. Thank you!

Would it be posssible to backport the fix as well back to the stable
series affected? 

In Debian we have the reports as per https://bugs.debian.org/1022126
where the issue was introduced back in 5.10.y. Context in
https://lore.kernel.org/linux-scsi/CAK=zhgr=MYn=-mrz3gKUFoXG_+EQ796bHEWSdK88o1Aqamby7g@mail.gmail.com/
.

Regards,
Salvatore
