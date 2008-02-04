From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 13:24:53 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain>
 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196AbYBDVZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 16:25:59 -0500
In-Reply-To: <20080204210121.GF18682@fieldses.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>



On Mon, 4 Feb 2008, J. Bruce Fields wrote:
> 
> I'd assumed the move was primarily because of the difficulty of getting
> correct semantics on a shared filesystem

.. not even shared. It was hard to get correct semantics full stop. 

Which is a traditional problem. The thing is, the kernel always has some 
internal state, and it's hard to expose all the semantics that the kernel 
knows about to user space.

So no, performance is not the only reason to move to kernel space. It can 
easily be things like needing direct access to internal data queues (for a 
iSCSI target, this could be things like barriers or just tagged commands - 
yes, you can probably emulate things like that without access to the 
actual IO queues, but are you sure the semantics will be entirely right?

The kernel/userland boundary is not just a performance boundary, it's an 
abstraction boundary too, and these kinds of protocols tend to break 
abstractions. NFS broke it by having "file handles" (which is not 
something that really exists in user space, and is almost impossible to 
emulate correctly), and I bet the same thing happens when emulating a SCSI 
target in user space.

Maybe not. I _rally_ haven't looked into iSCSI, I'm just guessing there 
would be things like ordering issues.

		Linus
