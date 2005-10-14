From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Adaptec SAS integration notes
Date: Fri, 14 Oct 2005 11:06:15 -0700 (PDT)
Message-ID: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com>
References: <20051012184029.GA10786@havoc.gtf.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1015483234-1129313175=:5407"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:14230 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750801AbVJNSGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 14:06:16 -0400
In-Reply-To: <20051012184029.GA10786@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org
Cc: Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org

--0-1015483234-1129313175=:5407
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- Jeff Garzik <jgarzik@pobox.com> wrote:

> Problems (with both Adaptec SAS and existing kernel)

Jeff, you've got to be _specific_ in your specifying to _which_ group
those problems pertain to.  Saying "both Adaptec SAS and existing kernel"
is very vague.

I'll try to stay on technical matter, being _specific_ as well as
cutting and pasting code and function declarations where appropriate.

I'll be able to be even more specific when I come back.

> * Adaptec SAS abuses Scsi_Host_Template.  The host template is a set of
> ops for various layers, and it is fine as an interface.  No need to
> avoid it.

Neither the Host Adapter, nor the FW, implements anything which has
to do with the scsi host template.  What the Host Adapter (the hardware) and
the FW implement is access to the transport -- that' all.

So in effect the LLDD is _access to the (SAS) transport_. Cf. the USB Storage
code and SBP code.

Putting the host template back into the LLDD is a step _backwards_, i.e.
it's just a workaround, not a step forward.

The _reason_ the host template exists is that 10 years ago, there was
_only_ Parallel SCSI around and there was simply no need for layer
abstraction, so the host template was declared in the Parallel SCSI LLDD.

That is, SPI LLDDs from 10 years ago until now, implemented _both_
the layer _and_ the transport interface.  This (wrong) assumption has
been shattered with USB/SBP/SAS.

> * Way too much glue between scsi_host and the rest of SAS.
> sas_scsi_host.c is just the beginning.

sas_scsi_host.c is only 996 lines comments, GPL blurb and all.  And what
it implements is _essential_ -- there is no bloat.

sas_scsi_host.c has been attached at the end of this message for everyone
to see.
 
> * struct domain_device ultimately means "an RPC message destination",

Depends on your technial background.

What it actually means, as the name _also_ suggest is a device on
the domain, which is transport addressible.  See SAM chapter 4 and 5.

> and I'm not convinced it is a useful abstraction.  Further, if people
> choose to introduce this abstraction, the implementation of such should
> be far more widespread.

You must've seen latest emails between me and James B on linux-scsi
mailing list.  We both seem to agree (James correct me if I'm wrong)
that a struct scsi_domain_device { ... }; would be the proper
way to go next.  It doesn't exist yet, but it would be really easy to
create it.  It would also eliminate HCIL at the _core_.

SAM tells you what goes in struct scsi_domain_device { ... };.

Will the community be accepting patches?

> * Adaptec SAS could certainly integrate a bit with scsi_transport_sas...
> not sure if full integration will work:
> 
> * scsi_transport_sas's sas_rphy_add() digs a bit too deep into
> discovery.  I would prefer that libsas call scsi_scan_target() as it
> makes connections.

This concept was all taken from FC and "implanted" into "scsi_transport_sas".
And it is wrong.  For proper implmentation see the SAS code:
http://linux.adaptec.com/sas/

You cannot care about "remote" ports -- some types of device have _no_
port layer, as well you only care about the port "half" on your end.
SAS is quite clear on that.

> * Given how low-level SAS wide ports are, it really feels like we should
> be dealing with things at the SAS port level, not SAS phy level.

I see this is not directed at the SAS code, but at the "SAS transport
attributes" code not written by me.

http://linux.adaptec.com/sas/ clearly shows you the proper
abstraction.  E.g. see line 524 of sas_discover.c:

 res = task->dev->port->ha->lldd_execute_task(task, 1, GFP_KERNEL);

A task "belongs" to a device,
  A device is addressible from a port,
    A port "belongs"/was formed to/at a Host Adapter,
      A host adapter implmements SAM's Execute Command SCSI RPC to provide
      access to the transport.

> * Thought should be given to HBAs as RPC targets, since they have WWNs etc.

It is an interesting concept, except you should ask yourself what _services_
will they provide: SMP/SSP/STP?  Initiator/target, etc.

Before we start messing with what you suggest above, SCSI Core has a
_long_ way to go.

(BTW, we're already doing this.)

> * very poor SATA interface

Hmm, no sorry, I'm not going to accept the BS FUD, generalized
comment.

SATA interface is just STP.  There is one thing I'd like to remove/improve
from the ata task struct as shown in the SAS code, but other than that
this is how you access STP targets.

Look, I've even included comments on how to integrate the code with
a SATL (which libata is _not_, but it does implement some SATL tasks).

I know that you're pushing for libata-scsi to become SATL, but this
is hard when your devices belong to a port in an _array_.

What you need is this: any entity from anywhere in the kernel
can fill out a struct and _register_ it with SATL for SATL to do
translation and bookkeeping -- all this at the _device_ level, not
port level as in libata, since ports may not be HW accessible or
of the same transport.

In effect, SATL would export only 2 functions: satl_register_device(),
and satl_unregister_device().  The rest of the stubs are filled out
at registration time (satl_register_device()) inside the struct
being passed to SATL.  Similarly to how it is done with the SAS code:
it exports only 2 functions: sas_register_ha() and sas_unregister_ha().
All the funcitionality is filled in by the LLDD and the SAS layer at
registration time.

> * not sure if SMP really needs a full blown block driver abstraction.
> Christoph did some experiments and wasn't terribly pleased with what he
> saw.  I can see his point.

Apparently this applies to his code not mine.

This link show how to use SMP:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509318354&w=2
(this is also xlinked from the Adaptec SAS page)

SMP is NOT block device and will NEVER BE.

It is simply a _management_ protocol at a _transport_ level.  SCSI Core
should NOT know or be aware of it.  Reasons: expanders! (what are they?)

The readers of this thread can follow how user space interfaces with
SMP targets starting at sas_expander.c, line 1758, smp_portal_write()
and smp_portal_read() -- the functions are pretty small and easy
to read and follow.  There is information in drivers/scsi/sas/README
and in the link above (from the Announcements texts to linux-kernel
and linux-scsi).

> * duplicates HCIL mapping code

True.  I've been meaning to remove that somehow, but calling
scsi_scan_target() and passing HCIL to _it_ is also ugly.
Ideally I'd like to see struct scsi_domain_device { ... }; in place.
My comments in sas_discover.c and sas_scsi_host.c are pretty clear on that.

> * existing LUN scan should be fine, with maybe a few tiny tweaks
> 
> * Consider the problem of SAS vs. SATA, and both Adaptec SAS and libata
> fighting over who's host struct to use.

Yeah, I agree with you: the political BS is just overflowing and hitting
the fan all the time.

How about a drivers/scsi/satl/satl.c which Doug can start writing
and then we can contribute?

If there is proper SATL implemented, then you _do not_ need this
"fighting over a whose host struct to use", because:

1. host struct is higher abstraction,
2. Transport could be _different_ for the SATA device: this means that
   error handling could be different.

Will the community be accepting patches?

> Nice stuff (with both Adaptec SAS and existing kernel)
> ----------
> * Overall, the Adaptec SAS code is pretty clean and easy to read

Thank you!
 
> * Having ->lldd_execute_task() and similar hooks match closely with
> the hardware behavior, so those are nice.

The hardware was designed and implmented with SAS spec in mind, which
in turn mirrors SAM.  Many reasons but most notably, it is just easier
to go this way as opposed to having the HW do it one way and then needing
a translation to SAM behaviour.

You will notice that all SAS solutions on the market go this way: it's
just easier.

> * Adaptec SAS transport is cleanly separated from the rest of things

Yes, it is.  It is a Transport _Layer_ sitting between the (SAS) Transport
interface to the interconnect and SCSI Core (SAM to be).  Designing it
this way was the whole point.

Thank you for the nice words. 
 
> * SCSI core already pretty much equates to SAM, even if there is plenty
> of HCIL dependency in various places (HCIL should get marginalized,
> as all agree)

At a concept level yes, at implementation level absolutely no.

A true SAM layer would be *much* _smaller_ and would have a more
straightforward path for tasks. (as does the SAS layer)

> Solutions
> ---------
> * Similar to libata drivers, scsi-host-template should be in the LLDD,
> even if it is filled with mostly generic helper calls.

Again, see SBP and USB storage code (as well as the SAS code): this would be
a step backwards not forwards.  A true SAS LLLD has nothing to do with
the scsi host template.  This abstraction happens at the (SAS/SBP/USB Storage)
level layer.
 
> * I would tend to prefer calling scsi_scan_target() from SAS discovery
> code, rather than sas_rhy_add()

This is apparently not my code.

The SAS transport _layer_ does complete domain discovery as stipulated in
SAS 1.1.  (2.0 is out -- I'll be updating things when I come back).

> * Using scsi_scan_target() would allow us to use the normal LUN scan

Again not my code.  Normal LUN "scan" is done through REPORT LUNS
as shown in sas_discover.c as I posted both functions to this list
in a recent email.
 
> * Avoid writing a separate SMP driver for now, and see how things
> shake out with future SAS+SATA hardware.

No such intentions.  SMP should not be in a separate driver.
For SMP you need _addressing_ and the solution to this problem
has been showin in driver/scsi/sas/README and in the announcement
emails to linux-kernel and linux-scsi here:
http://linux.adaptec.com/sas/
 
> * Put HCIL mapping into top-level helper code, for sharing between FC
> and SAS (hopefully!)

One step further: eliminate the ugly legacy SPI-centric HCIL from
SCSI Core.  Minimise and streamline SCSI Core.

> * use existing struct scsi_lun where feasible
> 
> * LONG TERM: I wouldn't mind a small "scsi_rpc" helper lib
> which provided execute_task() hook and other task mgmt functions.
> Authors could choose to use that interface -- sitting just underneath
> Scsi_Host_Template -- if their hardware closely matches the pure SAM
> TMF model.  If hardware doesn't closely match, using this interface
> will simply lead to a lot of glue/simulation code.  This gets the
> hardware a bit closer to scsi_execute_req() etc.

You don't see the _big_ picture: you need a _layer_, not "helper libs".
This is what Object Oriented Deisign is all about.  SAM is object
oriented, as is SAS as is iSCSI as is SBP, etc.

"Helper libs" makes the code ugly and spaghetti like.

A transport LLDD implments access to the _transport_: take USB, SBP and SAS --
they all do it.  They need a management transport layer as showin in
those implementations.

I know that this is how libata works: "helper libs" but you have to think
on a larger scale:

libata is two layers: SATL and HW interface -- given ata_port and how
devices are array elemets in ata_port, I'd say let Doug write
drivers/scsi/satl/satl.c (if he accepts) and let libata become
smaller, using SATL at a _device_ level, not port level.

This would make it possible for any entity to register a device
with SATL for SAT translation.  Plus such layers export only 2 functions
and the rest are in the stubs of the structures as showin in the SAS
Transport layer code.

Look at the big picture and how the layers interact with each other.
You need an _overall_ picture.

    Luben
-- 
http://linux.adaptec.com/sas/
Opinion expressed are my own, not my empoyer's or otherwise.
For inquiries write to ltuikov@yahoo.com.

--0-1015483234-1129313175=:5407
Content-Type: text/x-csrc; name="sas_scsi_host.c"
Content-Description: 4006696493-sas_scsi_host.c
Content-Disposition: inline; filename="sas_scsi_host.c"

/*
 * Serial Attached SCSI (SAS) class SCSI Host glue.
 *
 * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
 * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 *
 * This file is licensed under GPLv2.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 *
 * $Id: //depot/sas-class/sas_scsi_host.c#60 $
 */

#include "sas_internal.h"
#include <scsi/sas/sas_discover.h>
#include <scsi/sas/sas_task.h>

#include <scsi/scsi_host.h>
#include <scsi/scsi_device.h>
#include <scsi/scsi_tcq.h>
#include <scsi/scsi.h>

#include <linux/err.h>
#include <linux/blkdev.h>
#include <linux/kobject.h>
#include <linux/scatterlist.h>

/* The SAM LUN structure should be _completely_ opaque to SCSI Core.
 * This is why this macro here, and not using the broken
 * scsilun_to_int().  Ideally, a SCSI LUN should be communicated in
 * its entirety, and not as an integer.  For some unknown to myself
 * reason, SCSI Core thinks that SCSI LUNs can be interpreted as
 * integers.
 */
#define SCSI_LUN(_sam_lun)   ((unsigned int)be32_to_cpu(*(__be32 *)_sam_lun))

/* ---------- SCSI Core device registration ---------- */

int  sas_register_with_scsi(struct LU *lu)
{
	int err;

	lu->map.channel = lu->parent->port->id;
	lu->map.id      = sas_reserve_free_id(lu->parent->port);
	if (lu->map.id == -ENOMEM)
		return -ENOMEM;

	err = scsi_add_device(lu->parent->port->ha->core.shost,
			      lu->map.channel, lu->map.id,
			      SCSI_LUN(lu->LUN));
	return err;
}

void sas_unregister_with_scsi(struct LU *lu)
{
	if (lu->uldd_dev) {
		struct scsi_device *scsi_dev = lu->uldd_dev;
		scsi_remove_device(scsi_dev);
	}
}

/* ---------- SCSI Host glue ---------- */

#define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
#define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *) _t; } while (0)

static void sas_scsi_task_done(struct sas_task *task)
{
	struct task_status_struct *ts = &task->task_status;
	struct scsi_cmnd *sc = task->uldd_task;
	unsigned ts_flags = task->task_state_flags;
	int hs = 0, stat = 0;

	if (unlikely(!sc)) {
		SAS_DPRINTK("task_done called with non existing SCSI cmnd!\n");
		list_del_init(&task->list);
		sas_free_task(task);
		return;
	}

	if (ts->resp == SAS_TASK_UNDELIVERED) {
		/* transport error */
		hs = DID_NO_CONNECT;
	} else { /* ts->resp == SAS_TASK_COMPLETE */
		/* task delivered, what happened afterwards? */
		switch (ts->stat) {
		case SAS_DEV_NO_RESPONSE:
		case SAS_INTERRUPTED:
		case SAS_PHY_DOWN:
		case SAS_NAK_R_ERR:
		case SAS_OPEN_TO:
			hs = DID_NO_CONNECT;
			break;
		case SAS_DATA_UNDERRUN:
			sc->resid = ts->residual;
			if (sc->request_bufflen - sc->resid < sc->underflow)
				hs = DID_ERROR;
			break;
		case SAS_DATA_OVERRUN:
			hs = DID_ERROR;
			break;
		case SAS_QUEUE_FULL:
			hs = DID_SOFT_ERROR; /* retry */
			break;
		case SAS_DEVICE_UNKNOWN:
			hs = DID_BAD_TARGET;
			break;
		case SAS_SG_ERR:
			hs = DID_PARITY;
			break;
		case SAS_OPEN_REJECT:
			if (ts->open_rej_reason == SAS_OREJ_RSVD_RETRY)
				hs = DID_SOFT_ERROR; /* retry */
			else
				hs = DID_ERROR;
			break;
		case SAS_PROTO_RESPONSE:
			SAS_DPRINTK("LLDD:%s sent SAS_PROTO_RESP for an SSP "
				    "task; please report this\n",
				    task->dev->port->ha->sas_ha_name);
			break;
		case SAS_ABORTED_TASK:
			hs = DID_ABORT;
			break;
		case SAM_CHECK_COND:
			memcpy(sc->sense_buffer, ts->buf,
			       max(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
			stat = SAM_CHECK_COND;
			break;
		default:
			stat = ts->stat;
			break;
		}
	}
	ASSIGN_SAS_TASK(sc, NULL);
	sc->result = (hs << 16) | stat;
	list_del_init(&task->list);
	sas_free_task(task);
	/* This is very ugly but this is how SCSI Core works. */
	if (ts_flags & SAS_TASK_STATE_ABORTED)
		scsi_finish_command(sc);
	else
		sc->scsi_done(sc);
}

static inline enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
{
	enum task_attribute ta = TASK_ATTR_SIMPLE;
	if (cmd->request && blk_rq_tagged(cmd->request)) {
		if (cmd->device->ordered_tags &&
		    (cmd->request->flags & REQ_HARDBARRIER))
			ta = TASK_ATTR_HOQ;
	}
	return ta;
}

static inline struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
					       struct LU *lu,
					       unsigned long gfp_flags)
{
	struct sas_task *task = sas_alloc_task(gfp_flags);

	if (!task)
		return NULL;

	*(u32 *)cmd->sense_buffer = 0;
	task->uldd_task = cmd;
	ASSIGN_SAS_TASK(cmd, task);

	task->dev = lu->parent;
	task->task_proto = task->dev->tproto; /* BUG_ON(!SSP) */

	task->ssp_task.retry_count = 1;
	memcpy(task->ssp_task.LUN, lu->LUN, 8);
	task->ssp_task.task_attr = sas_scsi_get_task_attr(cmd);
	memcpy(task->ssp_task.cdb, cmd->cmnd, 16);

	task->scatter = cmd->request_buffer;
	task->num_scatter = cmd->use_sg;
	task->total_xfer_len = cmd->request_bufflen;
	task->data_dir = cmd->sc_data_direction;

	task->task_done = sas_scsi_task_done;

	return task;
}

static inline int sas_queue_up(struct sas_task *task)
{
	struct sas_ha_struct *sas_ha = task->dev->port->ha;
	struct scsi_core *core = &sas_ha->core;
	unsigned long flags;
	LIST_HEAD(list);

	spin_lock_irqsave(&core->task_queue_lock, flags);
	if (sas_ha->lldd_queue_size < core->task_queue_size + 1) {
		spin_unlock_irqrestore(&core->task_queue_lock, flags);
		return -SAS_QUEUE_FULL;
	}
	list_add_tail(&task->list, &core->task_queue);
	core->task_queue_size += 1;
	spin_unlock_irqrestore(&core->task_queue_lock, flags);
	up(&core->queue_thread_sema);

	return 0;
}

/**
 * sas_queuecommand -- Enqueue a command for processing
 * @parameters: See SCSI Core documentation
 *
 * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
 * call us without holding an IRQ spinlock...
 */
static int sas_queuecommand(struct scsi_cmnd *cmd,
			    void (*scsi_done)(struct scsi_cmnd *))
{
	int res = 0;
	struct LU *lu = cmd->device->hostdata;
	struct Scsi_Host *host = cmd->device->host;

	spin_unlock_irq(host->host_lock);
	if (!lu) {
		SAS_DPRINTK("scsi cmd 0x%p sent to non existing LU\n",
			    cmd);
		cmd->result = DID_BAD_TARGET << 16;
		scsi_done(cmd);
		goto out;
	} else {
		struct sas_ha_struct *sas_ha = lu->parent->port->ha;
		struct sas_task *task;

		res = -ENOMEM;
		task = sas_create_task(cmd, lu, GFP_ATOMIC);
		if (!task)
			goto out;

		cmd->scsi_done = scsi_done;
		/* Queue up, Direct Mode or Task Collector Mode. */
		if (sas_ha->lldd_max_execute_num < 2)
			res = sas_ha->lldd_execute_task(task, 1, GFP_ATOMIC);
		else
			res = sas_queue_up(task);

		/* Examine */
		if (res) {
			SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
			ASSIGN_SAS_TASK(cmd, NULL);
			sas_free_task(task);
			if (res == -SAS_QUEUE_FULL) {
				cmd->result = DID_SOFT_ERROR << 16; /* retry */
				res = 0;
				scsi_done(cmd);
			}
			goto out;
		}
	}
out:
	spin_lock_irq(host->host_lock);
	return res;
}

static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct LU *lu)
{
	struct scsi_cmnd *cmd, *n;

	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
		struct LU *x = cmd->device->hostdata;

		if (x == lu)
			list_del_init(&cmd->eh_entry);
	}
}

static void sas_scsi_clear_queue_I_T(struct list_head *error_q,
				     struct domain_device *dev)
{
	struct scsi_cmnd *cmd, *n;

	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
		struct LU *y = cmd->device->hostdata;
		struct domain_device *x = y->parent;

		if (x == dev)
			list_del_init(&cmd->eh_entry);
	}
}

static void sas_scsi_clear_queue_port(struct list_head *error_q,
				      struct sas_port *port)
{
	struct scsi_cmnd *cmd, *n;

	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
		struct LU *y = cmd->device->hostdata;
		struct sas_port *x = y->parent->port;

		if (x == port)
			list_del_init(&cmd->eh_entry);
	}
}

enum task_disposition {
	TASK_IS_DONE,
	TASK_IS_ABORTED,
	TASK_IS_AT_LU,
	TASK_IS_NOT_AT_LU,
};

static enum task_disposition sas_scsi_find_task(struct sas_task *task)
{
	struct sas_ha_struct *ha = task->dev->port->ha;
	unsigned long flags;
	int i, res;

	if (ha->lldd_max_execute_num > 1) {
		struct scsi_core *core = &ha->core;
		struct sas_task *t, *n;

		spin_lock_irqsave(&core->task_queue_lock, flags);
		list_for_each_entry_safe(t, n, &core->task_queue, list) {
			if (task == t) {
				list_del_init(&t->list);
				spin_unlock_irqrestore(&core->task_queue_lock,
						       flags);
				SAS_DPRINTK("%s: task 0x%p aborted from "
					    "task_queue\n",
					    __FUNCTION__, task);
				return TASK_IS_ABORTED;
			}
		}
		spin_unlock_irqrestore(&core->task_queue_lock, flags);
	}

	for (i = 0; i < 5; i++) {
		SAS_DPRINTK("%s: aborting task 0x%p\n", __FUNCTION__, task);
		res = task->dev->port->ha->lldd_abort_task(task);

		spin_lock_irqsave(&task->task_state_lock, flags);
		if (task->task_state_flags & SAS_TASK_STATE_DONE) {
			spin_unlock_irqrestore(&task->task_state_lock, flags);
			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
				    task);
			return TASK_IS_DONE;
		}
		spin_unlock_irqrestore(&task->task_state_lock, flags);

		if (res == TMF_RESP_FUNC_COMPLETE) {
			SAS_DPRINTK("%s: task 0x%p is aborted\n",
				    __FUNCTION__, task);
			return TASK_IS_ABORTED;
		} else if (ha->lldd_query_task) {
			SAS_DPRINTK("%s: querying task 0x%p\n",
				    __FUNCTION__, task);
			res = ha->lldd_query_task(task);
			if (res == TMF_RESP_FUNC_SUCC) {
				SAS_DPRINTK("%s: task 0x%p at LU\n",
					    __FUNCTION__, task);
				return TASK_IS_AT_LU;
			} else if (res == TMF_RESP_FUNC_COMPLETE) {
				SAS_DPRINTK("%s: task 0x%p not at LU\n",
					    __FUNCTION__, task);
				return TASK_IS_NOT_AT_LU;
			}
		}
	}
	return res;
}

static int sas_recover_lu(struct domain_device *dev, struct LU *lu)
{
	struct sas_ha_struct *ha = dev->port->ha;
	int res = TMF_RESP_FUNC_FAILED;

	SAS_DPRINTK("eh: device %llx LUN %llx has the task\n",
		    SAS_ADDR(dev->sas_addr),
		    SAS_ADDR(lu->LUN));

	if (ha->lldd_abort_task_set)
		res = ha->lldd_abort_task_set(dev, lu->LUN);

	if (res == TMF_RESP_FUNC_FAILED) {
		if (ha->lldd_clear_task_set)
			res = ha->lldd_clear_task_set(dev, lu->LUN);
	}

	if (res == TMF_RESP_FUNC_FAILED) {
		if (ha->lldd_lu_reset)
			res = ha->lldd_lu_reset(dev, lu->LUN);
	}

	return res;
}

static int sas_recover_I_T(struct domain_device *dev)
{
	struct sas_ha_struct *ha = dev->port->ha;
	int res = TMF_RESP_FUNC_FAILED;

	SAS_DPRINTK("I_T nexus reset for dev %016llx\n",
		    SAS_ADDR(dev->sas_addr));

	if (ha->lldd_I_T_nexus_reset)
		res = ha->lldd_I_T_nexus_reset(dev);

	return res;
}

static int sas_scsi_recover_host(struct Scsi_Host *shost)
{
	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
	unsigned long flags;
	LIST_HEAD(error_q);
	struct scsi_cmnd *cmd, *n;
	enum task_disposition res = TASK_IS_DONE;
	int tmf_resp;

	spin_lock_irqsave(shost->host_lock, flags);
	list_splice_init(&shost->eh_cmd_q, &error_q);
	spin_unlock_irqrestore(shost->host_lock, flags);

	SAS_DPRINTK("Enter %s\n", __FUNCTION__);

	/* All tasks on this list were marked SAS_TASK_STATE_ABORTED
	 * by sas_scsi_timed_out() callback.
	 */
Again:
	SAS_DPRINTK("going over list...\n");
	list_for_each_entry_safe(cmd, n, &error_q, eh_entry) {
		struct sas_task *task = TO_SAS_TASK(cmd);
		struct LU *lu = cmd->device->hostdata;

		SAS_DPRINTK("trying to find task 0x%p\n", task);
		list_del_init(&cmd->eh_entry);
		res = sas_scsi_find_task(task);

		cmd->eh_eflags = 0;
		shost->host_failed--;

		switch (res) {
		case TASK_IS_DONE:
			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
				    task);
			task->task_done(task);
			continue;
		case TASK_IS_ABORTED:
			SAS_DPRINTK("%s: task 0x%p is aborted\n",
				    __FUNCTION__, task);
			task->task_done(task);
			continue;
		case TASK_IS_AT_LU:
			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
			tmf_resp = sas_recover_lu(task->dev, lu);
			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
				SAS_DPRINTK("dev %016llx LU %016llx is "
					    "recovered\n",
					    SAS_ADDR(task->dev),
					    SAS_ADDR(lu->LUN));
				task->task_done(task);
				sas_scsi_clear_queue_lu(&error_q, lu);
				goto Again;
			}
			/* fallthrough */
		case TASK_IS_NOT_AT_LU:
			SAS_DPRINTK("task 0x%p is not at LU: I_T recover\n",
				    task);
			tmf_resp = sas_recover_I_T(task->dev);
			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
				SAS_DPRINTK("I_T %016llx recovered\n",
					    SAS_ADDR(task->dev->sas_addr));
				task->task_done(task);
				sas_scsi_clear_queue_I_T(&error_q, task->dev);
				goto Again;
			}
			/* Hammer time :-) */
			if (ha->lldd_clear_nexus_port) {
				struct sas_port *port = task->dev->port;
				SAS_DPRINTK("clearing nexus for port:%d\n",
					    port->id);
				res = ha->lldd_clear_nexus_port(port);
				if (res == TMF_RESP_FUNC_COMPLETE) {
					SAS_DPRINTK("clear nexus port:%d "
						    "succeeded\n", port->id);
					task->task_done(task);
					sas_scsi_clear_queue_port(&error_q,
								  port);
					goto Again;
				}
			}
			if (ha->lldd_clear_nexus_ha) {
				SAS_DPRINTK("clear nexus ha\n");
				res = ha->lldd_clear_nexus_ha(ha);
				if (res == TMF_RESP_FUNC_COMPLETE) {
					SAS_DPRINTK("clear nexus ha "
						    "succeeded\n");
					task->task_done(task);
					goto out;
				}
			}
			/* If we are here -- this means that no amount
			 * of effort could recover from errors.  Quite
			 * possibly the HA just disappeared.
			 */
			SAS_DPRINTK("error from  device %llx, LUN %llx "
				    "couldn't be recovered in any way\n",
				    SAS_ADDR(task->dev->sas_addr),
				    SAS_ADDR(lu->LUN));

			task->task_done(task);
			goto clear_q;
		}
	}
out:
	SAS_DPRINTK("--- Exit %s\n", __FUNCTION__);
	return 0;
clear_q:
	SAS_DPRINTK("--- Exit %s -- clear_q\n", __FUNCTION__);
	list_for_each_entry_safe(cmd, n, &error_q, eh_entry) {
		struct sas_task *task = TO_SAS_TASK(cmd);
		list_del_init(&cmd->eh_entry);
		task->task_done(task);
	}
	return 0;
}

static enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
{
	struct sas_task *task = TO_SAS_TASK(cmd);
	unsigned long flags;

	if (!task) {
		SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_HANDLED\n",
			    cmd, task);
		return EH_HANDLED;
	}

	spin_lock_irqsave(&task->task_state_lock, flags);
	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
		spin_unlock_irqrestore(&task->task_state_lock, flags);
		SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_HANDLED\n",
			    cmd, task);
		return EH_HANDLED;
	}
	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
	spin_unlock_irqrestore(&task->task_state_lock, flags);

	SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_NOT_HANDLED\n",
		    cmd, task);

	return EH_NOT_HANDLED;
}

/**
 * sas_slave_alloc -- configure an LU which SCSI Core wants to poke at
 * @scsi_dev: pointer to scsi device
 *
 * The kludge here is that the only token we have to go by in order to
 * identify which device SCSI Core has just found about, is channel,
 * id and lun/2.  Of course this is 1) incredibly broken and 2)
 * leftover from when SCSI Core was SPI-centric.  A solution would be
 * to pass an opaque token to scsi_add_device, which SCSI Core treats
 * as that, an opaque token, which it sets inside scsi_dev, so we can
 * find out which device SCSI Core is talking about.  That is, how
 * SCSI Core is _addressing_ the device is not the business of LLDD
 * and vice versa.  An even _better_ solution is if SCSI Core knew
 * about a "SCSI device with Target ports" so we can register only the
 * targets, and then it would do its own LU discovery...  See comment
 * in sas_do_lu_discovery().
 */
static int sas_slave_alloc(struct scsi_device *scsi_dev)
{
	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(scsi_dev->host);
	struct sas_port *port = sas_ha->sas_port[scsi_dev->channel];
        unsigned id = scsi_dev->id;
	unsigned lun = scsi_dev->lun;

	struct domain_device *dev = NULL;
	struct LU *lu = NULL;

	scsi_dev->hostdata = NULL;

	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
		if (dev->dev_type == SAS_END_DEV) {
			list_for_each_entry(lu, &dev->end_dev.LU_list, list) {
				if (lu->map.id == id &&
				    SCSI_LUN(lu->LUN) == lun) {
					scsi_dev->hostdata = lu;
					lu->uldd_dev = scsi_dev;
					goto out_loop;
				}
			}
		}
	}
out_loop:
	if (!scsi_dev->hostdata) {
		SAS_DPRINTK("sas device not found! How is this possible?\n");
		return -ENODEV;
	}
	kobject_get(&lu->lu_obj);
	return 0;
}

#define SAS_DEF_QD 32
#define SAS_MAX_QD 64

static int sas_slave_configure(struct scsi_device *scsi_dev)
{
	struct LU *lu = scsi_dev->hostdata;
	struct domain_device *dev;
	struct sas_ha_struct *sas_ha;

	if (!lu) {
		SAS_DPRINTK("slave configure and no LU?!\n");
		return -ENODEV;
	}

	dev = lu->parent;
	sas_ha = dev->port->ha;

	if (scsi_dev->inquiry_len > 7) {
		u8 bq = (scsi_dev->inquiry[6] & 0x80) ? 1 : 0;
		u8 cq = (scsi_dev->inquiry[7] & 0x02) ? 1 : 0;

		if (bq ^ cq) {
			lu->tm_type = (bq<<1) | cq;
			scsi_dev->tagged_supported = 1;
			if (cq)
				scsi_set_tag_type(scsi_dev, MSG_ORDERED_TAG);
			else
				scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
			scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
		} else {
			SAS_DPRINTK("device %llx, LUN %llx doesn't support "
				    "TCQ\n", SAS_ADDR(dev->sas_addr),
				    SAS_ADDR(lu->LUN));
			scsi_dev->tagged_supported = 0;
			scsi_set_tag_type(scsi_dev, 0);
			scsi_deactivate_tcq(scsi_dev, 1);
		}
	}

	if (dev->end_dev.itnl_timeout > 0)
		scsi_dev->timeout = HZ +
			msecs_to_jiffies(dev->end_dev.itnl_timeout);

	return 0;
}

static void sas_slave_destroy(struct scsi_device *scsi_dev)
{
	struct LU *lu = scsi_dev->hostdata;

	if (lu) {
		scsi_dev->hostdata = NULL;
		lu->uldd_dev = NULL;
		kobject_put(&lu->lu_obj);
	}
}

static int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
{
	int res = min(new_depth, SAS_MAX_QD);

	if (scsi_dev->tagged_supported)
		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
					res);
	else {
		struct LU *lu = scsi_dev->hostdata;
		sas_printk("device %llx LUN %llx queue depth changed to 1\n",
			   SAS_ADDR(lu->parent->sas_addr),
			   SAS_ADDR(lu->LUN));
		scsi_adjust_queue_depth(scsi_dev, 0, 1);
		res = 1;
	}

	return res;
}

static int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
{
	struct LU *lu = scsi_dev->hostdata;

	if (!scsi_dev->tagged_supported)
		return 0;

	scsi_deactivate_tcq(scsi_dev, 1);

	switch (qt) {
	case MSG_ORDERED_TAG:
		if (lu->tm_type != TASK_MANAGEMENT_FULL)
			qt = MSG_SIMPLE_TAG;
		break;
	case MSG_SIMPLE_TAG:
	default:
		;
	}

	scsi_set_tag_type(scsi_dev, qt);
	scsi_activate_tcq(scsi_dev, scsi_dev->queue_depth);

	return qt;
}

static int sas_bios_param(struct scsi_device *scsi_dev,
			  struct block_device *bdev,
			  sector_t capacity, int *hsc)
{
	hsc[0] = 255;
	hsc[1] = 63;
	sector_div(capacity, 255*63);
	hsc[2] = capacity;

	return 0;
}

static const struct scsi_host_template sas_host_template = {
	.module = THIS_MODULE,
	/* .name is initialized */
	.name = "",
	.queuecommand = sas_queuecommand,
	.eh_strategy_handler = sas_scsi_recover_host,
	.eh_timed_out = sas_scsi_timed_out,
	.slave_alloc = sas_slave_alloc,
	.slave_configure = sas_slave_configure,
	.slave_destroy = sas_slave_destroy,
	.change_queue_depth = sas_change_queue_depth,
	.change_queue_type = sas_change_queue_type,
	.bios_param = sas_bios_param,
	/* .can_queue is initialized */
	.this_id = -1,
	.sg_tablesize = SG_ALL,
	.max_sectors = SCSI_DEFAULT_MAX_SECTORS,
	/* .cmd_per_lun is initilized to .can_queue */
	.use_clustering = ENABLE_CLUSTERING,
};

static inline void sas_init_host_template(struct sas_ha_struct *sas_ha)
{
	struct scsi_host_template *sht = sas_ha->core.sht;

	*sht = sas_host_template;

	sht->name = sas_ha->sas_ha_name;
	sht->can_queue = sas_ha->lldd_queue_size;
	sht->cmd_per_lun = sht->can_queue;
}

int sas_register_scsi_host(struct sas_ha_struct *sas_ha)
{
	int err = -ENOMEM;

	sas_ha->core.sht = kzalloc(sizeof(*sas_ha->core.sht), GFP_KERNEL);
	if (!sas_ha->core.sht)
		return -ENOMEM;

	sas_init_host_template(sas_ha);

	sas_ha->core.shost = scsi_host_alloc(sas_ha->core.sht, sizeof(void *));
	if (!sas_ha->core.shost) {
		printk(KERN_NOTICE "couldn't allocate scsi host\n");
		goto out_err;
	}
	SHOST_TO_SAS_HA(sas_ha->core.shost) = sas_ha;

	/* XXX: SCSI Core should really fix this (max vs. num of) */
	sas_ha->core.shost->max_channel = sas_ha->num_phys - 1;
	sas_ha->core.shost->max_id = ~0 - 1;
	sas_ha->core.shost->max_lun = ~0 - 1;

	sas_ha->core.shost->max_cmd_len = 16;

	err = scsi_add_host(sas_ha->core.shost, &sas_ha->pcidev->dev);
	if (err) {
		scsi_host_put(sas_ha->core.shost);
		sas_ha->core.shost = NULL;
		goto out_err;
	}
	return 0;

out_err:
	kfree(sas_ha->core.sht);
	sas_ha->core.sht = NULL;
	return err;
}

void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha)
{
	scsi_remove_host(sas_ha->core.shost);
	scsi_host_put(sas_ha->core.shost);
	sas_ha->core.shost = NULL;
	kfree(sas_ha->core.sht);
	sas_ha->core.sht = NULL;
}

/* ---------- Task Collector Thread implementation ---------- */

static void sas_queue(struct sas_ha_struct *sas_ha)
{
	struct scsi_core *core = &sas_ha->core;
	unsigned long flags;
	LIST_HEAD(q);
	int can_queue;
	int res;

	spin_lock_irqsave(&core->task_queue_lock, flags);
	while (!core->queue_thread_kill &&
	       !list_empty(&core->task_queue)) {

		can_queue = sas_ha->lldd_queue_size - core->task_queue_size;
		if (can_queue >= 0) {
			can_queue = core->task_queue_size;
			list_splice_init(&core->task_queue, &q);
		} else {
			struct list_head *a, *n;

			can_queue = sas_ha->lldd_queue_size;
			list_for_each_safe(a, n, &core->task_queue) {
				list_move_tail(a, &q);
				if (--can_queue == 0)
					break;
			}
			can_queue = sas_ha->lldd_queue_size;
		}
		core->task_queue_size -= can_queue;
		spin_unlock_irqrestore(&core->task_queue_lock, flags);
		{
			struct sas_task *task = list_entry(q.next,
							   struct sas_task,
							   list);
			list_del_init(&q);
			res = sas_ha->lldd_execute_task(task, can_queue,
							GFP_KERNEL);
			if (unlikely(res))
				__list_add(&q, task->list.prev, &task->list);
		}
		spin_lock_irqsave(&core->task_queue_lock, flags);
		if (res) {
			list_splice_init(&q, &core->task_queue); /*at head*/
			core->task_queue_size += can_queue;
		}
	}
	spin_unlock_irqrestore(&core->task_queue_lock, flags);
}

static DECLARE_COMPLETION(queue_th_comp);

/**
 * sas_queue_thread -- The Task Collector thread
 * @_sas_ha: pointer to struct sas_ha
 */
static int sas_queue_thread(void *_sas_ha)
{
	struct sas_ha_struct *sas_ha = _sas_ha;
	struct scsi_core *core = &sas_ha->core;

	daemonize("sas_queue_%d", core->shost->host_no);
	current->flags |= PF_NOFREEZE;

	complete(&queue_th_comp);

	while (1) {
		down_interruptible(&core->queue_thread_sema);
		sas_queue(sas_ha);
		if (core->queue_thread_kill)
			break;
	}

	complete(&queue_th_comp);

	return 0;
}

/* ---------- SCSI Core struct attributes ---------- */

static ssize_t show_task_queue_size(struct scsi_core *core, char *page)
{
	return sprintf(page, "%d\n", core->task_queue_size);
}

struct scsi_core_attribute {
	struct attribute attr;
	ssize_t (*show)(struct scsi_core *, char *);
	ssize_t (*store)(struct scsi_core *, const char *, size_t len);
};

#define to_scsi_core(_obj) container_of((_obj), struct scsi_core, \
					scsi_core_obj)
#define to_sc_attr(_attr) container_of((_attr), struct scsi_core_attribute,\
				       attr)

static ssize_t sc_show_attr(struct kobject *kobj, struct attribute *attr,
			    char *page)
{
	ssize_t ret = 0;
	struct scsi_core *core = to_scsi_core(kobj);
	struct scsi_core_attribute *sc_attr = to_sc_attr(attr);

	if (sc_attr->show)
		ret = sc_attr->show(core, page);
	return ret;
}

static struct scsi_core_attribute sc_attrs[] = {
	__ATTR(task_queue_size, 0444, show_task_queue_size, NULL),
	__ATTR_NULL,
};

static struct attribute *sc_def_attrs[ARRAY_SIZE(sc_attrs)];

static struct sysfs_ops sc_sysfs_ops = {
	.show = sc_show_attr,
};

static struct kobj_type scsi_core_ktype = {
	.sysfs_ops = &sc_sysfs_ops,
	.default_attrs = sc_def_attrs,
};

int sas_init_queue(struct sas_ha_struct *sas_ha)
{
	int res;
	struct scsi_core *core = &sas_ha->core;

	spin_lock_init(&core->task_queue_lock);
	core->task_queue_size = 0;
	INIT_LIST_HEAD(&core->task_queue);
	init_MUTEX_LOCKED(&core->queue_thread_sema);

	res = kernel_thread(sas_queue_thread, sas_ha, 0);
	if (res >= 0) {
		int i;
		wait_for_completion(&queue_th_comp);

		for (i = 0; i < ARRAY_SIZE(sc_attrs)-1; i++)
			sc_def_attrs[i] = &sc_attrs[i].attr;
		sc_def_attrs[i] = NULL;

		core->scsi_core_obj.kset = &sas_ha->ha_kset;
		kobject_set_name(&core->scsi_core_obj, "%s", "scsi_core");
		core->scsi_core_obj.ktype = &scsi_core_ktype;
	}

	return res < 0 ? res : 0;
}

void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
{
	unsigned long flags;
	struct scsi_core *core = &sas_ha->core;
	struct sas_task *task, *n;

	init_completion(&queue_th_comp);
	core->queue_thread_kill = 1;
	up(&core->queue_thread_sema);
	wait_for_completion(&queue_th_comp);

	if (!list_empty(&core->task_queue))
		SAS_DPRINTK("HA: %llx: scsi core task queue is NOT empty!?\n",
			    SAS_ADDR(sas_ha->sas_addr));

	spin_lock_irqsave(&core->task_queue_lock, flags);
	list_for_each_entry_safe(task, n, &core->task_queue, list) {
		struct scsi_cmnd *cmd = task->uldd_task;

		list_del_init(&task->list);

		ASSIGN_SAS_TASK(cmd, NULL);
		sas_free_task(task);
		cmd->result = DID_ABORT << 16;
		cmd->scsi_done(cmd);
	}
	spin_unlock_irqrestore(&core->task_queue_lock, flags);
}

--0-1015483234-1129313175=:5407--
