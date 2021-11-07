Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DF2C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 02:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8D96152A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 02:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhKGC06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 22:26:58 -0400
Received: from peace.netnation.com ([204.174.223.2]:45088 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbhKGC05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 22:26:57 -0400
Received: from sim by peace.netnation.com with local (Exim 4.92)
        (envelope-from <sim@hostway.ca>)
        id 1mjXqs-0008TY-Od; Sat, 06 Nov 2021 19:24:10 -0700
Date:   Sat, 6 Nov 2021 19:24:10 -0700
From:   Simon Kirby <sim@hostway.ca>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: Unreliable disk detection order in 5.x
Message-ID: <20211107022410.GA6530@hostway.ca>
References: <20211105064623.GD32560@hostway.ca>
 <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 05, 2021 at 04:45:53PM +0900, Damien Le Moal wrote:

> > Any ideas on suggestions on what I could use to track down what changed
> > here, or ideas on what might have influenced it?
> 
> Most distro kernels are now compiled with asynchronous device scan enabled to
> speedup the boot process. This potentially result in the device names changing
> across reboots. Reliable device names are provided by udev under
> /dev/disk/by-id, by-uuid etc.
> 
> You can turn off scsi asynchronous device scan using the scsi_mod.scan=sync
> kernel boot argument, or disable the CONFIG_SCSI_SCAN_ASYNC option for your
> kernel (device drivers -> scsi device support -> asynchronous scsi scanning).
> 
> But even with synchronous scanning, device names are not reliable and there are
> no guarantees that one particular device will always have the same name.

This occurs regardless of the CONFIG_SCSI_SCAN_ASYNC setting, and also
with scsi_mod.scan=sync on vendor kernels. All of these disks are coming
from the same driver and card.

I understand that using UUIDs, by-id, etc., is an option to work around
this, but then we would have to push IDs for disks in every server to our
configuration management. It does not seem that this change is really
intentional.

Simon-
