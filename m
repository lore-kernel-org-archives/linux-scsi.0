Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70AFC433C1
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Mar 2021 10:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E6D619FC
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Mar 2021 10:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhC0KYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Mar 2021 06:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhC0KYj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Mar 2021 06:24:39 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BB7C0613B1;
        Sat, 27 Mar 2021 03:24:39 -0700 (PDT)
Date:   Sat, 27 Mar 2021 10:24:33 +0000
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        Joe Szczypek <jszczype@redhat.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Don Brace <don.brace@microchip.com>
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Message-ID: <20210327102433.179ce571@sf>
In-Reply-To: <23674602-0f14-0b71-3192-aa0184a34d6e@physik.fu-berlin.de>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
        <20210312222718.4117508-1-slyfox@gentoo.org>
        <23674602-0f14-0b71-3192-aa0184a34d6e@physik.fu-berlin.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Mar 2021 18:28:31 +0100
John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> wrote:

> Hi Sergei!
> 
> On 3/12/21 11:27 PM, Sergei Trofimovich wrote:
> > The failure initially observed as boot failure on rx3600 ia64 machine
> > with RAID bus controller: Hewlett-Packard Company Smart Array P600:
> > 
> >     kernel unaligned access to 0xe000000105dd8b95, ip=0xa000000100b87551
> >     kernel unaligned access to 0xe000000105dd8e95, ip=0xa000000100b87551
> >     hpsa 0000:14:01.0: Controller reports max supported commands of 0 Using 16 instead. Ensure that firmware is up to date.
> >     swapper/0[1]: error during unaligned kernel access
> > 
> > Here unaligned access comes from 'struct CommandList' that happens
> > to be packed. The change f749d8b7a ("scsi: hpsa: Correct dev cmds
> > outstanding for retried cmds") introduced unexpected padding and
> > un-aligned atomic_t from natural alignment to something else.
> > 
> > This change does not remove packing annotation from struct but only
> > restores alignment of atomic variable.
> > 
> > The change is tested on the same rx3600 machine.  
> 
> I just gave it a try on my RX2660 and for me, the hpsa driver won't load even
> with your patch.
> 
> Can you share your kernel configuration so I can give it a try?

Sure! Here is a config from a few days ago:
    https://dev.gentoo.org/~slyfox/configs/guppy-config-5.12.0-rc4-00016-g427684abc9fd-dirty

-- 

  Sergei
