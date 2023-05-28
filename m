Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B554CC7EE29
	for <linux-scsi@archiver.kernel.org>; Sun, 28 May 2023 14:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjE1OBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjE1OBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2023 10:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDEFC9;
        Sun, 28 May 2023 07:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52BC561730;
        Sun, 28 May 2023 14:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B08C433D2;
        Sun, 28 May 2023 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685282502;
        bh=IsefeyptmWfGbQl4cywapOg6S7HuyWajQPFCB3z6mOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2C2d8Xv2zpXwhw8dLe2BFItft/csg6JIXVvzF5nZqULxf3uMCGztm7W77pOh7Ch2
         zonoFvUOFDk10xlhiQ0CntEkCfBCK8RVgJQbx0Hwgy0zd3QpaNCuukH61Rib4qwBtv
         2q+m2IA4RFIY6pxlXm12u39O6DUPjs7kRswUvZ40=
Date:   Sun, 28 May 2023 14:59:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <benh@debian.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-scsi <linux-scsi@vger.kernel.org>, security@kernel.org
Subject: Re: dpt_i2o fixes for stable
Message-ID: <2023052856-starfish-avoid-3dde@gregkh>
References: <b1d71ba992d0adab2519dff17f6d241279c0f5f1.camel@debian.org>
 <2023052823-uncoated-slimy-cbc7@gregkh>
 <5eb8dad50ac455513be8c93c2f0aa0b5b9627b3e.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eb8dad50ac455513be8c93c2f0aa0b5b9627b3e.camel@debian.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 28, 2023 at 02:40:52PM +0200, Ben Hutchings wrote:
> On Sun, 2023-05-28 at 08:02 +0100, Greg Kroah-Hartman wrote:
> > On Sat, May 27, 2023 at 10:42:00PM +0200, Ben Hutchings wrote:
> > > I'm proposing to address the most obvious issues with dpt_i2o on stable
> > > branches.  At this stage it may be better to remove it as has been done
> > > upstream, but I'd rather limit the regression for anyone still using
> > > the hardware.
> > > 
> > > The changes are:
> > > 
> > > - "scsi: dpt_i2o: Remove broken pass-through ioctl (I2OUSERCMD)",
> > >   which closes security flaws including CVE-2023-2007.
> > > - "scsi: dpt_i2o: Do not process completions with invalid addresses",
> > >   which removes the remaining bus_to_virt() call and may slightly
> > >   improve handling of misbehaving hardware.
> > > 
> > > These changes have been compiled on all the relevant stable branches,
> > > but I don't have hardware to test on.
> > 
> > Why don't we just delete it in the stable trees as well?  If no one has
> > the hardware (otherwise the driver would not have been removed), who is
> > going to hit these issues anyway?
> 
> We don't know that no-one is using the hardware, just because no-one
> among a small group of kernel developers and early adopters has spoken
> up yet.

So what are we supposed to do here.  Take patches that even if the
driver is added back upstream will not get merged there (as it will not
be obvious they are needed)?  Or just ignore this?

Why did you work on these changes, were there reports of problems?  Or
complaints from users?  Something else?

thanks,

greg k-h
