Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73553C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 323D964E13
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhCANOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:14:01 -0500
Received: from authsmtp41.register.it ([81.88.55.104]:49019 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235398AbhCANNH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:13:07 -0500
Received: from [192.168.43.2] ([176.201.234.222])
        by cmsmtp with ESMTPSA
        id GiLVl1alDQ36QGiLVlKVCz; Mon, 01 Mar 2021 14:12:22 +0100
X-Rid:  guido@trentalancia.com@176.201.234.222
Message-ID: <1614604341.6918.28.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Mon, 01 Mar 2021 14:12:21 +0100
In-Reply-To: <BL0PR04MB651464BF2CC7DAF8C6F812C4E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
         <1614582394.13266.11.camel@trentalancia.com>
         <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614598394.4338.18.camel@trentalancia.com>
         <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614602388.6918.8.camel@trentalancia.com>
         <BL0PR04MB6514A85C4B56E1370406B97BE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614603429.6918.18.camel@trentalancia.com>
         <BL0PR04MB651464BF2CC7DAF8C6F812C4E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfMZjlmc6HKxeh9NpSHzlO4VoOMIa3s19fmx3iyXwI/KKhgMgEZ0xBD4CEIngcGikoeCfzti2hU/vTUmhVJIl1SuzA0DMj47RrtL8fT40pwqKSYHM1MG8
 ri3KyyYeiiwGmkpB0G35FSMWwkRNYXPoTNZt3mM8sOq8rlIkBXskXhXtVo02I7jTcLLUitmpIsJ3pLxbOwBKiUAgY6NMi2kBeHIADhzAbywHIjNw6+5i6qUp
 AE7Ohj2Hj5GHR94Zs7gtTQ==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 01/03/2021 at 13.04 +0000, Damien Le Moal wrote:
> Yes, I believe that: your patch disables the write cache ! So no
> synchronize
> cache command, no caching, no data loss. All good.

[...]

> Because the drive does not have synchronize cache while caching data,
> which is
> crazy.

[...]

> Sure, because you end up with WCE=0. All good.

[...]

> I understand the situation perfectly. I am not doubting your result.
> I looked at
> your patch and understand it. It is sensible, but does not plug all
> the possible
> holes with such weird drive. So that is not a good solution to me.

It is the only possible solution to the best of my knowledge.

> The alternative, safe this one, is a udev rule disabling your drive
> write cache
> or you setting the permanent drive config with WCE=0. That will have
> *exactly*
> the same effect as your patch: things will work just fine. Try that
> solution
> please. No need for a kernel patch.

That is a cumbersome trick, not a safe and stable solution.

The simplest point of failure of such trick is that an unexperienced
user plugs in one of such drives without knowing the trick and data
corruption occurs.

Another very big disadvantage is that on multiple systems the same
configuration needs to be replicated over and over on all systems.

Guido
