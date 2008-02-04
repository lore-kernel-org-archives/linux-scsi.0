From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 16:01:21 -0500
Message-ID: <20080204210121.GF18682@fieldses.org>
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain> <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755306AbYBDVBv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 04, 2008 at 11:44:31AM -0800, Linus Torvalds wrote:
...
> Pure user-space solutions work, but tend to eventually be turned into 
> kernel-space if they are simple enough and really do have throughput and 
> latency considerations (eg nfsd), and aren't quite complex and crazy 
> enough to have a large impedance-matching problem even for basic IO stuff 
> (eg samba).
...
> So just going by what has happened in the past, I'd assume that iSCSI 
> would eventually turn into "connecting/authentication in user space" with 
> "data transfers in kernel space". But only if it really does end up 
> mattering enough. We had a totally user-space NFS daemon for a long time, 
> and it was perfectly fine until people really started caring.

I'd assumed the move was primarily because of the difficulty of getting
correct semantics on a shared filesystem--if you're content with
NFS-only access to your filesystem, then you can probably do everything
in userspace, but once you start worrying about getting stable
filehandles, consistent file locking, etc., from a real disk filesystem
with local users, then you require much closer cooperation from the
kernel.

And I seem to recall being told that sort of thing was the motivation
more than performance, but I wasn't there (and I haven't seen
performance comparisons).

--b.
