From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: can't write to tape
Date: Fri, 7 Jan 2005 21:13:43 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0501072057500.6238@poirot.grange>
References: <200501060518.25782.andrex@alumni.utexas.net>
 <Pine.LNX.4.60.0501062138580.7568@poirot.grange> <200501070552.57607.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43471 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261591AbVAGUQ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 15:16:57 -0500
In-Reply-To: <200501070552.57607.andrex@alumni.utexas.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

On Fri, 7 Jan 2005, Andrew Schulman wrote:

> > > Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt failed
> >
> > This doesn't look good. However, after a brief look at the code, I cannot
> > say what exactly went wrong there. Jamie?
> 
> I didn't mention it before, but I've gotten that particular message for a long 
> time, even when the tape drive used to work.  I reported on it several months 
> ago on this list 
> (http://marc.theaimsgroup.com/?l=linux-scsi&m=108039964822342&w=2) in 
> connection with a balky CD burner, which I've since junked.  After some work 
> and upgrading my kernel, I got the CD burner working again, but the flood of 
> sg_to_virt failed messages continued.  Jaime finally recommended that I just 
> disable them, which I did until I got rid of the CD burner.  Maybe 
> relevant...

Could you try disabling highmem either try a kernel without highmem 
support, or boot with mem=900M, or remove a part of your RAM (if you 
don't have to saw your RAMs for that:-)), maybe, booting with highmem=0, 
or with nohighio.

> > > Jan  5 22:50:18 helium kernel: st0: Error with sense data: Info fld=0x67,
> > > Current st0: sense = f0  4
> >
> > Sense key 4 - hardware error.
> >
> > > Jan  5 22:50:18 helium kernel: ASC=80 ASCQ=98
> >
> > Additional sense code 0x80 - vendor specific.
> >
> > So, the sense codes indicate a hardware problem on the tape drive, but the
> > first message might mean a software bug. You don't have highmem on that
> > machine (> 1GB RAM), do you?
> 
> CONFIG_HIGHMEM4G is enabled in the kernel, and I have 1 GiB of RAM.

Yeah, that should have been >= 1G. So, at least the message could indicate 
a bug in highmem support in the driver.

Still, your tape problem seems to be unrelated. Do you have a chance to 
test it in another system / with another controller?

Thanks
Guennadi
---
Guennadi Liakhovetski

