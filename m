From: "Kai Ruhnau" <kai@tragetaschen.dyndns.org>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Fri, 16 Jan 2004 08:49:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <14dd01c3dc05$4435ce70$060ba8c0@AldiP4>
References: <Pine.LNX.4.44.0401122345060.9046-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout06.sul.t-online.com ([194.25.134.19]:10187 "EHLO
	mailout06.sul.t-online.com") by vger.kernel.org with ESMTP
	id S265309AbUAPHuA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 02:50:00 -0500
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Mon, 12 Jan 2004, Kai Ruhnau wrote:
>
> > I try to do, what I can:
> >
> > kernel 2.4.22 aha152x compiled in:
> >   aha152x: ABORT timed out - removed from issue queue
> > kernel 2.4.22 aha152x as module:
> >   No such device
> > kernel 2.4.10 aha152x compiled in:
> >   timeout and NULL-pointer dereference
> > kernel 2.4.10 aha152x as module:
> >   kernel Oops (NULL pointer dereference) during linuxrc
>
> Please try the patch below - just to see where it fails. It looks like
> you've got another driver claiming the 0x340 region - can you check your
> /proc/ioports? If not - I don't understand why SuSE-7.3 detected the chip,
> and vanilla kernels don't - among all SuSE-7.3 patches nothing touches
> aha152x.*. The patch might not apply cleanly to your kernel-version, but
> you should be able to add the required lines manually.
>
> Also, can you install SuSE 2.4.10 sources, compile a kernel from them and
> see if that works? It would be useful to get a kernel, that works, that we
> can compile ourselves, that we can compare with those kernels, that fail,
> and that we can put some debugging output in.
>
[patch]

Hi,

I actually didn't integrate the patch, but I noticed a difference between my
initrd and SuSEs initrd. And I think, it is the error, you predicted.
The problem does not lie in the aha152x driver, but in the parameters for
isa-pnp. To make everything work, I have to specify the parameter
'isapnp_reset=0' when I load isa-pnp. After that, my network-card gets
another io-range (the same as under SuSE).
I don't know if this is the solution or just a workaround that happens to
work, but it works. Perhaps someone can explain me, what happens when the
cards get 'reseted'.

Thanks to all readers. And especially to you Guennadi for your help!

Greetings
Kai

