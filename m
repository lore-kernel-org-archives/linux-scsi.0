Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62571C43381
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E5F864E2E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhCAMws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:52:48 -0500
Received: from authsmtp24.register.it ([81.88.48.47]:43455 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235189AbhCAMwr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:52:47 -0500
Received: from [192.168.43.2] ([176.201.234.222])
        by cmsmtp with ESMTPSA
        id Gi1qlCZTIf5o5Gi1slmmjY; Mon, 01 Mar 2021 13:52:05 +0100
X-Rid:  guido@trentalancia.com@176.201.234.222
Message-ID: <1614603122.6918.14.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Mon, 01 Mar 2021 13:52:02 +0100
In-Reply-To: <BL0PR04MB6514DA80936D19A42FC9073AE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
         <1614582394.13266.11.camel@trentalancia.com>
         <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614598394.4338.18.camel@trentalancia.com>
         <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <BL0PR04MB6514DA80936D19A42FC9073AE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfGeqkwru7XMf8rXBIQfdLR0jEVVW32MOI1Nzt8FiqoBU2nULGFVM5VNKX3kel+pFOsSaTlHASUyVzcNTaDRpwVKMaadYX7ONeKDF7a/WoRFmVxUWcs72
 EI/0Nilvu1MibjNkkLSaTsl5rcbhYkoe/5PErDbwe8Mwu7OXVLhyvOlUbIfTg3dSZAt8EXfzfEHVB9b88kRT3PKi3P2mdhVu9QZANUs8ZkWC71sdoYY0K1J4
 0RzYSSOt6P+hphZiUL4/uw==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 01/03/2021 at 12.42 +0000, Damien Le Moal wrote:
> I checked the standards again. It turns out that SYNCHRONIZE CACHE
> command is
> optional in SBC... Aouch. Got so used to have that one on any drive
> that I
> thought it was mandatory.
> 
> Well, it certainly is mandatory if the drive has a write cache, which
> seems to
> be the case for you.
> 
> The problem with your patch though is that you disable write caching
> when you
> see an ILLEGAL REQUEST/INVALID OPCODE termination of synchronize
> cache. Which
> means that the drive was already used, written too and the cache has
> likely
> dirty data and I do not see any method to guarantee that that data
> makes it to
> persistent media before shutdown. Imagine if that was the synchronize
> cache sent
> before shutdown.

As already said, I have tested the patch for over a year now and I have
never experienced the problem that you are foreseeing !

The current alternative is data corruption each time that the drive is
mounted and the inability to use it.

So, the patch is the way forward for using such drives plug and play
without cumbersome configuration such as disabling the write cache,
which advanced users can always make.

> So the only reasonable solution for such drive is to use it with
> write cache
> disabled from the start.
> down.

It works well even with write caching enabled.

If you have an alternative patch to propose, go ahead otherwise I would
push for getting this merged and sorting out the issue for good.

Guido
