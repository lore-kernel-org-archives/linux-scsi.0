Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0FCC43332
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 325D164EEE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCQR2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:28:50 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:44407 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231184AbhCQR2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 13:28:43 -0400
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1lMZyC-002jNS-LK; Wed, 17 Mar 2021 18:28:32 +0100
Received: from p5b13a966.dip0.t-ipconnect.de ([91.19.169.102] helo=[192.168.178.139])
          by inpost2.zedat.fu-berlin.de (Exim 4.94)
          with esmtpsa (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lMZyC-003vpV-EX; Wed, 17 Mar 2021 18:28:32 +0100
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
To:     Sergei Trofimovich <slyfox@gentoo.org>,
        linux-kernel@vger.kernel.org
Cc:     linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, Joe Szczypek <jszczype@redhat.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Don Brace <don.brace@microchip.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
 <20210312222718.4117508-1-slyfox@gentoo.org>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <23674602-0f14-0b71-3192-aa0184a34d6e@physik.fu-berlin.de>
Date:   Wed, 17 Mar 2021 18:28:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210312222718.4117508-1-slyfox@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 91.19.169.102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sergei!

On 3/12/21 11:27 PM, Sergei Trofimovich wrote:
> The failure initially observed as boot failure on rx3600 ia64 machine
> with RAID bus controller: Hewlett-Packard Company Smart Array P600:
> 
>     kernel unaligned access to 0xe000000105dd8b95, ip=0xa000000100b87551
>     kernel unaligned access to 0xe000000105dd8e95, ip=0xa000000100b87551
>     hpsa 0000:14:01.0: Controller reports max supported commands of 0 Using 16 instead. Ensure that firmware is up to date.
>     swapper/0[1]: error during unaligned kernel access
> 
> Here unaligned access comes from 'struct CommandList' that happens
> to be packed. The change f749d8b7a ("scsi: hpsa: Correct dev cmds
> outstanding for retried cmds") introduced unexpected padding and
> un-aligned atomic_t from natural alignment to something else.
> 
> This change does not remove packing annotation from struct but only
> restores alignment of atomic variable.
> 
> The change is tested on the same rx3600 machine.

I just gave it a try on my RX2660 and for me, the hpsa driver won't load even
with your patch.

Can you share your kernel configuration so I can give it a try?

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

