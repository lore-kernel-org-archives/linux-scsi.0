From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch 1/4 v2] SCSI: target: dereferencing ERR_PTRs
Date: Wed, 15 Jun 2011 09:38:31 -0700
Message-ID: <1308155911.20109.6.camel@haakon2.linux-iscsi.org>
References: <20110614072720.GO3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35635 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1FOQrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 12:47:22 -0400
In-Reply-To: <20110614072720.GO3583@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, Ankit Jain <jankit@suse.de>, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Tue, 2011-06-14 at 10:27 +0300, Dan Carpenter wrote:
> transport_init_session() and core_tmr_alloc_req() never return NULL,
> they only return ERR_PTRs on error.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2: return PTR_ERR(tl_nexus->se_sess); for Ankit Jain.
> 

Thanks Dan and Ankit!  Committed as 4e559cb1699 into lio-core-2.6.git

--nab

> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index a3bd57f..03744c2 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -229,7 +229,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
>  		return NULL;
>  
>  	sess->se_sess = transport_init_session();
> -	if (!sess->se_sess) {
> +	if (IS_ERR(sess->se_sess)) {
>  		kfree(sess);
>  		return NULL;
>  	}
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index dee2a2c..77ff8d0 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -386,7 +386,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
>  	 */
>  	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, (void *)tl_tmr,
>  				TMR_LUN_RESET);
> -	if (!se_cmd->se_tmr_req)
> +	if (IS_ERR(se_cmd->se_tmr_req))
>  		goto release;
>  	/*
>  	 * Locate the underlying TCM struct se_lun from sc->device->lun
> @@ -1017,6 +1017,7 @@ static int tcm_loop_make_nexus(
>  	struct se_portal_group *se_tpg;
>  	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
>  	struct tcm_loop_nexus *tl_nexus;
> +	int ret = -ENOMEM;
>  
>  	if (tl_tpg->tl_hba->tl_nexus) {
>  		printk(KERN_INFO "tl_tpg->tl_hba->tl_nexus already exists\n");
> @@ -1033,8 +1034,11 @@ static int tcm_loop_make_nexus(
>  	 * Initialize the struct se_session pointer
>  	 */
>  	tl_nexus->se_sess = transport_init_session();
> -	if (!tl_nexus->se_sess)
> +	if (IS_ERR(tl_nexus->se_sess)) {
> +		ret = PTR_ERR(tl_nexus->se_sess);
>  		goto out;
> +	}
> +
>  	/*
>  	 * Since we are running in 'demo mode' this call with generate a
>  	 * struct se_node_acl for the tcm_loop struct se_portal_group with the SCSI
> @@ -1060,7 +1064,7 @@ static int tcm_loop_make_nexus(
>  
>  out:
>  	kfree(tl_nexus);
> -	return -ENOMEM;
> +	return ret;
>  }
>  
>  static int tcm_loop_drop_nexus(

