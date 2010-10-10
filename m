From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4] tcm: Unify virtual subsystem plugin emulation code
Date: Sun, 10 Oct 2010 09:32:02 +0200
Message-ID: <20101010073202.GA16772@lst.de>
References: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60016 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0JJHc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2010 03:32:27 -0400
Content-Disposition: inline
In-Reply-To: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>

What you did in this patch is a good step toward getting rid of the
scsi logic in the backend, but it's quite enough yet.  For one thing
the backends really shouldn't know anything about scsi commands, so
the call to transport_emulate_control_cdb should happen before even
calling into the backend.  Second your ->emulate_foo callbacks still
are far too SCSI-specific, e.g. WRITE SAME witht unmap bit and UNMAP
emulation really should just go into a single ->discard callback
for the backend.  And instead of calling into the backend again for
readcap emulation just set block_size and size attributs on a per-
device object and let common code handle it.  Similarly for inquity
just set the device type and other variables and handle it in common
code.  That avoid the special se_subsystem_api_cdb vector and simplifies
the code a lot conceptually a lot.  Together with calling
transport_emulate_control_cdb directly from core code before going
into ->do_task that does all the required work to make the backends
independent of the scsi protocol, so we could also use it e.g.
for ATA or virtio targets.

