From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Thu, 10 Feb 2011 11:03:11 -0800
Message-ID: <1297364591.18212.172.camel@haakon2.linux-iscsi.org>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42915 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1BJTDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2011 14:03:18 -0500
In-Reply-To: <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Thu, 2011-02-10 at 21:21 +0900, FUJITA Tomonori wrote:
> This replaces ibmvstgt driver.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/ibmvscsi/Makefile    |    4 +-
>  drivers/scsi/ibmvscsi/ibmvscsis.c | 1759 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 1762 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/scsi/ibmvscsi/ibmvscsis.c
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
> index 0000000..1ab4d73
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
> @@ -0,0 +1,1759 @@
> +/*
> + * IBM eServer i/pSeries Virtual SCSI Target Driver
> + * Copyright (C) 2003-2005 Dave Boutcher (boutcher@us.ibm.com) IBM Corp.
> + *			   Santiago Leon (santil@us.ibm.com) IBM Corp.
> + *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
> + *
> + * Copyright (C) 2005-2011 FUJITA Tomonori <tomof@acm.org>
> + * Copyright (C) 2010 Nicholas A. Bellinger <nab@kernel.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
> + * USA
> + */
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

Ok, these two hardcoded defs can  be converted into context specific
fabric dependent configfs attributes (TF_CIT_TMPL(fabric)->tfc_* below)
using target_core_fabric_configfs.h wrappers..

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
> +#define GETTARGET(x) ((int)((((u64)(x)) >> 56) & 0x003f))
> +#define GETBUS(x) ((int)((((u64)(x)) >> 53) & 0x0007))
> +#define GETLUN(x) ((int)((((u64)(x)) >> 48) & 0x001f))
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
> +struct ibmvscsis_adapter {
> +	struct vio_dev *dma_dev;
> +	struct list_head siblings;
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
> +	unsigned long tport_tpgt;
> +
> +	/* Returned by ibmvscsis_make_tpg() */
> +	struct se_portal_group se_tpg;
> +
> +	struct se_session *se_sess;
> +
> +
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
> +struct ibmvscsis_cmnd {
> +	/* Used for libsrp processing callbacks */
> +	struct scsi_cmnd sc;
> +	/* Used for TCM Core operations */
> +	struct se_cmd se_cmd;
> +	/* Sense buffer that will be mapped into outgoing status */
> +	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
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
> +	return 4;
> +}
> +
> +static char *ibmvscsis_get_fabric_wwn(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_adapter *adapter =
> +		container_of(se_tpg, struct ibmvscsis_adapter, se_tpg);
> +
> +	return adapter->tport_name;
> +}
> +
> +static u16 ibmvscsis_get_tag(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_adapter *adapter =
> +		container_of(se_tpg, struct ibmvscsis_adapter, se_tpg);
> +	return adapter->tport_tpgt;
> +}
> +
> +static u32 ibmvscsis_get_default_depth(struct se_portal_group *se_tpg)
> +{
> +	return 1;
> +}
> +
> +/* we don't care about the transport id since we never use pr. */
> +static u32 ibmvscsis_get_pr_transport_id(struct se_portal_group *se_tpg,
> +					 struct se_node_acl *se_nacl,
> +					 struct t10_pr_registration *pr_reg,
> +					 int *format_code,
> +					 unsigned char *buf)
> +{
> +	return 24;
> +}
> +
> +static u32 ibmvscsis_get_pr_transport_id_len(struct se_portal_group *se_tpg,
> +					     struct se_node_acl *se_nacl,
> +					     struct t10_pr_registration *pr_reg,
> +					     int *format_code)
> +{
> +	return 24;
> +}
> +
> +static char *ibmvscsis_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
> +						 const char *buf,
> +						 u32 *out_tid_len,
> +						 char **port_nexus_ptr)
> +{
> +	return NULL;
> +}
> +

OK, I still need to add generic SCSI_PROTOCOL_SRP handlers for PR
TransportID processing, and get up and running with TCM_Loop SRP target
ports.  I will look at getting this resolved in LIO upstream in the near
future, and make sure this gets converted..

> +struct ibmvscsis_nacl {
> +	/* Binary World Wide unique Port Name for SRP Initiator port */
> +	u64 iport_wwpn;
> +	/* ASCII formatted WWPN for Sas Initiator port */
> +	char iport_name[IBMVSCSIS_NAMELEN];
> +	/* Returned by ibmvscsis_make_nodeacl() */
> +	struct se_node_acl se_node_acl;
> +};
> +

<SNIP>

> +
> +static int ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +

The TM request/response logic still needs to be hooked up, right..?

> +static u16 ibmvscsis_set_fabric_sense_len(struct se_cmd *se_cmd,
> +					  u32 sense_length)
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
> +static u64 make_lun(unsigned int bus, unsigned int target, unsigned int lun);
> +
> +static u64 ibmvscsis_pack_lun(unsigned int lun)
> +{
> +	return make_lun(0, lun & 0x003f, 0);
> +}
> +
> +/* Local pointer to allocated TCM configfs fabric module */
> +static struct target_fabric_configfs *ibmvscsis_fabric_configfs;
> +
> +static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
> +						  struct config_group *group,
> +						  const char *name)
> +{
> +	struct ibmvscsis_adapter *adapter =
> +		container_of(wwn, struct ibmvscsis_adapter, tport_wwn);
> +	struct se_node_acl *acl;
> +	int ret;
> +	char *dname = (char *)dev_name(&adapter->dma_dev->dev);
> +
> +	if (strncmp(name, "tpgt_1", 6))
> +		return ERR_PTR(-EINVAL);
> +
> +	ret = core_tpg_register(&ibmvscsis_fabric_configfs->tf_ops, wwn,
> +				&adapter->se_tpg, (void *)adapter,
> +				TRANSPORT_TPG_TYPE_NORMAL);
> +	if (ret)
> +		return ERR_PTR(-ENOMEM);
> +
> +	adapter->se_sess = transport_init_session();
> +	if (!adapter->se_sess) {
> +		core_tpg_deregister(&adapter->se_tpg);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	acl = core_tpg_check_initiator_node_acl(&adapter->se_tpg, dname);
> +	if (!acl) {
> +		transport_free_session(adapter->se_sess);
> +		adapter->se_sess = NULL;
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	adapter->se_sess->se_node_acl = acl;
> +
> +	transport_register_session(&adapter->se_tpg,
> +				   adapter->se_sess->se_node_acl,
> +				   adapter->se_sess, adapter);
> +
> +	return &adapter->se_tpg;
> +}
> +
> +static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
> +{
> +	struct ibmvscsis_adapter *adapter =
> +		container_of(se_tpg, struct ibmvscsis_adapter, se_tpg);
> +	unsigned long flags;
> +
> +
> +	transport_deregister_session_configfs(adapter->se_sess);
> +	transport_free_session(adapter->se_sess);
> +	core_tpg_deregister(se_tpg);
> +
> +	spin_lock_irqsave(&tpg_lock, flags);
> +	adapter->se_sess = NULL;
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +}
> +
> +static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
> +					   struct config_group *group,
> +					   const char *name)
> +{
> +	struct ibmvscsis_adapter *adapter;
> +	unsigned long tpgt, flags;
> +
> +	if (strict_strtoul(name, 10, &tpgt))
> +		return NULL;
> +
> +	spin_lock_irqsave(&tpg_lock, flags);
> +	list_for_each_entry(adapter, &tpg_list, siblings) {
> +		if (tpgt == adapter->tport_tpgt)
> +			goto found;
> +	}
> +
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +	return NULL;
> +found:
> +	spin_unlock_irqrestore(&tpg_lock, flags);
> +
> +	return &adapter->tport_wwn;
> +}
> +
> +static void ibmvscsis_drop_tport(struct se_wwn *wwn)
> +{
> +}
> +

Ok, this should be OK being a NOP since adapter->tport_wwn memory is not
being released..

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
> +static int ibmvscsis_write_pending(struct se_cmd *se_cmd);
> +static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd);
> +static int ibmvscsis_queue_status(struct se_cmd *se_cmd);
> +static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd);
> +static void ibmvscsis_check_stop_free(struct se_cmd *se_cmd);
> +
> +static struct target_core_fabric_ops ibmvscsis_ops = {
> +	.task_sg_chaining		= 1,
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
> +	.tpg_check_demo_mode_write_protect = ibmvscsis_check_false,
> +	.tpg_check_prod_mode_write_protect = ibmvscsis_check_false,
> +	.tpg_alloc_fabric_acl		= ibmvscsis_alloc_fabric_acl,
> +	.tpg_release_fabric_acl		= ibmvscsis_release_fabric_acl,
> +	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
> +	.new_cmd_map			= ibmvscsis_new_cmd_map,
> +	.check_stop_free		= ibmvscsis_check_stop_free,
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
> +	.fabric_make_wwn		= ibmvscsis_make_tport,
> +	.fabric_drop_wwn		= ibmvscsis_drop_tport,
> +	.fabric_make_tpg		= ibmvscsis_make_tpg,
> +	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
> +	.fabric_post_link		= NULL,
> +	.fabric_pre_unlink		= NULL,
> +	.fabric_make_np			= NULL,
> +	.fabric_drop_np			= NULL,
> +	.fabric_make_nodeacl		= NULL,
> +	.fabric_drop_nodeacl		= NULL,
> +};
> +
> +static inline union viosrp_iu *vio_iu(struct iu_entry *iue)
> +{
> +	return (union viosrp_iu *)(iue->sbuf->buf);
> +}
> +
> +static int send_iu(struct iu_entry *iue, u64 length, u8 format)
> +{
> +	struct srp_target *target = iue->target;
> +	struct ibmvscsis_adapter *adapter = target->ldata;
> +	long rc, rc1;
> +	union {
> +		struct viosrp_crq cooked;
> +		u64 raw[2];
> +	} crq;
> +
> +	/* First copy the SRP */
> +	rc = h_copy_rdma(length, adapter->liobn, iue->sbuf->dma,
> +			 adapter->riobn, iue->remote_token);
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
> +	rc1 = h_send_crq(adapter->dma_dev->unit_address, crq.raw[0],
> +			 crq.raw[1]);
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
> +	struct ibmvscsis_adapter *adapter = target->ldata;
> +	dma_addr_t data_token;
> +	struct mad_adapter_info_data *info;
> +	int err;
> +
> +	info = dma_alloc_coherent(&adapter->dma_dev->dev, sizeof(*info),
> +				  &data_token, GFP_KERNEL);
> +	if (!info) {
> +		printk(KERN_ERR "bad dma_alloc_coherent %p\n", target);
> +		return 1;
> +	}
> +
> +	/* Get remote info */
> +	err = h_copy_rdma(sizeof(*info), adapter->riobn, remote_buffer,
> +			  adapter->liobn, data_token);
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
> +	err = h_copy_rdma(sizeof(*info), adapter->liobn, data_token,
> +			  adapter->riobn, remote_buffer);
> +
> +	dma_free_coherent(&adapter->dma_dev->dev, sizeof(*info), info,
> +			  data_token);
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
> +static void process_iu(struct viosrp_crq *crq,
> +		       struct ibmvscsis_adapter *adapter)
> +{
> +	struct iu_entry *iue;
> +	long err;
> +	int done = 1;
> +
> +	iue = srp_iu_get(&adapter->srpt);
> +	if (!iue) {
> +		printk(KERN_ERR "Error getting IU from pool\n");
> +		return;
> +	}
> +
> +	iue->remote_token = crq->IU_data_ptr;
> +
> +	err = h_copy_rdma(crq->IU_length, adapter->riobn,
> +			  iue->remote_token, adapter->liobn, iue->sbuf->dma);
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
> +static void process_crq(struct viosrp_crq *crq,
> +			struct ibmvscsis_adapter *adapter)
> +{
> +	switch (crq->valid) {
> +	case 0xC0:
> +		/* initialization */
> +		switch (crq->format) {
> +		case 0x01:
> +			h_send_crq(adapter->dma_dev->unit_address,
> +				   0xC002000000000000, 0);
> +			break;
> +		case 0x02:
> +			break;
> +		default:
> +			printk(KERN_ERR "Unknown format %u\n", crq->format);
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
> +			process_iu(crq, adapter);
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
> +static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
> +			    struct ibmvscsis_cmnd *vsc,
> +			    struct srp_cmd *cmd)
> +{
> +	struct se_cmd *se_cmd;
> +	int attr;
> +	int data_len;
> +	int ret;
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
> +	se_cmd = &vsc->se_cmd;
> +
> +	transport_init_se_cmd(se_cmd,
> +			      adapter->se_tpg.se_tpg_tfo,
> +			      adapter->se_sess, data_len,
> +			      srp_cmd_direction(cmd),
> +			      attr, vsc->sense_buf);
> +
> +	ret = transport_get_lun_for_cmd(se_cmd, NULL, cmd->lun);
> +	if (ret) {
> +		printk(KERN_ERR "invalid lun %u\n", GETLUN(cmd->lun));
> +		transport_send_check_condition_and_sense(se_cmd,
> +							 se_cmd->scsi_sense_reason,
> +							 0);
> +		return ret;
> +	}
> +
> +	transport_device_setup_cmd(se_cmd);
> +	transport_generic_handle_cdb_map(se_cmd);
> +
> +	return 0;
> +}
> +
> +static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd)
> +{
> +	struct ibmvscsis_cmnd *cmd =
> +		container_of(se_cmd, struct ibmvscsis_cmnd, se_cmd);
> +	struct scsi_cmnd *sc = &cmd->sc;
> +	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
> +	struct srp_cmd *scmd = iue->sbuf->buf;
> +	int ret;
> +
> +	/*
> +	 * Allocate the necessary tasks to complete the received CDB+data
> +	 */
> +	ret = transport_generic_allocate_tasks(se_cmd, scmd->cdb);
> +	if (ret == -1) {
> +		/* Out of Resources */
> +		return PYX_TRANSPORT_LU_COMM_FAILURE;
> +	} else if (ret == -2) {
> +		/*
> +		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
> +		 */
> +		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
> +			return PYX_TRANSPORT_RESERVATION_CONFLICT;
> +		/*
> +		 * Otherwise, return SAM_STAT_CHECK_CONDITION and return
> +		 * sense data
> +		 */
> +		return PYX_TRANSPORT_USE_SENSE_REASON;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ibmvscsis_check_stop_free(struct se_cmd *se_cmd)
> +{
> +	if (se_cmd->se_tmr_req)
> +		return;
> +	transport_generic_free_cmd(se_cmd, 0, 1, 0);
> +}
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
> +static int ibmvscsis_inquery(struct ibmvscsis_adapter *adapter,
> +			      struct srp_cmd *cmd, char *data)
> +{
> +	struct se_portal_group *se_tpg = &adapter->se_tpg;
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
> +		printk(KERN_INFO "%s %d: needs the normal path\n",
> +		       __func__, __LINE__);
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
> +			 adapter->dma_dev->unit_address,
> +			 GETBUS(lun),
> +			 GETTARGET(lun),
> +			 GETLUN(lun));
> +	}
> +
> +	len = min_t(int, sizeof(*id), cdb[4]);
> +
> +	unpacked_lun = scsi_lun_to_int(cmd->lun);
> +
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +
> +	if (unpacked_lun < TRANSPORT_MAX_LUNS_PER_TPG &&
> +	    se_tpg->tpg_lun_list[unpacked_lun].lun_status ==
> +	    TRANSPORT_LUN_STATUS_ACTIVE)
> +		;
> +	else
> +		data[0] = TYPE_NO_LUN;
> +
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +
> +	return len;
> +}
> +
> +static int ibmvscsis_mode_sense(struct ibmvscsis_adapter *adapter,
> +				struct srp_cmd *cmd, char *mode)
> +{
> +	int bytes;
> +	struct se_portal_group *se_tpg = &adapter->se_tpg;
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
> +		*((u32 *) &mode[4]) = blocks - 1;
> +		*((u32 *) &mode[8]) = 512;
> +		bytes = mode[0] = 12;	/* length */
> +		break;
> +
> +	case 0x08: /* Cache page */
> +		/* length should be 4 */
> +#if 0
> +		if (cmd->cdb[4] != 4
> +		    && cmd->cdb[4] != 0x20) {
> +			send_rsp(iue, ILLEGAL_REQUEST, 0x20);
> +			dma_free_coherent(iue->adapter->dev,
> +					  MODE_SENSE_BUFFER_SIZE,
> +					  mode, data_token);
> +			return FREE_IU;
> +		}
> +#endif
> +

Can this be dropped..?

> +		mode[1] = 0x00;	/* Default medium */
> +		if (0)
> +			mode[2] = 0x80;	/* device specific */
> +		else
> +			mode[2] = 0x00;	/* device specific */
> +
> +		/* note the DPOFUA bit is set to zero! */
> +		mode[3] = 0x08;	/* block descriptor length */
> +		*((u32 *) &mode[4]) = blocks - 1;
> +		*((u32 *) &mode[8]) = 512;
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
> +static int ibmvscsis_report_luns(struct ibmvscsis_adapter *adapter,
> +				 struct srp_cmd *cmd, u64 *data)
> +{
> +	u64 lun;
> +	struct se_portal_group *se_tpg = &adapter->se_tpg;
> +	int i, idx;
> +	int alen, oalen, nr_luns, rbuflen = 4096;
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
> +		lun = make_lun(0, i & 0x003f, 0);
> +		data[idx++] = cpu_to_be64(lun);
> +		alen -= 8;
> +		if (!alen)
> +			break;
> +		rbuflen -= 8;
> +		if (!rbuflen)
> +			break;
> +
> +		nr_luns++;
> +	}
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +done:
> +	put_unaligned_be32(nr_luns * 8, data);
> +	return min(oalen, nr_luns * 8 + 8);
> +}
> +
> +static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
> +			  struct srp_direct_buf *md, int nmd,
> +			  enum dma_data_direction dir, unsigned int rest)
> +{
> +	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
> +	struct srp_target *target = iue->target;
> +	struct ibmvscsis_adapter *adapter = target->ldata;
> +	dma_addr_t token;
> +	long err;
> +	unsigned int done = 0;
> +	int i, sidx, soff;
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
> +						  adapter->riobn,
> +						  md[i].va + mdone,
> +						  adapter->liobn,
> +						  token + soff);
> +			else
> +				err = h_copy_rdma(slen,
> +						  adapter->liobn,
> +						  token + soff,
> +						  adapter->riobn,
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
> +	if (scsi_sg_count(sc))
> +		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
> +					ibmvscsis_rdma, 1, 1);
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
> +struct ibmvscsis_cmd {
> +	/* Used for libsrp processing callbacks */
> +	struct scsi_cmnd sc;
> +	/* Used for TCM Core operations */
> +	struct se_cmd se_cmd;
> +	/* Sense buffer that will be mapped into outgoing status */
> +	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
> +};
> +
> +static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
> +{
> +	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
> +			struct ibmvscsis_cmnd, se_cmd);
> +	struct scsi_cmnd *sc = &cmd->sc;
> +	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
> +	int ret;
> +
> +	sc->sdb.length = se_cmd->data_length;
> +
> +	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
> +	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
> +		transport_do_task_sg_chain(se_cmd);
> +
> +		sc->sdb.table.nents = T_TASK(se_cmd)->t_tasks_sg_chained_no;
> +		sc->sdb.table.sgl = T_TASK(se_cmd)->t_tasks_sg_chained;
> +	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> +		/*
> +		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
> +		 * using a contigious buffer
> +		 */
> +		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
> +		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
> +			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
> +
> +		sc->sdb.table.nents = 1;
> +		sc->sdb.table.sgl = &T_TASK(se_cmd)->t_tasks_sg_bounce;
> +	}
> +
> +	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
> +				ibmvscsis_rdma, 1, 1);
> +	if (ret) {
> +		printk(KERN_ERR "srp_transfer_data() failed: %d\n", ret);
> +		return PYX_TRANSPORT_LU_COMM_FAILURE;
> +	}
> +	/*
> +	 * We now tell TCM to add this WRITE CDB directly into the TCM storage
> +	 * object execution queue.
> +	 */
> +	transport_generic_process_write(se_cmd);
> +	return 0;
> +}
> +
> +static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
> +{
> +	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
> +			struct ibmvscsis_cmnd, se_cmd);
> +	struct scsi_cmnd *sc = &cmd->sc;
> +	/*
> +	 * Check for overflow residual count
> +	 */
> +	if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
> +		scsi_set_resid(sc, se_cmd->residual_count);
> +
> +	sc->sdb.length = se_cmd->data_length;
> +
> +	/*
> +	 * Setup the struct se_task->task_sg[] chained SG list
> +	 */
> +	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
> +	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
> +		transport_do_task_sg_chain(se_cmd);
> +
> +		sc->sdb.table.nents = T_TASK(se_cmd)->t_tasks_sg_chained_no;
> +		sc->sdb.table.sgl = T_TASK(se_cmd)->t_tasks_sg_chained;
> +	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> +		/*
> +		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
> +		 * using a contigious buffer
> +		 */
> +		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
> +		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
> +			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
> +
> +		sc->sdb.table.nents = 1;
> +		sc->sdb.table.sgl = &T_TASK(se_cmd)->t_tasks_sg_bounce;
> +	}
> +	/*
> +	 * Perform the SCSI READ data transfer from sc->sdb.table into
> +	 * VIO LPAR memory.  This will occur via libsrp in the
> +	 * ibmvscsis_rdma() callback
> +	 */
> +#if 0
> +	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
> +				ibmvscsis_rdma, 1, 1);
> +	if (ret) {
> +		printk(KERN_ERR "srp_transfer_data() failed: %d, returning"
> +				" DID_ERROR\n", ret);
> +		sc->result = host_byte(DID_ERROR) | se_cmd->scsi_status;
> +	} else
> +		sc->result = host_byte(DID_OK) | se_cmd->scsi_status;
> +#endif

Mmmm, is this really supposed to be disabled..?

> +	/*
> +	 * This will call srp_transfer_data() and post the response
> +	 * to VIO via libsrp.
> +	 */
> +	ibmvscsis_cmd_done(sc);
> +	return 0;
> +}
> +
> +static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
> +{
> +	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
> +						  struct ibmvscsis_cmnd, se_cmd);
> +	struct scsi_cmnd *sc = &cmd->sc;
> +	/*
> +	 * Copy any generated SENSE data into sc->sense_buffer and
> +	 * set the appropiate sc->result to be translated by
> +	 * ibmvscsis_cmd_done()
> +	 */
> +	if (se_cmd->sense_buffer &&
> +	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
> +	    (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
> +		memcpy((void *)sc->sense_buffer, (void *)se_cmd->sense_buffer,
> +				SCSI_SENSE_BUFFERSIZE);
> +		sc->result = host_byte(DID_OK) | driver_byte(DRIVER_SENSE) |
> +				SAM_STAT_CHECK_CONDITION;
> +	} else
> +		sc->result = host_byte(DID_OK) | se_cmd->scsi_status;
> +	/*
> +	 * Finally post the response to VIO via libsrp.
> +	 */
> +	ibmvscsis_cmd_done(sc);
> +	return 0;
> +}
> +
> +static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
> +				  struct iu_entry *iue)
> +{
> +	int data_len;
> +	struct srp_cmd *cmd = iue->sbuf->buf;
> +	struct scsi_cmnd *sc;
> +	struct page *pg;
> +	struct ibmvscsis_cmnd *vsc;
> +
> +	data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
> +
> +	vsc = kzalloc(sizeof(*vsc), GFP_KERNEL);
> +	sc = &vsc->sc;
> +	sc->sense_buffer = vsc->sense_buf;
> +	sc->cmnd = cmd->cdb;
> +	sc->SCp.ptr = (char *)iue;
> +
> +	switch (cmd->cdb[0]) {
> +	case INQUIRY:
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_inquery(adapter, cmd,
> +						   page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(vsc);
> +		break;
> +	case REPORT_LUNS:
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_report_luns(adapter, cmd,
> +						       page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(vsc);
> +		break;
> +	case MODE_SENSE:
> +		/* fixme: needs to use tcm */
> +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		sc->sdb.length = ibmvscsis_mode_sense(adapter,
> +						      cmd, page_address(pg));
> +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> +		ibmvscsis_cmd_done(sc);
> +		sg_free_table(&sc->sdb.table);
> +		__free_page(pg);
> +		kfree(vsc);
> +		break;

Just to verify again, INQUIRY and REPORT_LUNS are the only CDBs that
have a hard requirement of being intercepted in order for VSCSI to
function, right..?

> +	default:
> +		tcm_queuecommand(adapter, vsc, cmd);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +

I think everything else looks quite reasonable.

Thanks Tomo-san!

--nab

