From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 2/4] tcm_qla2xxx: T10-Dif set harware capability
Date: Sat, 29 Mar 2014 03:12:59 +0300
Message-ID: <5336100B.1010604@mellanox.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com> <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On 3/29/2014 2:05 AM, Quinn Tran wrote:
> Set Protection Type(1,2,3) capabilities, Guarg type (CRC/IPchksm)
> capabilities bits to let TCM core knows of HW/fabric capabilities.
>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 23 +++++++++++++++++++++++
>   drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 +
>   2 files changed, 24 insertions(+)
>
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index b23a0ff..4d93081 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -910,12 +910,20 @@ DEF_QLA_TPG_ATTR_BOOL(demo_mode_login_only);
>   DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
>   QLA_TPG_ATTR(demo_mode_login_only, S_IRUGO | S_IWUSR);
>   
> +/*
> + * Define tcm_qla2xxx_tpg_attrib_s_t10dif_force_on
> + */
> +DEF_QLA_TPG_ATTR_BOOL(t10dif_force_on);
> +DEF_QLA_TPG_ATTRIB(t10dif_force_on);
> +QLA_TPG_ATTR(t10dif_force_on, S_IRUGO | S_IWUSR);
> +
>   static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
>   	&tcm_qla2xxx_tpg_attrib_generate_node_acls.attr,
>   	&tcm_qla2xxx_tpg_attrib_cache_dynamic_acls.attr,
>   	&tcm_qla2xxx_tpg_attrib_demo_mode_write_protect.attr,
>   	&tcm_qla2xxx_tpg_attrib_prod_mode_write_protect.attr,
>   	&tcm_qla2xxx_tpg_attrib_demo_mode_login_only.attr,
> +	&tcm_qla2xxx_tpg_attrib_t10dif_force_on.attr,
>   	NULL,
>   };
>   
> @@ -1049,6 +1057,18 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
>   	tpg->tpg_attrib.demo_mode_write_protect = 1;
>   	tpg->tpg_attrib.cache_dynamic_acls = 1;
>   	tpg->tpg_attrib.demo_mode_login_only = 1;
> +	tpg->tpg_attrib.t10dif_force_on = 0;
> +	tpg->se_tpg.fabric_sup_prot_type = 0;
> +	tpg->se_tpg.fabric_sup_guard_type = 0;

You can lose guard_type - this is more relevant to the initiator side.

> +
> +	if (scsi_host_get_prot(lport->qla_vha->host)) {
> +		tpg->se_tpg.fabric_sup_prot_type = (TARGET_DIF_TYPE0_PROT|
> +			TARGET_DIF_TYPE1_PROT|TARGET_DIF_TYPE2_PROT|
> +			TARGET_DIF_TYPE3_PROT);
> +
> +		tpg->se_tpg.fabric_sup_guard_type = TARGET_GUARD_CRC|
> +			TARGET_GUARD_IP;
> +	}
>   
>   	ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
>   				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
> @@ -1127,6 +1147,8 @@ static ssize_t tcm_qla2xxx_npiv_tpg_store_enable(
>   		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
>   	}
>   
> +	core_tpg_set_fabric_t10dif(se_tpg, tpg->tpg_attrib.t10dif_force_on);
> +

Any way we can get this logic to be shared also with iscsi, srp, etc... 
all fabrics should
be set with t10dif right? so I would imagine it would be better to 
centralize it right?

>   	return count;
>   }
>   
> @@ -1169,6 +1191,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
>   	tpg->tpg_attrib.demo_mode_write_protect = 1;
>   	tpg->tpg_attrib.cache_dynamic_acls = 1;
>   	tpg->tpg_attrib.demo_mode_login_only = 1;
> +	tpg->tpg_attrib.t10dif_force_on = 0;
>   
>   	ret = core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
>   				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> index 33aaac8..62fdce3 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> @@ -28,6 +28,7 @@ struct tcm_qla2xxx_tpg_attrib {
>   	int demo_mode_write_protect;
>   	int prod_mode_write_protect;
>   	int demo_mode_login_only;
> +	int t10dif_force_on;
>   };
>   
>   struct tcm_qla2xxx_tpg {
