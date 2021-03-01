Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BC0C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 11:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD1164E07
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 11:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhCALKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 06:10:45 -0500
Received: from authsmtp06.register.it ([81.88.48.56]:46365 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233671AbhCALKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 06:10:16 -0500
Received: from [192.168.43.2] ([176.201.234.222])
        by cmsmtp with ESMTPSA
        id GgOslzagMQ36QGgOulJ00R; Mon, 01 Mar 2021 12:07:47 +0100
X-Rid:  guido@trentalancia.com@176.201.234.222
Message-ID: <1614600461.4338.9.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>, linux-scsi@vger.kernel.org
Date:   Mon, 01 Mar 2021 13:07:41 +0100
In-Reply-To: <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
         <1614582394.13266.11.camel@trentalancia.com>
         <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien,

what tells you the drive is reporting write cache ? I am not sure about
this...

Consider, we are talking about rather old drives.

I suppose the point is that they were designed with very different
specifications compared to recent drives, surely including the absence
of Synchronize Cache but possibly Write Caching too: the point of
failure is at the Synchronize Cache issuing code, so I patched there.

Whatever the case and as already pointed out, if you are willing to
propose an alternative patch, I will be happy to test it and report
back, as long as the issue is resolved as soon as possible.

Guido

On Mon, 01/03/2021 at 07.38 +0000, Damien Le Moal wrote:
> On 2021/03/01 16:12, Guido Trentalancia wrote:
> > Hi James,
> > 
> > thanks for getting back on this issue.
> > 
> > I have tested this patch for over a year and it works flawlessly
> > without any data corruption !
> > 
> > On such kind of drives the actual situation is just the opposite as
> > you
> > describe: data corruption occurs when not using this patch !
> > 
> > I do not agree with you: if a drive does not support Synchronize
> > Cache
> > command, there is no point in treating the failure as critical and
> > by
> > all means the failure must be ignored, as there is nothing which
> > can be
> > done about it and it should not be treated as a failure !
> 
> If the drive does not support synchronize cache, then the drive
> should *not*
> report write caching either. If it does, then the kernel will issue
> synchronize
> cache commands and that command failing indicates the drive is
> broken/lying ==
> junk and should not be trusted.
> 
> The user can trivially remedy to this situation by force disabling
> the write
> cache: no more synchronize cache commands will be issued and no more
> failures.
> No need to patch the kernel for that. And if the drive does not allow
> disabling
> write caching, then I seriously recommend replacing it :)
> 
> > 
> > However, if you are willing to propose an alternative patch, I'd be
> > happy to test it and report back, as long as this bug is fixed in
> > the
> > shortest time possible.
> > 
> > Guido
> > 
> > On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:
> > > On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:
> > > > Many obsolete hard drives do not support the Synchronize Cache
> > > > SCSI
> > > > command. Such command is generally issued during fsync() calls
> > > > which
> > > > at the moment therefore fail with the ILLEGAL_REQUEST sense
> > > > key.
> > > 
> > > It should be that all drives that don't support sync cache also
> > > don't
> > > have write back caches, which means we don't try to do a cache
> > > sync
> > > on
> > > them.  The only time you we ever try to sync the cache is if the
> > > device
> > > advertises a write back cache, in which case the sync cache
> > > command
> > > is
> > > mandatory.
> > > 
> > > I'm sure some SATA manufacturers somewhere cut enough corners to
> > > produce an illegally spec'd drive like this, but your proposed
> > > remedy
> > > is unviable: you can't ignore a cache failure on flush barriers
> > > which
> > > will cause data corruption.  You have to disable barriers on the
> > > filesystem to get correct operation and be very careful about
> > > power
> > > down.
> > > 
> > > James
> > > 
> > > 
> 
> 
