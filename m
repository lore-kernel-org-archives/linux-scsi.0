From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard capability
 to the tcm_qla2xxx module
Date: Mon, 04 Apr 2016 13:54:11 -0700
Message-ID: <1459803251.10124.7.camel@haakon3.risingtidesystems.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com>
	 <56FB5E98.9010103@sandisk.com>
	 <1459402453.31390.45.camel@haakon3.risingtidesystems.com>
	 <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com>
	 <1049122887.26432420.1459534525185.JavaMail.zimbra@redhat.com>
	 <1615130599.26684873.1459613094650.JavaMail.zimbra@redhat.com>
	 <363538615.26701710.1459617008813.JavaMail.zimbra@redhat.com>
	 <1459640375.13184.14.camel@haakon3.risingtidesystems.com>
	 <1261843246.27018882.1459691827923.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53927 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbcDDUyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 16:54:14 -0400
In-Reply-To: <1261843246.27018882.1459691827923.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>

On Sun, 2016-04-03 at 09:57 -0400, Laurence Oberman wrote:
> Hi Nicholas
> 
> Apologies for the top posting, that was in my haste to correct the prior patch that had the typo.
> When I investigated the attributes it looked like I would have had to create a store and a check function and call the check function each time.
> That was my lack of understanding of the functionality.
> 
> I also looked at your example and in my case I needed a way to set the attribute to a number matching the host#.
> When I tested this I was only able to set boolean values of 1 or 0 for the attributes and the definition of
> tcm_qla2xxx_tpg_attrib_##name##_store validates that only booleans of 1 or 0 are supported.
> 
> However after your email I then realized using a boolean on the endpoints below will work here.
> Thank you for taking the time to show me, it was very helpful.
> 
> sys]# find . -name jam_host
> ./kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
> ./kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:af/tpgt_1/attrib/jam_host
> 
> I tested this and here are the patches in the format you require.
> Hopefully this new functionality will be useful for others.
> I am not set for emailing directly from git.
> 
> Tested by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/scsi/qla2xxx/Kconfig       |   11 +++++++++++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++++++++++++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    1 +
>  3 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
> index 10aa18b..5110fab 100644
> --- a/drivers/scsi/qla2xxx/Kconfig
> +++ b/drivers/scsi/qla2xxx/Kconfig
> @@ -36,3 +36,14 @@ config TCM_QLA2XXX
>  	default n
>  	---help---
>  	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+ series target mode HBAs
> +
> +config TCM_QLA2XXX_DEBUG
> +	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series target mode HBAs"
> +	depends on SCSI_QLA_FC && TARGET_CORE
> +	depends on LIBFC
> +	select BTREE
> +	default n
> +	---help---
> +	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for QLogic 24xx+ series target mode HBAs
> +	This will include code to enable the SCSI command jammer
> +

Instead of duplicating the 'depends' here for TCM_QLA2XXX, just do a:

if TCM_QLA2XXX

config TCM_QLA2XXX_DEBUG
...
...

endif

> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 1808a01..411a450 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -457,6 +457,10 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>  	struct se_cmd *se_cmd = &cmd->se_cmd;
>  	struct se_session *se_sess;
>  	struct qla_tgt_sess *sess;
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +        struct se_portal_group *se_tpg;
> +        struct tcm_qla2xxx_tpg *tpg;
> +#endif

Whitespace instead of TAB here.

>  	int flags = TARGET_SCF_ACK_KREF;
>  
>  	if (bidi)
> @@ -476,6 +480,15 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>  		pr_err("Unable to locate active struct se_session\n");
>  		return -EINVAL;
>  	}
> + 
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +	se_tpg = se_sess->se_tpg;
> +	tpg = container_of(se_tpg,struct tcm_qla2xxx_tpg, se_tpg);
> + 	if (unlikely(tpg->tpg_attrib.jam_host)) {
> + 		/* return, and dont run target_submit_cmd,discarding command */
> +                return 0;
> +	}
> +#endif

Whitespace instead of TABs here too.

>  
>  	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
>  	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> @@ -844,6 +857,9 @@ DEF_QLA_TPG_ATTRIB(cache_dynamic_acls);
>  DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
>  DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
>  DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +DEF_QLA_TPG_ATTRIB(jam_host);
> +#endif
>  
>  static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
>  	&tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
> @@ -851,6 +867,9 @@ static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
>  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
>  	&tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
>  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +        &tcm_qla2xxx_tpg_attrib_attr_jam_host,
> +#endif
>  	NULL,
>  };

Whitespace instead of TABs here too.


