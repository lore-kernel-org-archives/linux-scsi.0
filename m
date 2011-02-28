From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
Date: Mon, 28 Feb 2011 09:07:48 +0100
Message-ID: <20110228080748.GA15238@lst.de>
References: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org> <1298874020-15628-6-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1298874020-15628-6-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

> --- /dev/null
> +++ b/drivers/target/tcm_loop/Makefile
> @@ -0,0 +1,11 @@
> +EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_loop/

This should not be needed.

> +
> +tcm_loop-y			:= tcm_loop_fabric.o \
> +				   tcm_loop_fabric_scsi.o \
> +				   tcm_loop_configfs.o \
> +
> +obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop.o
> +
> +ifdef CONFIG_TCM_LOOP_CDB_DEBUG
> +EXTRA_CFLAGS			+= -DTCM_LOOP_CDB_DEBUG
> +endif

Please just test for CONFIG_TCM_LOOP_CDB_DEBUG directly in the code.

> +#include <linux/version.h>
> +#include <generated/utsrelease.h>
> +#include <linux/utsname.h>

These should not be needed.

> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/kthread.h>

You don't use kthreads in this file, so it shouldn't be needed either.

> +#include <tcm_loop_core.h>
> +#include <tcm_loop_configfs.h>
> +#include <tcm_loop_fabric.h>
> +#include <tcm_loop_fabric_scsi.h>

Theseshould be ""-style includes.

> +	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
> +	if (!(tl_nexus)) {

Please remove all these totally pointless braces inside negations.

> diff --git a/drivers/target/tcm_loop/tcm_loop_configfs.h b/drivers/target/tcm_loop/tcm_loop_configfs.h
> new file mode 100644
> index 0000000..f46aa4b
> --- /dev/null
> +++ b/drivers/target/tcm_loop/tcm_loop_configfs.h
> @@ -0,0 +1,2 @@
> +extern int tcm_loop_register_configfs(void);
> +extern void tcm_loop_deregister_configfs(void);

I think just having one header for this module instead of mini-headers
like this is a lot easier to read/maintain.

> +#include <linux/kthread.h>

Again, this should not be needed.

> +int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
> +{
> +	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
> +				struct tcm_loop_cmd, tl_se_cmd);
> +	struct scsi_cmnd *sc = tl_cmd->sc;
> +
> +	TL_CDB_DEBUG( "tcm_loop_queue_data_in() called for scsi_cmnd: %p"
> +			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
> +
> +	sc->result = SAM_STAT_GOOD;
> +	set_host_byte(sc, DID_OK);
> +	(*sc->scsi_done)(sc);

This can be written simpler as sc->scsi_done(sc);

> +#include <linux/version.h>
> +#include <generated/utsrelease.h>
> +#include <linux/utsname.h>

not needed.

> +#include <scsi/libsas.h> /* For TASK_ATTR_* */

I thought that got fixed for the next merge window?

> + * Copied from drivers/scsi/libfc/fc_fcp.c:fc_change_queue_depth() and
> + * drivers/scsi/libiscsi.c:iscsi_change_queue_depth()
> + */

Sounds like we should move it to generic code instead of adding a third
duplicate.

> +static inline struct tcm_loop_hba *tcm_loop_get_hba(struct scsi_cmnd *sc)
> +{
> +	return (struct tcm_loop_hba *)sc->device->host->hostdata[0];
> +}

You probably want to use shost_priv instead.

> +	struct se_portal_group *se_tpg;
> +	struct tcm_loop_hba *tl_hba;
> +	struct tcm_loop_tpg *tl_tpg;
> +
> +	TL_CDB_DEBUG("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
> +		" scsi_buf_len: %u\n", sc->device->host->host_no,
> +		sc->device->id, sc->device->channel, sc->device->lun,
> +		sc->cmnd[0], scsi_bufflen(sc));
> +	/*
> +	 * Locate the tcm_loop_hba_t pointer 
> +	 */
> +	tl_hba = tcm_loop_get_hba(sc);
> +	if (!(tl_hba)) {
> +		printk(KERN_ERR "Unable to locate struct tcm_loop_hba from"
> +				" struct scsi_cmnd\n");
> +		set_host_byte(sc, DID_ERROR);
> +		sc->scsi_done(sc);
> +		return 0;	
> +	}

This can't ever be null.

> +static struct scsi_host_template tcm_loop_driver_template = {
> +	.proc_info		= tcm_loop_proc_info,
> +	.proc_name		= "tcm_loopback",
> +	.name			= "TCM_Loopback",
> +	.info			= NULL,
> +	.slave_alloc		= NULL,
> +	.slave_configure	= NULL,
> +	.slave_destroy		= NULL,
> +	.ioctl			= NULL,

There is no need to fill unused methods with NULLs.
