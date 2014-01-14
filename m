From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Enhancements to enable NPIV support for QLOGIC
 ISPs with TCM/LIO.
Date: Mon, 13 Jan 2014 21:00:20 -0800
Message-ID: <1389675620.5567.488.camel@haakon3.risingtidesystems.com>
References: <1389298424-10371-1-git-send-email-saurav.kashyap@qlogic.com>
	 <1389663375.5567.482.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389663375.5567.482.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hey Saurav & Co,

Another quick question..  So I'm trying to configure a QLogic Sanbox
5600 switch to test the NPIV target related code..

However, I'm currently running into failures during
qla_mid.c:qla24xx_vport_create_req_sanity_check() at the point where the
switch is checked for NPIV support, eg:

        /* Check up whether npiv supported switch presented */
        if (!(ha->switch_cap & FLOGI_MID_SUPPORT))
                return VPCERR_NO_FABRIC_SUPP;

which is failing with both the original patch, as well as the updated
version to call fc_vport_create() directly from tcm_qla2xxx control path
code.

FYI, this is with the latest firmware (V7.4.0.29.0) on the 5600.  Is
there anything special that I need to do extra to enable / configure
NPIV here..?

TIA!

--nab

On Mon, 2014-01-13 at 17:36 -0800, Nicholas A. Bellinger wrote:
> Hi Saurav & Co,
> 
> Thanks for posting, and apologies for the slight delay.
> 
> Comments are below.
> 
> On Thu, 2014-01-09 at 15:13 -0500, Saurav Kashyap wrote:
> > Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
> > Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> > Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_attr.c    |    2 +
> >  drivers/scsi/qla2xxx/qla_def.h     |   12 ++-
> >  drivers/scsi/qla2xxx/qla_target.c  |  150 +++++++++++++++++++-----------------
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  110 +++++++++++++++-----------
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    4 -
> >  5 files changed, 153 insertions(+), 125 deletions(-)
> 
> <SNIP>
> 
> > diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > index 7eb19be..113ca95 100644
> > --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> 
> <SNIP>
> 
> > @@ -1650,6 +1645,9 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
> >  	struct tcm_qla2xxx_lport *lport;
> >  	u64 npiv_wwpn, npiv_wwnn;
> >  	int ret;
> > +	struct scsi_qla_host *vha = NULL;
> > +	struct qla_hw_data *ha = NULL;
> > +	scsi_qla_host_t *base_vha = NULL;
> >  
> >  	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
> >  				&npiv_wwpn, &npiv_wwnn) < 0)
> > @@ -1666,12 +1664,29 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
> >  			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
> >  	sprintf(lport->lport_naa_name, "naa.%016llx", (unsigned long long) npiv_wwpn);
> >  
> > -/* FIXME: tcm_qla2xxx_npiv_make_lport */
> > -	ret = -ENOSYS;
> > +	ret = tcm_qla2xxx_init_lport(lport);
> >  	if (ret != 0)
> >  		goto out;
> >  
> > +	ret = qlt_lport_register(&tcm_qla2xxx_template, npiv_wwpn,
> > +				tcm_qla2xxx_lport_register_cb, lport);
> > +
> > +	if (ret != 0)
> > +		goto out_lport;
> > +
> > +	vha = lport->qla_vha;
> > +	ha = vha->hw;
> > +	base_vha = pci_get_drvdata(ha->pdev);
> > +
> > +	if (!qla_tgt_mode_enabled(base_vha)) {
> > +		ret = -EPERM;
> > +		goto out_lport;
> > +	}
> > +
> 
> As discussed off-list, I'd rather perform the fc_vport creation using
> fc_vport_create() from within tcm_qla2xxx_npiv_make_lport() context,
> instead of using external sysfs attributes separate from the NPIV
> specific TFO->make_wwpn() configfs call.
> 
> This makes life easier for existing userspace code that persists
> configurations across target restart when metadata required to do NPIV
> configuration is entirely encapsulated within the configfs hierarchy. 
> 
> For /sys/kernel/config/target/qla2xxx_npiv/$WWPN, I'd like to propose
> the following format:
> 
>       $PARENT_WWPN@$NPIV_WWPN:$NPIV_WWNN
> 
> which would appear under configfs as:
> 
>       21:00:00:24:ff:31:4c:49@21000000deadbeef:200000000000ffff
> 
> The changes required look something like the following below, that
> applies atop your current patch.
> 
> The qlt_lport_register() (*callback) has been modified to accept the
> passed npiv_wwpn + npiv_wwnn, and then tcm_qla2xxx code calls a NPIV
> specific tcm_qla2xxx_lport_register_npiv_cb() to invoke
> fc_vport_create() directly.
> 
> From there, the struct scsi_qla_host *npiv_vha is extracted from
> vport->dd_data, and pointer assignment set in lport->qla_vha.
> 
> Btw, this code needs a bit more work to extract phys_wwpn from the
> passed configfs name, but should give an idea of how this can work.
> 
> Any objections to this approach..?
> 
> --nab
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 202060d..cebe356 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4235,8 +4235,10 @@ static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
>   * @callback:  lport initialization callback for tcm_qla2xxx code
>   * @target_lport_ptr: pointer for tcm_qla2xxx specific lport data
>   */
> -int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
> -	int (*callback)(struct scsi_qla_host *), void *target_lport_ptr)
> +int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 phys_wwpn,
> +		       u64 npiv_wwpn, u64 npiv_wwnn,
> +		       int (*callback)(struct scsi_qla_host *, u64, u64),
> +		       void *target_lport_ptr)
>  {
>  	struct qla_tgt *tgt;
>  	struct scsi_qla_host *vha;
> @@ -4259,7 +4261,7 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
>  			continue;
>  
>  		spin_lock_irqsave(&ha->hardware_lock, flags);
> -		if (host->active_mode & MODE_TARGET) {
> +		if ((!npiv_wwpn || !npiv_wwnn) && host->active_mode & MODE_TARGET) {
>  			pr_debug("MODE_TARGET already active on qla2xxx(%d)\n",
>  			    host->host_no);
>  			spin_unlock_irqrestore(&ha->hardware_lock, flags);
> @@ -4273,7 +4275,7 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
>  			    " qla2xxx scsi_host\n");
>  			continue;
>  		}
> -		qlt_lport_dump(vha, wwpn, b);
> +		qlt_lport_dump(vha, phys_wwpn, b);
>  
>  		if (memcmp(vha->port_name, b, WWN_SIZE)) {
>  			scsi_host_put(host);
> @@ -4284,7 +4286,7 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
>  		 */
>  		ha->tgt.tgt_ops = qla_tgt_ops;
>  		vha->vha_tgt.target_lport_ptr = target_lport_ptr;
> -		rc = (*callback)(vha);
> +		rc = (*callback)(vha, npiv_wwpn, npiv_wwnn);
>  		if (rc != 0) {
>  			ha->tgt.tgt_ops = NULL;
>  			vha->vha_tgt.target_lport_ptr = NULL;
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index b33e411..2a5d3cb 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -932,8 +932,8 @@ void qlt_disable_vha(struct scsi_qla_host *);
>   */
>  extern int qlt_add_target(struct qla_hw_data *, struct scsi_qla_host *);
>  extern int qlt_remove_target(struct qla_hw_data *, struct scsi_qla_host *);
> -extern int qlt_lport_register(struct qla_tgt_func_tmpl *, u64,
> -			int (*callback)(struct scsi_qla_host *), void *);
> +extern int qlt_lport_register(struct qla_tgt_func_tmpl *, u64, u64, u64,
> +			int (*callback)(struct scsi_qla_host *, u64, u64), void *);
>  extern void qlt_lport_deregister(struct scsi_qla_host *);
>  extern void qlt_unreg_sess(struct qla_tgt_sess *);
>  extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 113ca95..080fae2 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1559,7 +1559,8 @@ static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
>  	return 0;
>  }
>  
> -static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha)
> +static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha,
> +					 u64 npiv_wwpn, u64 npiv_wwnn)
>  {
>  	struct tcm_qla2xxx_lport *lport;
>  	/*
> @@ -1598,7 +1599,7 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
>  	if (ret != 0)
>  		goto out;
>  
> -	ret = qlt_lport_register(&tcm_qla2xxx_template, wwpn,
> +	ret = qlt_lport_register(&tcm_qla2xxx_template, wwpn, 0, 0,
>  				tcm_qla2xxx_lport_register_cb, lport);
>  	if (ret != 0)
>  		goto out_lport;
> @@ -1637,17 +1638,53 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
>  	kfree(lport);
>  }
>  
> +static int tcm_qla2xxx_lport_register_npiv_cb(struct scsi_qla_host *vha,
> +					      u64 npiv_wwpn, u64 npiv_wwnn)
> +{
> +	struct fc_vport *vport;
> +	struct Scsi_Host *sh;
> +	struct scsi_qla_host *npiv_vha;
> +	struct tcm_qla2xxx_lport *lport;
> +	struct fc_vport_identifiers vport_id;
> +
> +	lport = (struct tcm_qla2xxx_lport *)vha->vha_tgt.target_lport_ptr;
> +	sh = vha->host;;
> +
> +	memset(&vport_id, 0, sizeof(vport_id));
> +	vport_id.port_name = npiv_wwpn;
> +	vport_id.node_name = npiv_wwnn;
> +	vport_id.roles = FC_PORT_ROLE_FCP_INITIATOR;
> +	vport_id.vport_type = FC_PORTTYPE_NPIV;
> +	vport_id.disable = false;
> +
> +	vport = fc_vport_create(sh, 0, &vport_id);
> +	if (!vport) {
> +		lport->qla_vha = NULL;
> +		return -ENODEV;
> +	}
> +	/*
> +	 * Setup local pointer to NPIV vhba
> +	 */
> +	npiv_vha = *(struct scsi_qla_host **)vport->dd_data;
> +	lport->qla_vha = npiv_vha;
> +
> +	return 0;
> +}
> +
> +
>  static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
>  	struct target_fabric_configfs *tf,
>  	struct config_group *group,
>  	const char *name)
>  {
>  	struct tcm_qla2xxx_lport *lport;
> -	u64 npiv_wwpn, npiv_wwnn;
> +	u64 phys_wwpn, npiv_wwpn, npiv_wwnn;
>  	int ret;
>  	struct scsi_qla_host *vha = NULL;
>  	struct qla_hw_data *ha = NULL;
>  	scsi_qla_host_t *base_vha = NULL;
> +#warning FIXME: Extract phys_wwpn from passed *name
> +	phys_wwpn = 0;
>  
>  	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
>  				&npiv_wwpn, &npiv_wwnn) < 0)
> @@ -1668,9 +1705,9 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
>  	if (ret != 0)
>  		goto out;
>  
> -	ret = qlt_lport_register(&tcm_qla2xxx_template, npiv_wwpn,
> -				tcm_qla2xxx_lport_register_cb, lport);
> -
> +	ret = qlt_lport_register(&tcm_qla2xxx_template, phys_wwpn, npiv_wwpn,
> +				 npiv_wwnn, tcm_qla2xxx_lport_register_npiv_cb,
> +				 lport);
>  	if (ret != 0)
>  		goto out_lport;
>  
