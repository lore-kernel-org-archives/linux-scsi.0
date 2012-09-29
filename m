From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Sat, 29 Sep 2012 15:55:13 -0500 (CDT)
Message-ID: <alpine.LNX.2.02.1209291443590.14311@banach.math.auburn.edu>
References: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA@mail.gmail.com> <Pine.LNX.4.44L0.1209271447340.1230-100000@iolanthe.rowland.org> <CAEG-z29dU=C49u7_Hi--dKLLf4OuS_LgB3azR4ui4ngu8dt-bQ@mail.gmail.com> <20120927200433.GB27721@xanatos>
 <CAEG-z2-Z9ojSYatHAq-71EjM36uieL3rrn1V4+hsZAz5murGTA@mail.gmail.com> <alpine.LNX.2.00.1209271758310.12216@banach.math.auburn.edu> <CAEG-z2-vNfQh2yHnu2LqfCjP06LzULHU3vUWoVp-eetAzNbFpg@mail.gmail.com> <CAEG-z29e2mh8b9mhvFtbEXGAdP+sHA+S5-6u5vnpdzhb20QEgQ@mail.gmail.com>
 <CAEG-z2-e2cwZLsDc9ZK8JWAtpKbEcHSG7STwGezc-+9D-=P5Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60275 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2I2Uyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 16:54:32 -0400
In-Reply-To: <CAEG-z2-e2cwZLsDc9ZK8JWAtpKbEcHSG7STwGezc-+9D-=P5Jw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org



On Sat, 29 Sep 2012, Adrian Sandu wrote:

> > The only solution I see is to buy something else, like an Asus
> > EB1501P-B057E .. I need something small and fast enough .. :| Maybe
> > any other recommendations ? ( other root chipset / atom cpu .. small
> > powered .. etc. )
> 
> DON'T KILL ME ! .. I got the best cables I could get my hands on (
> double-shielded, 24k golded connectors .. metal pieces .. the best I
> could get my hands on on such short notice )... I replaced 2 cables (
> to hard drives ) and the one from the hub to the computer. I only got
> 1 "reset" message in /var/log/messages in 24 hours .. I'll replace the
> other 4 just to be sure .. Now I should "spam" the companies and tell
> them they should provide cables within specs ..
> 
> I guess having 6 drives that close ( among with other powering cables
> .. networking (I think I got at least 40 cables in that 1 sq m. ))
> isn't that good especially when the usb has another power source and
> stuff..
> 
> IT WORKS. YEY. Hope this will help somebody in the future. Thanks for
> bearing me .. I sure learned a lesson from this. I guess all is well
> when it ends well.

Adrian,

I certainly would not think of "killing" anyone. I don't think anyone else 
on the list would, either. But your problems with the hard drivers are in 
fact an object lesson about flaky and barely-within-spec or 
barely-out-of-spec hardware. The problems are indeed very vexing and are 
quite difficult to isolate. I am glad that a couple of us actually began 
to suspect the hardware. It seems that those suspicions panned out, and 
all is well that ends well.

Even though I was not the first to pinpoint the problem, I had been 
reading this thread and the other post which raised the issue of hardware 
problems really got my spider-sense tingling. I started to remember some 
of my own experiences. Two of them immediately come to mind and might 
serve as a further object lesson to anyone who passes by and reads this:

1. A camera with the SQ913 camera chipset inside. My camera, which was 
used to write the driver code in libgphoto2, worked just fine on a Dell 
Pentium 3 system and on an old laptop with an OHCI setup for its USB, and 
refused to work properly on any of several computers in the house which 
ran an AMD cpu on top of a VIA-based motherboard. On those systems, severe 
data loss, data corruption, and actual crashing occurred while downloading 
still photos from the camera. Putting a magnetic core around the cable 
helped a little bit, but the problem did not go away. So, again, an 
example of a poor specimen of hardware hooked by a cheap cable to a cheap 
motherboard, and there was trouble. To this day I have no way to pinpoint 
the exact cause of the problem.

2. I forget which dual-mode camera it was, but it is one of those for 
which I wrote the kernel support. I discovered the problem at the worst 
possible time: after already writing the code and submitting same, and it 
actually went into a production kernel. When I found the problem, it was 
too late to get anything changed until the next release date. What was the 
problem? Well, the camera needs several mysterious initialization commands 
to start the video stream. Some of these were obviously superfluous and 
could be safely left unused. But I left out one too many. I developed the 
driver on an AMD system with ATI USB host controllers. Everything worked, 
and the code was duly submitted. Then, too late, I tested on a 
Pentium4-on-Intel system. There, the video stream would not start, 
or it would start and speedily crash. When I put back into the driver 
that pesky "one too many" omitted init string, the camera worked on an 
Intel setup, too. What exactly does that one command do? I don't 
exactly know. Precisely what caused the problem? I don't know. All I can 
say for sure is that the Intel (UHCI) system needed for a certain setup 
command to be sent to the camera, whereas the ATI (OHCI) system did not. 
And that is, in fact, something very strange. Go figure.

We are working with computers. Weird stuff is not supposed to happen. But 
it does. Occasionally, this needs to be remembered, as it does 
occasionally cause real-world problems and is often the likely explanation 
for what is otherwise inexplicable. Thus, sooner or later some old geezer 
comes along and reminds people that Murphy is still around to do his 
mischief. I am glad that my suggestions turned out to be helpful.

Theodore Kilgore




