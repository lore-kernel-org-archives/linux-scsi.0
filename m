From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 10:27:58 -0700 (PDT)
Message-ID: <20050821172758.36512.qmail@web51608.mail.yahoo.com>
References: <1124640387.5068.2.camel@mulgrave>
Reply-To: luben_tuikov@adaptec.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:42445 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751163AbVHUVlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:41:50 -0400
Received: from web51608.mail.yahoo.com (web51608.mail.yahoo.com [206.190.38.213])
	by zeus1.kernel.org (8.13.1/8.13.1) with SMTP id j7LHTGjV012128
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 10:29:18 -0700
In-Reply-To: <1124640387.5068.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, luben_tuikov@adaptec.com
Cc: Andrew Morton <akpm@osdl.org>, Jim Houston <jim.houston@ccur.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Sun, 2005-08-21 at 08:49 -0700, Luben Tuikov wrote:
> > The caller is the aic94xx SAS LLDD.  It uses IDR to generate unique
> > task tag for each SCSI task being submitted.  It is then used to lookup
> > the task given the task tag, in effect using IDR as a fast lookup table.
> > 
> > Yes, I'm also not aware of any other users of IDR from mixed process/IRQ
> > context or for SCSI Task tag purposes.
> 
> Just a minute, that's not what idr was designed for.  It was really
> designed for enumerations (like disk) presented to the user.  That's why
> using it in IRQ context hasn't been considered.

Hi James, how are you?

Is this the only use _you_ could find for a *radix tree*? ;-)
Since of course sd.c uses it just as an enumeration, according to
you this must be the only use? :-)

It was designed as a general purpose id to pointer translation
service, just as the comment in it says.

> However, there is an infrastructure in the block layer called the
> generic tag infrastructure which was designed precisely for this purpose
> and which is designed to operate in IRQ context.

James, I'm sure you're well aware that,
   - a request_queue is LU-bound,
   - a SCSI _transport_ (*ANY*) can _only_ address domain devices, but
     _not_ LUs.  LUs are *not* seen on the domain.

See the different associations?  Then why are you posting such emails?

Andrew, please apply this patch.

Thanks,
     Luben

