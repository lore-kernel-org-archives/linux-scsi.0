Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E22FC432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 15:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4733520722
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 15:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="nFVel339"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfKZPOR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 10:14:17 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:32796 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbfKZPOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 10:14:17 -0500
Received: by mail-il1-f194.google.com with SMTP id y16so10411943iln.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2019 07:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NelhYQEseu/7zrmJjT1c+B6QEJCkr4nf8LehOSkDJD4=;
        b=nFVel339LoT+RjzrhKqwVlhsD4zOWXEqXVF9eZ+33w3b0CtB47WthAXlnR1vTVx/1w
         NyHZwNXp45TU3SFzohlW72uZoo2rdSSRDSwWZfv0IWMAOKRcWMAnVbBEmDpGKK4/KFoz
         AZ5wWObjKDkiksJ5YCYdjHrY/3X6qKag8Gf3WKpdqj12xmpnAqJo9/v2fjsxOOku/xe9
         /AB3m7JE1MZrcMYp2L0Ul90DLtHqy+z5LbY6D9wuHaDABmCEatd53QT+jgfgeFNqw/Ih
         +PSISMHeWNRhMOgrlTvIA5kRhxK+nTqFzwxYoW1qaDFynOCWYMe6J9YsSskZBiT9aXMC
         4Sxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NelhYQEseu/7zrmJjT1c+B6QEJCkr4nf8LehOSkDJD4=;
        b=unjIWBgAUvALXBqZCP4pH6/gHQ2ebZl8AD9Jj1Xp9u+XAo1z5X9EaV37/YSc9dS/fX
         LMEJr8DT+XG2lpVNG1A1GorRsaSPVl2qtGsAvsgkeivOeeic73t8Si2Swxzucdy/86VK
         AAa8NaFjM8RPE8Q6Wl/mHpgq1B4v2u03dHGA94cMlWeUzKAhnAY9D4S4her7YoLZRzrn
         gQz9LMxqb7W5yCsQdibwJQcWlHyGqYKm6pH26kgPg+QH41Vk5aq5LgcXtl5hv/26637f
         KJR660xEjSoTuu4UoJwj9WFaMNqRF7GxtVs0hHJsBEadu+BXlqwlbIcBCdEPfQjQXU68
         rXTg==
X-Gm-Message-State: APjAAAWM1eZg2JiF87XfTjSm3OvgL/gVgrepgQ/ebZ55qu0WwCxrf1nY
        RJJAjGENqPOeczuXzyzzUeqWhQ==
X-Google-Smtp-Source: APXvYqz1b8dU2Vt1sEOjb4Z/KXLaXZkk/3jqCl8fwxwDjaLt6YDqTuaGF/o4VCbA1jDI2ujTeq4E5g==
X-Received: by 2002:a92:86c5:: with SMTP id l66mr38218708ilh.280.1574781255440;
        Tue, 26 Nov 2019 07:14:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p16sm3266654ili.33.2019.11.26.07.14.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 07:14:14 -0800 (PST)
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
Date:   Tue, 26 Nov 2019 08:14:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126091416.20052-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/19 2:14 AM, Hannes Reinecke wrote:
> Instead of allocating the tag bitmap in place we should be using a
> pointer. This is in preparation for shared host-wide bitmaps.

Not a huge fan of this, it's an extra indirection in the hot path
of both submission and completion.

-- 
Jens Axboe

