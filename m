From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 11:44:31 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>  <1201639331.3069.58.camel@localhost.localdomain>  <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>  <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
  <1202144767.3096.38.camel@localhost.localdomain>  <47A7488B.4080000@vlnb.net>  <1202145901.3096.49.camel@localhost.localdomain>  <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929AbYBDTpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 14:45:05 -0500
In-Reply-To: <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>



On Mon, 4 Feb 2008, Nicholas A. Bellinger wrote:
> 
> While this does not have anything to do directly with the kernel vs. 
> user discussion for target mode storage engine, the scaling and latency 
> case is easy enough to make if we are talking about scaling TCP for 10 
> Gb/sec storage fabrics.

I would like to point out that while I think there is no question that the 
basic data transfer engine would perform better in kernel space, there 
stll *are* questions whether

 - iSCSI is relevant enough for us to even care ...

 - ... and the complexity is actually worth it.

That said, I also tend to believe that trying to split things up between 
kernel and user space is often more complex than just keeping things in 
one place, because the trade-offs of which part goes where wll inevitably 
be wrong in *some* area, and then you're really screwed.

So from a purely personal standpoint, I'd like to say that I'm not really 
interested in iSCSI (and I don't quite know why I've been cc'd on this 
whole discussion) and think that other approaches are potentially *much* 
better. So for example, I personally suspect that ATA-over-ethernet is way 
better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
low-level, and against those crazy SCSI people to begin with.

So take any utterances of mine with a big pinch of salt.

Historically, the only split that has worked pretty well is "connection 
initiation/setup in user space, actual data transfers in kernel space". 

Pure user-space solutions work, but tend to eventually be turned into 
kernel-space if they are simple enough and really do have throughput and 
latency considerations (eg nfsd), and aren't quite complex and crazy 
enough to have a large impedance-matching problem even for basic IO stuff 
(eg samba).

And totally pure kernel solutions work only if there are very stable 
standards and no major authentication or connection setup issues (eg local 
disks).

So just going by what has happened in the past, I'd assume that iSCSI 
would eventually turn into "connecting/authentication in user space" with 
"data transfers in kernel space". But only if it really does end up 
mattering enough. We had a totally user-space NFS daemon for a long time, 
and it was perfectly fine until people really started caring.

			Linus
