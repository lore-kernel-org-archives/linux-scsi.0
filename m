From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/42 RESEND+NEW] Target updates for May 27
Date: Mon, 30 May 2011 08:56:04 -0400
Message-ID: <20110530125604.GA15449@infradead.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
 <1306534540.23461.203.camel@haakon2.linux-iscsi.org>
 <20110527223538.GA26592@infradead.org>
 <1306539563.23461.229.camel@haakon2.linux-iscsi.org>
 <20110528074333.GA22382@infradead.org>
 <4DE1AE2F.70705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46824
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756587Ab1E3M4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2011 08:56:34 -0400
Content-Disposition: inline
In-Reply-To: <4DE1AE2F.70705@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Sat, May 28, 2011 at 07:23:43PM -0700, Andy Grover wrote:
> I guess this is my fault for not CCing linux-scsi. I'm working on tcm
> cleanups and have been sending them to linux-iscsi-target-dev, because
> there are a lot of them. Aren't you guys on that list too?

I'm not on it.  In fact I didn't really know about it until known.

I'll take all my complains back in that case, my fault for not beeing
on the proper list.

> In any case, here's my git tree for review hch, I've been developing
> against nab's lio-41, under the perhaps mistaken assumption that it all
> would go in and then patched up to snuff:
> 
> git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab

Looks pretty good, and removes a few items from my todo list.

Some comments on the patches:

"target: get_cdb should never return NULL":

	looks good by itself, but I think the real fix here is to not
	leave the CDB allocation to the I/O backend, but just include
	it in the se_task.  Or maybe even in the se_cmd once that
	whole CDB splitting mess is moved into pscsi, which will
	simplify the common code further,

"target: inline struct se_transport_task into struct se_task"

	The description is wrong, it's moved into the se_cmd, which
	is the correct thing to do anyway.

"target: Rename transport_generic_handle_cdb to _new_cmd"

	About the naming:  For now it's transport_generic for exported
	APIs I think.  IMHO it's a pretty bad choice and should be
	replaced by target_, but let's do that in one big sweep.

"target: Have iscsi fabric allocate its own buffers"

	ceil seems to be a reimplementation of DIV_ROUND_UP from
	kernel.h

"target/iscsi: Do not use t_mem_list anymore"

	Very nice cleanup!

"target: Call transport_new_cmd instead of adding to cmd queue"

	Did you test all other frontends that they are fine with this
	change?
	Also the code really needs to handle errors from transport_new_cmd.

	The comment above transport_generic_new_cmd needs an update,
	or even better the wrapper should be killed and callers should
	use transport_new_cmd directly.
	The TRANSPORT_NEW_CMD enum value and code switch case in
	transport_processing_thread cab be removed now.

	Btw, it seems like transport_processing_thread and the various
	helpers to queue up work to it could be nicely cleaned up
	by using a workqueue with a work item embedded into the
	se_cmd.  That way this work could a) be made to scale to
	multiple CPUs, and b) we could kill new_cmd_map by just
	allowing the frontend to setup their own work queue handlers
	instead of going through this abstraction.

"target/file: Alloc iov[] off the stack"

	We can get pretty large iovecs, and blindly allocation them on
	the stack seems like a bad idea.  It might make sense to do
	so for the fast path, which means we'd need a __fd_do_readv
	that gets the vector passed, and then a smart wrapper using
	the stack for small vectors, and some technic making sure
	gcc doesn't bloat the stack otherwise.
