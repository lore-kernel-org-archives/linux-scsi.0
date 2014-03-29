From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Sat, 29 Mar 2014 03:05:40 +0300
Message-ID: <53360E54.5060004@mellanox.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com> <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:50546 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbaC2AFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 20:05:53 -0400
In-Reply-To: <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

On 3/29/2014 2:05 AM, Quinn Tran wrote:
> Check lower layer/HW support of T10-dif capability.
> When the LUN is linked between the underlining fabric
> and back end device, the Protection Type(1,2,3) is
> check against each other to make sure both side are
> capable of supporting the same protection setting.
>
> ln -s /sys/kernel/config/target/core/rd_mcp_0/q_tcm_mcp.0
> /sys/kernel/config/target/qla2xxx/$L_WWPN/tpgt_1/lun/lun_0/tcm_123
>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>   drivers/target/target_core_fabric_configfs.c | 20 ++++++++++++++++++++
>   drivers/target/target_core_tpg.c             |  9 +++++++++
>   include/target/target_core_base.h            | 14 ++++++++++++++
>   include/target/target_core_fabric.h          |  1 +
>   4 files changed, 44 insertions(+)
>
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 7de9f04..3ce07ec 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -777,6 +777,26 @@ static int target_fabric_port_link(
>   				struct se_portal_group, tpg_group);
>   	tf = se_tpg->se_tpg_wwn->wwn_tf;
>   
> +
> +	if (dev->dev_attrib.pi_prot_type) {
> +		uint32_t cap[] = { 0,
> +				   TARGET_DIF_TYPE1_PROTECTION,
> +				   TARGET_DIF_TYPE2_PROTECTION,
> +				   TARGET_DIF_TYPE3_PROTECTION};
> +		uint32_t pt_bits = cap[dev->dev_attrib.pi_prot_type];
> +		pt_bits &= se_tpg->fabric_sup_prot_type;

At what point should the fabric fill that? it can vary between portals 
right?
I would prefer to do that as a function pointer to explicitly ask the 
fabric it's support.

> +
> +		/* cross check with fabric to see if t10dif is supported */
> +		if (!pt_bits) {
> +			//dev->dev_attrib.pi_prot_type = 0;

Probably should lose the comment.

> +			pr_err("dev[%p]: DIF protection mismatch with fabric "
> +				"(%s). Transport capability bits[0x%x]\n",
> +				dev, se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
> +				se_tpg->fabric_sup_prot_type);
> +			return -EFAULT;

Didn't we agree that this is allowed and the target core should 
compensate on the lack fabric support?

> +		}
> +	}
> +
>   	if (lun->lun_se_dev !=  NULL) {
>   		pr_err("Port Symlink already exists\n");
>   		return -EEXIST;
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index c036595..9279971 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -632,6 +632,15 @@ int core_tpg_set_initiator_node_tag(
>   }
>   EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
>   
> +void core_tpg_set_fabric_t10dif(
> +	struct se_portal_group *tpg,
> +	uint32_t fabric_t10dif_force_on)
> +{
> +	tpg->fabric_t10dif_force_on = fabric_t10dif_force_on;
> +}
> +EXPORT_SYMBOL(core_tpg_set_fabric_t10dif);
> +

Is there a user for this function in this patch?

> +
>   static void core_tpg_lun_ref_release(struct percpu_ref *ref)
>   {
>   	struct se_lun *lun = container_of(ref, struct se_lun, lun_ref);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index ec3e3a3..fc2c0ef 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -241,6 +241,17 @@ enum tcm_tmrsp_table {
>   	TMR_FUNCTION_REJECTED		= 5,
>   };
>   
> +enum target_guard_type_cap {
> +	TARGET_GUARD_CRC = 1 << 0,
> +	TARGET_GUARD_IP  = 1 << 1,
> +};
> +

So this was dropped in previous rounds, this is more of an initiator 
thing, the target will always
receive CRC from the wire and will pass it to the backing device so no 
need to convert to IP_CSUM.

> +enum target_prot_type_cap {
> +	TARGET_DIF_TYPE1_PROTECTION = 1 << 0, /* T10 DIF Type 1 */
> +	TARGET_DIF_TYPE2_PROTECTION = 1 << 1, /* T10 DIF Type 2 */
> +	TARGET_DIF_TYPE3_PROTECTION = 1 << 2, /* T10 DIF Type 3 */
> +};
> +
>   /*
>    * Used for target SCSI statistics
>    */
> @@ -862,6 +873,9 @@ struct se_portal_group {
>   	enum transport_tpg_type_table se_tpg_type;
>   	/* Number of ACLed Initiator Nodes for this TPG */
>   	u32			num_node_acls;
> +	u32			fabric_t10dif_force_on;
> +	u32			fabric_sup_guard_type;
> +	u32			fabric_sup_prot_type;
>   	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
>   	atomic_t		tpg_pr_ref_count;
>   	/* Spinlock for adding/removing ACLed Nodes */
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 1d10436..4c3dab5 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -152,6 +152,7 @@ int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
>   		unsigned char *, u32, int);
>   int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
>   		struct se_node_acl *, const char *);
> +void	core_tpg_set_fabric_t10dif(struct se_portal_group *, uint32_t);
>   int	core_tpg_register(struct target_core_fabric_ops *, struct se_wwn *,
>   		struct se_portal_group *, void *, int);
>   int	core_tpg_deregister(struct se_portal_group *);

