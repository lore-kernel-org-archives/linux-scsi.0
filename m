Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089E2C11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 08:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E216461D07
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 08:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhF3IPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:15:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56934 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhF3IPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2021 04:15:20 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5FF1222177;
        Wed, 30 Jun 2021 08:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625040771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESF4as1UHsM7KZCzsh1G7q2F2uELJjQRAkK650wK854=;
        b=HhxddL4hOZbBT1vT5K78+wwnw2hoNkikV1tyML/Na2o5P2lh5SsKjyoCl7TSSVM9/9izdV
        yjk+lzUzk162iTIqLP9chNR275b1fsrulwFt7ERyg6VOwpEvypKHl92t35NXV8Yezb/Nyg
        xf12vGc935sjNJPU2uwncyJbZq8rloI=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id DBD6B11906;
        Wed, 30 Jun 2021 08:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625040771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESF4as1UHsM7KZCzsh1G7q2F2uELJjQRAkK650wK854=;
        b=HhxddL4hOZbBT1vT5K78+wwnw2hoNkikV1tyML/Na2o5P2lh5SsKjyoCl7TSSVM9/9izdV
        yjk+lzUzk162iTIqLP9chNR275b1fsrulwFt7ERyg6VOwpEvypKHl92t35NXV8Yezb/Nyg
        xf12vGc935sjNJPU2uwncyJbZq8rloI=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id LfFSM4In3GBYNwAALh3uQQ
        (envelope-from <mwilck@suse.com>); Wed, 30 Jun 2021 08:12:50 +0000
Message-ID: <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
From:   Martin Wilck <mwilck@suse.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Date:   Wed, 30 Jun 2021 10:12:50 +0200
In-Reply-To: <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
References: <20210628095210.26249-1-mwilck@suse.com>
         <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
         <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
         <20210629125909.GB14372@lst.de>
         <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
         <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Di, 2021-06-29 at 14:23 -0700, Keith Busch wrote:
> On Tue, Jun 29, 2021 at 09:23:18PM +0200, Martin Wilck wrote:
> > On Di, 2021-06-29 at 14:59 +0200, Christoph Hellwig wrote:
> > > On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> > > 
> > > > The sg_io-on-multipath code needs to answer the question "is
> > > > this a
> > > > path or a target error?". Therefore it calls blk_path_error(),
> > > > which
> > > > requires obtaining a blk_status_t first. But that's not
> > > > available
> > > > in
> > > > the sg_io code path. So how should I deal with this situation?
> > > 
> > > Not by exporting random crap from the SCSI code.
> > 
> > So, you'd prefer inlining scsi_result_to_blk_status()?
> 
> I don't think you need to. The only scsi_result_to_blk_status()
> caller
> is sg_io_to_blk_status(). That's already in the same file as
> scsi_result_to_blk_status() so no need to export it. You could even
> make
> it static.

Thanks for your suggestion. I'd be lucky if this was true. But the most
important users of scsi_result_to_blk_status() are in scsi_lib.c
(scsi_io_completion_action(), scsi_io_completion_nz_result()).

If I move scsi_result_to_blk_status() to vmlinux without exporting it,
it won't be available in the SCSI core any more, at least not with
CONFIG_SCSI=m.

Regards,
Martin


