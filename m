From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Tue, 17 Jun 2008 17:59:41 -0500
Message-ID: <1213743581.3465.98.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213540781.3517.18.camel@localhost.localdomain>
	 <48584106.5000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49690 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759984AbYFQW7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 18:59:46 -0400
In-Reply-To: <48584106.5000302@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Tue, 2008-06-17 at 18:56 -0400, Chuck Ebbert wrote:
> James Bottomley wrote:
> > On Fri, 2008-06-13 at 13:57 +0200, Geert Uytterhoeven wrote:
> >> We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
> >>
> >> It can easily be reproduced by:
> >>
> >>   1. Inserting an audio CD
> >>   2. Running the following command as soon as the blue CD/DVD/BD drive LED
> >>      stops blinking and is lit continuously:
> >>       
> >> 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> >>
> >> On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
> >> insertion, or it will fail.
> >> On 2.6.24 and older, it just works immediately.
> >>
> >> It does not matter whether
> >> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> >> is applied or not.
> >>
> >> We haven't bisected it yet.
> > 
> > There aren't that many commits affecting sr between 2.6.24 and 2.6.25,
> > so I'd bet on the previous culprits.
> > 
> > This time, the taxonomy looks like NOT_READY isn't being waited for
> > properly.  I'd still tend to blame
> > 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 it's just that this time I
> > suspect this to be the problem line:
> > 
> 
> Looking at the last part of that commit, what code path could ever lead 
> to reaching that last return statement and returning 
> CDS_DRIVE_NOT_READY? Maybe I'm just being dense but it looks unreachable 
> to me:

It is ... unfortunately, it's also been verified not to be the problem
(that's what I thought at first too) ... it looks like drivers/cdrom has
no real use for CDS_DRIVE_NOT_READY.

James


