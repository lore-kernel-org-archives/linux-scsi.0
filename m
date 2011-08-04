From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: TARGET: Use ERR_CAST inlined function
Date: Thu, 04 Aug 2011 11:00:49 -0700
Message-ID: <1312480849.22234.6.camel@haakon2.linux-iscsi.org>
References: <1312235902.2629.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44593 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1HDSKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 14:10:32 -0400
In-Reply-To: <1312235902.2629.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Mon, 2011-08-01 at 23:58 +0200, Thomas Meyer wrote:
> Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/err_cast.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 

Hi Thomas,

This patch has been committed into lio-core-2.6.git/master as
cb057fc79f, and will be queued in the next round of target updates.

Also just an FYI, this patch was missing your 'Signed-off-by' line.  I
went ahead and added this, but please remember to include this in
subsequent patches.

Thanks!

--nab

> diff -u -p a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> --- a/drivers/target/target_core_fabric_configfs.c 2011-07-26 00:46:09.670171895 +0200
> +++ b/drivers/target/target_core_fabric_configfs.c 2011-08-01 20:49:50.880256441 +0200
> @@ -481,7 +481,7 @@ static struct config_group *target_fabri
>  
>  	se_nacl = tf->tf_ops.fabric_make_nodeacl(se_tpg, group, name);
>  	if (IS_ERR(se_nacl))
> -		return ERR_PTR(PTR_ERR(se_nacl));
> +		return ERR_CAST(se_nacl);
>  
>  	nacl_cg = &se_nacl->acl_group;
>  	nacl_cg->default_groups = se_nacl->acl_default_groups;
> diff -u -p a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> --- a/drivers/target/iscsi/iscsi_target_configfs.c 2011-07-28 15:32:18.326584569 +0200
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c 2011-08-01 20:49:55.393565325 +0200
> @@ -268,7 +268,7 @@ struct se_tpg_np *lio_target_call_addnpt
>  				ISCSI_TCP);
>  	if (IS_ERR(tpg_np)) {
>  		iscsit_put_tpg(tpg);
> -		return ERR_PTR(PTR_ERR(tpg_np));
> +		return ERR_CAST(tpg_np);
>  	}
>  	pr_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
>  
> @@ -1285,7 +1285,7 @@ struct se_wwn *lio_target_call_coreaddti
>  
>  	tiqn = iscsit_add_tiqn((unsigned char *)name);
>  	if (IS_ERR(tiqn))
> -		return ERR_PTR(PTR_ERR(tiqn));
> +		return ERR_CAST(tiqn);
>  	/*
>  	 * Setup struct iscsi_wwn_stat_grps for se_wwn->fabric_stat_group.
>  	 */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

