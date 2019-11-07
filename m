Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B514C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 16:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2686B214D8
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 16:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbfKGQyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 11:54:24 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39892 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfKGQyY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 11:54:24 -0500
Received: by mail-pl1-f195.google.com with SMTP id o9so1880810plk.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 08:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QhLzTQKyrfcZZ1o3PBjkixE58c6aBVjMZG7tC/xnMog=;
        b=qeqxQ8bMapP9smEWpLedrBj7YFBNWK9YRdfwraOt2x0Fnm1yJFM9EenVG4OArbP8ul
         CvOM8HNpfuELZr6z4Yhgo1DVplCLvUUABdl9aeboZ10ujtNegvzDtCyKL9bzQdY7FNWD
         KXZsA7+YPbQrhywdf3iAWYOC+OfjY0e6Ld+E6/wsaQFv6c51/XGKOTP0szkavxJKEIyi
         rcH73FxlM/HEQ641SlhfKa3lD98LorKUTJwq/65qtcA9OAYtLyiMYEcKCwnACGoanW9M
         FgavX2FqVxo3Mb5nYXQxj9M9+Xsvy2sZ3tjtV9XDBE9iT6LZeb0J7VbDeg4ohKbEEr/T
         r0EQ==
X-Gm-Message-State: APjAAAVCmoEU4yeNpGGfDu96ZPaPrnmNJYwNjvzN3w8feJUNg7Mz5SzT
        xHKe6e0Obvykwd2+549MbOWcALLb
X-Google-Smtp-Source: APXvYqyUyCGGzC5dG1BprJjHYly/su+JkRPgfwV5o2Om9drTpTZETbAXnxtu67d1paeo4aM3EmHL8g==
X-Received: by 2002:a17:90a:901:: with SMTP id n1mr6605696pjn.113.1573145663434;
        Thu, 07 Nov 2019 08:54:23 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d4sm2834821pjs.9.2019.11.07.08.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 08:54:22 -0800 (PST)
Subject: Re: [PATCH 4/8] qla2xxx: Fix driver unload hang
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-5-hmadhani@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f4c6df6c-f1b1-d465-dc41-dc8e63df56e2@acm.org>
Date:   Thu, 7 Nov 2019 08:54:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105150657.8092-5-hmadhani@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/19 7:06 AM, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> This patch fixes driver unload hang by removing msleep()
> 
> Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair functionality.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index bddb26baedd2..ff4528702b4e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -9009,8 +9009,6 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
>   	struct qla_hw_data *ha = qpair->hw;
>   
>   	qpair->delete_in_progress = 1;
> -	while (atomic_read(&qpair->ref_count))
> -		msleep(500);
>   
>   	ret = qla25xx_delete_req_que(vha, qpair->req);
>   	if (ret != QLA_SUCCESS)

I think that an explanation is needed why that loop had been introduced 
and also why it is safe not to wait until qpair->ref_count drops to zero 
in qla2xxx_delete_qpair().

Thanks,

Bart.


