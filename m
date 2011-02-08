From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: understanding the sg_ses --raw output? so I can turn on the
 faulty light
Date: Tue, 08 Feb 2011 08:18:04 -0600
Message-ID: <1297174684.3088.11.camel@mulgrave.site>
References: <4D500EFC.1040801@jbit.dk>
	 <1297093255.3012.30.camel@mulgrave.site>  <4D513D24.800@jbit.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab1BHOSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2011 09:18:09 -0500
In-Reply-To: <4D513D24.800@jbit.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Bendtsen <jonbendtsen@jbit.dk>
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-02-08 at 13:55 +0100, Jon Bendtsen wrote:
> On 07/02/11 16.40, James Bottomley wrote:
> > On Mon, 2011-02-07 at 16:25 +0100, Jon Bendtsen wrote:
> >> Hi
> >>
> >> There has earlier been 2 threads on sg_ses 21 may 2007 and 10 june 2010,
> >> but unfortunately neither seemed to include information about how to
> >> understand the --raw output from sg_ses.
> > 
> > It's a hex dump of the diagnostic mode page.
> 
> I know that. What I meant was which segments in the hex dump correlate
> to which segments in the text version of the dianostic mode page?

It's what the man page says:  the byte for byte output of the diagnostic
mode page minus the first four bytes.

> How long are the segments? 8 bytes? The way it is formatted something
> could hint that? Or is it just 4 bytes which another formatting suggests?

Well the descriptor format is variable, it's documented in the SES
standard.

[...]
> > I'd firstly validate that your lights can be flashed with the ses
> > driver ... if they can, then look for a mistake in the hex dump.
> 
> How can I validate that my lights can be flashed with the SES driver?

well, it depends what the enclosure calls it's slots, but it would be
something like

echo 1 > /sys/class/enclosure/<dev>/<slot>/fault

After making sure the ses driver is loaded and bound, of course.  Quite
a few fault lights are hard wired, and not amenable to software
interference (others aren't hard wired at all and only work with
software).

James


