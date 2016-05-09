From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard capability
 to the tcm_qla2xxx module
Date: Mon, 9 May 2016 10:56:04 -0400 (EDT)
Message-ID: <1911585367.34699247.1462805764493.JavaMail.zimbra@redhat.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com> <1049122887.26432420.1459534525185.JavaMail.zimbra@redhat.com> <1615130599.26684873.1459613094650.JavaMail.zimbra@redhat.com> <363538615.26701710.1459617008813.JavaMail.zimbra@redhat.com> <1459640375.13184.14.camel@haakon3.risingtidesystems.com> <1261843246.27018882.1459691827923.JavaMail.zimbra@redhat.com> <1459803251.10124.7.camel@haakon3.risingtidesystems.com> <40304386.27344954.1459810203532.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:46081 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcEIO4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 10:56:10 -0400
In-Reply-To: <40304386.27344954.1459810203532.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> Cc: "Himanshu Madhani" <himanshu.madhani@qlogic.com>, "Bart Van Assche" <bart.vanassche@sandisk.com>, "linux-scsi"
> <linux-scsi@vger.kernel.org>, "target-devel" <target-devel@vger.kernel.org>, "Quinn Tran" <quinn.tran@qlogic.com>
> Sent: Monday, April 4, 2016 6:50:03 PM
> Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard capability to the tcm_qla2xxx module
> 
> Hello Nicholas
> 
> Its fixed now.
> Many Thanks.
> 
> $ scripts/checkpatch.pl
> 0001-tcm_qla2xxx-Add-SCSI-command-jammer-discard-capabili.patch
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #12:
> new file mode 100644
> 
> total: 0 errors, 1 warnings, 91 lines checked
> 
> 0001-tcm_qla2xxx-Add-SCSI-command-jammer-discard-capabili.patch has style
> problems, please review.
> 
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> 
> 
> Tested by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>  Documentation/scsi/tcm_qla2xxx.txt |   22 ++++++++++++++++++++++
>  drivers/scsi/qla2xxx/Kconfig       |    9 +++++++++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++++++++++++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    1 +
>  4 files changed, 52 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/scsi/tcm_qla2xxx.txt
> 
> diff --git a/Documentation/scsi/tcm_qla2xxx.txt
> b/Documentation/scsi/tcm_qla2xxx.txt
> new file mode 100644
> index 0000000..c3a670a
> --- /dev/null
> +++ b/Documentation/scsi/tcm_qla2xxx.txt
> @@ -0,0 +1,22 @@
> +tcm_qla2xxx jam_host attribute
> +------------------------------
> +There is now a new module endpoint atribute called jam_host
> +attribute: jam_host: boolean=0/1
> +This attribute and accompanying code is only included if the
> +Kconfig parameter TCM_QLA2XXX_DEBUG is set to Y
> +By default this jammer code and functionality is disabled
> +
> +Use this attribute to control the discarding of SCSI commands to a
> +selected host.
> +This may be useful for testing error handling and simulating slow drain
> +and other fabric issues.
> +
> +Setting a boolean of 1 for the jam_host attribute for a particular host
> + will discard the commands for that host.
> +Reset back to 0 to stop the jamming.
> +
> +Enable host 4 to be jammed
> +echo 1 >
> /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
> +
> +Disable jamming on host 4
> +echo 0 >
> /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
> diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
> index 10aa18b..67c0d5a 100644
> --- a/drivers/scsi/qla2xxx/Kconfig
> +++ b/drivers/scsi/qla2xxx/Kconfig
> @@ -36,3 +36,12 @@ config TCM_QLA2XXX
>  	default n
>  	---help---
>  	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+ series
>  	target mode HBAs
> +
> +if TCM_QLA2XXX
> +config TCM_QLA2XXX_DEBUG
> +	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series target
> mode HBAs"
> +	default n
> +	---help---
> +	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for QLogic 24xx+
> series target mode HBAs
> +	This will include code to enable the SCSI command jammer
> +endif
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 1808a01..948224e 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -457,6 +457,10 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha,
> struct qla_tgt_cmd *cmd,
>  	struct se_cmd *se_cmd = &cmd->se_cmd;
>  	struct se_session *se_sess;
>  	struct qla_tgt_sess *sess;
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +	struct se_portal_group *se_tpg;
> +	struct tcm_qla2xxx_tpg *tpg;
> +#endif
>  	int flags = TARGET_SCF_ACK_KREF;
>  
>  	if (bidi)
> @@ -477,6 +481,15 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha,
> struct qla_tgt_cmd *cmd,
>  		return -EINVAL;
>  	}
>  
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +	se_tpg = se_sess->se_tpg;
> +	tpg = container_of(se_tpg, struct tcm_qla2xxx_tpg, se_tpg);
> +	if (unlikely(tpg->tpg_attrib.jam_host)) {
> +		/* return, and dont run target_submit_cmd,discarding command */
> +		return 0;
> +	}
> +#endif
> +
>  	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
>  	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
>  				cmd->unpacked_lun, data_length, fcp_task_attr,
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
> @@ -851,6 +867,9 @@ static struct configfs_attribute
> *tcm_qla2xxx_tpg_attrib_attrs[] = {
>  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
>  	&tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
>  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> +	&tcm_qla2xxx_tpg_attrib_attr_jam_host,
> +#endif
>  	NULL,
>  };
>  
> @@ -1023,6 +1042,7 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
>  	tpg->tpg_attrib.demo_mode_write_protect = 1;
>  	tpg->tpg_attrib.cache_dynamic_acls = 1;
>  	tpg->tpg_attrib.demo_mode_login_only = 1;
> +	tpg->tpg_attrib.jam_host = 0;
>  
>  	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
>  	if (ret < 0) {
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> index 3bbf4cb..37e026a 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> @@ -34,6 +34,7 @@ struct tcm_qla2xxx_tpg_attrib {
>  	int prod_mode_write_protect;
>  	int demo_mode_login_only;
>  	int fabric_prot_type;
> +	int jam_host;
>  };
>  
>  struct tcm_qla2xxx_tpg {
> --
> 1.7.1
> 
> 
> Laurence Oberman
> Principal Software Maintenance Engineer
> Red Hat Global Support Services
> 
> ----- Original Message -----
> From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Himanshu Madhani" <himanshu.madhani@qlogic.com>, "Bart Van Assche"
> <bart.vanassche@sandisk.com>, "linux-scsi" <linux-scsi@vger.kernel.org>,
> "target-devel" <target-devel@vger.kernel.org>, "Quinn Tran"
> <quinn.tran@qlogic.com>
> Sent: Monday, April 4, 2016 4:54:11 PM
> Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard capability
> to the tcm_qla2xxx module
> 
> On Sun, 2016-04-03 at 09:57 -0400, Laurence Oberman wrote:
> > Hi Nicholas
> > 
> > Apologies for the top posting, that was in my haste to correct the prior
> > patch that had the typo.
> > When I investigated the attributes it looked like I would have had to
> > create a store and a check function and call the check function each time.
> > That was my lack of understanding of the functionality.
> > 
> > I also looked at your example and in my case I needed a way to set the
> > attribute to a number matching the host#.
> > When I tested this I was only able to set boolean values of 1 or 0 for the
> > attributes and the definition of
> > tcm_qla2xxx_tpg_attrib_##name##_store validates that only booleans of 1 or
> > 0 are supported.
> > 
> > However after your email I then realized using a boolean on the endpoints
> > below will work here.
> > Thank you for taking the time to show me, it was very helpful.
> > 
> > sys]# find . -name jam_host
> > ./kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
> > ./kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:af/tpgt_1/attrib/jam_host
> > 
> > I tested this and here are the patches in the format you require.
> > Hopefully this new functionality will be useful for others.
> > I am not set for emailing directly from git.
> > 
> > Tested by: Laurence Oberman <loberman@redhat.com>
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > ---
> >  drivers/scsi/qla2xxx/Kconfig       |   11 +++++++++++
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++++++++++++
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    1 +
> >  3 files changed, 32 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
> > index 10aa18b..5110fab 100644
> > --- a/drivers/scsi/qla2xxx/Kconfig
> > +++ b/drivers/scsi/qla2xxx/Kconfig
> > @@ -36,3 +36,14 @@ config TCM_QLA2XXX
> >  	default n
> >  	---help---
> >  	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+
> >  	series target mode HBAs
> > +
> > +config TCM_QLA2XXX_DEBUG
> > +	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series target
> > mode HBAs"
> > +	depends on SCSI_QLA_FC && TARGET_CORE
> > +	depends on LIBFC
> > +	select BTREE
> > +	default n
> > +	---help---
> > +	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for QLogic 24xx+
> > series target mode HBAs
> > +	This will include code to enable the SCSI command jammer
> > +
> 
> Instead of duplicating the 'depends' here for TCM_QLA2XXX, just do a:
> 
> if TCM_QLA2XXX
> 
> config TCM_QLA2XXX_DEBUG
> ...
> ...
> 
> endif
> 
> > diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > index 1808a01..411a450 100644
> > --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > @@ -457,6 +457,10 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t
> > *vha, struct qla_tgt_cmd *cmd,
> >  	struct se_cmd *se_cmd = &cmd->se_cmd;
> >  	struct se_session *se_sess;
> >  	struct qla_tgt_sess *sess;
> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> > +        struct se_portal_group *se_tpg;
> > +        struct tcm_qla2xxx_tpg *tpg;
> > +#endif
> 
> Whitespace instead of TAB here.
> 
> >  	int flags = TARGET_SCF_ACK_KREF;
> >  
> >  	if (bidi)
> > @@ -476,6 +480,15 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t
> > *vha, struct qla_tgt_cmd *cmd,
> >  		pr_err("Unable to locate active struct se_session\n");
> >  		return -EINVAL;
> >  	}
> > +
> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> > +	se_tpg = se_sess->se_tpg;
> > +	tpg = container_of(se_tpg,struct tcm_qla2xxx_tpg, se_tpg);
> > + 	if (unlikely(tpg->tpg_attrib.jam_host)) {
> > + 		/* return, and dont run target_submit_cmd,discarding command */
> > +                return 0;
> > +	}
> > +#endif
> 
> Whitespace instead of TABs here too.
> 
> >  
> >  	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
> >  	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> > @@ -844,6 +857,9 @@ DEF_QLA_TPG_ATTRIB(cache_dynamic_acls);
> >  DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
> >  DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
> >  DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> > +DEF_QLA_TPG_ATTRIB(jam_host);
> > +#endif
> >  
> >  static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
> >  	&tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
> > @@ -851,6 +867,9 @@ static struct configfs_attribute
> > *tcm_qla2xxx_tpg_attrib_attrs[] = {
> >  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
> >  	&tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
> >  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> > +        &tcm_qla2xxx_tpg_attrib_attr_jam_host,
> > +#endif
> >  	NULL,
> >  };
> 
> Whitespace instead of TABs here too.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Himanshu, Quinn

Is this patch good now to be taken.

Thanks
Laurence

