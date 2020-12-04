Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883EBC4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FCC22CAD
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbgLDQv2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:51:28 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35824 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbgLDQv2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:51:28 -0500
Received: by mail-pf1-f195.google.com with SMTP id c79so4113211pfc.2;
        Fri, 04 Dec 2020 08:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tKNG89IP0eWAuFAmQbkXENZV9Tbmi4dU4MxDvBA7mFI=;
        b=OfUNSUs5OxS2as7eBxQdTZXATgCM9VvgbpYwrkxk2Ok51AW9WU1Dbem2i14dSOaPVU
         Ki0X7/cmuq87VlyBZlHKNOmxHZZYKN15nhhfDpitfcgPJQcGiMT10fAOy1Oco9oUBgbV
         V1O4qdZq2ef0bLDSrWfbE0TQXia8Hgr6K+M/o3zDGs+GruFatt+3yiVgmPnAB0NEu99F
         BVMgw9+uF5D6eqNxSvIxwJ+axyCz0VPqLy7VTwhuoEf9yeN6m4cYUBMKtVmlphd01GD4
         0VBRMTWv++TkWjO5aifejOmxMd9RVZJQFbXBCZfIZUH0Z3rmvfBLF6hxpqVfSFFGmVdO
         iDTw==
X-Gm-Message-State: AOAM531ogFjfZAO+LBBfTAcRjuRGJxEuRp2sqnEdobUR25fYvMJrdKbv
        QMicZtvKn76CAK9nBz+xeIo=
X-Google-Smtp-Source: ABdhPJyVjoClBTZulB9nZ/rWWhlx2xF6FBwXReB+wzB03dYuTytWT/YAJkp7loPNHUyzV5nqAtAYEg==
X-Received: by 2002:a63:4:: with SMTP id 4mr8059058pga.443.1607100647637;
        Fri, 04 Dec 2020 08:50:47 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w2sm2687796pjb.22.2020.12.04.08.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:50:46 -0800 (PST)
Subject: Re: [PATCH v4 5/9] scsi: Do not wait for a request in
 scsi_eh_lock_door()
To:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20201130024615.29171-1-bvanassche@acm.org>
 <20201130024615.29171-6-bvanassche@acm.org>
 <bdadfbcd-76c4-4658-0b36-b7666fa1dc7b@suse.de>
 <6e5fbc73-881e-69c7-54ce-381b8b695b3c@acm.org>
 <b56cf3af-940f-62ed-2a79-eb80599e2f44@suse.de> <20201203072738.GB633702@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <32732e89-e425-2b71-4564-35e243f170bc@acm.org>
Date:   Fri, 4 Dec 2020 08:50:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201203072738.GB633702@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/20 11:27 PM, Ming Lei wrote:
> BTW, scsi_eh_lock_door() returns void, and it can't be sync because
> there may not be any driver tag available. Even though it is available,
> the host state isn't running yet, so the command can't be queued to LLD
> yet.
> 
> Maybe the above lines should be put after host state is updated to
> RUNNING.
> 
> Also changing to NOWAIT can't avoid the issue completely, what if 'none'
> is used?

Hi Ming,

I am considering to drop this patch since the latest version of the SPI
DV patch no longer introduces a new blk_mq_freeze_queue() call in the
SPI DV code. In other words, any potential issues with
scsi_eh_lock_door() are existing issues and are not made worse by my
patch series.

Thanks,

Bart.
