From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 08 Nov 2010 13:10:36 -0800
Message-ID: <1289250636.27226.50.camel@haakon2.linux-iscsi.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
	 <20101108143307.GA22121@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60503 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0KHVPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 16:15:49 -0500
In-Reply-To: <20101108143307.GA22121@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2010-11-08 at 09:33 -0500, Christoph Hellwig wrote:
> Hi Nick,
> 
> I promised you and James to get back to a throughout review for more
> than just the backends.  It's still in progress, but here is what I
> think is most important:
> 
>  - Sort of the the namepspace for both the file names and function
>    names.  I think you reluctantly agreed to do that a while ago anyway,
>    but I think it's time to bite the bullet now.  Please agree on a
>    common prefix for both function names and modules.  I think the
>    target name in the directory structure is the best one, but I really
>    don't care too much.  The transport_ prefix used in some code is
>    really misleading, and the se_ in other isn't too helpful either.

Fair enough.  So for the sake on continuity I am happy to rename
functions that are available externally to frontends with a target_*()
prefix and primary data structures to a tcm_* prefix.  

>  - make sure backends, frontends and core/ code under drivers/target/
>    are properly separated

So at this point only the backend code still lives in drivers/target,
while everything related to frontends resides in
drivers/target/$TCM_MODNAME.  Now moving IBLOCK, FILEIO, PSCSI and
RAMDISK .c and .h files into drivers/target/backend/ to resolve this
item..

>  - clean up the exported - both as in EXPORT_SYMBOL and simply global
>    functions.  There's a lot of things that should be static or not
>    exported to modules but is right now.  The scripts/namespace.pl
>    script in the kernel tree is a great helper for that.

<nod>  I will follow up with an audit of this code, most of which is
coming from target_core_transport.c

>  - Similarly the headers could use some re-arrangement.  I've been
>    trying to make sense of what each header does but couldn't find it.
>    In the optimal world you'd have one header for the front-end API,
>    one of the back-end API and one or more for common structures
>    and defintions.  All with a comment explaining what they are there
>    for.
> 

Yes, the documentation that I have been promising will help clear this
up.  target_core_transport.h contains the struct se_subsystem_api that
is used for backend code, and target_core_fabric_ops.h contains the
struct target_core_fabric_ops used by frontend drivers.  There is still
a handful of other includes required for frontend drivers, but I did
spend time on this recently to clean up what is made available in
include/target.  

--nab

