Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCADC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F3964EB3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhBSTdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBSTdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:33:36 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6EFC061574;
        Fri, 19 Feb 2021 11:32:56 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bl23so15608738ejb.5;
        Fri, 19 Feb 2021 11:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nLggecqWC51S9UecfW/KRLLB4cxx0bqo9cBlUaGRJdM=;
        b=FHfg50iWk/Fxj9APkEU6/crtqhoi1RqgZrEg0G7RwZnhKR+/BEFJDh1V9U1sseHENM
         m3qiZ31fAiinUlY7ai0K7fS8iqsbQ1NnKlXG72T4QU332Zj9mNflThotLlztiFzOJtN6
         hVRhtVK9/4v0H1f7Kg2LBrfql2H585muMYVOB19Tytf0VLyZgaWH145UhbYPrZIq5+Ov
         R8Vf++7K1JSS3GHnYEuvLJN6+E1eoLsoGD6BEGEwqGc2hMeymSSxha4WWjZEEd46KAmu
         iE8ZO0v3eegwggfxpmHK/LmDn4RzauNo4+gtMtNXHS/03M5mvXJbbbPb45vzBNelevkY
         KLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nLggecqWC51S9UecfW/KRLLB4cxx0bqo9cBlUaGRJdM=;
        b=qrDxK/xxgDkB2sV7ORUrFhmm3ZAsq35DQH0+L0JqfoNiHdHjrpo1IZwDhWdHZmaEsp
         zGw0L610u0ZiqB56BYd10Okp+Uv8r0kC4+3FxV4sbbfqPUPA8VGPCy/XHVBXyu5qvOEO
         pPuq6xpisx4EOegVWzIQW/JZGtERzHw6Xw9JXMbOYnyNQR7SS/Etu9WgQKiWJwnftCED
         PNEoueKYJ5NkUEDjMQ/QaeC599ZFpuQ9+ygbneFohl9ULNgEOQ2PC/8YrhiZii63FuwW
         4sjssBuXfLarURwXCuV8c6XE014FKKiErPChzsEvePQ1QunwUMeeIsLJsSEIssmcqRM+
         nx/g==
X-Gm-Message-State: AOAM530xOrYG+JQk1+v4PucW0NXFJwT1cPP1HRAVSL/oSGSfy7BYErwz
        GeilRsjQdrNsfASpaHLoJ3+SSVyDkbc=
X-Google-Smtp-Source: ABdhPJzGkAm4hsnsbm89UvtwrqEvlUTPpEciauUNoIJkYglxJy/zTKsDQ+GIRKvhpWL7BVw6t/NLQQ==
X-Received: by 2002:a17:907:20a8:: with SMTP id pw8mr10349198ejb.9.1613763175062;
        Fri, 19 Feb 2021 11:32:55 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id de33sm4745779ejc.37.2021.02.19.11.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 11:32:54 -0800 (PST)
Subject: Re: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-16-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <c6781cb3-ded7-6ecb-a711-963512313c3e@gmail.com>
Date:   Fri, 19 Feb 2021 20:32:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.02.21 21:28, Mike Christie wrote:
> tcm_loop could be used like a normal block device, so we can't use
> GFP_KERNEL. This adds a gfp_t arg to target_cmd_init_cdb and covnerts
> the users. For every driver but loop I kept GFP_KERNEL. For loop and
> xcopy I switched to GFP_NOIO.


In the patch below for xcopy GFP_KERNEL is inserted.

> 
> This will also be useful in the later patches where loop needs to
> do target_submit_prep from interrupt context to get a ref to the
> se_device, and so it will need to use GFP_ATOMIC.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c  |  3 ++-
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  3 ++-
>   drivers/target/iscsi/iscsi_target.c    |  3 ++-
>   drivers/target/loopback/tcm_loop.c     |  3 ++-
>   drivers/target/target_core_transport.c | 14 ++++++++------
>   drivers/target/target_core_xcopy.c     |  2 +-
>   drivers/target/tcm_fc/tfc_cmd.c        |  2 +-
>   drivers/vhost/scsi.c                   |  2 +-
>   drivers/xen/xen-scsiback.c             |  2 +-
>   include/target/target_core_fabric.h    |  5 +++--
>   10 files changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 87741e0b4bca..51c386a215f5 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1537,7 +1537,8 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>   		goto busy;
>   	}
>   
> -	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
> +	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0,
> +			       GFP_KERNEL))
>   		return;
>   
>   	target_submit(cmd);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 56394d901791..12a2265eb2de 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -492,7 +492,8 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>   	if (rc)
>   		return rc;
>   
> -	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
> +	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0,
> +			       GFP_KERNEL))
>   		return 0;
>   
>   	target_submit(se_cmd);
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index f2107705f2ea..566adfde1661 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1166,7 +1166,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>   
>   	target_get_sess_cmd(&cmd->se_cmd, true);
>   
> -	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
> +	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb,
> +						GFP_KERNEL);
>   	if (cmd->sense_reason) {
>   		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
>   			return iscsit_add_reject_cmd(cmd,
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 461f4125fcab..677e4b8f0642 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -156,7 +156,8 @@ static void tcm_loop_submission_work(struct work_struct *work)
>   
>   	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
>   			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
> -			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
> +			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc),
> +			       GFP_NOIO))
>   		return;
>   
>   	target_submit(se_cmd);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 1f35cce6e92b..6c88ca832da6 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1427,7 +1427,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
>   }
>   
>   sense_reason_t
> -target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
> +target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
>   {
>   	sense_reason_t ret;
>   
> @@ -1448,8 +1448,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
>   	 * setup the pointer from __t_task_cdb to t_task_cdb.
>   	 */
>   	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
> -		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
> -						GFP_KERNEL);
> +		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
>   		if (!cmd->t_task_cdb) {
>   			pr_err("Unable to allocate cmd->t_task_cdb"
>   				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
> @@ -1638,6 +1637,7 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
>    * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
>    * @sgl_prot: struct scatterlist memory protection information
>    * @sgl_prot_count: scatterlist count for protection information
> + * @gfp_t: gfp allocation type
>    *
>    * Returns:
>    *	- less than zero to signal failure.
> @@ -1648,11 +1648,12 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
>   int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
>   		       struct scatterlist *sgl, u32 sgl_count,
>   		       struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
> -		       struct scatterlist *sgl_prot, u32 sgl_prot_count)
> +		       struct scatterlist *sgl_prot, u32 sgl_prot_count,
> +		       gfp_t gfp)
>   {
>   	sense_reason_t rc;
>   
> -	rc = target_cmd_init_cdb(se_cmd, cdb);
> +	rc = target_cmd_init_cdb(se_cmd, cdb, gfp);
>   	if (rc)
>   		goto send_cc_direct;
>   
> @@ -1788,7 +1789,8 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>   	if (rc)
>   		return;
>   
> -	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
> +	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0,
> +			       GFP_KERNEL))
>   		return;
>   
>   	target_submit(se_cmd);
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index e86cc6135587..d31ed071cb08 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -554,7 +554,7 @@ static int target_xcopy_setup_pt_cmd(
>   	}
>   	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>   
> -	if (target_cmd_init_cdb(cmd, cdb))
> +	if (target_cmd_init_cdb(cmd, cdb, GFP_KERNEL))
>   		return -EINVAL;
>   
>   	cmd->tag = 0;
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index 1376501ee3d0..410b723f9d79 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -555,7 +555,7 @@ static void ft_send_work(struct work_struct *work)
>   		goto err;
>   
>   	if (target_submit_prep(&cmd->se_cmd, fcp->fc_cdb, NULL, 0, NULL, 0,
> -			       NULL, 0))
> +			       NULL, 0, GFP_KERNEL))
>   		return;
>   
>   	target_submit(&cmd->se_cmd);
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 76508d408bb3..93f5631b469c 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -811,7 +811,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>   
>   	if (target_submit_prep(se_cmd, cmd->tvc_cdb, sg_ptr,
>   			       cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
> -			       cmd->tvc_prot_sgl_count))
> +			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
>   		return;
>   
>   	target_submit(se_cmd);
> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index 7bf9a6bede6d..eb3d8e35cbcd 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -368,7 +368,7 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
>   			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);
>   
>   	if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl,
> -			       pending_req->n_sg, NULL, 0, NULL, 0))
> +			       pending_req->n_sg, NULL, 0, NULL, 0, GFP_KERNEL))
>   		return;
>   
>   	target_submit(se_cmd);
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 86b0d4a7df92..0543ab107723 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -157,10 +157,11 @@ int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>   int	target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
>   		struct scatterlist *sgl, u32 sgl_count,
>   		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
> -		struct scatterlist *sgl_prot, u32 sgl_prot_count);
> +		struct scatterlist *sgl_prot, u32 sgl_prot_count, gfp_t gfp);
>   void	target_submit(struct se_cmd *se_cmd);
>   sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
> -sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
> +sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
> +				   gfp_t gfp);
>   sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
>   void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
>   		unsigned char *, u64, u32, int, int, int);
> 
