Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBF5C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 18:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8376A6135F
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 18:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhDTS3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 14:29:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:60670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233556AbhDTS3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 14:29:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C7CBB312;
        Tue, 20 Apr 2021 18:28:30 +0000 (UTC)
Date:   Tue, 20 Apr 2021 20:28:30 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Message-ID: <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
References: <20210419100014.47144-1-dwagner@suse.de>
 <YH8QzgWiec8vka20@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8QzgWiec8vka20@SPB-NB-133.local>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Roman,

On Tue, Apr 20, 2021 at 08:35:10PM +0300, Roman Bolshakov wrote:
> + James S.
> 
> Daniel, WRT to your patch I don't think we should add one more approach
> to set dev_loss_tmo via kernel module parameter as NVMe adopters are
> going to be even more confused about the parameter. Just imagine
> knowledge bases populated with all sorts of the workarounds, that apply
> to kernel version x, y, z, etc :)

Totally agree. I consider this patch just a hack and way to get the
discussion going, hence the RFC :) Well, maybe we are going to add it
downstream in our kernels until we have a better way for setting the
dev_loss_tmo.

As explained the debugfs interface is not working (okay, that's
something which could be fixed) and it has the big problem that it is
not under control by udevd. Not sure if we with some new udev rules the
debugfs could automatically discovered or not.

> What exists for FCP/SCSI is quite clear and reasonable. I don't know why
> FC-NVMe rports should be way too different.

The lpfc driver does expose the FCP/SCSI and the FC-NVMe rports nicely
via the fc_remote_ports and this is what I would like to have from the
qla2xxx driver as well. qla2xxx exposes the FCP/SCSI rports but not the
FC-NVMe rports.

Thanks,
Daniel
