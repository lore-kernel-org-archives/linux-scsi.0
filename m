Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43485C64EC4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 14:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjBVOxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 09:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjBVOxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 09:53:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3817E124;
        Wed, 22 Feb 2023 06:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC7DBB80B46;
        Wed, 22 Feb 2023 14:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43F9C433D2;
        Wed, 22 Feb 2023 14:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677077621;
        bh=FHrTWbOnw2MWBxJqKEWmRBZVxIbkKnOkOTPhwQA/g70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IAst0/gO0iYNRNUBjg+NzD5Ko8CuOcrKGeN5HAuz6HocXg1iEstvPZIY+YtNuJN8k
         TrtyJYjNefnjhnlA9RSG6R+9FvcL582sTkiSJBeag/+b56WNqlXcY/TvCvLmb9tAW3
         vN1ueckIqqAhRYvAfPrxFQAl2jVOr3cx8rf311p+zn/rd+NE9lYsllSRKHS3vksA25
         AWFlipx/5yyuymKJ99oEjCJDfC1Rxnrnv1wbBXACXz6qS4LCguzz8+SvgMxTXUbaT9
         Mds/YKXZigL0yAO0UoXvjUtiF3HQghCC1JmMa2R4rLQOzuuAUPDGx/GryZ4NASWubm
         ar+lUXQu0LXmA==
Date:   Wed, 22 Feb 2023 07:53:38 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        lsf-pc@lists.linuxfoundation.org
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Message-ID: <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2023 at 04:37:51PM +0200, Sagi Grimberg wrote:
> 
> > > I did not understand what is the relationship between aborts and CDL.
> > > Sounds to me that this would tie in to something like Time Limited Error
> > > Recovery (TLER) and LR bit set based on ioprio?
> > > 
> > > I am unclear where do aborts come into play here.
> > 
> > CDL: Command Duration Limits
> > 
> > One use case is reading from storage for audio visual output.
> > An application only wants to wait so long (e.g. one or two frames
> > on the video output) before it wants to forget about the current
> > read (i.e. "abort" it) and move onto the next read. An alert viewer
> > might notice a momentary freeze frame.
> > 
> > The SCSI CDL mechanism uses the DL0, DL1 and DL2 bits in the READ(16,32)
> > commands. CDL also depends on the CDLP and RWCDLP fields in the
> > REPORT SUPPORTED OPERATION CODES command and one of the CDL
> > mode pages. So there may be some additional "wiring" needed in the
> > SCSI subsystem.
> 
> I still don't understand where issuing aborts from userspace come into
> play here...

The only connection is that aborts are obsolete and unnecessary if
you have a working CDL implementation.
