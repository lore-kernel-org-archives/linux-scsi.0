Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7F8C4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 11:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96D9D20728
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 11:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604055917;
	bh=HkILBJuhp20eEQXOXy7z45QV74eTNliVADEHd72LFo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZA4DyptrBwxZGBe6XDdXZft3uRqGj5Ov6FZu0Lp9RGBh+gkPHvdpHTn+xfQpPc8eu
	 FOOAvwWQNr4MTsQlRfQv9zB2DLkhruF56BCmJNoQPF9rDRdiAt4U7uW2JQ2OIJABbr
	 IR46E4AqdPqCEBPEWngdYtAylBPkuVMima/WdAJ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgJ3LFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3LFN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 07:05:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F9420724;
        Fri, 30 Oct 2020 11:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604055912;
        bh=HkILBJuhp20eEQXOXy7z45QV74eTNliVADEHd72LFo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iyTS4J43yvqa2fgb21t7LJsLyNU25aSYx/CPW/AQFwRxvVg3JE5tsfHGK674rcr3O
         zYs9gjjWlOWaxOVYQpbJEcgJasWptoYKWHc/J7h1myQF7B8Neg2kGR/UQEo9+aPHJE
         a9xZOaFXZBLfi9YUn+htxKHvf8HploekpXXe2hmw=
Date:   Fri, 30 Oct 2020 12:06:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        scsi <linux-scsi@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Subject: Re: [PATCH 02/18] block: open code kobj_map into in block/genhd.c
Message-ID: <20201030110600.GA2406237@kroah.com>
References: <20201029145841.144173-1-hch@lst.de>
 <20201029145841.144173-3-hch@lst.de>
 <20201029192236.GA991240@kroah.com>
 <20201029193242.GA4799@lst.de>
 <20201030104033.GA2392682@kroah.com>
 <CAMuHMdXuzM0Z+yXXWqw8E2u-TNaC6C7NMRMH+X8oWQGaD=jckw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXuzM0Z+yXXWqw8E2u-TNaC6C7NMRMH+X8oWQGaD=jckw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 30, 2020 at 11:49:11AM +0100, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Fri, Oct 30, 2020 at 11:40 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Oct 29, 2020 at 08:32:42PM +0100, Christoph Hellwig wrote:
> > > On Thu, Oct 29, 2020 at 08:22:36PM +0100, Greg Kroah-Hartman wrote:
> > > > After this, you want me to get rid of kobj_map, right?  Or you don't
> > > > care as block doesn't use it anymore?  :)
> > >
> > > I have a patch to kill it, but it causes odd regressions with the
> > > tpm driver according to the kernel test.  As I have grand plans that
> > > build on the block ѕide of this series for 5.11, I plan to defer the
> > > chardev side and address it for 5.12.
> >
> > Ok, sounds good.
> >
> > Wow, I just looked at the tpm code, and it is, um, "interesting" in how
> > it thinks device lifespans work.  Nothing like having 4 different
> > structures with different lifespans embedded within a single structure.
> > Good thing that no one can dynamically remove a TPM device during
> > "normal" operation.
> 
> /sys/.../unbind?

I said "normal" operations :)

Anyone who uses unbind and is suprised when things go "boom" is naive.

thanks,

greg k-h
