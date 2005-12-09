From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Thu, 08 Dec 2005 21:57:22 -0600
Message-ID: <439900A2.4040009@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net> <1134071268.3259.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38632 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751261AbVLID5r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 22:57:47 -0500
In-Reply-To: <1134071268.3259.29.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

James Bottomley wrote:
> 
> Additionally, it's perfectly possible for all of this to be done zero
> copy on the data.  A user space target mmaps the data on its storage
> device and then does a SG_IO type scatter gather user virtual region
> pass to the underlying target infrastructure.  We already have this
> demonstrated in the SG_IO path, someone just needs to come up with the
> correct implementation for a target path.
> 

I guess I am going to try to do some work in userspace so we can 
benchmark things and see how much performance drops.

For your suggestion, are you referring to the sg.c mmap path? I was 
thinking that maybe we could modify dm so it can do mmap like sg.c does. 
The dm device would be the target device and would sit above the real 
device or another MD/DM/Loop/ramdsik device or whatever so when 
userspace decides to execute the command it would inform the dm device 
and that kernel driver would just then send down the bios.

For something like qlogic or mpt would this basically work like the 
following:

1. dm mmap is called and our dm_target (dm drivers like dm-multipath or 
dm-raid are called dm_targets) does like sg.c sg_mmap* and sg_vma* ops.
2. HW interrupt comes in and we allocate a scatterlist with pages from #1.
3. netlink (or whatever is the favorite interface) a message to 
userpsace to tell it we have a command ready.
4. userspace decides if it is a read or write and if it is a read or 
write then userspace tells the dm device to read/write some pages.
5. dm's bi_endio is called when io is finished so we netlink to 
userspace and then userspaces netlinks back to the kernel and tells the 
LLD like qlogic that some data and/or a responce or sense is ready for 
it to transfer.
