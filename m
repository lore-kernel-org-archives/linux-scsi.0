From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Mon, 25 Jul 2011 17:32:56 -0700
Message-ID: <1311640376.17766.221.camel@haakon2.linux-iscsi.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	 <20110725163739.5c19b04d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36254 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZAmR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2011 20:42:17 -0400
In-Reply-To: <20110725163739.5c19b04d.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>Andy Grover <agrover@redhat.com>

On Mon, 2011-07-25 at 16:37 -0700, Andrew Morton wrote:
> On Sat, 23 Jul 2011 16:16:15 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Please go ahead and pull from:
> > 
> >   master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge
> 
> i386 allyesconfig:
> 
> ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!
> 
> somewhere in drivers/target/target_core_transport.c:transport_allocate_data_tasks().

Mmmm, I was under the assumption that DIV_ROUND_UP() did unsigned long
long division correctly for sector_t on 32-bit , but apparently not with
the new v4.1 transport_allocate_data_tasks() code..   Andy..?  

Once upon a time we used the following __udivdi3() and __umoddi3()
wrappers around do_div() to handle this instruction in target_core_mod
for 32-bit, but we ended up removing these during the .38 merge in favor
of IIRC direct do_div() usage.  These wrappers are still in use for LIO
backports on 32-bit x86 and arm however..

So I'll go ahead and make sure this works on i386 with lio-core-2.6.git
shortly, and double check __udivdi3() usage with iscsi-target in
for-next.  Andrew and Christoph, did have any input on a preffered
method of handling this case in the new v4.1 DIV_ROUND_UP() usage..?

Thank you!

--nab


