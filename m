Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55120C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 17:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjERRoV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 13:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjERRoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 13:44:20 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ABDF4
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 10:44:19 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-24e147c2012so1136880a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 10:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684431859; x=1687023859;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzZKCQyl5DR28PaziuBcRQkllvfGXE9cOXzg/9LwzjU=;
        b=SXJ82f1ZSUvOYOnWkZP3Q0iankhUyi6dID5C672EI6LzHnnE+JkpdHh2W26iYxZpf4
         2F67EKPS7CpVmh83sXA12Ohh0a6tv5rTITEz+kW8eBV0pFqcYgedR8J3AC845lEhgyUG
         Mp0V9WlH385oT9bPNOH2K5kKMf29WN5jxttu6bP5ydSL6BKZy87eNCJamJxFannk6BfS
         BE575QjurmCIDxG+JyFxXjL9hz1dAIsdzzC+b8Jz9Q9NBFyNKbeLGVqjX5qz2oSHGgX6
         l4o+IZVqU9+4+9PtljIc8RgRW8nIyGwJrhHg6Kq6lRqWXjZZbwekeihh6CEKwNfq1lce
         BzIg==
X-Gm-Message-State: AC+VfDytD6brQAFfNpIWhFV9kHzqDIRKdYzOoomUn6bufIHVPzgT0xe9
        4Odf5jppl0RZw5DOfxReFFM=
X-Google-Smtp-Source: ACHHUZ5WNShZgik1KJ55HsIVeIzma1fR+pnl6uUe8zH0w/BGCcjf1DQIy3xx8riu4863Y2eGV/81Qg==
X-Received: by 2002:a17:90a:1116:b0:250:69de:7157 with SMTP id d22-20020a17090a111600b0025069de7157mr3622765pja.2.1684431858847;
        Thu, 18 May 2023 10:44:18 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090a2e1200b00252b3328ad8sm1681592pjd.0.2023.05.18.10.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 10:44:18 -0700 (PDT)
Message-ID: <d61314e0-317f-f1b2-9c3f-04de3aa5535d@acm.org>
Date:   Thu, 18 May 2023 10:44:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/8] qla2xxx: klocwork - Check for a valid fcport pointer
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
References: <20230518075841.40363-1-njavali@marvell.com>
 <20230518075841.40363-4-njavali@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230518075841.40363-4-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/23 00:58, Nilesh Javali wrote:
> Klocwork reported warning of null pointer may be dereferenced.
> The routine exits when sa_ctl is NULL and fcport is allocated after
> the exit call thus causing NULL fcport pointer to dereference at the
> time of exit.
> 
> Add a check for a valid fcport pointer at the time of exit.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_edif.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index ec0e20255bd3..14e314c12dd6 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2411,7 +2411,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
>   	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>   	fcport->flags &= ~FCF_ASYNC_SENT;
>   done:
> -	fcport->flags &= ~FCF_ASYNC_ACTIVE;
> +	if (fcport)
> +		fcport->flags &= ~FCF_ASYNC_ACTIVE;
>   	return rval;
>   }

Please change the "goto done" statements that occur before fcport is set 
into "return rval" instead of making the above change.

Bart.


