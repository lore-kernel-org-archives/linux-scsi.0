From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] tcm: Unify virtual subsystem plugin emulation code
Date: Mon, 11 Oct 2010 12:56:51 -0700
Message-ID: <1286827011.20358.35.camel@haakon2.linux-iscsi.org>
References: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org>
	 <20101010073202.GA16772@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ne1.yahoo.com ([98.138.90.70]:45031 "HELO
	nm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756005Ab0JKUDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2010 16:03:08 -0400
In-Reply-To: <20101010073202.GA16772@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>

On Sun, 2010-10-10 at 09:32 +0200, Christoph Hellwig wrote:
> What you did in this patch is a good step toward getting rid of the
> scsi logic in the backend, but it's quite enough yet.  For one thing
> the backends really shouldn't know anything about scsi commands, so
> the call to transport_emulate_control_cdb should happen before even
> calling into the backend.

Hmmm, good point.  I was trying to avoid doing this initially because it
adds more complexity when calling ->do_task() in target_core_transport.c
__transport_execute_tasks(), but I would agree the tradeoff here to make
IBLOCK, FILEIO and RAMDISK subsystem backend code SCSI control CDB
emulation independent is worth it.

> Second your ->emulate_foo callbacks still
> are far too SCSI-specific, e.g. WRITE SAME witht unmap bit and UNMAP
> emulation really should just go into a single ->discard callback
> for the backend.  And instead of calling into the backend again for
> readcap emulation just set block_size and size attributs on a per-
> device object and let common code handle it.  Similarly for inquity
> just set the device type and other variables and handle it in common
> code.

Ok, I think this makes sense and should be easy enough for the cases
that have been listed here.  However, there are still cases (namely DIF)
that containing SCSI specific bits and would still be going into IBLOCK
and FILEIO.

> That avoid the special se_subsystem_api_cdb vector and simplifies
> the code a lot conceptually a lot.  Together with calling
> transport_emulate_control_cdb directly from core code before going
> into ->do_task that does all the required work to make the backends
> independent of the scsi protocol, so we could also use it e.g.
> for ATA or virtio targets.

Makes sense, I will drop struct se_subsystem_api_cdb, et al and post a
followup patch series this afternoon.

Thanks!

--nab

