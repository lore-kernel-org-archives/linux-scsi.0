From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Thu, 11 Jan 2007 10:26:04 -0500
Message-ID: <45A6570C.3090308@torque.net>
References: <45A6195E.7020103@scanventure.no>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50790 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXAKP0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 10:26:21 -0500
In-Reply-To: <45A6195E.7020103@scanventure.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarjei Huse <tarjei@scanventure.no>
Cc: linux-scsi@vger.kernel.org

Tarjei Huse wrote:
> Hi, I'm working on getting Linux to use my SATA drives on an IBM x306
> running a HostRaid controller that uses the adaptech 9405w chipset.
> 
> I found this thread on the list:
> http://thread.gmane.org/gmane.linux.scsi/29040/focus=29040

Basically Luben Tuikov developed the original aic94xx
SAS driver for Linux when he was working for Adaptec.
Soon after he made it available, the Linux SCSI
community decided to fork the development for various
reasons. The "Linux SCSI community" version seems to
have passed through various hands, currently it seems
to Darrick Wong's headache. In the meantime Mr Tuikov
has continued developing his "version" which I can
report is now very stable and feature rich on my hardware
(an adaptec 48300 HBA with a aic-9410w chip in it).

Some people involved are still quite upset about
what happened and it shows in the email exchange
you referred to. One unfortunate aspect of the GPL
and what the "community" did is that the source
code still has the copyright notices of Adaptec
and Luben Tuikov. That may lead an observer to think
that either or both still have an interest or
control over that driver. As far as I can see that
is not the case and a note should be added to the
source code to that end.

So given the above, Linux distribution vendors have
a problem when they try to "certify" hardware containing
Adaptec SAS aic94xx series chips.

> What I'm wondering about is:
> a) Where can I get the patches that mr Tuikov maintains for this
> chipset?

You need to contact Luben Tuikov < ltuikov@yahoo.com > directly.

 b) Are they maintained wrt to different kernel versions, i.e.
> do they apply cleanly to a 2.6.20 or 2.6.16 kernel?

You need different driver versions for different kernels.

> c) In the thread Darrick Wong refers to another branch[1] that contains 
> (according to him) a lot of fixes for this chipset. Is that branch
> confirmed to work with my chipset?

I haven't checked recently but Adaptec used to have their own
linux driver, named the adp94xx driver. It would seem that
Adaptec has lost interest in Linux.

> My main goal is to get this box up and running using debian or ubuntu. I
> have managed to get it to run the debian 2.6.9 kernel as outlined in [2]
> using the adp94xx driver, but I cannot get that driver to compile on
> newer kernels.

See my previous note.

> I have also tried to compile the latest rc of the 2.6.20 kernel and
> loaded up the aic94xx driver + firmware. I then ended up getting the
> same errors that started the above mentioned thread on this list.

Here are my thoughts on the 48300 HBA and the available drivers.
I bought the device about 12 months ago so I assumed it at least
had production firmware on it. It required two firmware upgrades
before it was stable in POST+scan in non-trivial SAS toplologies
(by which I mean connected to SAS expanders). [Since I also had
a LSI MPT Fusion SAS controller, it was relatively simple for me
to determine the source of my problems.] All drivers I tried
(although I could never get the adp94xx driver working because
it was too old) showed the same problems (tmf timeouts). Then
Luben Tuikov sent me a version of his driver with a "use_msi"
related fix in it. My 48300 has been rock solid since. The last
time I tried "Darrick's" driver (about a week ago) it failed in
the fashion unto which I have become accustomed.

I have encouraged people to talk amongst themselves about the
use_msi patch, but I don't believe that I should be reverse
engineering that patch. There are other issues. As you may
understand from the above, I am walking on a bit of a tight rope
here.

I can also report that the same hardware works fine in
Windows 2000, Vista RC1 and that FreeBSD doesn't have
an aic94xx driver yet.

> So what is the best solution here? Has anyone managed to get a newer
> kernel to run on this chipset?
> 
> 1.
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=summary
> 
> 2. http://www.jimmy.co.at/weblog/?p=71

This last thread may help explain IBM's interest in getting the
aic94xx working reliably.


Is there a best solution?

Doug Gilbert



