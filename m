Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88036C282DD
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 18:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 651782075D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 18:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U3nfmbMH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgAHSnM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 13:43:12 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54251 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgAHSnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 13:43:12 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so1438438pjc.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 10:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GqM7/Gox89N6RYmX8N+C+JYNDY9Y92t5hXeig9A+0NE=;
        b=U3nfmbMHq/W60Cggp7RJIO+vjwZF+eOByq0zw2NdD3Ar4SSHaOIVputw0PVblX2/o4
         rGuycl8hULEeLa76n6VKtiejtrAZxV2ip7LKG2pkIUppk7kP+nYsoJH8PIA2ERd6eHZF
         7kg8c8oxe1HfsuNiPK04ZvCZVI7p4MrF4wrplzGBHJ7+0t7oRiI5MUorB0njq6uxH/p4
         g3w3/0xI8Flgn5SK4qw2rmZOVRk4uCUJbVGYc+4YUDe02CHqfod56+BNdpYqpkr4u4Ju
         QWRtvYtE+1qc0bdsIr5YDGmM3klH/1hIseMl+g3jErzlysuBDR4N36fNB1+B3orn9fso
         nn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GqM7/Gox89N6RYmX8N+C+JYNDY9Y92t5hXeig9A+0NE=;
        b=T2cg95ORvFio40SdUTOZmXAYiV23pvtqZmWJHyQmB4vG/BCPck5SIedPbfdV2Uebc6
         181C7juF6GKfAhp14s4jmvPM4u6rM9i1scL34DAVk+I0jZ9nllX+LIOC1V9V7wEgQpi6
         JTz6/o8n/aC9XDDIz++0Bc3BN3CyDGJSk+4LaEzEGCgjwgWgze5G82C/xMVftTJVkZ+A
         2GKnXLN4Yf2L6PvS1CvfNDk0Ie+JWN5x1nX/2Z9JxmKJrCTcAfYMf1qoxDZdM9Z1FFlJ
         QNFy1q2awThSrUGf5fPhSaopuYpJKeopgPAB42/2Ze2zIK4g65p9o+Ovz7ptKTgS9BAv
         1viA==
X-Gm-Message-State: APjAAAUUVK8Frh51hAtf0mxC6/vZNdWSIEJXHMTTRf5uLwyeaUPL+O3y
        LtmE9KA2oiC+QDN4rZfVjtJfVg==
X-Google-Smtp-Source: APXvYqwLsrqAQku6UEZ+m75sX13ln6fLUNoETR2ZmPckprU0bqTzke9nFnndvHW2jpMVg425OyWE3w==
X-Received: by 2002:a17:90a:480a:: with SMTP id a10mr14637pjh.88.1578508990909;
        Wed, 08 Jan 2020 10:43:10 -0800 (PST)
Received: from google.com ([2620:15c:201:0:7f8c:9d6e:20b8:e324])
        by smtp.gmail.com with ESMTPSA id y7sm4734645pfb.139.2020.01.08.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 10:43:10 -0800 (PST)
Date:   Wed, 8 Jan 2020 10:43:05 -0800
From:   Satya Tangirala <satyat@google.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 0/9] Inline Encryption Support
Message-ID: <20200108184305.GA173657@google.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20200108140556.GB2896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108140556.GB2896@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 08, 2020 at 06:05:56AM -0800, Christoph Hellwig wrote:
> I haven't been able to deep dive into the details, but the structure
> of this still makes me very unhappy.
> 
> Most of it is related to the software fallback again.  Please split the
> fallback into a separate file, and also into a separate data structure.
> There is abslutely no need to have the overhead of the software only
> fields for the hardware case.
> 
The fallback actually is in a separate file, and the software only fields
are not allocated in the hardware case anymore, either - I should have
made that clear(er) in the coverletter.
> On the counter side I think all the core block layer code added should
> go into a single file instead of split into three with some odd
> layering.
> 
Alright, I'll look into this. I still think that the keyslot manager
should maybe go in a separate file because it does a specific, fairly
self contained task and isn't just block layer code - it's the interface
between the device drivers and any upper layer.
> Also what I don't understand is why this managed key-slots on a per-bio
> basis.  Wou;dn't it make a whole lot more sense to manage them on a
> struct request basis once most of the merging has been performed?
I don't immediately see an issue with making it work on a struct request
basis. I'll look into this more carefully.

Thanks!
Satya
