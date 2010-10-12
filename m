From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 0/4] tcm: Unify virtual subsystem plugin emulation code
Date: Tue, 12 Oct 2010 23:00:58 +0400
Message-ID: <4CB4B06A.5090809@vlnb.net>
References: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org> <20101010073202.GA16772@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab0JLTBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2010 15:01:32 -0400
In-Reply-To: <20101010073202.GA16772@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>

Christoph Hellwig, on 10/10/2010 11:32 AM wrote:
> What you did in this patch is a good step toward getting rid of the
> scsi logic in the backend, but it's quite enough yet.  For one thing
> the backends really shouldn't know anything about scsi commands, so
> the call to transport_emulate_control_cdb should happen before even
> calling into the backend.  Second your ->emulate_foo callbacks still
> are far too SCSI-specific, e.g. WRITE SAME witht unmap bit and UNMAP
> emulation really should just go into a single ->discard callback
> for the backend.  And instead of calling into the backend again for
> readcap emulation just set block_size and size attributs on a per-
> device object and let common code handle it.  Similarly for inquity
> just set the device type and other variables and handle it in common
> code.  That avoid the special se_subsystem_api_cdb vector and simplifies
> the code a lot conceptually a lot. Together with calling
> transport_emulate_control_cdb directly from core code before going
> into ->do_task that does all the required work to make the backends
> independent of the scsi protocol, so we could also use it e.g.
> for ATA or virtio targets.

I strongly disagree with this approach to allow non-SCSI transports to
use facilities provided by a generic (SCSI) target subsystem. This
approach is bad, because you enforce the SCSI target subsystem to
implement in its interface "the least common denominator" of all
services non-SCSI transports can requests, which leads to:

1. The SCSI target subsystem code overcomplication, so making it much
harder to audit and more buggy.

2. You creates hidden inter-transport dependencies inside of the target
subsystem, so by fixing services for one transport you can break another.

3. By introducing additional processing to hide SCSI internals you hurt
performance, especially for the mainline SCSI case.

Moreover, my experience tells me that fully hiding SCSI internals of the
target subsystem is hardly feasible at all.

There is another, much better approach to allow non-SCSI transports to
use facilities provided by the SCSI target subsystem: leave the generic
target subsystem fully SCSI-centric and create for each non-SCSI
transport a helper library which would allow to translate its requests
to the corresponding SCSI requests and SCSI sense to their error codes.

All non-SCSI transports I know, including ATA, are, basically, subsets
of SCSI facilities, so translation of their requests to the
corresponding SCSI commands would be a straightforward task. For
instance, discard would be translated to SCSI UNMAP.

This approach would bring:

1. Clear, easy auditable target subsystem's code.

2. Clear separation of SCSI and non-SCSI processing among different SCSI
and non-SCSI target drivers.

3. The best performance in all cases.

Vlad



