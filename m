From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH-v2 02/12] target: Convert demo-mode only drivers to
 target_alloc_session
Date: Tue, 26 Jan 2016 10:45:52 +0100
Message-ID: <56A74050.2020202@suse.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
 <1453709466-6308-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933692AbcAZJpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 04:45:54 -0500
In-Reply-To: <1453709466-6308-3-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>

On 25/01/16 09:10, Nicholas A. Bellinger wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Chris Boot <bootc@bootc.net>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/loopback/tcm_loop.c  | 35 +++++--------------------
>  drivers/target/sbp/sbp_target.c     | 33 ++++++------------------
>  drivers/usb/gadget/function/f_tcm.c | 45 ++++++++++----------------------
>  drivers/xen/xen-scsiback.c          | 51 ++++++++++---------------------------
>  4 files changed, 42 insertions(+), 122 deletions(-)

Regarding drivers/xen/xen-scsiback.c:
Acked-by: Juergen Gross <jgross@suse.com>

> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index d41a5c3..0216c75 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -806,54 +806,33 @@ static int tcm_loop_make_nexus(
>  	struct tcm_loop_tpg *tl_tpg,
>  	const char *name)
>  {
> -	struct se_portal_group *se_tpg;
>  	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
>  	struct tcm_loop_nexus *tl_nexus;
> -	int ret = -ENOMEM;
>  
>  	if (tl_tpg->tl_nexus) {
>  		pr_debug("tl_tpg->tl_nexus already exists\n");
>  		return -EEXIST;
>  	}
> -	se_tpg = &tl_tpg->tl_se_tpg;
>  
>  	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
>  	if (!tl_nexus) {
>  		pr_err("Unable to allocate struct tcm_loop_nexus\n");
>  		return -ENOMEM;
>  	}
> -	/*
> -	 * Initialize the struct se_session pointer
> -	 */
> -	tl_nexus->se_sess = transport_init_session(
> -				TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS);
> +
> +	tl_nexus->se_sess = target_alloc_session(&tl_tpg->tl_se_tpg, 0, 0,
> +					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
> +					name, tl_nexus, NULL);
>  	if (IS_ERR(tl_nexus->se_sess)) {
> -		ret = PTR_ERR(tl_nexus->se_sess);
> -		goto out;
> -	}
> -	/*
> -	 * Since we are running in 'demo mode' this call with generate a
> -	 * struct se_node_acl for the tcm_loop struct se_portal_group with the SCSI
> -	 * Initiator port name of the passed configfs group 'name'.
> -	 */
> -	tl_nexus->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
> -				se_tpg, (unsigned char *)name);
> -	if (!tl_nexus->se_sess->se_node_acl) {
> -		transport_free_session(tl_nexus->se_sess);
> -		goto out;
> +		kfree(tl_nexus);
> +		return PTR_ERR(tl_nexus->se_sess);
>  	}
> -	/* Now, register the I_T Nexus as active. */
> -	transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
> -			tl_nexus->se_sess, tl_nexus);
> +
>  	tl_tpg->tl_nexus = tl_nexus;
>  	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
>  		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
>  		name);
>  	return 0;
> -
> -out:
> -	kfree(tl_nexus);
> -	return ret;
>  }
>  
>  static int tcm_loop_drop_nexus(
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 3072f1a..ddd3398 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -196,45 +196,28 @@ static struct sbp_session *sbp_session_create(
>  	struct sbp_session *sess;
>  	int ret;
>  	char guid_str[17];
> -	struct se_node_acl *se_nacl;
> +
> +	snprintf(guid_str, sizeof(guid_str), "%016llx", guid);
>  
>  	sess = kmalloc(sizeof(*sess), GFP_KERNEL);
>  	if (!sess) {
>  		pr_err("failed to allocate session descriptor\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
> +	spin_lock_init(&sess->lock);
> +	INIT_LIST_HEAD(&sess->login_list);
> +	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
> +	sess->guid = guid;
>  
> -	sess->se_sess = transport_init_session(TARGET_PROT_NORMAL);
> +	sess->se_sess = target_alloc_session(&tpg->se_tpg, 0, 0, TARGET_PROT_NORMAL,
> +					     guid_str, sess, NULL);
>  	if (IS_ERR(sess->se_sess)) {
>  		pr_err("failed to init se_session\n");
> -
>  		ret = PTR_ERR(sess->se_sess);
>  		kfree(sess);
>  		return ERR_PTR(ret);
>  	}
>  
> -	snprintf(guid_str, sizeof(guid_str), "%016llx", guid);
> -
> -	se_nacl = core_tpg_check_initiator_node_acl(&tpg->se_tpg, guid_str);
> -	if (!se_nacl) {
> -		pr_warn("Node ACL not found for %s\n", guid_str);
> -
> -		transport_free_session(sess->se_sess);
> -		kfree(sess);
> -
> -		return ERR_PTR(-EPERM);
> -	}
> -
> -	sess->se_sess->se_node_acl = se_nacl;
> -
> -	spin_lock_init(&sess->lock);
> -	INIT_LIST_HEAD(&sess->login_list);
> -	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
> -
> -	sess->guid = guid;
> -
> -	transport_register_session(&tpg->se_tpg, se_nacl, sess->se_sess, sess);
> -
>  	return sess;
>  }
>  
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index bad007b5..2e8b91d 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1581,53 +1581,34 @@ out:
>  
>  static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
>  {
> -	struct se_portal_group *se_tpg;
>  	struct tcm_usbg_nexus *tv_nexus;
> -	int ret;
> +	int ret = 0;
>  
>  	mutex_lock(&tpg->tpg_mutex);
>  	if (tpg->tpg_nexus) {
>  		ret = -EEXIST;
>  		pr_debug("tpg->tpg_nexus already exists\n");
> -		goto err_unlock;
> +		goto out_unlock;
>  	}
> -	se_tpg = &tpg->se_tpg;
>  
> -	ret = -ENOMEM;
>  	tv_nexus = kzalloc(sizeof(*tv_nexus), GFP_KERNEL);
> -	if (!tv_nexus)
> -		goto err_unlock;
> -	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
> -	if (IS_ERR(tv_nexus->tvn_se_sess))
> -		goto err_free;
> +	if (!tv_nexus) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
>  
> -	/*
> -	 * Since we are running in 'demo mode' this call with generate a
> -	 * struct se_node_acl for the tcm_vhost struct se_portal_group with
> -	 * the SCSI Initiator port name of the passed configfs group 'name'.
> -	 */
> -	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
> -			se_tpg, name);
> -	if (!tv_nexus->tvn_se_sess->se_node_acl) {
> +	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, 0, 0,
> +						     TARGET_PROT_NORMAL, name,
> +						     tv_nexus, NULL);
> +	if (IS_ERR(tv_nexus->tvn_se_sess)) {
>  #define MAKE_NEXUS_MSG "core_tpg_check_initiator_node_acl() failed for %s\n"
>  		pr_debug(MAKE_NEXUS_MSG, name);
>  #undef MAKE_NEXUS_MSG
> -		goto err_session;
> +		kfree(tv_nexus);
> +		ret = PTR_ERR(tv_nexus->tvn_se_sess);
>  	}
> -	/*
> -	 * Now register the TCM vHost virtual I_T Nexus as active.
> -	 */
> -	transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
> -			tv_nexus->tvn_se_sess, tv_nexus);
> -	tpg->tpg_nexus = tv_nexus;
> -	mutex_unlock(&tpg->tpg_mutex);
> -	return 0;
>  
> -err_session:
> -	transport_free_session(tv_nexus->tvn_se_sess);
> -err_free:
> -	kfree(tv_nexus);
> -err_unlock:
> +out_unlock:
>  	mutex_unlock(&tpg->tpg_mutex);
>  	return ret;
>  }
> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index 43bcae8..594f8a7 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -1485,58 +1485,35 @@ static struct configfs_attribute *scsiback_param_attrs[] = {
>  static int scsiback_make_nexus(struct scsiback_tpg *tpg,
>  				const char *name)
>  {
> -	struct se_portal_group *se_tpg;
> -	struct se_session *se_sess;
>  	struct scsiback_nexus *tv_nexus;
> +	int ret = 0;
>  
>  	mutex_lock(&tpg->tv_tpg_mutex);
>  	if (tpg->tpg_nexus) {
> -		mutex_unlock(&tpg->tv_tpg_mutex);
>  		pr_debug("tpg->tpg_nexus already exists\n");
> -		return -EEXIST;
> +		ret = -EEXIST;
> +		goto out_unlock;
>  	}
> -	se_tpg = &tpg->se_tpg;
>  
>  	tv_nexus = kzalloc(sizeof(struct scsiback_nexus), GFP_KERNEL);
>  	if (!tv_nexus) {
> -		mutex_unlock(&tpg->tv_tpg_mutex);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto out_unlock;
>  	}
> -	/*
> -	 * Initialize the struct se_session pointer
> -	 */
> -	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
> +
> +	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, 0, 0,
> +						     TARGET_PROT_NORMAL, name,
> +						     tv_nexus, NULL);
>  	if (IS_ERR(tv_nexus->tvn_se_sess)) {
> -		mutex_unlock(&tpg->tv_tpg_mutex);
>  		kfree(tv_nexus);
> -		return -ENOMEM;
> -	}
> -	se_sess = tv_nexus->tvn_se_sess;
> -	/*
> -	 * Since we are running in 'demo mode' this call with generate a
> -	 * struct se_node_acl for the scsiback struct se_portal_group with
> -	 * the SCSI Initiator port name of the passed configfs group 'name'.
> -	 */
> -	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
> -				se_tpg, (unsigned char *)name);
> -	if (!tv_nexus->tvn_se_sess->se_node_acl) {
> -		mutex_unlock(&tpg->tv_tpg_mutex);
> -		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
> -			 name);
> -		goto out;
> +		ret = -ENOMEM;
> +		goto out_unlock;
>  	}
> -	/* Now register the TCM pvscsi virtual I_T Nexus as active. */
> -	transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
> -			tv_nexus->tvn_se_sess, tv_nexus);
> -	tpg->tpg_nexus = tv_nexus;
>  
> +	tpg->tpg_nexus = tv_nexus;
> +out_unlock:
>  	mutex_unlock(&tpg->tv_tpg_mutex);
> -	return 0;
> -
> -out:
> -	transport_free_session(se_sess);
> -	kfree(tv_nexus);
> -	return -ENOMEM;
> +	return ret;
>  }
>  
>  static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
> 

