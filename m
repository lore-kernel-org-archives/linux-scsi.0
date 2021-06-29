Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01DBC11F69
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 21:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D408761DA0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 21:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhF2VZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 17:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235952AbhF2VZr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 17:25:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E4C61D9F;
        Tue, 29 Jun 2021 21:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625001799;
        bh=PLiKpnQ1g+KFeebLlA/Bls/LC73XIpp6AEpo8vdjk8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nObzBLx6ix3Lqflr7i+J2OaevfFdFjrxLMxya76De2c/A+RhaNTNJJTdhcpOoAM2O
         Vp6zAfG0Wn/czeb87KyVw5QzhJL14CQgDWPoYhCn7d4F5j4yknuuM1u6XqgTRwoVGS
         0KXGsSSCNdugRt+sTnLKqXnicxWV43PmbR8vkRQMZi0xS+EcZzvAmHHFZUMjvcg0m0
         tMEoQjDcP/U+A0MtH0SMPTkCfOUmTVrzY0Vg4lMHR/dcNpv0OgyegwcoYgF5AuKFBM
         x9DjZe9ry9LmqoOP3PUSzT3Dxoj101K2kZeOZiAKpSuqx+yG23UMuU085XvKaLza5Z
         vK2YHTpPvjB8Q==
Date:   Tue, 29 Jun 2021 14:23:16 -0700
From:   Keith Busch <kbusch@kernel.org>
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
Message-ID: <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
References: <20210628095210.26249-1-mwilck@suse.com>
 <20210628095210.26249-2-mwilck@suse.com>
 <20210628095341.GA4105@lst.de>
 <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
 <20210629125909.GB14372@lst.de>
 <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 29, 2021 at 09:23:18PM +0200, Martin Wilck wrote:
> On Di, 2021-06-29 at 14:59 +0200, Christoph Hellwig wrote:
> > On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> > 
> > > The sg_io-on-multipath code needs to answer the question "is this a
> > > path or a target error?". Therefore it calls blk_path_error(),
> > > which
> > > requires obtaining a blk_status_t first. But that's not available
> > > in
> > > the sg_io code path. So how should I deal with this situation?
> > 
> > Not by exporting random crap from the SCSI code.
> 
> So, you'd prefer inlining scsi_result_to_blk_status()?

I don't think you need to. The only scsi_result_to_blk_status() caller
is sg_io_to_blk_status(). That's already in the same file as
scsi_result_to_blk_status() so no need to export it. You could even make
it static.
