Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CF4C77B7E
	for <linux-scsi@archiver.kernel.org>; Sun, 28 May 2023 11:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjE1Lef (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 May 2023 07:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjE1Lee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2023 07:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEAD1B4;
        Sun, 28 May 2023 04:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD1161475;
        Sun, 28 May 2023 11:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4977FC433EF;
        Sun, 28 May 2023 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685273655;
        bh=CJ1aT1tS2s04jg9rgqkZVw+PTXwXSXYsc5Zx28T3tVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SwCMngdLNchUUjwVhARn3dwJREdoegZHsMIaWu3TLreXFJkUckJiIX2DuvdVPke+m
         0sUIB6dH89HkE6iGhyzY7iAEwvX3792lNN2//X3ndjs9EiNLEZ9jq6co7M6AZjQRKq
         MzlbM4DZ76nBLYuJAIe66rHVfb177i/yI1N5H5VE=
Date:   Sun, 28 May 2023 12:28:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Ben Hutchings <benh@debian.org>, Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-scsi <linux-scsi@vger.kernel.org>, security@kernel.org
Subject: Re: dpt_i2o fixes for stable
Message-ID: <2023052800-tux-defraud-374d@gregkh>
References: <b1d71ba992d0adab2519dff17f6d241279c0f5f1.camel@debian.org>
 <2023052823-uncoated-slimy-cbc7@gregkh>
 <98021ba4-a6cd-69aa-393f-37b2ddab5587@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98021ba4-a6cd-69aa-393f-37b2ddab5587@linux-m68k.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 28, 2023 at 07:58:11PM +1000, Finn Thain wrote:
> On Sun, 28 May 2023, Greg Kroah-Hartman wrote:
> 
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
> > 
> 
> It's already gone from two stable trees. Would you also have it deleted 
> from users' machines, or would you have each distro separately maintain 
> out-of-tree that code which it is presently shipping, or something else?

Delete it as obviously no one actually has this hardware.  Or just leave
it alone, as obviously no one has this hardware so any changes made to
the code would not actually affect anyone.

Or am I missing something here?

thanks,

greg k-h
