Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A960EC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 18:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6177A64EB1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 18:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBSSyd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 13:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhBSSya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 13:54:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498E6C061574;
        Fri, 19 Feb 2021 10:53:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s11so11607243edd.5;
        Fri, 19 Feb 2021 10:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Gj+/sUU6qWAZ1p+cGO4cqu9Uc+Gf4Nlr08/9L/PXY+8=;
        b=rve4uUrlZYuOjskhJio1I7CJatfBFkI0omzNodXy4BTn6HBM028tl5L52gsW816pB1
         LqiLBmsYRFyNQZoOeYBm9Lgu7UumxH4EbFHGMNoXr9vW5ZU5++tYPt/SM3PudScdVPg7
         keIiOeD21iwVVNkD4/OCMbjIfrM2SF5dEncldE1nyjbb3h0t4U7o2fqeZCHyexvWpQj9
         HAP9FqZk2OUImRSv7uxiTAeCNVOKa5oHcU8sT9wMDbKoR0tZ6V15HLxmjZk7ESd2EbYV
         zhsltahwX4lHtQ8Nila63FFEWfQT69Zyq1DKh72x0j/XhksPNuq09w+Z6koU6k/GIAC9
         vuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gj+/sUU6qWAZ1p+cGO4cqu9Uc+Gf4Nlr08/9L/PXY+8=;
        b=l+KkAvRl1Ns8gsxHxYYjix9naWVOZ0x4yAcc4bfjZxDpqEanCaOvI2iU5+8Fo80q40
         IIOcac0zHPI4uRKMZj8LoszVM44HiZx/2mTN6wyhdpoX6vdno2vxs2KluJWUXeXqJSyF
         TmSr39NqRgWBI0HxMzZcXJR1GYQiWYBcbTpO3aJzsGZMvZPvNKPvHtIl9Tk4vYIDiUaR
         4jOMO8krBUZWk4XazNVKau6eagvp3/b8Cqi/1ZgsHgjl4Sk1oTQRa5iSffj3KlNvRjUR
         7jPb/FKpLG1mBNSn2RlRsReR3g6m5JncnyZu0HABo3RaFcoq/B8FsMAQLYBpjQdTzEsJ
         oWuA==
X-Gm-Message-State: AOAM530ILObuDrs/c5Tb2osJlfolW4pbtgLw56FnfIcY1g2+Yz7Viq5Z
        yuIsBq/P+ng/OpDadpXGuCt7Q6F+1U0=
X-Google-Smtp-Source: ABdhPJz2iF4akvpbzbANvIalJuD4ZLuKAbj1zuIy1P/0UfhnUsUm+07p188LNRD7uKOKTsrXWp7VfA==
X-Received: by 2002:a50:e1c9:: with SMTP id m9mr11105737edl.307.1613760828771;
        Fri, 19 Feb 2021 10:53:48 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id di27sm5537398edb.21.2021.02.19.10.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 10:53:48 -0800 (PST)
Subject: Re: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-16-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <35baac82-f5a0-7798-505b-d0ac55dcd5bf@gmail.com>
Date:   Fri, 19 Feb 2021 19:53:47 +0100
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


Just a nit: shoulodn't it be "@gfp: ..."?
