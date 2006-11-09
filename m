From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 09 Nov 2006 09:52:57 +0900
Message-ID: <20061109095257I.fujita.tomonori@lab.ntt.co.jp>
References: <454FAD72.6040103@torque.net>
	<200611081048.01531.jli@greshamstorage.com>
	<20061108172218.GG16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:31141 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1422874AbWKIAyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Nov 2006 19:54:00 -0500
In-Reply-To: <20061108172218.GG16952@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: jli@greshamstorage.com, dougg@torque.net, linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Wed, 8 Nov 2006 10:22:18 -0700

> On Wed, Nov 08, 2006 at 10:48:01AM -0600, Jeremy Linton wrote:
> > 	A unified multiple device mmap buffer interface for would probably be useful 
> > as well. This is to get around the problems inherent in the current design 
> > that keep more than one device from using a mmap/reserve buffer allocated for 
> > another device. 
> > 	What I would personally like to be able to do with the SG interface is have a 
> > shared memory region where I can kick off a few dozen tagged commands to a 
> > device, get notification when they have completed and then send a similar 
> > command to a second device, all without involving the CPU in any copy 
> > operations, or too many page management operations.
> > 	In my dream world this would require some kind of tagging of commands as well 
> > so I don't have to handle a bunch of async completions for commands in a 
> > group that need to complete as a group.
> 
> This is all starting to sound/feel a lot like the current proposed
> design for netchannels: http://lwn.net/Articles/206699/
> 
> If we did an AF_SCSI (I've seen it mooted before), then I suppose we
> could just use netchannels.
> 
> The other route is tweaking the current netchannels proposal to be a bit
> less networking-centric and use kiocbs (or something ...) to hold the
> data that's being transmitted.

netchannels works if we can make it less networking-centric, though
ring buffer would be preferable for the target code since netchannels
needs to allocate and free skbuffs and do copies again and again.
