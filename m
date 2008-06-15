From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Sun, 15 Jun 2008 09:39:41 -0500
Message-ID: <1213540781.3517.18.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56990 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758056AbYFOOjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2008 10:39:45 -0400
In-Reply-To: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Fri, 2008-06-13 at 13:57 +0200, Geert Uytterhoeven wrote:
> We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
> 
> It can easily be reproduced by:
> 
>   1. Inserting an audio CD
>   2. Running the following command as soon as the blue CD/DVD/BD drive LED
>      stops blinking and is lit continuously:
>       
> 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> 
> On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
> insertion, or it will fail.
> On 2.6.24 and older, it just works immediately.
> 
> It does not matter whether
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> is applied or not.
> 
> We haven't bisected it yet.

There aren't that many commits affecting sr between 2.6.24 and 2.6.25,
so I'd bet on the previous culprits.

This time, the taxonomy looks like NOT_READY isn't being waited for
properly.  I'd still tend to blame
210ba1d1724f5c4ed87a2ab1a21ca861a915f734 it's just that this time I
suspect this to be the problem line:

	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
		return CDS_DISC_OK;

Previously the code would have returned CDS_NO_DISC for the not ready
case.  The CD would have tried to close the door but (and this is the
key) it would have waited for the door to close before trying again.

James


