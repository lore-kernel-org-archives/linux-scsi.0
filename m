Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E8BC43215
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 22:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E42620722
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 22:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Q/TFhfb1";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Q/TFhfb1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfLBWkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:40:40 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49156 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725853AbfLBWkk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 17:40:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6FCBA8EE180;
        Mon,  2 Dec 2019 14:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1575326439;
        bh=w/oP+1BA9PA+20BsnpDXfjU/W0UeBcXPQE9EA4rXG7E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q/TFhfb106IByr2UHFDTsb5mKi9sCvOku2EZUYITsc1bD181AripSFV7XVrDcvMHw
         ry0b18H8qc/HfPIROWBWvNQf9ou/Rm3IT0I78hArcBZ30hmdEdhgbawqno+xNVWxd7
         LCm7UPVKKssPKqK52/5mrTiJbngcGlUwAcRsDpvg=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tlDozYtRc6qk; Mon,  2 Dec 2019 14:40:39 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id BF5558EE11D;
        Mon,  2 Dec 2019 14:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1575326439;
        bh=w/oP+1BA9PA+20BsnpDXfjU/W0UeBcXPQE9EA4rXG7E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q/TFhfb106IByr2UHFDTsb5mKi9sCvOku2EZUYITsc1bD181AripSFV7XVrDcvMHw
         ry0b18H8qc/HfPIROWBWvNQf9ou/Rm3IT0I78hArcBZ30hmdEdhgbawqno+xNVWxd7
         LCm7UPVKKssPKqK52/5mrTiJbngcGlUwAcRsDpvg=
Message-ID: <1575326437.24227.19.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.4+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Mon, 02 Dec 2019 14:40:37 -0800
In-Reply-To: <CAHk-=wjWNpPW91wyEj4FC4pOimWEUtLVb_RwQgB+9h2OO6ynyA@mail.gmail.com>
References: <1575137443.5563.18.camel@HansenPartnership.com>
         <CAHk-=wjWNpPW91wyEj4FC4pOimWEUtLVb_RwQgB+9h2OO6ynyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-12-02 at 13:57 -0800, Linus Torvalds wrote:
> On Sat, Nov 30, 2019 at 10:10 AM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> >    The two major core
> > changes are Al Viro's reworking of sg's handling of copy to/from
> > user, Ming Lei's removal of the host busy counter to avoid
> > contention in the multiqueue case and Damien Le Moal's fixing of
> > residual tracking across error handling.
> 
> Math is hard. You say "The two major core changes are.." and then you
> list _three_ changes.

Oh ... I wasn't expecting the Spanish Inquisition.

> Anyway, the sg copyin/out changes by Al conflicted fairly badly with
> Arnd's compat_ioctl changes.
> 
> Al did
> 
>   c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of
> userland sg_io_hdr_t")
> 
> which avoided doing a whole allocation of an 'sg_io_hdr_t' to just
> read the one field of it.
> 
> But Arnd did
> 
>   98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
> 
> which created a get_sg_io_hdr() helper that copied the 'sg_io_hdr_t'
> from user space the right way for both compat and native, which
> basically relied on the old approach.
> 
> So I effectively reverted Al's patch in order to take Arnd's patch in
> the crazy sg legacy case that presumably nobody really cares about
> anyway, since everybody should use SG_IO rather than the sg_read()
> thing. But I know not everybody is.
> 
> I added a comment in that place:
> 
>               /*
>                * This is stupid.
>                *
>                * We're copying the whole sg_io_hdr_t from user
>                * space just to get the 'pack_id' field. But the
>                * field is at different offsets for the compat
>                * case, so we'll use "get_sg_io_hdr()" to copy
>                * the whole thing and convert it.
>                *
>                * We could do something like just calculating the
>                * offset based of 'in_compat_syscall()', but the
>                * 'compat_sg_io_hdr' definition is in the wrong
>                * place for that.
>                */
> 
> since it turns out that the one 'pack_id' field we want does have the
> same format in compat  mode as in native mode ("int" and
> "compat_int_t" are the same), it's just at different offsets. But the
> definition of 'compat_sg_io_hdr' isn't available in that place.
> 
> I'm leaving it to Al and Arnd to decide if they want to fix the
> stupidity. I tried to make the minimally invasive merge resolution.
> 
> Al, Arnd? Comments?
> 
> It looks like linux-next punted on this entirely, and took Al's
> simplified version that doesn't work with the compat case. Maybe I
> should have done the same - if you use read() on the /dev/sg* device,
> you deserve to get broken for the compat case. And it didn't
> historically work anyway. But it was kind of sad to see how Arnd
> fixed it, and then it got broken again.

Sorry, I did do a test merge with the current state of your tree when I
sent the pull request, but, obviously, that didn't include the Arnd
changes and I've taken to rely on linux-next as the merge problem
canary for trees you haven't yet pulled.

> I really really wish we could get rid of sg_read/sg_write() entirely,
> and have SG_IO_SUBMIT and SG_IO_RECEIVE ioctl's that can handle the
> queued cases that apparently some people need. Because the read/write
> case really is disgusting.

We're definitely not having a read/write case for the proposed v4
protocol ... however we are a bit stuck with it for the existing v3
case.

James

