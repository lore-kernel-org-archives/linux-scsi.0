From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Mon, 25 Jul 2011 16:50:57 -0700
Message-ID: <20110725165057.9701f16b.akpm@linux-foundation.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	<20110725163739.5c19b04d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1GYXvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 19:51:41 -0400
In-Reply-To: <20110725163739.5c19b04d.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>L

On Mon, 25 Jul 2011 16:37:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

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

Probably the best place to fix this is within DIV_ROUND_UP(): make it
handle 64-bits on 32-bit.

This will have the pleasing side-effect of breaking
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c, which felt a need to duplicate the
existing DIV_ROUND_UP() implementation.

