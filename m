From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: tcm IBMVSCSIS driver
Date: Sat, 30 Oct 2010 16:05:43 -0700
Message-ID: <1288479943.21870.55.camel@haakon2.linux-iscsi.org>
References: <20101029143536R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58610 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0J3XKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Oct 2010 19:10:41 -0400
In-Reply-To: <20101029143536R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Linda Xie <lxie@us.ibm.com>, Robert C Jennings <rcjenn@us.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Joel Becker <joel.becker@oracle.com>

On Fri, 2010-10-29 at 14:43 +0900, FUJITA Tomonori wrote:
> This is not finished at all. But I'll be out of the office until
> November 15 (kernel summit, etc) so I've posted this broken driver.
> 
> This driver can only provide the logical units configured by tcm
> configfs to POWERPC firmware (without crashing).
> 
> I need to fix the driver to pass properly scsi commands to tcm.
> 

Hi Tomo-san,

First, let me say many thanks for your efforts to get TCM IBMVSCSIS up
and running with the VIO SRP LPAR logic.  I went ahead and merged your
initial patch into a branch at lio-core-2.6.git/tcm_ibmvstgt, and
started to merge my own ideas/code that have been pending in
drivers/target/tcm_ibmvstgt/ code back into the ibmvscsis.ko driver.

So far this has involved restructuring on the configfs control plane wrt
to the target_core_fabric_configfs.c callers, and how the interaction is
done with the arch/powerpc/kernel/vio.c ->probe() callers to register an
active LPAR region as an TCM VIO SRP endpoint.

The details itself may be a bit difficult to understand w/o a bit more
context, so I will post this patch seperately to the list.  Please have
a look and let me know what you think.  Also I will be jumping on the
I/O path items shortly (which are partially disabled in this patch) and
will post these later this evening.

One final question in that regard is in your ibmvscsis_queuecommand()
code, only INQUIRY, REPORT_LUNS, and MODE_SENSE need to be handled
specially for other non Linux VIO SRP Initiator guests on the other
end..  I would like to break this out (if possible) into individual
specialized CDB fields / bits if possible so these special cases so we
can drop excess emulation code in ibmvscsis.c.  This means we could
(eventually) allow TCM/IBMVSCSIS to utilize the SPC-3+ emulation bits in
INQUIRY for high level PR/ALUA emulation using SCSI_PROTOCOL_SRP for the
EVPD=0x83 case.

So then perhaps this is more a question for brking and the POWER IBM
folks.  Of the three CDBs in IBMVSCSIS (INQUIRY, REPORT_LUNS, and
MODE_SENSE) that we are expecting to be done internally to fabric module
code, are there any other specific bits you need set..?  Are there in
any bits/fields in the code below that can not *not* be set..?

Thanks!

--nab

> =
> >From 6c2e85067d9b7a176fb4f7abf71e103bbaf39f01 Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Fri, 29 Oct 2010 14:21:43 +0900
> Subject: [PATCH] tcm IBMVSCSIS driver
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/ibmvscsi/Makefile         |    4 +-
>  drivers/scsi/ibmvscsi/ibmvscsis.c      | 1778 ++++++++++++++++++++++++++++++++
>  drivers/scsi/libsrp.c                  |   12 +-
>  drivers/target/target_core_transport.c |    2 +-
>  include/Kbuild                         |    1 +
>  include/scsi/libsrp.h                  |   10 +-
>  6 files changed, 1796 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/scsi/ibmvscsi/ibmvscsis.c
>  create mode 100644 drivers/scsi/ibmvscsi/ibmvscsis.h
> 
> diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
> index a423d96..a615ea5 100644
> --- a/drivers/scsi/ibmvscsi/Makefile
> +++ b/drivers/scsi/ibmvscsi/Makefile
> @@ -1,8 +1,10 @@
> +EXTRA_CFLAGS += -I$(srctree)/drivers/target/
> +
>  obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
>  
>  ibmvscsic-y			+= ibmvscsi.o
>  ibmvscsic-$(CONFIG_PPC_ISERIES)	+= iseries_vscsi.o 
>  ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
>  
> -obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvstgt.o
> +obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsis.o
>  obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscsi/ibmvscsis.c
> new file mode 100644
> index 0000000..5dfd31a
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
> @@ -0,0 +1,1778 @@
> +#include <linux/slab.h>
> +#include <linux/kthread.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/utsname.h>
> +#include <asm/unaligned.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_tcq.h>
> +#include <scsi/libsrp.h>
> +#include <generated/utsrelease.h>
> +
> +#include <target/target_core_base.h>
> +#include <target/target_core_transport.h>
> +#include <target/target_core_fabric_ops.h>
> +#include <target/target_core_fabric_lib.h>
> +#include <target/target_core_fabric_configfs.h>
> +#include <target/target_core_device.h>
> +#include <target/target_core_tpg.h>
> +#include <target/target_core_configfs.h>
> +
> +#include <asm/hvcall.h>
> +#include <asm/iommu.h>
> +#include <asm/prom.h>
> +#include <asm/vio.h>
> +
> +#include "ibmvscsi.h"
> +#include "viosrp.h"
> +
> +#define IBMVSCSIS_VERSION  "v0.1"
> +#define IBMVSCSIS_NAMELEN 32
> +
> +#define	INITIAL_SRP_LIMIT	16
> +#define	DEFAULT_MAX_SECTORS	256
> +
> +/*
> + * Hypervisor calls.
> + */
> +#define h_copy_rdma(l, sa, sb, da, db) \
> +			plpar_hcall_norets(H_COPY_RDMA, l, sa, sb, da, db)
> +#define h_send_crq(ua, l, h) \
> +			plpar_hcall_norets(H_SEND_CRQ, ua, l, h)
> +#define h_reg_crq(ua, tok, sz)\
> +			plpar_hcall_norets(H_REG_CRQ, ua, tok, sz);
> +#define h_free_crq(ua) \
> +			plpar_hcall_norets(H_FREE_CRQ, ua);
> +
> +/*
> + * These are fixed for the system and come from the Open Firmware device tree.
> + * We just store them here to save getting them every time.
> + */
> +static char system_id[64] = "";
> +static char partition_name[97] = "UNKNOWN";
> +static unsigned int partition_number = -1;
> +
> +static LIST_HEAD(tpg_list);
> +static DEFINE_SPINLOCK(tpg_lock);
> +
> +struct ibmvscsis_nacl {
> +	/* Binary World Wide unique Port Name for SRP Initiator port */
> +	u64 iport_wwpn;
> +	/* ASCII formatted WWPN for Sas Initiator port */
> +	char iport_name[IBMVSCSIS_NAMELEN];
> +	/* Returned by ibmvscsis_make_nodeacl() */
> +	struct se_node_acl se_node_acl;
> +};
> +
> +struct ibmvscsis_tpg {
> +	struct vio_dev *dma_dev;
> +	struct list_head siblings;
> +
> +	struct se_session *se_sess;
> +
> +	struct crq_queue crq_queue;
> +
> +	struct work_struct crq_work;
> +
> +	unsigned long liobn;
> +	unsigned long riobn;
> +
> +	/* todo: remove */
> +	struct srp_target srpt;
> +
> +	/* SRP port target portal group tag for TCM */
> +	unsigned int tport_tpgt;
> +	/* Pointer back to ibmvscsis_tport */
> +	struct ibmvscsis_tport *tport;
> +	/* Returned by ibmvscsis_make_tpg() */
> +	struct se_portal_group se_tpg;
> +};
> +
> +struct ibmvscsis_tport {
> +	/* SCSI protocol the tport is providing */
> +	u8 tport_proto_id;
> +	/* Binary World Wide unique Port Name for SRP Target port */
> +	u64 tport_wwpn;
> +	/* ASCII formatted WWPN for SRP Target port */
> +	char tport_name[IBMVSCSIS_NAMELEN];
> +	/* Returned by ibmvscsis_make_tport() */
> +	struct se_wwn tport_wwn;
> +};
> +
> +static int ibmvscsis_check_true(struct se_portal_group *se_tpg)
> +{
> +	return 1;
> +}
> +
> +static int ibmvscsis_check_false(struct se_portal_group *se_tpg)
> +{
> +	return 0;
> +}
> +
> +static char *ibmvscsis_get_fabric_name(void)
> +{
> +	return "ibmvscsis";
> +}
> +
> +static u8 ibmvscsis_get_fabric_proto_ident(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
> +				struct ibmvscsis_tpg, se_tpg);
> +	struct ibmvscsis_tport *tport = tpg->tport;
> +	u8 proto_id = 0;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SRP:
> +	default:
> +#warning FIXME: Add srp_get_fabric_proto_ident()
> +#if 0
> +		proto_id = srp_get_fabric_proto_ident(se_tpg);
> +#endif
> +		break;
> +	}
> +
> +	return proto_id;
> +}
> +
> +static char *ibmvscsis_get_fabric_wwn(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
> +				struct ibmvscsis_tpg, se_tpg);
> +	struct ibmvscsis_tport *tport = tpg->tport;
> +
> +	return tport->tport_name;
> +}
> +
> +static u16 ibmvscsis_get_tag(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
> +				struct ibmvscsis_tpg, se_tpg);
> +	return tpg->tport_tpgt;
> +}
> +
> +static u32 ibmvscsis_get_default_depth(struct se_portal_group *se_tpg)
> +{
> +	return 1;
> +}
> +
> +static u32 ibmvscsis_get_pr_transport_id(struct se_portal_group *se_tpg,
> +					 struct se_node_acl *se_nacl,
> +					 struct t10_pr_registration *pr_reg,
> +					 int *format_code,
> +					 unsigned char *buf)
> +{
> +	struct ibmvscsis_tpg *tpg =
> +		container_of(se_tpg, struct ibmvscsis_tpg, se_tpg);
> +	struct ibmvscsis_tport *tport = tpg->tport;
> +	int ret = 0;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SRP:
> +	default:
> +#warning FIXME: Add srp_get_pr_transport_id()
> +#if 0
> +		ret = srp_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
> +					format_code, buf);
> +#endif
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static u32 ibmvscsis_get_pr_transport_id_len(struct se_portal_group *se_tpg,
> +					     struct se_node_acl *se_nacl,
> +					     struct t10_pr_registration *pr_reg,
> +					     int *format_code)
> +{
> +	struct ibmvscsis_tpg *tpg =
> +		container_of(se_tpg, struct ibmvscsis_tpg, se_tpg);
> +	struct ibmvscsis_tport *tport = tpg->tport;
> +	int ret = 0;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SRP:
> +	default:
> +#warning FIXME: Add srp_get_pr_transport_id_len()
> +#if 0
> +		ret = srp_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
> +					format_code);
> +#endif
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static char *ibmvscsis_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
> +						 const char *buf,
> +						 u32 *out_tid_len,
> +						 char **port_nexus_ptr)
> +{
> +	struct ibmvscsis_tpg *tpg =
> +		container_of(se_tpg, struct ibmvscsis_tpg, se_tpg);
> +	struct ibmvscsis_tport *tport = tpg->tport;
> +	char *tid = NULL;
> +
> +	switch (tport->tport_proto_id) {
> +	case SCSI_PROTOCOL_SRP:
> +	default:
> +#warning FIXME: Add srp_parse_pr_out_transport_id()
> +#if 0
> +		tid = srp_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
> +					port_nexus_ptr);
> +#endif
> +		break;
> +	}
> +
> +	return tid;
> +}
> +
> +static struct se_node_acl *ibmvscsis_alloc_fabric_acl(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_nacl *nacl;
> +
> +	nacl = kzalloc(sizeof(struct ibmvscsis_nacl), GFP_KERNEL);
> +	if (!(nacl)) {
> +		printk(KERN_ERR "Unable to alocate struct ibmvscsis_nacl\n");
> +		return NULL;
> +	}
> +
> +	return &nacl->se_node_acl;
> +}
> +
> +static void ibmvscsis_release_fabric_acl(struct se_portal_group *se_tpg,
> +					 struct se_node_acl *se_nacl)
> +{
> +	struct ibmvscsis_nacl *nacl = container_of(se_nacl,
> +			struct ibmvscsis_nacl, se_node_acl);
> +	kfree(nacl);
> +}
> +
> +static u32 ibmvscsis_tpg_get_inst_index(struct se_portal_group *se_tpg)
> +{
> +	return 1;
> +}
> +
> +static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
> +{
> +	return;
> +}
> +
> +static int ibmvscsis_shutdown_session(struct se_session *se_sess)
> +{
> +	return 0;
> +}
> +
> +static void ibmvscsis_close_session(struct se_session *se_sess)
> +{
> +	return;
> +}
> +
> +static void ibmvscsis_stop_session(struct se_session *se_sess,
> +				   int sess_sleep , int conn_sleep)
> +{
> +	return;
> +}
> +
> +static void ibmvscsis_reset_nexus(struct se_session *se_sess)
> +{
> +	return;
> +}
> +
> +static int ibmvscsis_sess_logged_in(struct se_session *se_sess)
> +{
> +	return 0;
> +}
> +
> +static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
> +{
> +	return 0;
> +}
> +
> +static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static int ibmvscsis_write_pending_status(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static void ibmvscsis_set_default_node_attrs(struct se_node_acl *nacl)
> +{
> +	return;
> +}
> +
> +static u32 ibmvscsis_get_task_tag(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static int ibmvscsis_get_cmd_state(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static void ibmvscsis_new_cmd_failure(struct se_cmd *se_cmd)
> +{
> +	return;
> +}
> +
> +static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static int ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static u16 ibmvscsis_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_length)
> +{
> +	return 0;
> +}
> +
> +static u16 ibmvscsis_get_fabric_sense_len(void)
> +{
> +	return 0;
> +}
> +
> +static int ibmvscsis_is_state_remove(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static u64 ibmvscsis_pack_lun(unsigned int lun)
> +{
> +	WARN_ON(lun >= 256);
> +	/* Caller wants this byte-swapped */
> +	return cpu_to_le64((lun & 0xff) << 8);
> +}
> +
> +/* Local pointer to allocated TCM configfs fabric module */
> +static struct target_fabric_configfs *ibmvscsis_fabric_configfs;
> +
> +static struct se_node_acl *ibmvscsis_make_nodeacl(
> +	struct se_portal_group *se_tpg,
> +	struct config_group *group,
> +	const char *name)
> +{
> +	struct se_node_acl *se_nacl, *se_nacl_new;
> +	struct ibmvscsis_nacl *nacl;
> +	u64 wwpn = 0;
> +	u32 nexus_depth;
> +
> +	printk("%s %d: %s\n", __func__, __LINE__, name);
> +
> +	se_nacl_new = ibmvscsis_alloc_fabric_acl(se_tpg);
> +	if (!(se_nacl_new))
> +		return ERR_PTR(-ENOMEM);
> +//#warning FIXME: Hardcoded nexus depth in ibmvscsis_make_nodeacl()
> +	nexus_depth = 1;
> +	/*
> +	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
> +	 * when converting a NodeACL from demo mode -> explict
> +	 */
> +	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
> +				name, nexus_depth);
> +	if (IS_ERR(se_nacl)) {
> +		ibmvscsis_release_fabric_acl(se_tpg, se_nacl_new);
> +		return se_nacl;
> +	}
> +	/*
> +	 * Locate our struct ibmvscsis_nacl and set the FC Nport WWPN
> +	 */
> +	nacl = container_of(se_nacl, struct ibmvscsis_nacl, se_node_acl);
> +	nacl->iport_wwpn = wwpn;
> +	/* ibmvscsis_format_wwn(&nacl->iport_name[0], IBMVSCSIS_NAMELEN, wwpn); */
> +
> +	return se_nacl;
> +}
> +
> +static void ibmvscsis_drop_nodeacl(struct se_node_acl *se_acl)
> +{
> +	struct ibmvscsis_nacl *nacl = container_of(se_acl,
> +				struct ibmvscsis_nacl, se_node_acl);
> +	kfree(nacl);
> +}
> +
> +static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
> +						  struct config_group *group,
> +						  const char *name)
> +{
> +	struct ibmvscsis_tport*tport = container_of(wwn,
> +			struct ibmvscsis_tport, tport_wwn);
> +
> +	struct ibmvscsis_tpg *tpg;
> +	unsigned long tpgt;
> +	int ret;
> +	unsigned long flags;
> +
> +	if (strstr(name, "tpgt_") != name)
> +		return ERR_PTR(-EINVAL);
> +	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
> +		return ERR_PTR(-EINVAL);
> +
> +	spin_lock_irqsave(&tpg_lock, flags);
> +	list_for_each_entry(tpg, &tpg_list, siblings) {
> +		printk("%s %d: %s %u, %lu\n", __func__, __LINE__,
> +		       dev_name(&tpg->dma_dev->dev),
> +		       tpg->tport_tpgt, tpgt);
> +
> +		if (tpgt == tpg->tport_tpgt)
> +			goto found;
> +	}
> +	printk("%s %d: can't find %s\n", __func__, __LINE__, name);
> +	ret = -EINVAL;
> +	goto unlock;
> +found:
> +	if (tpg->tport) {
> +		printk("%s %d: already bind %s\n", __func__, __LINE__, name);
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	tpg->tport = tport;
> +
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +
> +	ret = core_tpg_register(&ibmvscsis_fabric_configfs->tf_ops, wwn,
> +				&tpg->se_tpg, (void *)tpg,
> +				TRANSPORT_TPG_TYPE_NORMAL);
> +	if (ret)
> +		return ERR_PTR(-ENOMEM);
> +
> +	printk("%s %d: %d\n", __func__, __LINE__, ret);
> +
> +	tpg->se_sess = transport_init_session();
> +	if (!tpg->se_sess) {
> +		core_tpg_deregister(&tpg->se_tpg);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	printk("%s %d\n", __func__, __LINE__);
> +
> +	tpg->se_sess->se_node_acl =
> +		core_tpg_check_initiator_node_acl(&tpg->se_tpg,
> +						  (unsigned char*)dev_name(&tpg->dma_dev->dev));
> +
> +	transport_register_session(&tpg->se_tpg, tpg->se_sess->se_node_acl,
> +				   tpg->se_sess, tpg);
> +
> +	printk("%s %d: %p %p\n", __func__, __LINE__, tpg, &tpg->se_tpg);
> +
> +	return &tpg->se_tpg;
> +unlock:
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +	return ERR_PTR(ret);
> +}
> +
> +static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
> +				struct ibmvscsis_tpg, se_tpg);
> +	unsigned long flags;
> +
> +
> +	transport_deregister_session_configfs(tpg->se_sess);
> +	transport_free_session(tpg->se_sess);
> +	core_tpg_deregister(se_tpg);
> +
> +	spin_lock_irqsave(&tpg_lock, flags);
> +	tpg->tport = NULL;
> +	tpg->se_sess = NULL;
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +}
> +
> +static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
> +					   struct config_group *group,
> +					   const char *name)
> +{
> +	struct ibmvscsis_tport *tport;
> +
> +	printk("%s %d: create %s\n", __func__, __LINE__, name);
> +
> +	tport = kzalloc(sizeof(*tport), GFP_KERNEL);
> +	if (!(tport)) {
> +		printk(KERN_ERR "Unable to allocate struct tcm_ibmvscsis_tport");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	/* tport->tport_wwpn = wwpn; */
> +
> +	return &tport->tport_wwn;
> +}
> +
> +static void ibmvscsis_drop_tport(struct se_wwn *wwn)
> +{
> +	struct ibmvscsis_tport *tport = container_of(wwn,
> +				struct ibmvscsis_tport, tport_wwn);
> +	kfree(tport);
> +}
> +
> +static ssize_t ibmvscsis_wwn_show_attr_version(struct target_fabric_configfs *tf,
> +					       char *page)
> +{
> +	return sprintf(page, "IBMVSCSIS fabric module %s on %s/%s"
> +		"on "UTS_RELEASE"\n", IBMVSCSIS_VERSION, utsname()->sysname,
> +		utsname()->machine);
> +}
> +
> +TF_WWN_ATTR_RO(ibmvscsis, version);
> +
> +static struct configfs_attribute *ibmvscsis_wwn_attrs[] = {
> +	&ibmvscsis_wwn_version.attr,
> +	NULL,
> +};
> +
> +static struct target_core_fabric_ops ibmvscsis_ops = {
> +	.get_fabric_name		= ibmvscsis_get_fabric_name,
> +	.get_fabric_proto_ident		= ibmvscsis_get_fabric_proto_ident,
> +	.tpg_get_wwn			= ibmvscsis_get_fabric_wwn,
> +	.tpg_get_tag			= ibmvscsis_get_tag,
> +	.tpg_get_default_depth		= ibmvscsis_get_default_depth,
> +	.tpg_get_pr_transport_id	= ibmvscsis_get_pr_transport_id,
> +	.tpg_get_pr_transport_id_len	= ibmvscsis_get_pr_transport_id_len,
> +	.tpg_parse_pr_out_transport_id	= ibmvscsis_parse_pr_out_transport_id,
> +	.tpg_check_demo_mode		= ibmvscsis_check_true,
> +	.tpg_check_demo_mode_cache	= ibmvscsis_check_true,
> +	.tpg_check_demo_mode_write_protect = ibmvscsis_check_true,
> +	.tpg_check_prod_mode_write_protect = ibmvscsis_check_false,
> +	.tpg_alloc_fabric_acl		= ibmvscsis_alloc_fabric_acl,
> +	.tpg_release_fabric_acl		= ibmvscsis_release_fabric_acl,
> +	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
> +	.release_cmd_to_pool		= ibmvscsis_release_cmd,
> +	.release_cmd_direct		= ibmvscsis_release_cmd,
> +	.shutdown_session		= ibmvscsis_shutdown_session,
> +	.close_session			= ibmvscsis_close_session,
> +	.stop_session			= ibmvscsis_stop_session,
> +	.fall_back_to_erl0		= ibmvscsis_reset_nexus,
> +	.sess_logged_in			= ibmvscsis_sess_logged_in,
> +	.sess_get_index			= ibmvscsis_sess_get_index,
> +	.sess_get_initiator_sid		= NULL,
> +	.write_pending			= ibmvscsis_write_pending,
> +	.write_pending_status		= ibmvscsis_write_pending_status,
> +	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
> +	.get_task_tag			= ibmvscsis_get_task_tag,
> +	.get_cmd_state			= ibmvscsis_get_cmd_state,
> +	.new_cmd_failure		= ibmvscsis_new_cmd_failure,
> +	.queue_data_in			= ibmvscsis_queue_data_in,
> +	.queue_status			= ibmvscsis_queue_status,
> +	.queue_tm_rsp			= ibmvscsis_queue_tm_rsp,
> +	.get_fabric_sense_len		= ibmvscsis_get_fabric_sense_len,
> +	.set_fabric_sense_len		= ibmvscsis_set_fabric_sense_len,
> +	.is_state_remove		= ibmvscsis_is_state_remove,
> +	.pack_lun			= ibmvscsis_pack_lun,
> +	/*
> +	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
> +	 */
> +	.fabric_make_wwn		= ibmvscsis_make_tport,
> +	.fabric_drop_wwn		= ibmvscsis_drop_tport,
> +	.fabric_make_tpg		= ibmvscsis_make_tpg,
> +	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
> +	.fabric_post_link		= NULL,
> +	.fabric_pre_unlink		= NULL,
> +	.fabric_make_np			= NULL,
> +	.fabric_drop_np			= NULL,
> +	.fabric_make_nodeacl		= ibmvscsis_make_nodeacl,
> +	.fabric_drop_nodeacl		= ibmvscsis_drop_nodeacl,
> +};
> +
> +static inline union viosrp_iu *vio_iu(struct iu_entry *iue)
> +{
> +	return (union viosrp_iu *) (iue->sbuf->buf);
> +}
> +
> +static int send_iu(struct iu_entry *iue, u64 length, u8 format)
> +{
> +	struct srp_target *target = iue->target;
> +	struct ibmvscsis_tpg *tpg = target->ldata;
> +	long rc, rc1;
> +	union {
> +		struct viosrp_crq cooked;
> +		u64 raw[2];
> +	} crq;
> +
> +	/* First copy the SRP */
> +	rc = h_copy_rdma(length, tpg->liobn, iue->sbuf->dma,
> +			 tpg->riobn, iue->remote_token);
> +
> +	if (rc)
> +		printk(KERN_ERR "Error %ld transferring data\n", rc);
> +
> +	crq.cooked.valid = 0x80;
> +	crq.cooked.format = format;
> +	crq.cooked.reserved = 0x00;
> +	crq.cooked.timeout = 0x00;
> +	crq.cooked.IU_length = length;
> +	crq.cooked.IU_data_ptr = vio_iu(iue)->srp.rsp.tag;
> +
> +	if (rc == 0)
> +		crq.cooked.status = 0x99;	/* Just needs to be non-zero */
> +	else
> +		crq.cooked.status = 0x00;
> +
> +	rc1 = h_send_crq(tpg->dma_dev->unit_address, crq.raw[0], crq.raw[1]);
> +
> +	if (rc1) {
> +		printk(KERN_ERR "%ld sending response\n", rc1);
> +		return rc1;
> +	}
> +
> +	return rc;
> +}
> +
> +#define SRP_RSP_SENSE_DATA_LEN	18
> +
> +static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
> +		    unsigned char status, unsigned char asc)
> +{
> +	union viosrp_iu *iu = vio_iu(iue);
> +	uint64_t tag = iu->srp.rsp.tag;
> +
> +	/* If the linked bit is on and status is good */
> +	if (test_bit(V_LINKED, &iue->flags) && (status == NO_SENSE))
> +		status = 0x10;
> +
> +	memset(iu, 0, sizeof(struct srp_rsp));
> +	iu->srp.rsp.opcode = SRP_RSP;
> +	iu->srp.rsp.req_lim_delta = 1;
> +	iu->srp.rsp.tag = tag;
> +
> +	if (test_bit(V_DIOVER, &iue->flags))
> +		iu->srp.rsp.flags |= SRP_RSP_FLAG_DIOVER;
> +
> +	iu->srp.rsp.data_in_res_cnt = 0;
> +	iu->srp.rsp.data_out_res_cnt = 0;
> +
> +	iu->srp.rsp.flags &= ~SRP_RSP_FLAG_RSPVALID;
> +
> +	iu->srp.rsp.resp_data_len = 0;
> +	iu->srp.rsp.status = status;
> +	if (status) {
> +		uint8_t *sense = iu->srp.rsp.data;
> +
> +		if (sc) {
> +			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
> +			iu->srp.rsp.sense_data_len = SCSI_SENSE_BUFFERSIZE;
> +			memcpy(sense, sc->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> +		} else {
> +			iu->srp.rsp.status = SAM_STAT_CHECK_CONDITION;
> +			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
> +			iu->srp.rsp.sense_data_len = SRP_RSP_SENSE_DATA_LEN;
> +
> +			/* Valid bit and 'current errors' */
> +			sense[0] = (0x1 << 7 | 0x70);
> +			/* Sense key */
> +			sense[2] = status;
> +			/* Additional sense length */
> +			sense[7] = 0xa;	/* 10 bytes */
> +			/* Additional sense code */
> +			sense[12] = asc;
> +		}
> +	}
> +
> +	send_iu(iue, sizeof(iu->srp.rsp) + SRP_RSP_SENSE_DATA_LEN,
> +		VIOSRP_SRP_FORMAT);
> +
> +	return 0;
> +}
> +
> +static int send_adapter_info(struct iu_entry *iue,
> +			     dma_addr_t remote_buffer, u16 length)
> +{
> +	struct srp_target *target = iue->target;
> +	struct ibmvscsis_tpg *tpg = target->ldata;
> +	dma_addr_t data_token;
> +	struct mad_adapter_info_data *info;
> +	int err;
> +
> +	info = dma_alloc_coherent(&tpg->dma_dev->dev, sizeof(*info), &data_token,
> +				  GFP_KERNEL);
> +	if (!info) {
> +		printk(KERN_ERR "bad dma_alloc_coherent %p\n", target);
> +		return 1;
> +	}
> +
> +	/* Get remote info */
> +	err = h_copy_rdma(sizeof(*info), tpg->riobn, remote_buffer,
> +			  tpg->liobn, data_token);
> +	if (err == H_SUCCESS) {
> +		printk(KERN_INFO "Client connect: %s (%d)\n",
> +		       info->partition_name, info->partition_number);
> +	}
> +
> +	memset(info, 0, sizeof(*info));
> +
> +	strcpy(info->srp_version, "16.a");
> +	strncpy(info->partition_name, partition_name,
> +		sizeof(info->partition_name));
> +	info->partition_number = partition_number;
> +	info->mad_version = 1;
> +	info->os_type = 2;
> +	info->port_max_txu[0] = DEFAULT_MAX_SECTORS << 9;
> +
> +	/* Send our info to remote */
> +	err = h_copy_rdma(sizeof(*info), tpg->liobn, data_token,
> +			  tpg->riobn, remote_buffer);
> +
> +	dma_free_coherent(&tpg->dma_dev->dev, sizeof(*info), info, data_token);
> +
> +	if (err != H_SUCCESS) {
> +		printk(KERN_INFO "Error sending adapter info %d\n", err);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int process_mad_iu(struct iu_entry *iue)
> +{
> +	union viosrp_iu *iu = vio_iu(iue);
> +	struct viosrp_adapter_info *info;
> +	struct viosrp_host_config *conf;
> +
> +	switch (iu->mad.empty_iu.common.type) {
> +	case VIOSRP_EMPTY_IU_TYPE:
> +		printk(KERN_ERR "%s\n", "Unsupported EMPTY MAD IU");
> +		break;
> +	case VIOSRP_ERROR_LOG_TYPE:
> +		printk(KERN_ERR "%s\n", "Unsupported ERROR LOG MAD IU");
> +		iu->mad.error_log.common.status = 1;
> +		send_iu(iue, sizeof(iu->mad.error_log),	VIOSRP_MAD_FORMAT);
> +		break;
> +	case VIOSRP_ADAPTER_INFO_TYPE:
> +		info = &iu->mad.adapter_info;
> +		info->common.status = send_adapter_info(iue, info->buffer,
> +							info->common.length);
> +		send_iu(iue, sizeof(*info), VIOSRP_MAD_FORMAT);
> +		break;
> +	case VIOSRP_HOST_CONFIG_TYPE:
> +		conf = &iu->mad.host_config;
> +		conf->common.status = 1;
> +		send_iu(iue, sizeof(*conf), VIOSRP_MAD_FORMAT);
> +		break;
> +	default:
> +		printk(KERN_ERR "Unknown type %u\n", iu->srp.rsp.opcode);
> +	}
> +
> +	return 1;
> +}
> +
> +static void process_login(struct iu_entry *iue)
> +{
> +	union viosrp_iu *iu = vio_iu(iue);
> +	struct srp_login_rsp *rsp = &iu->srp.login_rsp;
> +	u64 tag = iu->srp.rsp.tag;
> +
> +	/* TODO handle case that requested size is wrong and
> +	 * buffer format is wrong
> +	 */
> +	memset(iu, 0, sizeof(struct srp_login_rsp));
> +	rsp->opcode = SRP_LOGIN_RSP;
> +	rsp->req_lim_delta = INITIAL_SRP_LIMIT;
> +	rsp->tag = tag;
> +	rsp->max_it_iu_len = sizeof(union srp_iu);
> +	rsp->max_ti_iu_len = sizeof(union srp_iu);
> +	/* direct and indirect */
> +	rsp->buf_fmt = SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT;
> +
> +	send_iu(iue, sizeof(*rsp), VIOSRP_SRP_FORMAT);
> +}
> +
> +static int process_srp_iu(struct iu_entry *iue)
> +{
> +	union viosrp_iu *iu = vio_iu(iue);
> +	struct srp_target *target = iue->target;
> +	int done = 1;
> +	u8 opcode = iu->srp.rsp.opcode;
> +	unsigned long flags;
> +
> +	switch (opcode) {
> +	case SRP_LOGIN_REQ:
> +		process_login(iue);
> +		break;
> +	case SRP_TSK_MGMT:
> +		/* done = process_tsk_mgmt(iue); */
> +		break;
> +	case SRP_CMD:
> +		spin_lock_irqsave(&target->lock, flags);
> +		list_add_tail(&iue->ilist, &target->cmd_queue);
> +		spin_unlock_irqrestore(&target->lock, flags);
> +		done = 0;
> +		break;
> +	case SRP_LOGIN_RSP:
> +	case SRP_I_LOGOUT:
> +	case SRP_T_LOGOUT:
> +	case SRP_RSP:
> +	case SRP_CRED_REQ:
> +	case SRP_CRED_RSP:
> +	case SRP_AER_REQ:
> +	case SRP_AER_RSP:
> +		printk(KERN_ERR "Unsupported type %u\n", opcode);
> +		break;
> +	default:
> +		printk(KERN_ERR "Unknown type %u\n", opcode);
> +	}
> +
> +	return done;
> +}
> +
> +static void process_iu(struct viosrp_crq *crq, struct ibmvscsis_tpg *tpg)
> +{
> +	struct iu_entry *iue;
> +	long err;
> +	int done = 1;
> +
> +	iue = srp_iu_get(&tpg->srpt);
> +	if (!iue) {
> +		printk(KERN_ERR "Error getting IU from pool\n");
> +		return;
> +	}
> +
> +	iue->remote_token = crq->IU_data_ptr;
> +
> +	err = h_copy_rdma(crq->IU_length, tpg->riobn,
> +			  iue->remote_token, tpg->liobn, iue->sbuf->dma);
> +
> +	if (err != H_SUCCESS) {
> +		printk(KERN_ERR "%ld transferring data error %p\n", err, iue);
> +		goto out;
> +	}
> +
> +	if (crq->format == VIOSRP_MAD_FORMAT)
> +		done = process_mad_iu(iue);
> +	else
> +		done = process_srp_iu(iue);
> +out:
> +	if (done)
> +		srp_iu_put(iue);
> +}
> +
> +static void process_crq(struct viosrp_crq *crq,	struct ibmvscsis_tpg *tpg)
> +{
> +	/* printk(KERN_INFO "%s: %p %x %x\n", __func__, */
> +	/*        tpg, crq->valid, crq->format); */
> +
> +	switch (crq->valid) {
> +	case 0xC0:
> +		/* initialization */
> +		switch (crq->format) {
> +		case 0x01:
> +			h_send_crq(tpg->dma_dev->unit_address,
> +				   0xC002000000000000, 0);
> +			break;
> +		case 0x02:
> +			break;
> +		default:
> +			printk("Unknown format %u\n", crq->format);
> +		}
> +		break;
> +	case 0xFF:
> +		/* transport event */
> +		break;
> +	case 0x80:
> +		/* real payload */
> +		switch (crq->format) {
> +		case VIOSRP_SRP_FORMAT:
> +		case VIOSRP_MAD_FORMAT:
> +			process_iu(crq, tpg);
> +			break;
> +		case VIOSRP_OS400_FORMAT:
> +		case VIOSRP_AIX_FORMAT:
> +		case VIOSRP_LINUX_FORMAT:
> +		case VIOSRP_INLINE_FORMAT:
> +			printk(KERN_ERR "Unsupported format %u\n", crq->format);
> +			break;
> +		default:
> +			printk(KERN_ERR "Unknown format %u\n", crq->format);
> +		}
> +		break;
> +	default:
> +		printk(KERN_ERR "unknown message type 0x%02x!?\n", crq->valid);
> +	}
> +}
> +
> +static inline struct viosrp_crq *next_crq(struct crq_queue *queue)
> +{
> +	struct viosrp_crq *crq;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&queue->lock, flags);
> +	crq = &queue->msgs[queue->cur];
> +	if (crq->valid & 0x80) {
> +		if (++queue->cur == queue->size)
> +			queue->cur = 0;
> +	} else
> +		crq = NULL;
> +	spin_unlock_irqrestore(&queue->lock, flags);
> +
> +	return crq;
> +}
> +
> +#if 0
> +static int srp_queuecommand(struct ibmvscsis_tpg *tpg,
> +			    struct srp_cmd *cmd)
> +{
> +	struct se_cmd *se_cmd;
> +	int attr;
> +	int data_len;
> +	int ret;
> +
> +	/* TODO: pre-allocate */
> +	vcmd = kzalloc(sizeof(*vcmd), GFP_ATOMIC);
> +	if (!vcmd)
> +		return -ENOMEM;
> +
> +	switch (cmd->task_attr) {
> +	case SRP_SIMPLE_TASK:
> +		attr = MSG_SIMPLE_TAG;
> +		break;
> +	case SRP_ORDERED_TASK:
> +		attr = MSG_ORDERED_TAG;
> +		break;
> +	case SRP_HEAD_TASK:
> +		attr = MSG_HEAD_TAG;
> +		break;
> +	default:
> +		printk(KERN_WARNING "Task attribute %d not supported\n",
> +		       cmd->task_attr);
> +		attr = MSG_SIMPLE_TAG;
> +	}
> +
> +	data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
> +
> +	se_cmd = &vcmd->se_cmd;
> +
> +	transport_init_se_cmd(se_cmd,
> +			      &ibmvscsis_fabric_configfs->tf_ops,
> +			      tpg->se_sess, data_len, srp_cmd_direction(cmd),
> +			      attr, vcmd->sense);
> +
> +	ret = transport_get_lun_for_cmd(se_cmd, NULL, cmd->lun);
> +	if (ret) {
> +		printk(KERN_ERR "invalid lun %lu\n", (unsigned long)cmd->lun);
> +		transport_send_check_condition_and_sense(se_cmd,
> +							 se_cmd->scsi_sense_reason,
> +							 0);
> +		return ret;
> +	}
> +
> +	transport_device_setup_cmd(se_cmd);
> +
> +	se_cmd->transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
> +
> +	return 0;
> +}
> +#endif
> +
> +#define GETTARGET(x) ((int)((((u64)(x)) >> 56) & 0x003f))
> +#define GETBUS(x) ((int)((((u64)(x)) >> 53) & 0x0007))
> +#define GETLUN(x) ((int)((((u64)(x)) >> 48) & 0x001f))
> +
> +static u64 scsi_lun_to_int(u64 lun)
> +{
> +	if (GETBUS(lun) || GETLUN(lun))
> +		return ~0UL;
> +	else
> +		return GETTARGET(lun);
> +}
> +
> +struct inquiry_data {
> +	u8 qual_type;
> +	u8 rmb_reserve;
> +	u8 version;
> +	u8 aerc_naca_hisup_format;
> +	u8 addl_len;
> +	u8 sccs_reserved;
> +	u8 bque_encserv_vs_multip_mchngr_reserved;
> +	u8 reladr_reserved_linked_cmdqueue_vs;
> +	char vendor[8];
> +	char product[16];
> +	char revision[4];
> +	char vendor_specific[20];
> +	char reserved1[2];
> +	char version_descriptor[16];
> +	char reserved2[22];
> +	char unique[158];
> +};
> +
> +static u64 make_lun(unsigned int bus, unsigned int target, unsigned int lun)
> +{
> +	u16 result = (0x8000 |
> +			   ((target & 0x003f) << 8) |
> +			   ((bus & 0x0007) << 5) |
> +			   (lun & 0x001f));
> +	return ((u64) result) << 48;
> +}
> +
> +static int ibmvscsis_inquery(struct ibmvscsis_tpg *tpg,
> +			      struct srp_cmd *cmd, char *data)
> +{
> +	struct se_portal_group *se_tpg = &tpg->se_tpg;
> +	struct inquiry_data *id = (struct inquiry_data *)data;
> +	u64 unpacked_lun, lun = cmd->lun;
> +	u8 *cdb = cmd->cdb;
> +	int len;
> +
> +	if (!data)
> +		printk(KERN_INFO "%s %d: oomu\n", __func__, __LINE__);
> +
> +	if (((cdb[1] & 0x3) == 0x3) || (!(cdb[1] & 0x3) && cdb[2])) {
> +		printk(KERN_INFO "%s %d: invalid req\n", __func__, __LINE__);
> +		return 0;
> +	}
> +
> +	if (cdb[1] & 0x3)
> +		printk(KERN_INFO "%s %d: needs the normal path\n", __func__, __LINE__);
> +	else {
> +		id->qual_type = TYPE_DISK;
> +		id->rmb_reserve = 0x00;
> +		id->version = 0x84; /* ISO/IE */
> +		id->aerc_naca_hisup_format = 0x22; /* naca & fmt 0x02 */
> +		id->addl_len = sizeof(*id) - 4;
> +		id->bque_encserv_vs_multip_mchngr_reserved = 0x00;
> +		id->reladr_reserved_linked_cmdqueue_vs = 0x02; /* CMDQ */
> +		memcpy(id->vendor, "IBM	    ", 8);
> +		/*
> +		 * Don't even ask about the next bit.  AIX uses
> +		 * hardcoded device naming to recognize device types
> +		 * and their client won't  work unless we use VOPTA and
> +		 * VDASD.
> +		 */
> +		if (id->qual_type == TYPE_ROM)
> +			memcpy(id->product, "VOPTA blkdev    ", 16);
> +		else
> +			memcpy(id->product, "VDASD blkdev    ", 16);
> +
> +		memcpy(id->revision, "0001", 4);
> +
> +		snprintf(id->unique, sizeof(id->unique),
> +			 "IBM-VSCSI-%s-P%d-%x-%d-%d-%d\n",
> +			 system_id,
> +			 partition_number,
> +			 tpg->dma_dev->unit_address,
> +			 GETBUS(lun),
> +			 GETTARGET(lun),
> +			 GETLUN(lun));
> +	}
> +
> +	len = min_t(int, sizeof(*id), cdb[4]);
> +
> +	printk(KERN_INFO "%s %d: %lu\n", __func__, __LINE__,
> +	       (unsigned long) lun);
> +
> +	unpacked_lun = scsi_lun_to_int(cmd->lun);
> +
> +	printk("%s %d: %lu\n", __func__, __LINE__, (unsigned long)unpacked_lun);
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +
> +	if (unpacked_lun < TRANSPORT_MAX_LUNS_PER_TPG &&
> +	    se_tpg->tpg_lun_list[unpacked_lun].lun_status == TRANSPORT_LUN_STATUS_ACTIVE)
> +		;
> +	else {
> +		printk("%s %d: no lun %lu\n",
> +		       __func__, __LINE__, (unsigned long)unpacked_lun);
> +		data[0] = TYPE_NO_LUN;
> +	}
> +
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +
> +	return len;
> +}
> +
> +static int ibmvscsis_report_luns(struct ibmvscsis_tpg *tpg,
> +				 struct srp_cmd *cmd, u64 *data)
> +{
> +	u64 lun;
> +	struct se_portal_group *se_tpg = &tpg->se_tpg;
> +	int i, idx;
> +	int alen, oalen, nr_luns, rbuflen = 4096;
> +
> +	printk(KERN_INFO "%s %d: %p\n", __func__, __LINE__, se_tpg);
> +
> +	alen = get_unaligned_be32(&cmd->cdb[6]);
> +
> +	alen &= ~(8 - 1);
> +	oalen = alen;
> +
> +	if (cmd->lun) {
> +		nr_luns = 1;
> +		goto done;
> +	}
> +
> +	alen -= 8;
> +	rbuflen -= 8; /* FIXME */
> +	idx = 2;
> +	nr_luns = 1;
> +
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +	for (i = 0; i < 255; i++) {
> +		if (se_tpg->tpg_lun_list[i].lun_status !=
> +		    TRANSPORT_LUN_STATUS_ACTIVE)
> +			continue;
> +
> +		printk(KERN_INFO "%s %d %d\n", __func__, __LINE__, i);
> +
> +		lun = make_lun(0, i & 0x003f, 0);
> +		data[idx++] = cpu_to_be64(lun);
> +		if (!(alen -= 8))
> +			break;
> +		if (!(rbuflen -= 8)) {
> +			printk(KERN_ERR "FIXME: too many luns\n");
> +			break;
> +		}
> +		nr_luns++;
> +	}
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +done:
> +	printk(KERN_INFO "%s %d: %d\n", __func__, __LINE__, nr_luns);
> +	put_unaligned_be32(nr_luns * 8, data);
> +	return min(oalen, nr_luns * 8 + 8);
> +
> +	/* scsi_set_in_resid_by_actual(cmd, 0); */
> +	/* sense_data_build(cmd, key, asc); */
> +	return SAM_STAT_CHECK_CONDITION;
> +}
> +
> +static int ibmvscsis_read_capacity(struct ibmvscsis_tpg *tpg,
> +				   struct srp_cmd *cmd, char *data)
> +{
> +	struct se_portal_group *se_tpg = &tpg->se_tpg;
> +	u64 unpacked_lun;
> +	struct se_lun *lun;
> +	u32 blocks;
> +
> +	unpacked_lun = scsi_lun_to_int(cmd->lun);
> +
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +
> +	lun = &se_tpg->tpg_lun_list[unpacked_lun];
> +
> +	blocks = TRANSPORT(lun->lun_se_dev)->get_blocks(lun->lun_se_dev);
> +
> +	printk(KERN_INFO "%s %d: %p %u\n",
> +	       __func__, __LINE__, se_tpg, blocks);
> +
> +	put_unaligned_be32(blocks - 1, data);
> +	put_unaligned_be32(512, data + 4);
> +
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +
> +	return 8;
> +}
> +
> +static int ibmvscsis_mode_sense(struct ibmvscsis_tpg *tpg,
> +				   struct srp_cmd *cmd, char *mode)
> +{
> +	int bytes;
> +	struct se_portal_group *se_tpg = &tpg->se_tpg;
> +	u64 unpacked_lun;
> +	struct se_lun *lun;
> +	u32 blocks;
> +
> +	unpacked_lun = scsi_lun_to_int(cmd->lun);
> +
> +	printk(KERN_INFO "%s %d: %p %lu\n",
> +	       __func__, __LINE__, se_tpg, (unsigned long)unpacked_lun);
> +
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +
> +	lun = &se_tpg->tpg_lun_list[unpacked_lun];
> +
> +	blocks = TRANSPORT(lun->lun_se_dev)->get_blocks(lun->lun_se_dev);
> +
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +
> +	switch (cmd->cdb[2]) {
> +	case 0:
> +	case 0x3f:
> +		mode[1] = 0x00;	/* Default medium */
> +		/* if (iue->req.vd->b.ro) */
> +		if (0)
> +			mode[2] = 0x80;	/* device specific  */
> +		else
> +			mode[2] = 0x00;	/* device specific  */
> +
> +		/* note the DPOFUA bit is set to zero! */
> +		mode[3] = 0x08;	/* block descriptor length */
> +		*((u32 *) & mode[4]) = blocks - 1;
> +		*((u32 *) & mode[8]) = 512;
> +		bytes = mode[0] = 12;	/* length */
> +		break;
> +
> +	case 0x08:		/* Cache page */
> +		/* /\* length should be 4 *\/ */
> +		/* if (cmd->cdb[4] != 4 */
> +		/*     && cmd->cdb[4] != 0x20) { */
> +		/* 	send_rsp(iue, ILLEGAL_REQUEST, 0x20); */
> +		/* 	dma_free_coherent(iue->adapter->dev, */
> +		/* 			  MODE_SENSE_BUFFER_SIZE, */
> +		/* 			  mode, data_token); */
> +		/* 	return FREE_IU; */
> +		/* } */
> +
> +		mode[1] = 0x00;	/* Default medium */
> +		if (0)
> +			mode[2] = 0x80;	/* device specific */
> +		else
> +			mode[2] = 0x00;	/* device specific */
> +
> +		/* note the DPOFUA bit is set to zero! */
> +		mode[3] = 0x08;	/* block descriptor length */
> +		*((u32 *) & mode[4]) = blocks - 1;
> +		*((u32 *) & mode[8]) = 512;
> +
> +		/* Cache page */
> +		mode[12] = 0x08;    /* page */
> +		mode[13] = 0x12;    /* page length */
> +		mode[14] = 0x01;    /* no cache (0x04 for read/write cache) */
> +
> +		bytes = mode[0] = 12 + mode[13];	/* length */
> +		break;
> +	}
> +
> +	return bytes;
> +}
> +
> +static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
> +			  struct srp_direct_buf *md, int nmd,
> +			  enum dma_data_direction dir, unsigned int rest)
> +{
> +	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
> +	struct srp_target *target = iue->target;
> +	struct ibmvscsis_tpg *tpg = target->ldata;
> +	dma_addr_t token;
> +	long err;
> +	unsigned int done = 0;
> +	int i, sidx, soff;
> +
> +	printk(KERN_INFO "%s %d: %x %u\n", __func__, __LINE__,
> +	       sc->cmnd[0], rest);
> +
> +	sidx = soff = 0;
> +	token = sg_dma_address(sg + sidx);
> +
> +	for (i = 0; i < nmd && rest; i++) {
> +		unsigned int mdone, mlen;
> +
> +		mlen = min(rest, md[i].len);
> +		for (mdone = 0; mlen;) {
> +			int slen = min(sg_dma_len(sg + sidx) - soff, mlen);
> +
> +			if (dir == DMA_TO_DEVICE)
> +				err = h_copy_rdma(slen,
> +						  tpg->riobn,
> +						  md[i].va + mdone,
> +						  tpg->liobn,
> +						  token + soff);
> +			else
> +				err = h_copy_rdma(slen,
> +						  tpg->liobn,
> +						  token + soff,
> +						  tpg->riobn,
> +						  md[i].va + mdone);
> +
> +			if (err != H_SUCCESS) {
> +				printk(KERN_ERR "rdma error %d %d %ld\n",
> +				       dir, slen, err);
> +				return -EIO;
> +			}
> +
> +			mlen -= slen;
> +			mdone += slen;
> +			soff += slen;
> +			done += slen;
> +
> +			if (soff == sg_dma_len(sg + sidx)) {
> +				sidx++;
> +				soff = 0;
> +				token = sg_dma_address(sg + sidx);
> +
> +				if (sidx > nsg) {
> +					printk(KERN_ERR "out of sg %p %d %d\n",
> +						iue, sidx, nsg);
> +					return -EIO;
> +				}
> +			}
> +		};
> +
> +		rest -= mlen;
> +	}
> +	return 0;
> +}
> +
> +static int ibmvscsis_cmd_done(struct scsi_cmnd *sc)
> +{
> +	unsigned long flags;
> +	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
> +	struct srp_target *target = iue->target;
> +	int err = 0;
> +
> +	/* printk(KERN_INFO "%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0], */
> +	/*        scsi_sg_count(sc)); */
> +
> +	if (scsi_sg_count(sc))
> +		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma, 1, 1);
> +
> +	spin_lock_irqsave(&target->lock, flags);
> +	list_del(&iue->ilist);
> +	spin_unlock_irqrestore(&target->lock, flags);
> +
> +	if (err || sc->result != SAM_STAT_GOOD) {
> +		printk(KERN_ERR "operation failed %p %d %x\n",
> +		       iue, sc->result, vio_iu(iue)->srp.cmd.cdb[0]);
> +		send_rsp(iue, sc, HARDWARE_ERROR, 0x00);
> +	} else
> +		send_rsp(iue, sc, NO_SENSE, 0x00);
> +
> +	/* done(sc); */
> +	srp_iu_put(iue);
> +	return 0;
> +}
> +
> +static int ibmvscsis_queuecommand(struct ibmvscsis_tpg *tpg,
> +				  struct iu_entry *iue)
> +{
> +	int data_len;
> +	struct srp_cmd *cmd = iue->sbuf->buf;
> +	struct scsi_cmnd *sc;
> +	struct page *pg;
> +
> +	data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
> +
> +	printk("%s %d: %x %u %u %lu\n",
> +	       __func__, __LINE__, cmd->cdb[0], data_len,
> +	       srp_cmd_direction(cmd), (unsigned long)cmd->lun);
> +
> +	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
> +	sc->cmnd = cmd->cdb;
> +	sc->SCp.ptr = (char *)iue;
> +
> +	switch (cmd->cdb[0]) {
> +	case INQUIRY:
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_inquery(tpg, cmd, page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(sc);
> +		break;
> +	case REPORT_LUNS:
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_report_luns(tpg, cmd, page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(sc);
> +		break;
> +	case START_STOP:
> +		/* fixme: needs to use tcm */
> +		ibmvscsis_cmd_done(sc);
> +		kfree(sc);
> +		break;
> +	case READ_CAPACITY:
> +		/* fixme: needs to use tcm */
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_read_capacity(tpg, cmd, page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(sc);
> +		break;
> +	case MODE_SENSE:
> +		/* fixme: needs to use tcm */
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_mode_sense(tpg, cmd, page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(sc);
> +		break;
> +	case READ_6:
> +		/* fixme: needs to use tcm */
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = data_len;
> +		sg_set_page(sc->sdb.table.sgl, pg, data_len, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(sc);
> +		break;
> +	default:
> +		/* fixme: needs to use tcm */
> +		sc->result = COMMAND_TERMINATED;
> +		ibmvscsis_cmd_done(sc);
> +		kfree(sc);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static void handle_cmd_queue(struct ibmvscsis_tpg *tpg)
> +{
> +	struct srp_target *target = &tpg->srpt;
> +	struct iu_entry *iue;
> +	struct srp_cmd *cmd;
> +	unsigned long flags;
> +	int err;
> +
> +retry:
> +	spin_lock_irqsave(&target->lock, flags);
> +
> +	list_for_each_entry(iue, &target->cmd_queue, ilist) {
> +		if (!test_and_set_bit(V_FLYING, &iue->flags)) {
> +			spin_unlock_irqrestore(&target->lock, flags);
> +			err = ibmvscsis_queuecommand(tpg, iue);
> +			if (err) {
> +				printk(KERN_ERR "cannot queue cmd %p %d\n", cmd, err);
> +				srp_iu_put(iue);
> +			}
> +			goto retry;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&target->lock, flags);
> +}
> +
> +static void handle_crq(struct work_struct *work)
> +{
> +	struct ibmvscsis_tpg *tpg =
> +		container_of(work, struct ibmvscsis_tpg, crq_work);
> +	struct viosrp_crq *crq;
> +	int done = 0;
> +
> +	while (!done) {
> +		while ((crq = next_crq(&tpg->crq_queue)) != NULL) {
> +			process_crq(crq, tpg);
> +			crq->valid = 0x00;
> +		}
> +
> +		vio_enable_interrupts(tpg->dma_dev);
> +
> +		crq = next_crq(&tpg->crq_queue);
> +		if (crq) {
> +			vio_disable_interrupts(tpg->dma_dev);
> +			process_crq(crq, tpg);
> +			crq->valid = 0x00;
> +		} else
> +			done = 1;
> +	}
> +
> +	handle_cmd_queue(tpg);
> +}
> +
> +static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
> +{
> +	struct ibmvscsis_tpg *tpg = data;
> +
> +	vio_disable_interrupts(tpg->dma_dev);
> +	schedule_work(&tpg->crq_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int crq_queue_create(struct crq_queue *queue, struct ibmvscsis_tpg *tpg)
> +{
> +	int err;
> +	struct vio_dev *vdev = tpg->dma_dev;
> +
> +	queue->msgs = (struct viosrp_crq *) get_zeroed_page(GFP_KERNEL);
> +	if (!queue->msgs)
> +		goto malloc_failed;
> +	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
> +
> +	queue->msg_token = dma_map_single(&vdev->dev, queue->msgs,
> +					  queue->size * sizeof(*queue->msgs),
> +					  DMA_BIDIRECTIONAL);
> +
> +	if (dma_mapping_error(&vdev->dev, queue->msg_token))
> +		goto map_failed;
> +
> +	err = h_reg_crq(vdev->unit_address, queue->msg_token,
> +			PAGE_SIZE);
> +
> +	/* If the adapter was left active for some reason (like kexec)
> +	 * try freeing and re-registering
> +	 */
> +	if (err == H_RESOURCE) {
> +	    do {
> +		err = h_free_crq(vdev->unit_address);
> +	    } while (err == H_BUSY || H_IS_LONG_BUSY(err));
> +
> +	    err = h_reg_crq(vdev->unit_address, queue->msg_token,
> +			    PAGE_SIZE);
> +	}
> +
> +	if (err != H_SUCCESS && err != 2) {
> +		printk(KERN_ERR "Error 0x%x opening virtual adapter\n", err);
> +		goto reg_crq_failed;
> +	}
> +
> +	err = request_irq(vdev->irq, &ibmvscsis_interrupt,
> +			  IRQF_DISABLED, "ibmvscsis", tpg);
> +	if (err)
> +		goto req_irq_failed;
> +
> +	vio_enable_interrupts(vdev);
> +
> +	h_send_crq(vdev->unit_address, 0xC001000000000000, 0);
> +
> +	queue->cur = 0;
> +	spin_lock_init(&queue->lock);
> +
> +	return 0;
> +
> +req_irq_failed:
> +	do {
> +		err = h_free_crq(vdev->unit_address);
> +	} while (err == H_BUSY || H_IS_LONG_BUSY(err));
> +
> +reg_crq_failed:
> +	dma_unmap_single(&vdev->dev, queue->msg_token,
> +			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
> +map_failed:
> +	free_page((unsigned long) queue->msgs);
> +
> +malloc_failed:
> +	return -ENOMEM;
> +}
> +
> +static void crq_queue_destroy(struct ibmvscsis_tpg *tpg)
> +{
> +	struct crq_queue *queue = &tpg->crq_queue;
> +	int err;
> +
> +	free_irq(tpg->dma_dev->irq, tpg);
> +	do {
> +		err = h_free_crq(tpg->dma_dev->unit_address);
> +	} while (err == H_BUSY || H_IS_LONG_BUSY(err));
> +
> +	dma_unmap_single(&tpg->dma_dev->dev, queue->msg_token,
> +			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
> +
> +	free_page((unsigned long)queue->msgs);
> +}
> +
> +static int ibmvscsis_probe(struct vio_dev *dev, const struct vio_device_id *id)
> +{
> +	unsigned int *dma, dma_size;
> +	unsigned long flags;
> +	int ret;
> +	struct ibmvscsis_tpg *tpg;
> +
> +	printk("%s: %s %s %x\n", __func__, dev->name, dev_name(&dev->dev),
> +	       dev->unit_address);
> +
> +	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
> +	if (!tpg)
> +		return -ENOMEM;
> +
> +	tpg->dma_dev = dev;
> +
> +	printk("%s %d: %p %p\n", __func__, __LINE__, tpg, &tpg->se_tpg);
> +
> +	dma = (unsigned int *)vio_get_attribute(dev, "ibm,my-dma-window",
> +						&dma_size);
> +	if (!dma || dma_size != 40) {
> +		printk(KERN_ERR "Couldn't get window property %d\n", dma_size);
> +		kfree(tpg);
> +		return -EIO;
> +	}
> +
> +	tpg->liobn = dma[0];
> +	tpg->riobn = dma[5];
> +	tpg->tport_tpgt = simple_strtoul(dev_name(&dev->dev), NULL, 10);
> +
> +	spin_lock_irqsave(&tpg_lock, flags);
> +	list_add(&tpg->siblings, &tpg_list);
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +
> +	INIT_WORK(&tpg->crq_work, handle_crq);
> +
> +	dev_set_drvdata(&dev->dev, tpg);
> +
> +	ret = srp_target_alloc(&tpg->srpt, &dev->dev, INITIAL_SRP_LIMIT,
> +			       SRP_MAX_IU_LEN);
> +
> +	tpg->srpt.ldata = tpg;
> +
> +	ret = crq_queue_create(&tpg->crq_queue, tpg);
> +
> +	printk("%s %d: %d\n", __func__, __LINE__, ret);
> +
> +	return 0;
> +}
> +
> +static int ibmvscsis_remove(struct vio_dev *dev)
> +{
> +	struct ibmvscsis_tpg *tpg = dev_get_drvdata(&dev->dev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tpg_lock, flags);
> +	list_del(&tpg->siblings);
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +	srp_target_free(&tpg->srpt);
> +
> +	crq_queue_destroy(tpg);
> +
> +	kfree(tpg);
> +	return 0;
> +}
> +
> +static struct vio_device_id ibmvscsis_device_table[] __devinitdata = {
> +	{"v-scsi-host", "IBM,v-scsi-host"},
> +	{"",""}
> +};
> +
> +MODULE_DEVICE_TABLE(vio, ibmvscsis_device_table);
> +
> +static struct vio_driver ibmvscsis_driver = {
> +	.id_table = ibmvscsis_device_table,
> +	.probe = ibmvscsis_probe,
> +	.remove = ibmvscsis_remove,
> +	.driver = {
> +		.name = "ibmvscsis",
> +		.owner = THIS_MODULE,
> +	}
> +};
> +
> +static int get_system_info(void)
> +{
> +	struct device_node *rootdn;
> +	const char *id, *model, *name;
> +	const unsigned int *num;
> +
> +	rootdn = of_find_node_by_path("/");
> +	if (!rootdn)
> +		return -ENOENT;
> +
> +	model = of_get_property(rootdn, "model", NULL);
> +	id = of_get_property(rootdn, "system-id", NULL);
> +	if (model && id)
> +		snprintf(system_id, sizeof(system_id), "%s-%s", model, id);
> +
> +	name = of_get_property(rootdn, "ibm,partition-name", NULL);
> +	if (name)
> +		strncpy(partition_name, name, sizeof(partition_name));
> +
> +	num = of_get_property(rootdn, "ibm,partition-no", NULL);
> +	if (num)
> +		partition_number = *num;
> +
> +	of_node_put(rootdn);
> +	return 0;
> +}
> +
> +static int ibmvscsis_register_configfs(void)
> +{
> +	struct target_fabric_configfs *fabric;
> +	int ret;
> +
> +	printk(KERN_INFO "IBMVSCSIS fabric module %s on %s/%s"
> +		" on "UTS_RELEASE"\n",IBMVSCSIS_VERSION, utsname()->sysname,
> +		utsname()->machine);
> +	/*
> +	 * Register the top level struct config_item_type with TCM core
> +	 */
> +	fabric = target_fabric_configfs_init(THIS_MODULE, "ibmvscsis");
> +	if (!(fabric)) {
> +		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
> +		return -ENOMEM;
> +	}
> +	/*
> +	 * Setup fabric->tf_ops from our local ibmvscsis_ops
> +	 */
> +	fabric->tf_ops = ibmvscsis_ops;
> +	/*
> +	 * Setup default attribute lists for various fabric->tf_cit_tmpl
> +	 */
> +	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = ibmvscsis_wwn_attrs;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
> +	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
> +	/*
> +	 * Register the fabric for use within TCM
> +	 */
> +	ret = target_fabric_configfs_register(fabric);
> +	if (ret < 0) {
> +		printk(KERN_ERR "target_fabric_configfs_register() failed"
> +				" for IBMVSCSIS\n");
> +		target_fabric_configfs_deregister(fabric);
> +		return ret;
> +	}
> +	/*
> +	 * Setup our local pointer to *fabric
> +	 */
> +	ibmvscsis_fabric_configfs = fabric;
> +	printk(KERN_INFO "IBMVSCSIS[0] - Set fabric -> ibmvscsis_fabric_configfs\n");
> +	return 0;
> +};
> +
> +static void ibmvscsis_deregister_configfs(void)
> +{
> +	if (!(ibmvscsis_fabric_configfs))
> +		return;
> +
> +	target_fabric_configfs_deregister(ibmvscsis_fabric_configfs);
> +	ibmvscsis_fabric_configfs = NULL;
> +	printk(KERN_INFO "IBMVSCSIS[0] - Cleared ibmvscsis_fabric_configfs\n");
> +};
> +
> +static int __init ibmvscsis_init(void)
> +{
> +	int ret;
> +
> +	ret = get_system_info();
> +	if (ret)
> +		return ret;
> +
> +	ret = vio_register_driver(&ibmvscsis_driver);
> +	if (ret)
> +		return ret;
> +
> +	ret = ibmvscsis_register_configfs();
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +};
> +
> +static void ibmvscsis_exit(void)
> +{
> +	vio_unregister_driver(&ibmvscsis_driver);
> +	ibmvscsis_deregister_configfs();
> +};
> +
> +MODULE_DESCRIPTION("IBMVSCSIS series fabric driver");
> +MODULE_LICENSE("GPL");
> +module_init(ibmvscsis_init);
> +module_exit(ibmvscsis_exit);
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.h b/drivers/scsi/ibmvscsi/ibmvscsis.h
> new file mode 100644
> index 0000000..e69de29
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index ff6a28c..13b6dc7 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -30,13 +30,6 @@
>  #include <scsi/srp.h>
>  #include <scsi/libsrp.h>
>  
> -enum srp_task_attributes {
> -	SRP_SIMPLE_TASK = 0,
> -	SRP_HEAD_TASK = 1,
> -	SRP_ORDERED_TASK = 2,
> -	SRP_ACA_TASK = 4
> -};
> -
>  /* tmp - will replace with SCSI logging stuff */
>  #define eprintk(fmt, args...)					\
>  do {								\
> @@ -363,7 +356,7 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
>  }
>  EXPORT_SYMBOL_GPL(srp_transfer_data);
>  
> -static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
> +int srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
>  {
>  	struct srp_direct_buf *md;
>  	struct srp_indirect_buf *id;
> @@ -394,7 +387,9 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
>  	}
>  	return len;
>  }
> +EXPORT_SYMBOL_GPL(srp_data_length);
>  
> +#if 0
>  int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
>  		  u64 itn_id, u64 addr)
>  {
> @@ -440,6 +435,7 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(srp_cmd_queue);
> +#endif
>  
>  MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
>  MODULE_AUTHOR("FUJITA Tomonori");
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 05b18c2..80366d2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -8434,7 +8434,7 @@ EXPORT_SYMBOL(transport_lun_wait_for_tasks);
>  #define DEBUG_CLEAR_L(x...)
>  #endif
>  
> -static void __transport_clear_lun_from_sessions(struct se_lun *lun)
> +void __transport_clear_lun_from_sessions(struct se_lun *lun)
>  {
>  	struct se_cmd *cmd = NULL;
>  	unsigned long lun_flags, cmd_flags;
> diff --git a/include/Kbuild b/include/Kbuild
> index 8d226bf..0219c53 100644
> --- a/include/Kbuild
> +++ b/include/Kbuild
> @@ -10,3 +10,4 @@ header-y += video/
>  header-y += drm/
>  header-y += xen/
>  header-y += scsi/
> +header-y += target/
> diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
> index f4105c9..f5ebdbf 100644
> --- a/include/scsi/libsrp.h
> +++ b/include/scsi/libsrp.h
> @@ -7,6 +7,13 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/srp.h>
>  
> +enum srp_task_attributes {
> +	SRP_SIMPLE_TASK = 0,
> +	SRP_HEAD_TASK = 1,
> +	SRP_ORDERED_TASK = 2,
> +	SRP_ACA_TASK = 4
> +};
> +
>  enum iue_flags {
>  	V_DIOVER,
>  	V_WRITE,
> @@ -64,7 +71,6 @@ extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64)
>  extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
>  			     srp_rdma_t, int, int);
>  
> -
>  static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
>  {
>  	return (struct srp_target *) host->hostdata;
> @@ -75,4 +81,6 @@ static inline int srp_cmd_direction(struct srp_cmd *cmd)
>  	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  }
>  
> +extern int srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir);
> +
>  #endif

