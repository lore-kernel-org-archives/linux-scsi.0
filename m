From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 08:49:19 -0700 (PDT)
Message-ID: <20050821154919.91440.qmail@web51609.mail.yahoo.com>
References: <20050821012506.5b106dab.akpm@osdl.org>
Reply-To: luben_tuikov@adaptec.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51609.mail.yahoo.com ([206.190.38.214]:43965 "HELO
	web51609.mail.yahoo.com") by vger.kernel.org with SMTP
	id S1751063AbVHUPtZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 11:49:25 -0400
In-Reply-To: <20050821012506.5b106dab.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Jim Houston <jim.houston@ccur.com>
Cc: luben_tuikov@adaptec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davej@redhat.com, jgarzik@pobox.com

--- Andrew Morton <akpm@osdl.org> wrote:

> Jim Houston <jim.houston@ccur.com> wrote:
> >
> > On Tue, 2005-08-16 at 18:03, Luben Tuikov wrote:
> > 
> > > If idr_get_new() or idr_remove() is used in IRQ context,
> > > then we may get a lockup when idr_pre_get was called
> > > in process context and an IRQ interrupted while it held
> > > the idp lock.
> > 
> > Hi Everyone,
> > 
> > Luben's changes make sense please merge them.
> > 
> 
> Well yes, the change makes sense if there's actually a caller which needs it.
> 
> If there is such a caller then Luben should identify it, please.

Hi Andrew,

The caller is the aic94xx SAS LLDD.  It uses IDR to generate unique
task tag for each SCSI task being submitted.  It is then used to lookup
the task given the task tag, in effect using IDR as a fast lookup table.

Yes, I'm also not aware of any other users of IDR from mixed process/IRQ
context or for SCSI Task tag purposes.

    Luben

