Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC16C4346E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 06:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF98221EB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 06:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g4QWH/t0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgIXGWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:22:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgIXGWv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Sep 2020 02:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600928569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gEcu4iBOxnLTbz9gqtT1ua1Oy+okXu52tVH1BUCGzcg=;
        b=g4QWH/t0/8LC8VVWd2JtVrvVn2COXvd9BrvIg9irGGcwWpdH8FhPdvFDRYXHxVBdxj1hkJ
        JFfMh5SDZ6aMTMcVdc9UYWlZktY7uWcf2jcjxLrR1ftkJyC1EVx2lIKB1AsZS4LRirECqc
        uHACmmRDCpLjXYfLKAN3ZDRA9um0vpE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-bP0SO1pvM8C6CheMEaqjfw-1; Thu, 24 Sep 2020 02:22:37 -0400
X-MC-Unique: bP0SO1pvM8C6CheMEaqjfw-1
Received: by mail-wr1-f72.google.com with SMTP id r16so803110wrm.18
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 23:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gEcu4iBOxnLTbz9gqtT1ua1Oy+okXu52tVH1BUCGzcg=;
        b=TC6ODLq74OZ5xDZ9Ql5CPKiwJ0DlRvmnQbknOMwklHzonWyBG4+uzuPfvRRKuq5jsM
         knk9qJgP99BOuiQyo00306E3sEJSbTPbuqUNSlZqXYuUFWim+GCTlnkjXS37MF6HZ2DW
         SpvUpMQxd0SvduZVKhJ4UUj35zqipUGhctFklT4ugbBEZFmmdOL8soCLg8TvSD58wo1A
         1uGkuFhbd9Si6ZYDoC+wk9R614mWgXRVEax45ey1nNnCYU8KIRjSAZN+GQBxyRAkJ3Cw
         I4H3Qk8xlgn4wkmrtG+IWnYgu6nk+tqd3EXu+p1xHYbo88NJv5gwP/7Q0h/D46K7KSsN
         /ESg==
X-Gm-Message-State: AOAM532/NGodOrI0mbwLvveeJdTnR0RxfjvO1TmHhIwIG4alpoW2yKdY
        aIeq19EyBi/3ZlqzCngwEfFya0hBlDhsXlRI/LIqvoScEQ8cmK/HrgQ0qM9iiiVnzgMluzcxYvG
        stQy0Hq7lUM9MDvzlzFPoNQ==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr2920496wmh.93.1600928556074;
        Wed, 23 Sep 2020 23:22:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoh0ZKLW0e65cydYc7n6/Gq1PKp4GnxH32SyCB3hl8vT0YCuziH4KYTidiSZ4HMuurvOlvqg==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr2920472wmh.93.1600928555769;
        Wed, 23 Sep 2020 23:22:35 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id r21sm2565717wrc.70.2020.09.23.23.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 23:22:34 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:22:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/8] vhost scsi: alloc cmds per vq instead of session
Message-ID: <20200924022107-mutt-send-email-mst@kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-4-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600712588-9514-4-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 21, 2020 at 01:23:03PM -0500, Mike Christie wrote:
> We currently are limited to 256 cmds per session. This leads to problems
> where if the user has increased virtqueue_size to more than 2 or
> cmd_per_lun to more than 256 vhost_scsi_get_tag can fail and the guest
> will get IO errors.
> 
> This patch moves the cmd allocation to per vq so we can easily match
> whatever the user has specified for num_queues and
> virtqueue_size/cmd_per_lun. It also makes it easier to control how much
> memory we preallocate. For cases, where perf is not as important and
> we can use the current defaults (1 vq and 128 cmds per vq) memory use
> from preallocate cmds is cut in half. For cases, where we are willing
> to use more memory for higher perf, cmd mem use will now increase as
> the num queues and queue depth increases.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 204 ++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 127 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index b22adf0..13311b8 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -52,7 +52,6 @@
>  #define VHOST_SCSI_VERSION  "v0.1"
>  #define VHOST_SCSI_NAMELEN 256
>  #define VHOST_SCSI_MAX_CDB_SIZE 32
> -#define VHOST_SCSI_DEFAULT_TAGS 256
>  #define VHOST_SCSI_PREALLOC_SGLS 2048
>  #define VHOST_SCSI_PREALLOC_UPAGES 2048
>  #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
> @@ -189,6 +188,9 @@ struct vhost_scsi_virtqueue {
>  	 * Writers must also take dev mutex and flush under it.
>  	 */
>  	int inflight_idx;
> +	struct vhost_scsi_cmd *scsi_cmds;
> +	struct sbitmap scsi_tags;
> +	int max_cmds;
>  };
>  
>  struct vhost_scsi {
> @@ -324,7 +326,9 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
>  {
>  	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
>  				struct vhost_scsi_cmd, tvc_se_cmd);
> -	struct se_session *se_sess = tv_cmd->tvc_nexus->tvn_se_sess;
> +	struct vhost_scsi_virtqueue *svq = container_of(tv_cmd->tvc_vq,
> +				struct vhost_scsi_virtqueue, vq);
> +	struct vhost_scsi_inflight *inflight = tv_cmd->inflight;
>  	int i;
>  
>  	if (tv_cmd->tvc_sgl_count) {
> @@ -336,8 +340,8 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
>  			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
>  	}
>  
> -	vhost_scsi_put_inflight(tv_cmd->inflight);
> -	target_free_tag(se_sess, se_cmd);
> +	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
> +	vhost_scsi_put_inflight(inflight);
>  }
>  
>  static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
> @@ -566,13 +570,14 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>  }
>  
>  static struct vhost_scsi_cmd *
> -vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
> +vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>  		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
>  		   u32 exp_data_len, int data_direction)
>  {
> +	struct vhost_scsi_virtqueue *svq = container_of(vq,
> +					struct vhost_scsi_virtqueue, vq);
>  	struct vhost_scsi_cmd *cmd;
>  	struct vhost_scsi_nexus *tv_nexus;
> -	struct se_session *se_sess;
>  	struct scatterlist *sg, *prot_sg;
>  	struct page **pages;
>  	int tag, cpu;
> @@ -582,15 +587,14 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>  		pr_err("Unable to locate active struct vhost_scsi_nexus\n");
>  		return ERR_PTR(-EIO);
>  	}
> -	se_sess = tv_nexus->tvn_se_sess;
>  
> -	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
> +	tag = sbitmap_get(&svq->scsi_tags, 0, false);
>  	if (tag < 0) {
>  		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
>  		return ERR_PTR(-ENOMEM);
>  	}


After this change, cpu is uninitialized.


>  
> -	cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[tag];
> +	cmd = &svq->scsi_cmds[tag];
>  	sg = cmd->tvc_sgl;
>  	prot_sg = cmd->tvc_prot_sgl;
>  	pages = cmd->tvc_upages;
> @@ -1065,11 +1069,11 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>  				scsi_command_size(cdb), VHOST_SCSI_MAX_CDB_SIZE);
>  				goto err;
>  		}
> -		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
> +		cmd = vhost_scsi_get_cmd(vq, tpg, cdb, tag, lun, task_attr,
>  					 exp_data_len + prot_bytes,
>  					 data_direction);
>  		if (IS_ERR(cmd)) {
> -			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
> +			vq_err(vq, "vhost_scsi_get_cmd failed %ld\n",
>  			       PTR_ERR(cmd));
>  			goto err;
>  		}
> @@ -1373,6 +1377,83 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  		wait_for_completion(&old_inflight[i]->comp);
>  }
>  
> +static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
> +{
> +	struct vhost_scsi_virtqueue *svq = container_of(vq,
> +					struct vhost_scsi_virtqueue, vq);
> +	struct vhost_scsi_cmd *tv_cmd;
> +	unsigned int i;
> +
> +	if (!svq->scsi_cmds)
> +		return;
> +
> +	for (i = 0; i < svq->max_cmds; i++) {
> +		tv_cmd = &svq->scsi_cmds[i];
> +
> +		kfree(tv_cmd->tvc_sgl);
> +		kfree(tv_cmd->tvc_prot_sgl);
> +		kfree(tv_cmd->tvc_upages);
> +	}
> +
> +	sbitmap_free(&svq->scsi_tags);
> +	kfree(svq->scsi_cmds);
> +	svq->scsi_cmds = NULL;
> +}
> +
> +static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
> +{
> +	struct vhost_scsi_virtqueue *svq = container_of(vq,
> +					struct vhost_scsi_virtqueue, vq);
> +	struct vhost_scsi_cmd *tv_cmd;
> +	unsigned int i;
> +
> +	if (svq->scsi_cmds)
> +		return 0;
> +
> +	if (sbitmap_init_node(&svq->scsi_tags, max_cmds, -1, GFP_KERNEL,
> +			      NUMA_NO_NODE))
> +		return -ENOMEM;
> +	svq->max_cmds = max_cmds;
> +
> +	svq->scsi_cmds = kcalloc(max_cmds, sizeof(*tv_cmd), GFP_KERNEL);
> +	if (!svq->scsi_cmds) {
> +		sbitmap_free(&svq->scsi_tags);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < max_cmds; i++) {
> +		tv_cmd = &svq->scsi_cmds[i];
> +
> +		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
> +					  sizeof(struct scatterlist),
> +					  GFP_KERNEL);
> +		if (!tv_cmd->tvc_sgl) {
> +			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
> +			goto out;
> +		}
> +
> +		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
> +					     sizeof(struct page *),
> +					     GFP_KERNEL);
> +		if (!tv_cmd->tvc_upages) {
> +			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
> +			goto out;
> +		}
> +
> +		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
> +					       sizeof(struct scatterlist),
> +					       GFP_KERNEL);
> +		if (!tv_cmd->tvc_prot_sgl) {
> +			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
> +			goto out;
> +		}
> +	}
> +	return 0;
> +out:
> +	vhost_scsi_destroy_vq_cmds(vq);
> +	return -ENOMEM;
> +}
> +
>  /*
>   * Called from vhost_scsi_ioctl() context to walk the list of available
>   * vhost_scsi_tpg with an active struct vhost_scsi_nexus
> @@ -1427,10 +1508,9 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  
>  		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
>  			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
> -				kfree(vs_tpg);
>  				mutex_unlock(&tpg->tv_tpg_mutex);
>  				ret = -EEXIST;
> -				goto out;
> +				goto undepend;
>  			}
>  			/*
>  			 * In order to ensure individual vhost-scsi configfs
> @@ -1442,9 +1522,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  			ret = target_depend_item(&se_tpg->tpg_group.cg_item);
>  			if (ret) {
>  				pr_warn("target_depend_item() failed: %d\n", ret);
> -				kfree(vs_tpg);
>  				mutex_unlock(&tpg->tv_tpg_mutex);
> -				goto out;
> +				goto undepend;
>  			}
>  			tpg->tv_tpg_vhost_count++;
>  			tpg->vhost_scsi = vs;
> @@ -1457,6 +1536,16 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  	if (match) {
>  		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
>  		       sizeof(vs->vs_vhost_wwpn));
> +
> +		for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
> +			vq = &vs->vqs[i].vq;
> +			if (!vhost_vq_is_setup(vq))
> +				continue;
> +
> +			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
> +				goto destroy_vq_cmds;
> +		}
> +
>  		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
>  			vq = &vs->vqs[i].vq;
>  			mutex_lock(&vq->mutex);
> @@ -1476,7 +1565,22 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  	vhost_scsi_flush(vs);
>  	kfree(vs->vs_tpg);
>  	vs->vs_tpg = vs_tpg;
> +	goto out;
>  
> +destroy_vq_cmds:
> +	for (i--; i >= VHOST_SCSI_VQ_IO; i--) {
> +		if (!vhost_vq_get_backend(&vs->vqs[i].vq))
> +			vhost_scsi_destroy_vq_cmds(&vs->vqs[i].vq);
> +	}
> +undepend:
> +	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
> +		tpg = vs_tpg[i];
> +		if (tpg) {
> +			tpg->tv_tpg_vhost_count--;
> +			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
> +		}
> +	}
> +	kfree(vs_tpg);
>  out:
>  	mutex_unlock(&vs->dev.mutex);
>  	mutex_unlock(&vhost_scsi_mutex);
> @@ -1549,6 +1653,12 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>  			mutex_lock(&vq->mutex);
>  			vhost_vq_set_backend(vq, NULL);
>  			mutex_unlock(&vq->mutex);
> +			/*
> +			 * Make sure cmds are not running before tearing them
> +			 * down.
> +			 */
> +			vhost_scsi_flush(vs);
> +			vhost_scsi_destroy_vq_cmds(vq);
>  		}
>  	}
>  	/*
> @@ -1842,23 +1952,6 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
>  	mutex_unlock(&vhost_scsi_mutex);
>  }
>  
> -static void vhost_scsi_free_cmd_map_res(struct se_session *se_sess)
> -{
> -	struct vhost_scsi_cmd *tv_cmd;
> -	unsigned int i;
> -
> -	if (!se_sess->sess_cmd_map)
> -		return;
> -
> -	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
> -		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
> -
> -		kfree(tv_cmd->tvc_sgl);
> -		kfree(tv_cmd->tvc_prot_sgl);
> -		kfree(tv_cmd->tvc_upages);
> -	}
> -}
> -
>  static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_store(
>  		struct config_item *item, const char *page, size_t count)
>  {
> @@ -1898,45 +1991,6 @@ static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_show(
>  	NULL,
>  };
>  
> -static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
> -			       struct se_session *se_sess, void *p)
> -{
> -	struct vhost_scsi_cmd *tv_cmd;
> -	unsigned int i;
> -
> -	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
> -		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
> -
> -		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
> -					  sizeof(struct scatterlist),
> -					  GFP_KERNEL);
> -		if (!tv_cmd->tvc_sgl) {
> -			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
> -			goto out;
> -		}
> -
> -		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
> -					     sizeof(struct page *),
> -					     GFP_KERNEL);
> -		if (!tv_cmd->tvc_upages) {
> -			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
> -			goto out;
> -		}
> -
> -		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
> -					       sizeof(struct scatterlist),
> -					       GFP_KERNEL);
> -		if (!tv_cmd->tvc_prot_sgl) {
> -			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
> -			goto out;
> -		}
> -	}
> -	return 0;
> -out:
> -	vhost_scsi_free_cmd_map_res(se_sess);
> -	return -ENOMEM;
> -}
> -
>  static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
>  				const char *name)
>  {
> @@ -1960,12 +2014,9 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
>  	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
>  	 * the SCSI Initiator port name of the passed configfs group 'name'.
>  	 */
> -	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
> -					VHOST_SCSI_DEFAULT_TAGS,
> -					sizeof(struct vhost_scsi_cmd),
> +	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg, 0, 0,
>  					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
> -					(unsigned char *)name, tv_nexus,
> -					vhost_scsi_nexus_cb);
> +					(unsigned char *)name, tv_nexus, NULL);
>  	if (IS_ERR(tv_nexus->tvn_se_sess)) {
>  		mutex_unlock(&tpg->tv_tpg_mutex);
>  		kfree(tv_nexus);
> @@ -2015,7 +2066,6 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
>  		" %s Initiator Port: %s\n", vhost_scsi_dump_proto_id(tpg->tport),
>  		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
>  
> -	vhost_scsi_free_cmd_map_res(se_sess);
>  	/*
>  	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
>  	 */
> -- 
> 1.8.3.1

