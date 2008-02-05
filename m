From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 22:01:21 +0300
Message-ID: <47A8B281.5030701@vlnb.net>
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	<1202151989.11265.576.camel@haakon2.linux-iscsi.org>	<alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>	<20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:56403 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbYBETBY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 14:01:24 -0500
In-Reply-To: <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Linus Torvalds wrote:
>>I'd assumed the move was primarily because of the difficulty of getting
>>correct semantics on a shared filesystem
> 
> 
> .. not even shared. It was hard to get correct semantics full stop. 
> 
> Which is a traditional problem. The thing is, the kernel always has some 
> internal state, and it's hard to expose all the semantics that the kernel 
> knows about to user space.
> 
> So no, performance is not the only reason to move to kernel space. It can 
> easily be things like needing direct access to internal data queues (for a 
> iSCSI target, this could be things like barriers or just tagged commands - 
> yes, you can probably emulate things like that without access to the 
> actual IO queues, but are you sure the semantics will be entirely right?
> 
> The kernel/userland boundary is not just a performance boundary, it's an 
> abstraction boundary too, and these kinds of protocols tend to break 
> abstractions. NFS broke it by having "file handles" (which is not 
> something that really exists in user space, and is almost impossible to 
> emulate correctly), and I bet the same thing happens when emulating a SCSI 
> target in user space.

Yes, there is something like that for SCSI target as well. It's a "local 
initiator" or "local nexus", see 
http://thread.gmane.org/gmane.linux.scsi/31288 and 
http://news.gmane.org/find-root.php?message_id=%3c463F36AC.3010207%40vlnb.net%3e 
for more info about that.

In fact, existence of local nexus is one more point why SCST is better, 
than STGT, because for STGT it's pretty hard to support it (all locally 
generated commands would have to be passed through its daemon, which 
would be a total disaster for performance), while for SCST it can be 
done relatively simply.

Vlad
