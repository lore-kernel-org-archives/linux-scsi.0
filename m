Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEFFC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C58264E89
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhCAHJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:09:10 -0500
Received: from authsmtp15.register.it ([81.88.48.38]:37409 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232287AbhCAHH2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 02:07:28 -0500
Received: from [192.168.43.2] ([151.46.175.224])
        by cmsmtp with ESMTPSA
        id GcdXl6P2Xf5o5GcdXlhz2r; Mon, 01 Mar 2021 08:06:37 +0100
X-Rid:  guido@trentalancia.com@151.46.175.224
Message-ID: <1614582394.13266.11.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 01 Mar 2021 08:06:34 +0100
In-Reply-To: <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCsVzcoWkjPxMVEx9G25xTbqHhC4hMIm/u9+FwoR/dLwi1UR6rN67gDAu5kq2geSOqEWv88GH/Uf+e0Dknw4C7Jsne3Eg+Aqw05miNBTl0YH5F+1GcET
 5CR6Jug1MjsUSEXC+8tL2yzKfyNJTCwZpmycb3MCwUOQ9vHQkXp2Zrff5pmxE+RSQEE1myeADtIFI0zci6I6m8Ni/YrAqmdPZYSEKh9lQQLYtdaDco5Ejggr
 tqz1klD3ddJXwo40rxKztB4hW5ySg6eZeWN8KiC+Fa0=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

thanks for getting back on this issue.

I have tested this patch for over a year and it works flawlessly
without any data corruption !

On such kind of drives the actual situation is just the opposite as you
describe: data corruption occurs when not using this patch !

I do not agree with you: if a drive does not support Synchronize Cache
command, there is no point in treating the failure as critical and by
all means the failure must be ignored, as there is nothing which can be
done about it and it should not be treated as a failure !

However, if you are willing to propose an alternative patch, I'd be
happy to test it and report back, as long as this bug is fixed in the
shortest time possible.

Guido

On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:
> On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:
> > Many obsolete hard drives do not support the Synchronize Cache SCSI
> > command. Such command is generally issued during fsync() calls
> > which
> > at the moment therefore fail with the ILLEGAL_REQUEST sense key.
> 
> It should be that all drives that don't support sync cache also don't
> have write back caches, which means we don't try to do a cache sync
> on
> them.  The only time you we ever try to sync the cache is if the
> device
> advertises a write back cache, in which case the sync cache command
> is
> mandatory.
> 
> I'm sure some SATA manufacturers somewhere cut enough corners to
> produce an illegally spec'd drive like this, but your proposed remedy
> is unviable: you can't ignore a cache failure on flush barriers which
> will cause data corruption.  You have to disable barriers on the
> filesystem to get correct operation and be very careful about power
> down.
> 
> James
> 
> 
