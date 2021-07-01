Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF27C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 07:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D61E6148E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 07:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhGAH7F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 03:59:05 -0400
Received: from verein.lst.de ([213.95.11.211]:46690 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234576AbhGAH7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jul 2021 03:59:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 52AB16736F; Thu,  1 Jul 2021 09:56:30 +0200 (CEST)
Date:   Thu, 1 Jul 2021 09:56:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Subject: Re: [PATCH v5 3/3] dm mpath: add CONFIG_DM_MULTIPATH_SG_IO -
 failover for SG_IO
Message-ID: <20210701075629.GA25768@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com> <20210628151558.2289-4-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628151558.2289-4-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 28, 2021 at 05:15:58PM +0200, mwilck@suse.com wrote:
> The qemu "pr-helper" was specifically invented for it. I
> believe that this is the most important real-world scenario for sending
> SG_IO ioctls to device-mapper devices.

pr-helper obviously does not SG_IO on dm-multipath as that simply does
not work.

More importantly - if you want to use persistent reservations use the
kernel ioctls for that.  These work on SCSI, NVMe and device mapper
without any extra magic.

Failing over SG_IO does not make sense.  It is an interface specically
designed to leave all error handling to the userspace program using it,
and we should not change that for one specific error case.  If you
want the kernel to handle errors for you, use the proper interfaces.
In this case this is the persistent reservation ioctls.  If they miss
some features that qemu needs we should add those.
