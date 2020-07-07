Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C238BC433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 10:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F36B20708
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 10:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GSTrLIas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgGGKSd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 06:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgGGKSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 06:18:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFB7C061755;
        Tue,  7 Jul 2020 03:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qTiURiDacJKwIm9SPgxJUCGJ55dLKh31h25sBYHTVY4=; b=GSTrLIasbmmxekUaiMETEG7GR8
        Rig4k5So96WoWX7n5bmmOJFaI06dZ9Sesys8SnOitzNsrJHBoPy7Fy/wBmTq+6xPdSIoxh9FNsUb7
        iJeV+Jt0vqKsMPwVuDZ79DNwwdCkGZrsPPsOq21ZS7Is19nbpwoXyHm/cbg7ks/4RE5tHgj1WRcOV
        4cjZaBfmCOWacCaMf4nSgg0FT30vqbUq8PQmJfx/bOcfQPyZGgucs3PJxSI7GRzgDeiGVjkWBTbdD
        ayE8E7T07lHuz7FBn17/r+UPE53/4fT3XKcxF6+zVyFmL3IHK7sgGkp/RaFHi2Ghqdxwso7CsYiiO
        CU+fZm9A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jskft-00030a-CJ; Tue, 07 Jul 2020 10:18:05 +0000
Date:   Tue, 7 Jul 2020 11:18:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200707101805.GA11097@infradead.org>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200618072138.GA11778@infradead.org>
 <9877e7de-d573-694b-2b75-95192756684b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200618134904.GA26650@infradead.org>
 <20200705213125.GC8285@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705213125.GC8285@khazad-dum.debian.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 05, 2020 at 06:31:25PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Jun 2020, Christoph Hellwig wrote:
> > > For SSDs, I don't think an extra stop should ever be an issue.
> > 
> > Extra shutdowns will usually cause additional P/E cycles.
> 
> I am not so sure.  We're talking about enforcing clean shutdowns here
> (from the SSD PoV).
> 
> A system reboot takes enough time that the SSD is likely to do about the
> same amount of P cycles commiting to FLASH any important data that it
> would trigger by a shutdown sequence, simply because it should not keep
> important data in RAM for too long.  By extension, it would not increase
> E cycles either.
> 
> OTOH, unclean shutdowns *always* cause extra P/E, and that's if you're
> lucky enough for it to not cause anything much worse.

The point is - with a normal system that doesn't required your odd
reboot method we'll normally not shut down the SSD at all, and that
won't require a P/E cycle.

But the whole thing is a moot point - if you quirk your system to
require a poweroff to reboot the kernel should trat it as a power off
as far as shutdown/remove callbacks are concerned and everything will
just work as intended.
