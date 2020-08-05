Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEDEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 20:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C03AA22B42
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 20:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596658337;
	bh=eNpUFKziZ8BMio9ND8TxOtF+Q/qHv5pmQy9gd3/EBrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Y2ghh/wYJM9D/0MNgtYV5qQ/qA6tDaLdb2SHXmbnDHGFyK+Ms84gZ6sHkTq12pDy0
	 JfcKbUvnBKsgx3qRpdUFH9uxZpMp51VkL/oUcuvrImFSSX1XZOFZvp5LscfJs3fLr7
	 izqW7dDsy/LNyiMcPDU3u/qjwPOHvEXbPW2Y2feQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgHEUMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHEQZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 12:25:34 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34857C00869E;
        Wed,  5 Aug 2020 07:39:17 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id 6so33840764qtt.0;
        Wed, 05 Aug 2020 07:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Ygb7Z7BelPPrQe4DRkGVgTQcrO8Cw2RRW2qRF9CXYE=;
        b=pp6tBE5oK4EXYLhHUerHhczMNOtv0AQryU6E7Oe9CXPImtvcqSnfK2pVeBKYdcc1CC
         7iFk3ssjwttxDGUiUsDFrVfdvCHnKNaN9gPuOrD/4dmwZPH5bN7mAVNhO9Fi5Y9c0T+3
         To33H16KJ+KUQ7uvE7dMCY2D096z84QZuhv2W9FJa0UawIL+mIlsQ888VL6aRgeNOKT5
         SjRHQBvMdgbRimITkdG9T7VPQdtgUv4IMERoZhDt4jT6Ses9mh7jMz6K5VUuRK+Zm7vM
         y8HjXEPIp4tfKn3y8kWSyef94WF1XiH8pTyGWYXIZDw5g/y+uQMNSGUfIm0DXBxcj7c7
         YHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3Ygb7Z7BelPPrQe4DRkGVgTQcrO8Cw2RRW2qRF9CXYE=;
        b=TX2cn/HCQ/x0S6LGbXUEXyD2APE04VqqJOXcD4K4tTFP47Hr1n7TDSGdJVXvrTNhq3
         9fAGYoEwbYflT3zjaqDBQAVGV7OKGcAlTQjs7p0miqMapQBWeMadmb4Ie17nWjTO809e
         R4UAun6ddHMnWQpf9xyZiNGvlsFGqEB4NGiFlmYZz621JCm4P7lVH0Gx9lum4EucK89I
         B4MauCLv4Rlr85e2Sv3Bz2QZHXu2EzK0sFIoQElIkBYHVtXOgLeoms0K5IwaUDgN7VwE
         Zw0ZNpwjLE8ACnxjPDng4Sq3W3XQaTo8eMEjuPranslWvN2meyGBb19z5O5+mWYW0Uy+
         NIkg==
X-Gm-Message-State: AOAM530Ljt2802O7qQjNXRroo1+teonoBuQGVmNjUA+P2xMynQkANqx8
        S6ENlJfaciVV79fGH4aDxxJ2VrPo
X-Google-Smtp-Source: ABdhPJwAeuq1Gw0g6oZ4EwMvVDPOBUpv5syUd1FNZfEiqH2s0XfPDKOIJt54icu/LvBGC9Z4mj/DrQ==
X-Received: by 2002:ac8:f73:: with SMTP id l48mr3680579qtk.296.1596638356595;
        Wed, 05 Aug 2020 07:39:16 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:fbb7])
        by smtp.gmail.com with ESMTPSA id f130sm1877609qke.99.2020.08.05.07.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:39:15 -0700 (PDT)
Date:   Wed, 5 Aug 2020 10:39:13 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ewan Milne <emilne@redhat.com>, mkumar@redhat.com
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio
 controller
Message-ID: <20200805143913.GC4819@mtj.thefacebook.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
 <20200804142123.GA4819@mtj.thefacebook.com>
 <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com>
 <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
 <227c7f27-c6c7-5db1-59ac-2dd428f5a42a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <227c7f27-c6c7-5db1-59ac-2dd428f5a42a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Wed, Aug 05, 2020 at 08:33:19AM +0200, Hannes Reinecke wrote:
> None of these are guaranteed to be either present or unique.
> It's not uncommon to have VMs with more than one MAC address, and any other
> unique identifier like system UUID is not required to be present.

I have a really hard time seeing how this fits into block cgroup interface.
The last time we did something similar (tagging from cgroup interface side)
was for netcls and it ended poorly. There are basic problems with e.g.
delegation as these things are at odds with everything else sharing the
interface.

My not-too-well informed suggestions are either building mapping somewhere
in the stack or at least implement the interface where it fits better so
that people who don't need app_identifier don't see them and preferably can
disable them. I don't mind cgroup data structs carrying extra bits for stuff
which want to make use of the cgroup tree but I'm a pretty firm nack on the
proposed interface.

Thanks.

-- 
tejun
