Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2F2C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 00:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjE2AGE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 May 2023 20:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjE2AGD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2023 20:06:03 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB432B8;
        Sun, 28 May 2023 17:06:00 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9AB065C00B6;
        Sun, 28 May 2023 20:05:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 28 May 2023 20:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1685318758; x=1685405158; bh=LYnCdBHw+nD5S
        4IL4lMllL6gGGRTemGi2zxuMX09r0o=; b=tcQlbaYHyhCRNM2INywmMWoUCDX4y
        BxupO1Qmmof8+HnVdhjDg8E0X/Y3hZ391Hi6/UQGito38grCh2uveygGrsnYbAeN
        xxwLR3CRmPk9NE5ToQ7/v1GacxGchr+jhCNJ0wGvD+G2oV3NwZmIYzIUWEKHTBYF
        T4zFsANk7u+ErwZQHMKGqq0nrOSUxZhNNLUUi/gHxssKz7/ZNN3mzg1S9OITnhEH
        Xhthb2v6a7dkoXWuCvyOF0h9m2AVHPW1RRImoUndVe8nxqmWGud/fM9/TJPwMuQA
        +sHc/ihC4ssPjeFg53NJ2oZPpOgx41PxBGl3NRfivFyj2xu1MlfT0YrAA==
X-ME-Sender: <xms:ZuxzZJ-KBvn3_O4lfbTdJc55NSuxI_VmlHMFXbFuGqzql1T1rgQkvw>
    <xme:ZuxzZNv73dxMAI2n-inP9R7Vn5sX62ctto39tfqjAGRgra8HMIXM_53Yc5hmHJoQ5
    gi3mT5vqAZIt59Nd1U>
X-ME-Received: <xmr:ZuxzZHBWD4pgHriODOMl4c94jIKnBxXfR9WMbWczLtIIA3NTe5fGC4fRND_Pw2O9axGJ9eSNyYLPYMDherPM0NbrVwlcHbK9V6E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekgedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:ZuxzZNfZU6TpIx6tR85nJMupUPTaY30oir6bgltGJ4ahEJysliLKrQ>
    <xmx:ZuxzZOOu4s2oZS9KV04RtesjaNlJCjBbP1ogyIOKTZ9ty68Fh8OoSw>
    <xmx:ZuxzZPkEz-ZyEF6RzkUvPEzelmMfwe4Oj879Tw3TMtfI8UAzjUtVbg>
    <xmx:ZuxzZLr6rCP9vDTmW8WO13V4Z91t5A9kNUeROGzW929CV7gxbwJ-FA>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 May 2023 20:05:55 -0400 (EDT)
Date:   Mon, 29 May 2023 10:06:07 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Ben Hutchings <benh@debian.org>, Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-scsi <linux-scsi@vger.kernel.org>, security@kernel.org
Subject: Re: dpt_i2o fixes for stable
In-Reply-To: <2023052800-tux-defraud-374d@gregkh>
Message-ID: <2c3e073d-4c85-9d22-a7cf-ae1314a15c91@linux-m68k.org>
References: <b1d71ba992d0adab2519dff17f6d241279c0f5f1.camel@debian.org> <2023052823-uncoated-slimy-cbc7@gregkh> <98021ba4-a6cd-69aa-393f-37b2ddab5587@linux-m68k.org> <2023052800-tux-defraud-374d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 28 May 2023, Greg Kroah-Hartman wrote:

> On Sun, May 28, 2023 at 07:58:11PM +1000, Finn Thain wrote:
> > On Sun, 28 May 2023, Greg Kroah-Hartman wrote:
> > 
> > > On Sat, May 27, 2023 at 10:42:00PM +0200, Ben Hutchings wrote:
> > > > I'm proposing to address the most obvious issues with dpt_i2o on stable
> > > > branches.  At this stage it may be better to remove it as has been done
> > > > upstream, but I'd rather limit the regression for anyone still using
> > > > the hardware.
> > > > 
> > > > The changes are:
> > > > 
> > > > - "scsi: dpt_i2o: Remove broken pass-through ioctl (I2OUSERCMD)",
> > > >   which closes security flaws including CVE-2023-2007.
> > > > - "scsi: dpt_i2o: Do not process completions with invalid addresses",
> > > >   which removes the remaining bus_to_virt() call and may slightly
> > > >   improve handling of misbehaving hardware.
> > > > 
> > > > These changes have been compiled on all the relevant stable branches,
> > > > but I don't have hardware to test on.
> > > 
> > > Why don't we just delete it in the stable trees as well?  If no one has
> > > the hardware (otherwise the driver would not have been removed), who is
> > > going to hit these issues anyway?
> > > 
> > 
> > It's already gone from two stable trees. Would you also have it deleted 
> > from users' machines, or would you have each distro separately maintain 
> > out-of-tree that code which it is presently shipping, or something else?
> 
> Delete it as obviously no one actually has this hardware.  Or just leave
> it alone, as obviously no one has this hardware so any changes made to
> the code would not actually affect anyone.
> 
> Or am I missing something here?
> 

Under the assumption that the hardware does not exist, surely there's no 
value in a distro shipping the driver. No argument from me on that point. 
But the assumption is questionable and impossible to validate.

As b04e75a4a8a8 was never reverted, I infer that users of v6.0 (and later) 
do not need the driver. How do you infer that users of distro kernels are 
not using a given driver?
