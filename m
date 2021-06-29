Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66420C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 12:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48A8D61DF1
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 12:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhF2NBo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 09:01:44 -0400
Received: from verein.lst.de ([213.95.11.211]:40940 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233698AbhF2NBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 09:01:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1E8FA67373; Tue, 29 Jun 2021 14:59:10 +0200 (CEST)
Date:   Tue, 29 Jun 2021 14:59:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Martin Wilck <mwilck@suse.com>
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
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
Message-ID: <20210629125909.GB14372@lst.de>
References: <20210628095210.26249-1-mwilck@suse.com> <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de> <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> Hello Christoph,
> 
> On Mo, 2021-06-28 at 11:53 +0200, Christoph Hellwig wrote:
> > On Mon, Jun 28, 2021 at 11:52:08AM +0200, mwilck@suse.com wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > > 
> > > This makes it possible to use scsi_result_to_blk_status() from
> > > code that shouldn't depend on scsi_mod (e.g. device mapper).
> > 
> > This really has no business being used outside of low-level SCSI
> > code.
> 
> And this is where my patch set uses it. Can you recommend a better
> way how to access this algorithm, without making dm_mod.ko or dm-
> mpath.ko depend on scsi_mod.ko, and without open-coding it
> independently in a different code path?

> The sg_io-on-multipath code needs to answer the question "is this a
> path or a target error?". Therefore it calls blk_path_error(), which
> requires obtaining a blk_status_t first. But that's not available in
> the sg_io code path. So how should I deal with this situation?

Not by exporting random crap from the SCSI code.
