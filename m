Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_NONE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC95C11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 06:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBC26148E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 06:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhGAGVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 02:21:35 -0400
Received: from verein.lst.de ([213.95.11.211]:46469 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233878AbhGAGVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jul 2021 02:21:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2869367373; Thu,  1 Jul 2021 08:19:02 +0200 (CEST)
Date:   Thu, 1 Jul 2021 08:19:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Alasdair G Kergon <agk@redhat.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
Message-ID: <20210701061901.GA22293@lst.de>
References: <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de> <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com> <20210629125909.GB14372@lst.de> <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com> <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com> <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com> <YNyVafnX09cOIZPe@redhat.com> <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com> <1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 30, 2021 at 03:08:11PM -0700, Bart Van Assche wrote:
> On 6/30/21 9:54 AM, Martin Wilck wrote:
> > @Martin, @Bart, do you have a suggestion for me?
> 
> The code in block/scsi_ioctl.c exists in the block layer since until
> recently most of it was used by both the IDE and SCSI code. Now that
> drivers/ide is gone (thanks Christoph!), how about moving block/bsg.c
> and block/scsi_ioctl.c to drivers/scsi/? As far as I can see the BSG
> code is only used by SCSI drivers:

I have a series to clean this mess up:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/scsi-ioctl

But more importantly, dm has no business interpreting the errors.  Just
like how SG_IO processing generally does not look at the error and
just returns it to userspace and leaves error handling to the caller
so should be the decision to resubmit it in a multi-path setup.
