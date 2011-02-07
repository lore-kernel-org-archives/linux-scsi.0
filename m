From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: understanding the sg_ses --raw output? so I can turn on the
 faulty light
Date: Mon, 07 Feb 2011 09:40:55 -0600
Message-ID: <1297093255.3012.30.camel@mulgrave.site>
References: <4D500EFC.1040801@jbit.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab1BGPlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2011 10:41:00 -0500
In-Reply-To: <4D500EFC.1040801@jbit.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Bendtsen <jonbendtsen@jbit.dk>
Cc: linux-scsi@vger.kernel.org

On Mon, 2011-02-07 at 16:25 +0100, Jon Bendtsen wrote:
> Hi
> 
> There has earlier been 2 threads on sg_ses 21 may 2007 and 10 june 2010,
> but unfortunately neither seemed to include information about how to
> understand the --raw output from sg_ses.

It's a hex dump of the diagnostic mode page.

> When I run this command
> 	sg_ses --page=2 /dev/sg30 --raw
> 
> I get output that looks like:
>         00 00 00 00 00 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  00 00 01 00 01 00 01 00
>         00 00 00 40 06 00 00 47  06 00 00 47 06 00 00 47
>         00 00 00 00 01 00 2c 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00
> 
> There are 26 segments starting with 01 00 00 00, and 27 with 06. I think
> i have to use the 01 segments, but the number 26 does not fit with my
> number of disks unless they count like this: controller, backplane + 24
> disks or enclosure port A + port B + 24 disks.
> 
> At first i figured i had to set 20 in the last field, but that did not
> work. So i tried modifying a 01 00 00 00 to 01 00 02 20 based on this
> webpage:
> http://storagesecrets.org/2008/12/scsi-enclosure-services-ses-ses-2-management/
> 
> I also tried with 06 00 00 00 to 06 00 02 20, still nothing.
> 
> I set the data using
> 	sg_ses --control --page=2 -d - /dev/sg30 < raw.test

So I don't really plan to parse a huge hex dump, but my instinct would
be you got something wrong.

I'd firstly validate that your lights can be flashed with the ses
driver ... if they can, then look for a mistake in the hex dump.

James


