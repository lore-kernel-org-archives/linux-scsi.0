Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52976C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0884264E40
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhCANF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:05:57 -0500
Received: from authsmtp37.register.it ([81.88.55.100]:60591 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232272AbhCANF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:05:57 -0500
X-Greylist: delayed 7046 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 08:05:56 EST
Received: from [192.168.43.2] ([176.201.234.222])
        by cmsmtp with ESMTPSA
        id GiEclCmfgf5o5GiEclmwsS; Mon, 01 Mar 2021 14:05:15 +0100
X-Rid:  guido@trentalancia.com@176.201.234.222
Message-ID: <1614603913.6918.24.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Mon, 01 Mar 2021 14:05:13 +0100
In-Reply-To: <BL0PR04MB65140D17E1F922C72902D107E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
         <1614582394.13266.11.camel@trentalancia.com>
         <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614598394.4338.18.camel@trentalancia.com>
         <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <BL0PR04MB6514DA80936D19A42FC9073AE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614603122.6918.14.camel@trentalancia.com>
         <BL0PR04MB65140D17E1F922C72902D107E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfOnDrbrdGqbPW6kPuXpmoJLoYFRSaoBCznbVHLfnETNlG/uwJclCFE06TmlSDVbz9tOttPljc53DKJCRL5wZyuLphXQrT+Hk0imOdyx9rkzruoVunY94
 tqPPs1AuD63NeJaMvqqqervOWAOyMiu4VyaqAlDCoDq5f9v5gqTTpXNbCoIGynaE/8/KQWNj91NjuOYfYFwEU7GE9UjW0rz+TEBKNs4CU+cMCPkjZdF8XlB6
 SZe6X7Hx3RX1je44uOoKtQ==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 01/03/2021 at 12.57 +0000, Damien Le Moal wrote:
> On 2021/03/01 21:52, Guido Trentalancia wrote:
> > As already said, I have tested the patch for over a year now and I
> > have
> > never experienced the problem that you are foreseeing !
> 
> That may be true for your specific drive, but since we are in
> uncharted
> (non-standard) territory here, we cannot say that this will hold for
> all such
> weird drives out there.

I do not work in the hard drive industry, so I cannot make assumptions
about all existing models.

All patches should normally undergo further testing and this is no
exception.

I would stress once again that the proposed patch disables write
caching as soon as it realizes that the drive does not support the Sync
Cache command, so it has been designed to be extra safe.

> > The current alternative is data corruption each time that the drive
> > is
> > mounted and the inability to use it.
> > 
> > So, the patch is the way forward for using such drives plug and
> > play
> > without cumbersome configuration such as disabling the write cache,
> > which advanced users can always make.

[...]

> As mentioned, the alternative is a udev rule to disable write cache.
> Or if the
> drive supports that, permanently save WCE=0 setting in the drive
> config so that
> it always come up with write cache disabled. No kernel patch needed,
> and you
> will note that this is also exactly the same as what your patch does,
> without
> waiting for an error.

The above is cumbersome, the kernel should support such drives plug and
play, without causing data corruption which is happening at the moment.

Guido
