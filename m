Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482E9C77B7C
	for <linux-scsi@archiver.kernel.org>; Sun, 28 May 2023 12:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjE1MlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 May 2023 08:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjE1Mk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2023 08:40:59 -0400
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B029AB9;
        Sun, 28 May 2023 05:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:MIME-Version:Content-Transfer-Encoding
        :Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:
        Reply-To:Content-ID:Content-Description;
        bh=F1S4Ih36C86GokfbQoGptZxOiHOyPRlnY+A5WO2Zub0=; b=Tq0FRqiZ8J0/+XPNTdAI9qHSV1
        BOh0KKj39gkkPdO6PlGADPM0dMg40i7YQXi6bjYJs/WwthWz/NbhVMbnFJ31TkTuzpOeirD3VK2dn
        QN45KyZQbcBuxZGGLeEEjNcMOWmIBeE8INwM5KUmtpDQZw7yDnMp3OG2DHSP/Lj3opThJQWzN1MHF
        v4RC+7WRTxErOgdX+R3NoWdkHsPOlRTtUABSn2C9B1fCUiia4OJsaNVqpwsseZG2p6tU0l4GmncmM
        v4aVh0yXAjGBn8qWUtoQY10IR989ecqj9GSWiRyQTx2BGv632MIVUJC/XdGQqPZk1nYi/OS8AUXcQ
        0UmXIoJA==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <benh@debian.org>)
        id 1q3Fhe-00D5xm-MN; Sun, 28 May 2023 12:40:55 +0000
Message-ID: <5eb8dad50ac455513be8c93c2f0aa0b5b9627b3e.camel@debian.org>
Subject: Re: dpt_i2o fixes for stable
From:   Ben Hutchings <benh@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-scsi <linux-scsi@vger.kernel.org>, security@kernel.org
Date:   Sun, 28 May 2023 14:40:52 +0200
In-Reply-To: <2023052823-uncoated-slimy-cbc7@gregkh>
References: <b1d71ba992d0adab2519dff17f6d241279c0f5f1.camel@debian.org>
         <2023052823-uncoated-slimy-cbc7@gregkh>
Organization: Debian
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
MIME-Version: 1.0
X-Debian-User: benh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2023-05-28 at 08:02 +0100, Greg Kroah-Hartman wrote:
> On Sat, May 27, 2023 at 10:42:00PM +0200, Ben Hutchings wrote:
> > I'm proposing to address the most obvious issues with dpt_i2o on stable
> > branches.  At this stage it may be better to remove it as has been done
> > upstream, but I'd rather limit the regression for anyone still using
> > the hardware.
> >=20
> > The changes are:
> >=20
> > - "scsi: dpt_i2o: Remove broken pass-through ioctl (I2OUSERCMD)",
> >   which closes security flaws including CVE-2023-2007.
> > - "scsi: dpt_i2o: Do not process completions with invalid addresses",
> >   which removes the remaining bus_to_virt() call and may slightly
> >   improve handling of misbehaving hardware.
> >=20
> > These changes have been compiled on all the relevant stable branches,
> > but I don't have hardware to test on.
>=20
> Why don't we just delete it in the stable trees as well?  If no one has
> the hardware (otherwise the driver would not have been removed), who is
> going to hit these issues anyway?

We don't know that no-one is using the hardware, just because no-one
among a small group of kernel developers and early adopters has spoken
up yet.

Ben.

--=20
Ben Hutchings - Debian developer, member of kernel, installer and LTS
teams
