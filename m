From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 20 Oct 2010 13:49:34 -0700
Message-ID: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Brian King <brking@linux.vnet.ibm.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

So as we get closer to the .37 merge window, I wanted to take this
oppourtunity to recap the current status of the drop-host_lock /
unlocked_qcmds=1 patches, and what is required for the next RFCv5 and
hopefully a merge into .37.  The last RFCv4 was posted here:

http://marc.info/?l=linux-kernel&m=128563953114561&w=2

Since then, Christof Schmitt has sent a patch to drop struct
scsi_cmnd->serial_number usage in zfcp, and Tim Chen has sent an
important fix to drop an extra host_lock access that I originally missed
in qla2xxx SHT->queuecommand() that certainly would have deadlocked a
running machine.   Many thanks to Christof and Tim for your
contributions and review!

So at this point in the game the current score sits at:

*) core drivers/scsi remaining issue(s):

The issue raised by andmike during RFCv4 described as:

"If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE is set it
would be correct for the scsi_decide_disposition cases but it would
appear this would stop __scsi_try_to_abort_cmd from being called in the
time out case as REQ_ATOM_COMPLETE is set prior to calling
blk_rq_timed_out."

The complete discussion is here:

http://marc.info/?l=linux-scsi&m=128535319915212&w=2

We still need folks with experience to dig into this code, so you know
the scsi_error.c code please jump in!

*) LLD libraries running by default w/ unlocked_qcmds=1

libiscsi: need ack from mnc
libsas: need ack from jejb
libfc: remaining rport state + host_lock less issue.  Need more input
       from mnc for James Smart and Joe on this...
libata: jgarzik thinks this should be OK, review and ack from tejun
        would also be very helpful.

The main issue remaining here is the audit of libfc rport (and other..?)
code that assumes host_lock is held to protect state.  mnc, do you have
any more thoughts for James Smart and Joe here..?

*) Individual LLDs running by default w/ unlocked_qcmds=1

aic94xx: need ack maintainer at adaptec..?)
mvsas: need ack maintainer at marvell..?)
pm8001: need ack Jang Wang
qla4xxx, qla2xxx: need ack Andrew Vasquez
fnic:  need ack Joe Eykholt

Aside from the required ACKs, I am not aware of any other mainline LLDs
doing the legacy SHT->queuecommand() -> unlock() -> do_lld_work() ->
lock() that have not already been converted.

The main question here is if any out of tree SCSI LLDs use this legacy
optimization..  Should we come up with a compile time way to alert
vendors to this..?

*) Individual LLDs converted to use explict scsi_cmd_get_serial()

mpt2sas: Add scsi_cmd_get_serial() call
mpt/fusion: Add scsi_cmd_get_serial() call
dpt_i2o: Add scsi_cmd_get_serial() call
eata: Add scsi_cmd_get_serial() call
u14-34f: Add scsi_cmd_get_serial() call
zfcp: Remove scsi_cmnd->serial_number from debug traces

Aside from the required ACKs, I am not aware of any other mainline LLDs
that use struct scsi_cmnd->serial_number internally that have not
already been converted.  The same applies to out of tree modules for
this, but is certainly not critical.

So as the clock winds down to get this merged into .37, if anyone else
has any concerns or comments please let myself and the other relivent
maintainers know and we will try to address them accordingly.

Thanks!

--nab
