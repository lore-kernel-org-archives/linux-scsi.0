From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 21/21] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Mon, 14 Mar 2011 15:02:55 -0700
Message-ID: <1300140175.28255.156.camel@haakon2.linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
	 <1300100775-10012-22-git-send-email-nab@linux-iscsi.org>
	 <20110314145808.GA28480@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110314145808.GA28480@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-14 at 15:58 +0100, Christoph Hellwig wrote:
> On Mon, Mar 14, 2011 at 04:06:15AM -0700, Nicholas A. Bellinger wrote:
> >  drivers/target/Kconfig                         |    2 +
> >  drivers/target/Makefile                        |    3 +
> >  drivers/target/tcm_loop/Kconfig                |   11 +
> >  drivers/target/tcm_loop/Makefile               |    5 +
> >  drivers/target/tcm_loop/tcm_loop_configfs.c    |  643 ++++++++++++++++++++++++
> >  drivers/target/tcm_loop/tcm_loop_core.h        |  141 ++++++
> >  drivers/target/tcm_loop/tcm_loop_fabric.c      |  472 +++++++++++++++++
> >  drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  574 +++++++++++++++++++++
> >  8 files changed, 1851 insertions(+), 0 deletions(-)
> 
> Please descide on a naming scheme for the frontend modules.  You have
> tcm_loop for thise one, and just iscsi for the iscsi frontend.

Ok, curently everything that appears under drivers/target/ beside
iscsi_target_mod.ko is using a matching drivers/target/$FABRIC_MOD/ and
$FABRIC_MOD.ko naming scheme.

I would prefer to keep iscsi_target_mod.ko for the software iSCSI case
in order to prevent chaos with existing userspace tools and prevent
breakage with existing other iSCSI target modules (IET is using
iscsi_trgt.ko IIRC).

How about dropping the 'tcm_' prefix from the drivers/target/tcm_subdir/
to follow how the fabric module actually appears once loaded under
/sys/kernel/config/target/$FABRIC/..?  We will need to keep the common
'tcm_' prefix for the actual target fabric modules (or choose a
different one) to handle those that interface with existing SCSI LLD
code.

>   I'm not sure what tcm actually stands for, but a common prefix defintively
> is helpful.
> 

target_core_mod -> tcm

> And for only about 1700 lines of code I really don't see why it needs to be
> split into multiple implementation files.
> 

This makes it a bit easier to grok as a reference for newcomers by
having seperate sections for configfs control plane, struct
target_core_fabric_ops API callers, and Linux/SCSI LLD specific glue.

--nab 
