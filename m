From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 12:24:59 -0800
Message-ID: <1202156699.11265.615.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:29988 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758669AbYBDUZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:25:27 -0500
In-Reply-To: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

On Mon, 2008-02-04 at 11:44 -0800, Linus Torvalds wrote:
> 
> On Mon, 4 Feb 2008, Nicholas A. Bellinger wrote:
> > 
> > While this does not have anything to do directly with the kernel vs. 
> > user discussion for target mode storage engine, the scaling and latency 
> > case is easy enough to make if we are talking about scaling TCP for 10 
> > Gb/sec storage fabrics.
> 
> I would like to point out that while I think there is no question that the 
> basic data transfer engine would perform better in kernel space, there 
> stll *are* questions whether
> 
>  - iSCSI is relevant enough for us to even care ...
> 
>  - ... and the complexity is actually worth it.
> 
> That said, I also tend to believe that trying to split things up between 
> kernel and user space is often more complex than just keeping things in 
> one place, because the trade-offs of which part goes where wll inevitably 
> be wrong in *some* area, and then you're really screwed.
> 
> So from a purely personal standpoint, I'd like to say that I'm not really 
> interested in iSCSI (and I don't quite know why I've been cc'd on this 
> whole discussion)

The generic target mode storage engine discussion quickly goes to
transport specific scenarios.  With so much interest in the SCSI
transports, in particuarly iSCSI, there are lots of devs, users, and
vendors who would like to see Linux improve in this respect.

>  and think that other approaches are potentially *much* 
> better. So for example, I personally suspect that ATA-over-ethernet is way 
> better than some crazy SCSI-over-TCP crap,

Having the non SCSI target mode transports use the same data IO path as
the SCSI ones to SCSI, BIO, and FILE subsystems is something that can
easily be agreed on.  Also having to emulate the non SCSI control paths
in a non generic matter to a target mode engine has to suck (I don't
know what AoE does for that now, considering that this is going down to
libata or real SCSI hardware in some cases.  There are some of the more
arcane task management functionality in SCSI (ACA anyone?) that even
generic SCSI target mode engines do not use, and only seem to make
endlessly complex implement and emulate.

But aside from those very SCSI hardware specific cases, having a generic
method to use something like ABORT_TASK or LUN_RESET for a target mode
engine (along with the data path to all of the subsystems) would be
beneficial for any fabric.

> but I'm biased for simple and 
> low-level, and against those crazy SCSI people to begin with.

Well, having no obvious preconception (well, aside from the email
address), I am of the mindset than the iSCSI people are the LEAST crazy
said crazy SCSI people.  Some people (usually least crazy iSCSI
standards folks) say that FCoE people are crazy.  Being one of the iSCSI
people I am kinda obligated to agree, but the technical points are
really solid, and have been so for over a decade.  They are listed here
for those who are interested:

http://www.ietf.org/mail-archive/web/ips/current/msg02325.html

> 
> So take any utterances of mine with a big pinch of salt.
> 
> Historically, the only split that has worked pretty well is "connection 
> initiation/setup in user space, actual data transfers in kernel space". 
> 
> Pure user-space solutions work, but tend to eventually be turned into 
> kernel-space if they are simple enough and really do have throughput and 
> latency considerations (eg nfsd), and aren't quite complex and crazy 
> enough to have a large impedance-matching problem even for basic IO stuff 
> (eg samba).
> 
> And totally pure kernel solutions work only if there are very stable 
> standards and no major authentication or connection setup issues (eg local 
> disks).
> 
> So just going by what has happened in the past, I'd assume that iSCSI 
> would eventually turn into "connecting/authentication in user space" with 
> "data transfers in kernel space". But only if it really does end up 
> mattering enough. We had a totally user-space NFS daemon for a long time, 
> and it was perfectly fine until people really started caring.

Thanks for putting this into an historical perspective.  Also it is
interesting to note that the iSCSI spec (RFC-3720) was ratified in April
2004, so it will be going on 4 years soon, which pre-RFC products first
going out in 2001 (yikes!).  In my experience, the iSCSI interopt
amongst implementations (espically between different OSes) has been
stable since about late 2004, early 2005, with interopt between OS SCSI
subsystems (espically talking to non SCSI hardware) being the slower of
the two.

--nab


