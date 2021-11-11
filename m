Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A4CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 01:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00AC61406
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 01:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhKKBEA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 20:04:00 -0500
Received: from peace.netnation.com ([204.174.223.2]:53160 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhKKBD7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 20:03:59 -0500
Received: from sim by peace.netnation.com with local (Exim 4.92)
        (envelope-from <sim@hostway.ca>)
        id 1mkySg-0008Bb-Ns; Wed, 10 Nov 2021 17:01:06 -0800
Date:   Wed, 10 Nov 2021 17:01:06 -0800
From:   Simon Kirby <sim@hostway.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: Unreliable disk detection order in 5.x
Message-ID: <20211111010106.GA27431@hostway.ca>
References: <20211105064623.GD32560@hostway.ca>
 <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
 <20211107022410.GA6530@hostway.ca>
 <ce4f925f-cbf9-9bbb-4bde-dd57059e3c84@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce4f925f-cbf9-9bbb-4bde-dd57059e3c84@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Nov 07, 2021 at 11:51:45AM -0800, Bart Van Assche wrote:

> On 11/6/21 19:24, Simon Kirby wrote:
> > This occurs regardless of the CONFIG_SCSI_SCAN_ASYNC setting, and
> > also with scsi_mod.scan=sync on vendor kernels. All of these disks
> > are coming from the same driver and card.
> > 
> > I understand that using UUIDs, by-id, etc., is an option to work
> > around this, but then we would have to push IDs for disks in every
> > server to our configuration management. It does not seem that this
> > change is really intentional.
> 
> SCSI disk detection is asynchronous on purpose since a long time. The most
> recent commit I know of that changed SCSI disk scanning
> behavior is commit f049cf1a7b67 ("scsi: sd: Rely on the driver core for
> asynchronous probing").
> 
> Please use one of the /dev/disk/by-*/* identifiers as Damien requested.

Hi Bart,

So, we're using DRBD on top of these, which means by-uuid is not
available; we can use only by-id and by-path. by-id is dependent on disk
models and serial numbers, and by-path is dependent on PCI bus details.
Both are going to be a good deal more work to maintain, since they're
both not just a simple enumeration.

I did try 5.14.17 with f049cf1a7b67 (and a065c0faacb1) reverted, and it
does indeed restore the behaviour where sd* order appears to be reliable.
Scan time (time until systemd starts) is within 4ms across 3 boots with
and without the revert, but this is just our particular case.

I don't fully understand the scan process here, but I can understand the
challenges in trying to parallelize it and still end up with a consistent
enumerated list.

I guess you would agree that removing sd* entirely would not be an option
because they've existed forever historically, but at the same time, the
only time they really "work" now are as symlink targets for by-*, and in
the case where only one disk exists at boot time. Do I have this right?

Simon-
