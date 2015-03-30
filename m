From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 11/15] loopback: Add fabric_prot_type attribute support
Date: Mon, 30 Mar 2015 11:07:33 +0300
Message-ID: <55190445.6030600@dev.mellanox.co.il>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com> <1427686104-14231-12-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-12-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch updates loopback to add a new fabric_prot_type TPG attribute,
> used for controlling LLD level protection into LIO when the backend
> device does not support T10-PI.
>
> Also, go ahead and set DIN_PASS + DOUT_PASS so target-core knows that
> it will be doing any WRITE_STRIP and READ_INSERT operations.
>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/loopback/tcm_loop.c | 54 ++++++++++++++++++++++++++++++++++++--
>   drivers/target/loopback/tcm_loop.h |  1 +
>   2 files changed, 53 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index f4618e7..797c731 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -697,6 +697,13 @@ static int tcm_loop_check_prod_mode_write_protect(struct se_portal_group *se_tpg
>   	return 0;
>   }
>
> +static int tcm_loop_check_prot_fabric_only(struct se_portal_group *se_tpg)
> +{
> +	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
> +						   tl_se_tpg);
> +	return tl_tpg->tl_fabric_prot_type;
> +}
> +

So now loopback devices can finally protect transfers with
read_verify=0, write_generate=0?

>   static struct se_node_acl *tcm_loop_tpg_alloc_fabric_acl(
>   	struct se_portal_group *se_tpg)
>   {
> @@ -912,6 +919,46 @@ static void tcm_loop_port_unlink(
>
>   /* End items for tcm_loop_port_cit */
>
> +static ssize_t tcm_loop_tpg_attrib_show_fabric_prot_type(
> +	struct se_portal_group *se_tpg,
> +	char *page)
> +{
> +	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
> +						   tl_se_tpg);
> +
> +	return sprintf(page, "%d\n", tl_tpg->tl_fabric_prot_type);
> +}
> +
> +static ssize_t tcm_loop_tpg_attrib_store_fabric_prot_type(
> +	struct se_portal_group *se_tpg,
> +	const char *page,
> +	size_t count)
> +{
> +	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
> +						   tl_se_tpg);
> +	unsigned long val;
> +	int ret = kstrtoul(page, 0, &val);
> +
> +	if (ret) {
> +		pr_err("kstrtoul() returned %d for fabric_prot_type\n", ret);
> +		return ret;
> +	}
> +	if (val != 0 && val != 1 && val != 3) {
> +		pr_err("Invalid qla2xxx fabric_prot_type: %lu\n", val);
> +		return -EINVAL;
> +	}
> +	tl_tpg->tl_fabric_prot_type = val;
> +
> +	return count;
> +}
> +
> +TF_TPG_ATTRIB_ATTR(tcm_loop, fabric_prot_type, S_IRUGO | S_IWUSR);
> +
> +static struct configfs_attribute *tcm_loop_tpg_attrib_attrs[] = {
> +	&tcm_loop_tpg_attrib_fabric_prot_type.attr,
> +	NULL,
> +};
> +
>   /* Start items for tcm_loop_nexus_cit */
>
>   static int tcm_loop_make_nexus(
> @@ -937,7 +984,8 @@ static int tcm_loop_make_nexus(
>   	/*
>   	 * Initialize the struct se_session pointer
>   	 */
> -	tl_nexus->se_sess = transport_init_session(TARGET_PROT_ALL);
> +	tl_nexus->se_sess = transport_init_session(
> +				TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS);
>   	if (IS_ERR(tl_nexus->se_sess)) {
>   		ret = PTR_ERR(tl_nexus->se_sess);
>   		goto out;
> @@ -1377,6 +1425,8 @@ static int tcm_loop_register_configfs(void)
>   					&tcm_loop_check_demo_mode_write_protect;
>   	fabric->tf_ops.tpg_check_prod_mode_write_protect =
>   					&tcm_loop_check_prod_mode_write_protect;
> +	fabric->tf_ops.tpg_check_prot_fabric_only =
> +					&tcm_loop_check_prot_fabric_only;
>   	/*
>   	 * The TCM loopback fabric module runs in demo-mode to a local
>   	 * virtual SCSI device, so fabric dependent initator ACLs are
> @@ -1429,7 +1479,7 @@ static int tcm_loop_register_configfs(void)
>   	 */
>   	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_loop_wwn_attrs;
>   	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = tcm_loop_tpg_attrs;
> -	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
> +	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = tcm_loop_tpg_attrib_attrs;
>   	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
>   	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
>   	/*
> diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
> index 6ae49f2..1e72ff7 100644
> --- a/drivers/target/loopback/tcm_loop.h
> +++ b/drivers/target/loopback/tcm_loop.h
> @@ -43,6 +43,7 @@ struct tcm_loop_nacl {
>   struct tcm_loop_tpg {
>   	unsigned short tl_tpgt;
>   	unsigned short tl_transport_status;
> +	enum target_prot_type tl_fabric_prot_type;
>   	atomic_t tl_tpg_port_count;
>   	struct se_portal_group tl_se_tpg;
>   	struct tcm_loop_hba *tl_hba;
>
