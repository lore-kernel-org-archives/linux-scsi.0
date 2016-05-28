From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Fri, 27 May 2016 21:27:55 -0700
Message-ID: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
	 <1464359544-85969-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464359544-85969-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, bart.vanassche@sandisk.com, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Bryant,

On Fri, 2016-05-27 at 09:32 -0500, Bryant G. Ly wrote
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c
> new file mode 100644
> index 0000000..292d129
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c

<SNIP>

> +
> +static struct se_portal_group *ibmvscsis_make_nexus(struct ibmvscsis_tport
> +						    *tport,
> +						    const char *name)
> +{
> +	struct se_node_acl *acl;
> +
> +	if (tport->se_sess) {
> +		pr_debug("tport->se_sess already exists\n");
> +		return &tport->se_tpg;
> +	}
> +
> +	/*
> +	 *  Initialize the struct se_session pointer and setup tagpool
> +	 *  for struct ibmvscsis_cmd descriptors
> +	 */
> +	tport->se_sess = transport_init_session(TARGET_PROT_NORMAL);
> +	if (IS_ERR(tport->se_sess))
> +		goto transport_init_fail;
> +
> +	/*
> +	 * Since we are running in 'demo mode' this call will generate a
> +	 * struct se_node_acl for the ibmvscsis struct se_portal_group with
> +	 * the SCSI Initiator port name of the passed configfs group 'name'.
> +	 */
> +
> +	acl = core_tpg_check_initiator_node_acl(&tport->se_tpg,
> +						(unsigned char *)name);
> +	if (!acl) {
> +		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
> +			 name);
> +		goto acl_failed;
> +	}
> +	tport->se_sess->se_node_acl = acl;
> +
> +	/*
> +	 * Now register the TCM ibmvscsis virtual I_T Nexus as active.
> +	 */
> +	transport_register_session(&tport->se_tpg,
> +				   tport->se_sess->se_node_acl,
> +				   tport->se_sess, tport);
> +
> +	tport->se_sess->se_tpg = &tport->se_tpg;
> +

FYI, starting in v4.6 these three calls are handled directly by a new
target_alloc_session() helper.

No objection to leaving this as-is for now to make it easier to run atop
unmodified v4.4 target code, but note you'll want to be converting this
post merge.

> +static int ibmvscsis_shutdown_session(struct se_session *se_sess)
> +{
> +	return 0;
> +}
> +
> +static void ibmvscsis_close_session(struct se_session *se_sess)
> +{
> +}
> +
>

These two target_core_fabric_ops callers have been made optional for v4.7+

> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
> new file mode 100644
> index 0000000..23e9449
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h

<SNIP>

> +
> +struct client_info {
> +#define SRP_VERSION "16.a"
> +	char srp_version[8];
> +	/* root node property ibm,partition-name */
> +	char partition_name[PARTITION_NAMELEN];
> +	/* root node property ibm,partition-no */
> +	u32 partition_number;
> +	/* initially 1 */
> +	u32 mad_version;
> +	u32 os_type;
> +};
> +
> +struct ibmvscsis_cmd {
> +	/* Used for libsrp processing callbacks */
> +	struct scsi_cmnd sc;

AFAICT, struct scsi_cmnd is only being used for passing io memory
descriptors and struct iu_entry via sc->SCp.ptr between ibmvscsi_tgt +
libsrp.

Now with the other legacy libsrp.c Scsi_Host related bits removed, it
should be easy to convert the rest in order to drop the last vestiges of
SCSI host LLD structures from ibmvscsi_tgt code.

> +	/* Used for TCM Core operations */
> +	struct se_cmd se_cmd;
> +	/* Sense buffer that will be mapped into outgoing status */
> +	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
> +	u32 lun;
> +};
> +

<SNIP>

> diff --git a/drivers/scsi/ibmvscsi/libsrp.h b/drivers/scsi/ibmvscsi/libsrp.h
> new file mode 100644
> index 0000000..bf9e30b
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/libsrp.h
> @@ -0,0 +1,91 @@
> +#ifndef __LIBSRP_H__
> +#define __LIBSRP_H__
> +
> +#include <linux/list.h>
> +#include <linux/kfifo.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/srp.h>
> +#include <target/target_core_base.h>
> +
> +enum srp_task_attributes {
> +	SRP_SIMPLE_TASK = 0,
> +	SRP_HEAD_TASK = 1,
> +	SRP_ORDERED_TASK = 2,
> +	SRP_ACA_TASK = 4
> +};
> +
> +enum iue_flags {
> +	V_DIOVER,
> +	V_WRITE,
> +	V_LINKED,
> +	V_FLYING,
> +};
> +
> +enum {
> +	SRP_TASK_MANAGEMENT_FUNCTION_COMPLETE           = 0,
> +	SRP_REQUEST_FIELDS_INVALID                      = 2,
> +	SRP_TASK_MANAGEMENT_FUNCTION_NOT_SUPPORTED      = 4,
> +	SRP_TASK_MANAGEMENT_FUNCTION_FAILED             = 5
> +};
> +
> +struct srp_buf {
> +	dma_addr_t dma;
> +	void *buf;
> +};
> +
> +struct srp_queue {
> +	void *pool;
> +	void *items;
> +	struct kfifo queue;
> +	spinlock_t lock;
> +};
> +
> +struct srp_target {
> +	struct Scsi_Host *shost;

Unused.

> +	struct se_device *tgt;
> +	struct device *dev;
> +
> +	spinlock_t lock;
> +	struct list_head cmd_queue;
> +
> +	size_t srp_iu_size;
> +	struct srp_queue iu_queue;
> +	size_t rx_ring_size;
> +	struct srp_buf **rx_ring;
> +
> +	void *ldata;
> +};
> 
> 
> V2
> Addressed comments from Bart/Joe in regards to styling and code structure
> 
> V3
> Addressed James Bottomley's comments in regards to having the old libsrp
> reverted to make it clear that we are resurrecting the old vscsi target
> driver and making changes to it to utilize LIO. I also made libsrp a linked
> file to the ibmvscsi module per Jame's comments.
> 

Btw, the patch series changelog should go at the top of the email.
