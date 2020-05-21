Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291DBC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 20:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD83207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 20:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6kwWhti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgEUUGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 16:06:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29243 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726814AbgEUUGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 16:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590091571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2rsjB333bm9UUZYWROF/tVZl9kjFmhPMGz6xRIFCKg=;
        b=e6kwWhtioM8+yhgbU35Fi6cEGRhiLEfT4ga1KhPneXnFYL/CJJkX4rPYlBC00+Ztsadke4
        W1vWCqCrmT8qBNXe97HFc64UUrD+7HusaPAAmbvCPqJeen9A5Dxcz1CnzS2zvpXN0YGgkj
        q+O7jHY3J4jndrjvQ8OXAe/Req7UXM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Y7xfbhZ9O5ajfvkGYmSiRQ-1; Thu, 21 May 2020 16:06:08 -0400
X-MC-Unique: Y7xfbhZ9O5ajfvkGYmSiRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66827872FE0;
        Thu, 21 May 2020 20:06:07 +0000 (UTC)
Received: from [10.10.119.146] (ovpn-119-146.rdu2.redhat.com [10.10.119.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 674886EA26;
        Thu, 21 May 2020 20:06:06 +0000 (UTC)
Subject: Re: [PATCH 3/3] target: rename target_setup_cmd_from_cdb() to
 target_parse_cdb()
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com, ssudhakarp@gmail.com
References: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <8cde32d4-eef3-ec4c-9a0e-54c896e90ccc@redhat.com>
Date:   Thu, 21 May 2020 15:06:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/21/20 12:42 PM, Sudhakar Panneerselvam wrote:
> This commit also removes the unused argument, cdb that was passed
> to this function.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c    | 2 +-
>  drivers/target/target_core_transport.c | 6 +++---
>  drivers/target/target_core_xcopy.c     | 2 +-
>  include/target/target_core_fabric.h    | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index a90b80aee9d8..38b14291eb76 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1185,7 +1185,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>  
>  	/* only used for printks or comparing with ->ref_task_tag */
>  	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
> -	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
> +	cmd->sense_reason = target_parse_cdb(&cmd->se_cmd);
>  	if (cmd->sense_reason)
>  		goto attach_cmd;
>  
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2e878188dff7..329c301129c2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1450,7 +1450,7 @@ void transport_init_se_cmd(
>  EXPORT_SYMBOL(target_init_cmd_from_cdb);
>  
>  sense_reason_t
> -target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
> +target_parse_cdb(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = cmd->se_dev;
>  	sense_reason_t ret;
> @@ -1472,7 +1472,7 @@ void transport_init_se_cmd(
>  	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
>  	return 0;
>  }
> -EXPORT_SYMBOL(target_setup_cmd_from_cdb);
> +EXPORT_SYMBOL(target_parse_cdb);
>  
>  /*
>   * Used by fabric module frontends to queue tasks directly.
> @@ -1636,7 +1636,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>  		return 0;
>  	}
>  
> -	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
> +	rc = target_parse_cdb(se_cmd);
>  	if (rc != 0) {
>  		transport_generic_request_failure(se_cmd, rc);
>  		return 0;
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index b20c25343cf1..5cd1e81b33f8 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -530,7 +530,7 @@ static int target_xcopy_setup_pt_cmd(
>  		return -EINVAL;
>  
>  	cmd->tag = 0;
> -	if (target_setup_cmd_from_cdb(cmd, cdb))
> +	if (target_parse_cdb(cmd))
>  		return -EINVAL;
>  
>  	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 5c92a5ccc9f0..6eb04a87ca97 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
>  		struct se_session *, u32, int, int, unsigned char *);
>  sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
>  sense_reason_t target_init_cmd_from_cdb(struct se_cmd *, unsigned char *);
> -sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
> +sense_reason_t target_parse_cdb(struct se_cmd *);
>  int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
>  		unsigned char *, unsigned char *, u64, u32, int, int, int,
>  		struct scatterlist *, u32, struct scatterlist *, u32,
> 

Maybe the naming would be nicer if we did:

target_init_cmd_cdb
and
target_parse_cmd_cdb

This would match each other's pattern and also match the style of the
other cmd related function naming where its "target or transport"
prefix, verb, cmd then optionally something extra.

Or maybe:

target_cmd_init_cdb
and
target_cmd_parse_cdb

so they at least match each other and you get an idea they pair together.

Just a suggestion and not a requirement, because I'm pretty bad at
naming, so I have no idea if its better or not.

