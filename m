Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97008C49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D5AA21927
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbfISOBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:01:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46388 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1731819AbfISOBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 10:01:02 -0400
Received: (qmail 1674 invoked by uid 2102); 19 Sep 2019 10:01:01 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 19 Sep 2019 10:01:01 -0400
Date:   Thu, 19 Sep 2019 10:01:01 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
cc:     Andrea Vai <andrea.vai@unipv.it>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <BYAPR04MB58160E6FEBD92D04ECA7D303E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
Message-ID: <Pine.LNX.4.44L0.1909190958140.1585-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Sep 2019, Damien Le Moal wrote:

> > This is exactly the sort of difference one might expect to see from
> > the commit f664a3cc17b7 ("scsi: kill off the legacy IO path") you
> > identified as the cause of the problem.  With multiqueue I/O, it's not 
> > surprising to see multiple sequences of block numbers.
> > 
> > Add it's not at all surprising that a consumer-grade USB storage device 
> > might do a much worse job of handling non-sequential writes than 
> > sequential ones.
> > 
> > Which leads to a simple question for the SCSI or block-layer 
> > maintainers:  Is there a sysfs setting Andrea can tweak which will 
> > effectively restrict a particular disk device down to a single I/O
> > queue, forcing sequential access?
> 
> The scheduling inefficiency you are seeing may be coming from the fact that the
> block layer does a direct issue of requests, bypassing the elevator, under some
> conditions. One of these is sync requests on a multiqueue device. We hit this
> problem on Zoned disks which can easily return an error for write requests
> without the elevator throttling writes per zones (zone write locking). This
> problem was discovered by Hans (on CC).

Is there any way for Andrea to check whether this is the underlying
cause?

> I discussed this with Hannes yesterday and we think we have a fix, but we'll
> need to do a lot of testing as all block devices are potentially impacted by the
> change, including stacked drivers (DM). Performance regression is scary with any
> change in that area (see blk_mq_make_request() and use of
> blk_mq_try_issue_directly() vs blk_mq_sched_insert_request()).

No doubt Andrea will be happy to test your fix when it's ready.

Alan Stern

