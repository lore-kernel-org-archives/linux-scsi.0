Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71B3C77B7E
	for <linux-scsi@archiver.kernel.org>; Sun, 28 May 2023 09:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjE1J6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 May 2023 05:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjE1J6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2023 05:58:05 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566F2BD;
        Sun, 28 May 2023 02:58:03 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id A14F05C00BA;
        Sun, 28 May 2023 05:58:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 28 May 2023 05:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1685267880; x=1685354280; bh=6bGr5f+l743JM
        FemgVuBrVS0xoynjVGDKTKNlL1flrc=; b=usKMJbH8U9arNw0HyLX2/SGOAsJU7
        jXCe/3HzS9LN2qtXMsEwKHVeWA+2X97qZrF2XwTPajmJsqcjbhWUL+iUpcCSdsdh
        dKj0hGmXWxLfs2w6vKoEkKaARwItU/EXd+PICwemadCECAvMUksoWV9gYTIXbV4a
        3ybVKLr+X4fUc7Wu+RECJaq1nSepVzRw6IiSUYchIuNMhCg0i1rXStudak+8CNGj
        430zCeUERnwJpNxgYhYwMo5idwKp+RYWOZ7Ato3EUlfRj32FQ1z3xitAfAn9es5O
        lVsBFkpocx0JMOE7uK51AjM4puKNa+JTy0SSYa0OEvWx63VfHIm6Hi1uw==
X-ME-Sender: <xms:qCVzZNCHUo3GuF-qllBHc5rrWtpq8pJ3XCc63M0RPs1keAnhbPdyWw>
    <xme:qCVzZLjP3i17OSo3I0p8KMuSu4t0_Ej7GtB1iUe8ERI6KK1or3y_X7auY1YLoy2ED
    XqZBGjaumFhWWKfzQo>
X-ME-Received: <xmr:qCVzZIkZfrvmuIax7mwbwOg4ha5gvHnRV0uojeSlV6YLWVTp_EjPS2yr1mHZI4bYMQ-qsiJsx9uXabAzhOiCluZLWsMyhqJ8-mE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:qCVzZHxh0bys7lpVmLnszsE1yrCAfHiKcz3mU0Y3O60a2RyHaXFVbQ>
    <xmx:qCVzZCSuTyWeFfCa64dten4r7K_AQiFCL3QDpblZYUBzljaxb3l2OA>
    <xmx:qCVzZKYZeLvawxjExolovg8MttFxw2teNKLzT-sRXzxf0JVV0_7cFw>
    <xmx:qCVzZIOi3L2-iXM6A1qjxf0xRCaERipsAqznw9f5m0blHLvV69BnmA>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 May 2023 05:57:58 -0400 (EDT)
Date:   Sun, 28 May 2023 19:58:11 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Ben Hutchings <benh@debian.org>, Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-scsi <linux-scsi@vger.kernel.org>, security@kernel.org
Subject: Re: dpt_i2o fixes for stable
In-Reply-To: <2023052823-uncoated-slimy-cbc7@gregkh>
Message-ID: <98021ba4-a6cd-69aa-393f-37b2ddab5587@linux-m68k.org>
References: <b1d71ba992d0adab2519dff17f6d241279c0f5f1.camel@debian.org> <2023052823-uncoated-slimy-cbc7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 28 May 2023, Greg Kroah-Hartman wrote:

> On Sat, May 27, 2023 at 10:42:00PM +0200, Ben Hutchings wrote:
> > I'm proposing to address the most obvious issues with dpt_i2o on stable
> > branches.  At this stage it may be better to remove it as has been done
> > upstream, but I'd rather limit the regression for anyone still using
> > the hardware.
> > 
> > The changes are:
> > 
> > - "scsi: dpt_i2o: Remove broken pass-through ioctl (I2OUSERCMD)",
> >   which closes security flaws including CVE-2023-2007.
> > - "scsi: dpt_i2o: Do not process completions with invalid addresses",
> >   which removes the remaining bus_to_virt() call and may slightly
> >   improve handling of misbehaving hardware.
> > 
> > These changes have been compiled on all the relevant stable branches,
> > but I don't have hardware to test on.
> 
> Why don't we just delete it in the stable trees as well?  If no one has
> the hardware (otherwise the driver would not have been removed), who is
> going to hit these issues anyway?
> 

It's already gone from two stable trees. Would you also have it deleted 
from users' machines, or would you have each distro separately maintain 
out-of-tree that code which it is presently shipping, or something else?
