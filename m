Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,
	GUARANTEED_100_PERCENT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEB3C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9022B64DA8
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhCAMkK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:40:10 -0500
Received: from authsmtp01.register.it ([81.88.48.51]:60763 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233353AbhCAMkJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:40:09 -0500
Received: from [192.168.43.2] ([176.201.234.222])
        by cmsmtp with ESMTPSA
        id Ghq0lER7YWCpnGhq1lYOnb; Mon, 01 Mar 2021 13:39:50 +0100
X-Rid:  guido@trentalancia.com@176.201.234.222
Message-ID: <1614602388.6918.8.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Mon, 01 Mar 2021 13:39:48 +0100
In-Reply-To: <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
         <1614582394.13266.11.camel@trentalancia.com>
         <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614598394.4338.18.camel@trentalancia.com>
         <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfD5RY8pp+FX6Qef2Dx60DdYINewolhKRx/lBI3rHW64jLy7VTpfTD4N9PNxctcHle0bUBgj8+D3a3xpQCW7gKZ0vwbOG+2biHRkC4Ora9ZcA91/XNQCR
 qFgvi2xTNY0TxdLzlCGfuAGxKQblMKGR7N7wE0vaKlLB/4QyDMx6jQhMnyKDQX/ZRq0a+AK8gPZICW4OOe4Ui9u1+qk3i4kvo7iBN6ecBnlUqbza5CF3x8SR
 pNMnMZ0/9MuwxuQ7fc8DqA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the system is shut down before the sync or drive unmounting and the
write cache is enabled, there might be the loss of data in the cache,
but this is because of the way the drive is designed.

I believe the kernel should support the drive as it is - plug and play
- without requiring cumbersome configurations.

Disabling the write cache for increased data security is up to the user
eventually requiring an increased level of safety against data loss.

In those earlier days, most operating systems were giving the user very
specific warning about the risks of write caching. Such warnings have
now been removed because of the advent of more recent hard-drive
specifications supporting new features such as the Synchronize Cache
command, but in my opinion this has nothing to do with the fact that
earlier drives should be supported in a plug and play fashion as they
were in earlier days.

Guido

On Mon, 01/03/2021 at 12.27 +0000, Damien Le Moal wrote:
> On 2021/03/01 20:33, Guido Trentalancia wrote:
> > I have just checked the drive and I can now confirm that you are
> > right
> > about the capabilities reported: it is indeed reporting Write
> > Caching.
> > 
> > However the point is that the current kernel behaviour is wrong and
> > leading to data corruption on such drives, as the sync function
> > fails
> > due to missing Synchronize Cache command.
> 
> Without sync working, how could you ever guarantee that even a clean
> shutdown of
> the host does not result in data loss ? I am not even talking about
> power
> failures and crashes here. A simple, clean "shutdown -h now". Without
> issuing a
> synchronize cache command after flushing the page cache and
> unmounting the FS,
> you will loose data and corrupt things. 100% guaranteed.
> 
> As James explained in different terms, it is the other way around:
> the kernel is
> correct and behaves according to the fact that the drive is saying "I
> am caching
> written sectors". That implies that synchronize cache *is* supported,
> per the
> standards. The corruption errors you are seeing are due to the drive
> being silly
> and failing synchronize cache commands, resulting in the cached data
> *not* going
> to persistent media, and loss of data on power down or crash. This is
> not a bad
> behavior. On the contrary, not seeing any data corruption would only
> mean that
> you are being lucky.
> 
> > Once again, this is because of very old HD specifications that were
> > implementing Write Caching without that command.
> 
> If the drive is scanned and initialized by sd/libata, it means that
> it is
> reporting following a supported standard version (SPC, SBC, ACS).
> Probably an
> old version, but still a standard. Synchronize cache command (for
> scsi) and
> flush cache/flush cache ext (for ATA) are not recent additions to
> SCSI & ATA.
> These have been around for a long time. It does not matter that the
> drive is old
> and following an old version. It should support cache flushing. Refer
> to the ACS
> specs. It is clearly noted that: "If the volatile write cache is
> disabled or no volatile write cache is present, the device shall
> indicate
> command completion without error.". Get the point ? That drive
> firmware is
> simply broken and missing a critical command.
> 
> > The way forward is to treat the command failure as non-critical
> > (see
> > attached patch) because clearly it's not implemented in all drives,
> > but
> > only more recent ones.
> 
> Nope. Simply disable the write cache. Try "hdparm -W 0 /dev/sdX" or
> "sdparm
> --clear=WCE /dev/sdX" to disable it. And a udev rule can do that for
> you on boot
> too. Failures and data corruption will go away. But the performance
> will likely
> go to the trash bin too...
> 
> A little bit of history: it used to be a thing, many many years ago,
> to see
> drives that had synchronize cache commands implemented as "nop" or
> not
> implemented at all. Unscrupulous vendors would do that to get better
> performance
> results for their drives with benchmarks. Because synchronize cache
> can be very
> costly and can take several seconds to complete. Using such drives in
> big RAID
> arrays with power failure protections would be fine, but any other
> use case by
> any regular user would create data corruption situations very
> quickly. As noted
> above, even a simple clean shutdown would lose data ! Such bad
> practice ended
> fairly quickly. For some reasons these bad drives failed to sell very
> well :)
> 
> > 
> > Guido
> > 
> > On Mon, 01/03/2021 at 07.38 +0000, Damien Le Moal wrote:
> > > On 2021/03/01 16:12, Guido Trentalancia wrote:
> > > > Hi James,
> > > > 
> > > > thanks for getting back on this issue.
> > > > 
> > > > I have tested this patch for over a year and it works
> > > > flawlessly
> > > > without any data corruption !
> > > > 
> > > > On such kind of drives the actual situation is just the
> > > > opposite as
> > > > you
> > > > describe: data corruption occurs when not using this patch !
> > > > 
> > > > I do not agree with you: if a drive does not support
> > > > Synchronize
> > > > Cache
> > > > command, there is no point in treating the failure as critical
> > > > and
> > > > by
> > > > all means the failure must be ignored, as there is nothing
> > > > which
> > > > can be
> > > > done about it and it should not be treated as a failure !
> > > 
> > > If the drive does not support synchronize cache, then the drive
> > > should *not*
> > > report write caching either. If it does, then the kernel will
> > > issue
> > > synchronize
> > > cache commands and that command failing indicates the drive is
> > > broken/lying ==
> > > junk and should not be trusted.
> > > 
> > > The user can trivially remedy to this situation by force
> > > disabling
> > > the write
> > > cache: no more synchronize cache commands will be issued and no
> > > more
> > > failures.
> > > No need to patch the kernel for that. And if the drive does not
> > > allow
> > > disabling
> > > write caching, then I seriously recommend replacing it :)
> > > 
> > > > 
> > > > However, if you are willing to propose an alternative patch,
> > > > I'd be
> > > > happy to test it and report back, as long as this bug is fixed
> > > > in
> > > > the
> > > > shortest time possible.
> > > > 
> > > > Guido
> > > > 
> > > > On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:
> > > > > On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:
> > > > > > Many obsolete hard drives do not support the Synchronize
> > > > > > Cache
> > > > > > SCSI
> > > > > > command. Such command is generally issued during fsync()
> > > > > > calls
> > > > > > which
> > > > > > at the moment therefore fail with the ILLEGAL_REQUEST sense
> > > > > > key.
> > > > > 
> > > > > It should be that all drives that don't support sync cache
> > > > > also
> > > > > don't
> > > > > have write back caches, which means we don't try to do a
> > > > > cache
> > > > > sync
> > > > > on
> > > > > them.  The only time you we ever try to sync the cache is if
> > > > > the
> > > > > device
> > > > > advertises a write back cache, in which case the sync cache
> > > > > command
> > > > > is
> > > > > mandatory.
> > > > > 
> > > > > I'm sure some SATA manufacturers somewhere cut enough corners
> > > > > to
> > > > > produce an illegally spec'd drive like this, but your
> > > > > proposed
> > > > > remedy
> > > > > is unviable: you can't ignore a cache failure on flush
> > > > > barriers
> > > > > which
> > > > > will cause data corruption.  You have to disable barriers on
> > > > > the
> > > > > filesystem to get correct operation and be very careful about
> > > > > power
> > > > > down.
> > > > > 
> > > > > James
> > > > > 
> > > > > 
> > > 
> > > 
> 
> 
