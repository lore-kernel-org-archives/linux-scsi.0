From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCHv4 0/19]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Sat, 02 Oct 2010 01:34:40 +0400
Message-ID: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52790 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0JAVfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 17:35:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>

Hi All,

Please review the next iteration of the patch set of the new (although,
in fact, the oldest) SCSI target framework for Linux SCST with a set of
dev handlers and 3 target drivers: for local access (scst_local), for
Infiniband SRP (srpt) and IBM POWER Virtual SCSI .

SCST is the most advanced and features rich SCSI target subsystem for
Linux. It allows to build the fastest devices and clusters delivering
millions of IOPS. Many companies are using it as a foundation for their
storage products and solutions. List of some of them you can find on
http://scst.sourceforge.net/users.html. There are also many other who
not yet added there or prefer for some reasons to not be listed on this
page.

The previous iterations of the SCST patch set you can find on
http://lkml.org/lkml/2008 and http://lkml.org/lkml/2010/4/13/146.

We believe that code is fully mainline ready (considering that ibmvstgt
driver for SCST not yet tested on hardware).

This iteration for simplicity contains only 2 target drivers: for local
access (scst_local) and SRP (ib_srpt). If SCST accepted, we will prepare
and submit patches for other target drivers: for iSCSI, FCoE, QLogic
Fibre Channel QLA 2xxx, Emulex Fibre Channel/FCoE and Marvell
88SE63xx/64xx/68xx/94xx SAS hardware.

Also this patchset contains port of ibmvstgt driver for SCST, many
thanks to Bart Van Assche for performing it!

This patchset is for kernel 2.6.35. On request we will rebase it for any
other kernel tree. Since SCST is quite self-contained and almost doesn't
touch outside kernel code, there are no problems in it.

As Dmitry Torokhov requested (thanks for the review!), in this iteration
we added more detail descriptions of each patch. Since the space for
description is too limited, we can't describe full SCST internals (it's
worth a book). But we hope that those description will be a good
starting point.

More detail description of SCST, its drivers and utilities you can find
on SCST home page http://scst.sourceforge.net. Detail features list and
comparison with other Linux target subsystems you can find on
http://scst.sourceforge.net/comparison.html. Description of the SCST
processing flow you can find in http://scst.sourceforge.net/scst_pg.html
(especially see picture "The commands processing flow").

SCST is complete self-contained subsystem. It shares only few with the
Linux SCSI (initiator) subsystem: constants and some low level utility
functions. This is a deliberate decision, because the task of
implementing a SCSI target (i.e. server) is orthogonal to the task of
implementing a SCSI initiator (i.e. client). Such orthogonality between
client and server implementations is quite common. In fact, I can't
recall anything, where client and server are coupled together. You can
see how few NFS client and server are sharing in the Linux kernel (<300
LOC). For me to build SCSI target around initiator is similar as to
build Sendmail around Mutt, or Apache around Firefox.

I'm writing about it so much, because STGT's in-kernel interface and
data fields embedded into the Linux SCSI (initiator) subsystem, i.e.
STGT is built around the Linux SCSI (initiator) subsystem, and this
approach considered the best by many kernel developers. But, in fact,
this approach is wrong, because of orthogonality between initiator and
target subsystems. A good design is to keep orthogonal things
separately, not coupled together.

Consequences of this bad move is predictable and common for cases when
separate things coupled together:

1. Internal: sometimes it isn't obvious if a function or data type is
for target or initiator mode. Hence, it is easy fixing initiator mode
break target and vice versa.

2. User visible. At the moment, supposed to be initiator-side
scsi_transport_* modules for FC and SRP depends from the target side
module module scsi_tgt, like:

# lsmod
Module                  Size  Used by
qla2xxx               130844  0
firmware_class          8064  1 qla2xxx
scsi_transport_fc      40900  1 qla2xxx
scsi_tgt               12196  1 scsi_transport_fc
...

This means that all FC and SRP users must have scsi_tgt loaded although
they never going to run a SCSI target and have never heard about the
only module in the kernel which actually needs scsi_tgt.ko: ibmvstgt.ko.

SCSI target and initiator devices generally live under different
lifetime rules starting from initialization: initiator devices created
by target scanning, while target devices created by external action on
the target side.

SCSI target and initiator devices doing opposite processing: initiator
is initiating SCSI commands, while target is processing them. The target
side initiating notifications, the initiator side - processing them, for
instance, by rescanning the corresponding target port after REPORT LUNS
DATA HAS CHANGED Unit Attention. Even DMA transfer direction for the
same commands is opposite. For instance for a READ command: TO_DEVICE
for target device and FROM_DEVICE for initiator device.

SCSI target and initiator subsystems need completely different user
interface, because the initiator subsystem creates devices internally,
but for the target subsystem devices created by external actions via the
user interface.

Yes, sure, there are cases when a HBA can serve both target and
initiator modes, but this is rather a special case. For instance, SCST
has 9 target drivers, from which 7 are target mode only drivers. For
such cases, the best is (and this approach is used by mvsas_tgt and
qla2x00t drivers):

 - To make the target mode part a separate add-on to the main initiator
mode driver. The initiator mode driver will be responsible for
initializing hardware and managing ports for both modes.

 - To add to the initiator module a set of hooks to allow it to interact
with target mode add-on as soon as it is loaded and send to it target
commands from initiators.

As an illustration, consider STGT ibmvstgt driver and see how many it
actually shares with the initiator mode. It is defined as:

static struct scsi_host_template ibmvstgt_sht = {
	.name			= TGT_NAME,
	.module			= THIS_MODULE,
	.can_queue		= INITIAL_SRP_LIMIT,
	.sg_tablesize		= SG_ALL,
	.use_clustering		= DISABLE_CLUSTERING,
	.max_sectors		= DEFAULT_MAX_SECTORS,
	.transfer_response	= ibmvstgt_cmd_done,
	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
	.shost_attrs		= ibmvstgt_attrs,
	.proc_name		= TGT_NAME,
	.supported_mode		= MODE_TARGET,
};

1. For "can_queue" we see in scsi_tgt_alloc_queue() commented code:

/*
 * this is a silly hack. We should probably just queue as many
 * command as is recvd to userspace. uspace can then make
 * sure we do not overload the HBA
 */
q->nr_requests = shost->can_queue;

The comment is correct, can_queue is nonsense on the target side,
because initiator is queuing commands and a target driver generally
can't do anything with it, so can_queue isn't property of a target
driver, but property of common flow control managed by the target mid-layer.

2. Similarly, "max_sectors" is also nonsense for a target driver,
because it doesn't queuing commands. In SCSI such limit is negotiated by
Block Limits VPD page on per LUN, not per target driver basis.

3. eh_abort_handler(). Such callback in the way how it is used by STGT
can only be used with a single threaded processing, because abort can
happen fully asynchronously to the processing of the affected command,
so the processing would need complicated locking to allow such async
abort. On practice with multithreaded processing it is much simpler to
have all commands processing fully synchronous and check for aborts only
in specially defined places. In this approach, such callback isn't needed.

4. transfer_response() - fully target mode callback

5. shost_attrs and proc_name - it's better to have target mode user
interface in different place with initiator mode.

Thus, we have shared between target and initiator modes only "name",
"module", "sg_tablesize", "use_clustering" fields. Not many, yes?

In the descriptions for specific patches I'll evaluate more about SCST
architecture.

Thanks,
Vlad
