From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 09 Nov 2006 09:44:18 +0900
Message-ID: <20061109094418X.fujita.tomonori@lab.ntt.co.jp>
References: <454FAD72.6040103@torque.net>
	<200611081048.01531.jli@greshamstorage.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:16283 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965942AbWKIAo6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Nov 2006 19:44:58 -0500
In-Reply-To: <200611081048.01531.jli@greshamstorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jli@greshamstorage.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Wed, 8 Nov 2006 10:48:01 -0600

> 
> 
> 
> On Monday 06 November 2006 15:47, Douglas Gilbert wrote:
> > I was asked to put together a proposal in May this
> > year for a new SCSI Generic interface structure. This
> 
> > Feel free to make suggestions.
> 	OK...
> 
> 	A unified multiple device mmap buffer interface for would probably be useful 
> as well. This is to get around the problems inherent in the current design 
> that keep more than one device from using a mmap/reserve buffer allocated for 
> another device. 
> 	What I would personally like to be able to do with the SG interface is have a 
> shared memory region where I can kick off a few dozen tagged commands to a 
> device, get notification when they have completed and then send a similar 
> command to a second device, all without involving the CPU in any copy 
> operations, or too many page management operations.
> 	In my dream world this would require some kind of tagging of commands as well 
> so I don't have to handle a bunch of async completions for commands in a 
> group that need to complete as a group.

Sounds like it's quite similar to what the target code (tgt) is doing
with its own ring buffer interface.

As discussed months ago, tgt has a lot in common with sg. We would
like to have the new sg flexible enough to handle various messages
that tgt needs. This will also require lots of changes to the block
layer functions to map user-space pages.
