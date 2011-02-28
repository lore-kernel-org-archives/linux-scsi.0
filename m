From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/5] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Mon, 28 Feb 2011 15:16:10 -0800
Message-ID: <1298934970.5401.224.camel@haakon2.linux-iscsi.org>
References: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org>
	 <1298874020-15628-6-git-send-email-nab@linux-iscsi.org>
	 <20110228080748.GA15238@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110228080748.GA15238@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-02-28 at 09:07 +0100, Christoph Hellwig wrote:
> > --- /dev/null
> > +++ b/drivers/target/tcm_loop/Makefile
> > @@ -0,0 +1,11 @@
> > +EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_loop/
> 
> This should not be needed.
> 

Ugh, forgot to fix up the Makefile bits..

Removed EXTRA_CFLAGS.

> > +
> > +tcm_loop-y			:= tcm_loop_fabric.o \
> > +				   tcm_loop_fabric_scsi.o \
> > +				   tcm_loop_configfs.o \
> > +
> > +obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop.o
> > +
> > +ifdef CONFIG_TCM_LOOP_CDB_DEBUG
> > +EXTRA_CFLAGS			+= -DTCM_LOOP_CDB_DEBUG
> > +endif
> 
> Please just test for CONFIG_TCM_LOOP_CDB_DEBUG directly in the code.
> 

Fixed

> > +#include <linux/version.h>
> > +#include <generated/utsrelease.h>
> > +#include <linux/utsname.h>
> 
> These should not be needed.
> 

Removed from tcm_loop_fabric_scsi.c, but these are still required for
tcm_loop_configfs.c:tcm_loop_wwn_show_attr_version()

> > +#include <linux/init.h>
> > +#include <linux/slab.h>
> > +#include <linux/kthread.h>
> 
> You don't use kthreads in this file, so it shouldn't be needed either.
> 

<nod>, dropping unnecessary kthread.h includes..

> > +#include <tcm_loop_core.h>
> > +#include <tcm_loop_configfs.h>
> > +#include <tcm_loop_fabric.h>
> > +#include <tcm_loop_fabric_scsi.h>
> 
> Theseshould be ""-style includes.
> 

Fixed

> > +	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
> > +	if (!(tl_nexus)) {
> 
> Please remove all these totally pointless braces inside negations.
> 

Fixed in all code

> > diff --git a/drivers/target/tcm_loop/tcm_loop_configfs.h b/drivers/target/tcm_loop/tcm_loop_configfs.h
> > new file mode 100644
> > index 0000000..f46aa4b
> > --- /dev/null
> > +++ b/drivers/target/tcm_loop/tcm_loop_configfs.h
> > @@ -0,0 +1,2 @@
> > +extern int tcm_loop_register_configfs(void);
> > +extern void tcm_loop_deregister_configfs(void);
> 
> I think just having one header for this module instead of mini-headers
> like this is a lot easier to read/maintain.
> 

Fair point.  Merging tcm_loop_configfs.h, tcm_loop_fabric.h and
tcm_loop_fabric_scsi.h into tcm_loop_core.h

> > +#include <linux/kthread.h>
> 
> Again, this should not be needed.
> 

Removed

> > +int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
> > +{
> > +	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
> > +				struct tcm_loop_cmd, tl_se_cmd);
> > +	struct scsi_cmnd *sc = tl_cmd->sc;
> > +
> > +	TL_CDB_DEBUG( "tcm_loop_queue_data_in() called for scsi_cmnd: %p"
> > +			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
> > +
> > +	sc->result = SAM_STAT_GOOD;
> > +	set_host_byte(sc, DID_OK);
> > +	(*sc->scsi_done)(sc);
> 
> This can be written simpler as sc->scsi_done(sc);
> 

Changed here and in tcm_loop_queue_status()

> > +#include <linux/version.h>
> > +#include <generated/utsrelease.h>
> > +#include <linux/utsname.h>
> 
> not needed.
> 

<nod>, these includes are now only included for tcm_loop_configfs.c

> > +#include <scsi/libsas.h> /* For TASK_ATTR_* */
> 
> I thought that got fixed for the next merge window?
> 

The TMR definitions did get fixed, but the conversion to use scsi_tcq.h
for SAM Task Attributes has not happened yet..

> > + * Copied from drivers/scsi/libfc/fc_fcp.c:fc_change_queue_depth() and
> > + * drivers/scsi/libiscsi.c:iscsi_change_queue_depth()
> > + */
> 
> Sounds like we should move it to generic code instead of adding a third
> duplicate.
> 

Indeed, this type of generic SCSI code should be moved into scsi_lib.c
so we can drop this LLD duplicate code..  While this does not address
all drivers that need to preform LLD specific ops while changing the
struct scsi_device->queue_depth, a generic caller would work fine for
these cases..

> > +static inline struct tcm_loop_hba *tcm_loop_get_hba(struct scsi_cmnd *sc)
> > +{
> > +	return (struct tcm_loop_hba *)sc->device->host->hostdata[0];
> > +}
> 
> You probably want to use shost_priv instead.
> 

Ok, converted tcm_loop_queuecommand() and tcm_loop_device_reset() to use
shost_priv().  Thanks for pointing this one out..

> > +	struct se_portal_group *se_tpg;
> > +	struct tcm_loop_hba *tl_hba;
> > +	struct tcm_loop_tpg *tl_tpg;
> > +
> > +	TL_CDB_DEBUG("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
> > +		" scsi_buf_len: %u\n", sc->device->host->host_no,
> > +		sc->device->id, sc->device->channel, sc->device->lun,
> > +		sc->cmnd[0], scsi_bufflen(sc));
> > +	/*
> > +	 * Locate the tcm_loop_hba_t pointer 
> > +	 */
> > +	tl_hba = tcm_loop_get_hba(sc);
> > +	if (!(tl_hba)) {
> > +		printk(KERN_ERR "Unable to locate struct tcm_loop_hba from"
> > +				" struct scsi_cmnd\n");
> > +		set_host_byte(sc, DID_ERROR);
> > +		sc->scsi_done(sc);
> > +		return 0;	
> > +	}
> 
> This can't ever be null.
> 

Unnecessary check(s) removed..

> > +static struct scsi_host_template tcm_loop_driver_template = {
> > +	.proc_info		= tcm_loop_proc_info,
> > +	.proc_name		= "tcm_loopback",
> > +	.name			= "TCM_Loopback",
> > +	.info			= NULL,
> > +	.slave_alloc		= NULL,
> > +	.slave_configure	= NULL,
> > +	.slave_destroy		= NULL,
> > +	.ioctl			= NULL,
> 
> There is no need to fill unused methods with NULLs.

Removed the NULL assignments from tcm_loop_driver_template..

Thanks for your review.   The tcm_loop changes have been committed and
pushed into lio-4.1 here, and I will get patch #5 of the mainline series
updated shortly..

commit 07bc6603d7ff5f0abf5fc0e3d546b17d0d32cafe
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Feb 28 15:40:13 2011 -0800

    tcm_loop: Cleanups for mainline
    
    This patch contains the following changes to TCM_Loop from Christoph's
    comments:
    
    *) Remove EXTRA_FLAGS from Makefile
    *) Change TCM_LOOP_CDB_DEBUG -> CONFIG_TCM_LOOP_CDB_DEBUG1
    *) Remove unncessary kthread.h and version.h/utsrelease.h/utsname.h includes
    *) Convert .c code to use "" style includes for local includes
    *) Change 'if (!(foo)) {}' usage to 'if (!foo) {}' and (*sc->scsi_done)() ->
       sc->scsi_done(sc)
    *) Merge tcm_loop_configfs.h, tcm_loop_fabric.h, and tcm_loop_fabric_scsi.h
       into tcm_loop_core.h
    *) Convert tcm_loop_driver_probe() to setup sh->hostdata for the tl_hba
       pointer, and update tcm_loop_queuecommand() + tcm_loop_device_reset()
       to use include/scsi/scsi_host.h:shost_priv()
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

 drivers/target/tcm_loop/Makefile               |    6 --
 drivers/target/tcm_loop/tcm_loop_configfs.c    |   38 ++++++--------
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 -
 drivers/target/tcm_loop/tcm_loop_core.h        |   66 +++++++++++++++++++++++-
 drivers/target/tcm_loop/tcm_loop_fabric.c      |   21 +++----
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   40 --------------
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   63 ++++++-----------------
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 ----
 8 files changed, 107 insertions(+), 139 deletions(-)
 delete mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.h
 delete mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.h
 delete mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h

Thanks!

--nab
