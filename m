Return-Path: <SRS0=JddF=7F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FFAC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 19:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F0A20735
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 19:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iIUjNhJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387834AbgEWTE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 May 2020 15:04:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387551AbgEWTE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 May 2020 15:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590260664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GIOD3WfqW5VONY6+8OFH3ayDFnP8eaMVgGkRrbEXpg=;
        b=iIUjNhJZIaIa8oN7522qBor30OE/kop6r8yWcOH9laqupro1vAmT0rD4o7CzHVMj3jTl0p
        f19NZ80X9lc+VQ+frg79VuJXjVhifZhOr6Kr+jh+XF+YBqQI6gtdkvjJ/AI2FuKOSlI0jg
        tYPErjHEnH51Ij6QXJ0fFIfyIzyOI40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-hcuBo1kAPw6CsohYNAnbZw-1; Sat, 23 May 2020 15:04:21 -0400
X-MC-Unique: hcuBo1kAPw6CsohYNAnbZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7949D464;
        Sat, 23 May 2020 19:04:19 +0000 (UTC)
Received: from [10.10.112.111] (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52BF46EA52;
        Sat, 23 May 2020 19:04:15 +0000 (UTC)
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in
 tcmu_check_expired_queue_cmd()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200523101129.GB98132@mwanda>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <0d4b569b-f21f-43f3-b25c-0b4c06cbe718@redhat.com>
Date:   Sat, 23 May 2020 14:04:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200523101129.GB98132@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/20 5:11 AM, Dan Carpenter wrote:
> The pr_debug() dereferences "cmd" after we already freed it by calling
> tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.
> 
> Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/target/target_core_user.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 904d8a8373f2..28fb9441de7a 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1292,13 +1292,13 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
>  	if (!time_after(jiffies, cmd->deadline))
>  		return;
>  
> +	pr_debug("Timing out queued cmd %p on dev %s.\n",
> +		  cmd, cmd->tcmu_dev->name);
> +
>  	list_del_init(&cmd->queue_entry);
>  	se_cmd = cmd->se_cmd;
>  	tcmu_free_cmd(cmd);
>  
> -	pr_debug("Timing out queued cmd %p on dev %s.\n",
> -		  cmd, cmd->tcmu_dev->name);
> -
>  	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
>  }
>  

Thanks.

Reviewed-by: Mike Christie <mchristi@redhat.com>

