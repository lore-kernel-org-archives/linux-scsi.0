Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CFCC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 14:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B0DF60F42
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 14:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245124AbhH0OKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 10:10:39 -0400
Received: from vps.thesusis.net ([34.202.238.73]:35896 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231571AbhH0OKj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 10:10:39 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2021 10:10:38 EDT
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id DEF3E47FAC; Fri, 27 Aug 2021 10:01:47 -0400 (EDT)
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
User-agent: mu4e 1.5.13; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Date:   Fri, 27 Aug 2021 09:58:38 -0400
In-reply-to: <20210827075045.642269-1-damien.lemoal@wdc.com>
Message-ID: <874kbbugtw.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien Le Moal <damien.lemoal@wdc.com> writes:

> Single LUN multi-actuator hard-disks are cappable to seek and execute
> multiple commands in parallel. This capability is exposed to the host
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
> Each positioning range describes the contiguous set of LBAs that an
> actuator serves.

Are these ranges exlusive to each actuator or can they overlap?

> This series does not attempt in any way to optimize accesses to
> multi-actuator devices (e.g. block IO schedulers or filesystems). This
> initial support only exposes the independent access ranges information
> to user space through sysfs.

Is the plan to eventually change the IO scheduler to maintain two
different queues, one for each actuator, and send down commands for two
different IO streams that the elevator attempts to keep sequential?

