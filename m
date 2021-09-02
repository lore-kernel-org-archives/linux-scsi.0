Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242DFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 18:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CAA610E9
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 18:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346900AbhIBSMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 14:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346898AbhIBSMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 14:12:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ED3C061760;
        Thu,  2 Sep 2021 11:11:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n4so1710374plh.9;
        Thu, 02 Sep 2021 11:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x8mcWyM7ld5BFaHR/hqJRtA5/ybLclhzA9CEtyCDlE0=;
        b=pNBDSAhU+x6hiGldE98Yt4lF6DSsMuKbIuhIugukPr3PpPv6mPllgTE8KBy0446Rey
         1J1CPpdt2V2SwQb09y85JVrYGoNMqp/spezwNPG53GyUOdCGt/k8Q4u+tMAoxR9hiqzI
         LvFN64xuQB5boMo7pCNFUIVA0KahOfKmlfs9Fna+ccDypx17jhFONiIngPL1q1+LgL4s
         EicE4hbOcesN6en43x4lx7hwVu4nPav+OtABJ6azrlYfl9N8jLVmLk7ejerfRw1QSlHH
         a4tNeIHQkcZFKl9p/JXnklwGIHko4tO6ZNt2mWE1a0FTWSgUj1ynTnG5tVUCGkx4cjIf
         bDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8mcWyM7ld5BFaHR/hqJRtA5/ybLclhzA9CEtyCDlE0=;
        b=gBLztpEAjOkMKxVd2vTnHjNQNMkeNJ2YKNRNaACFM3EvaVrsLKjVmkoA0CaMR1ogm/
         RnCYSF/xhMfD6m/yL+gdsS72yq0aoN9/6P56ENBokmKS+69psymUYJaOjvT9Ay/+9Q9+
         R+8wLdBLwZIhsxKHNZjfB67BIpglH30UZdhccOkh0NO8x9SFlC+0TA0uAMr0+tibM23v
         HTwE3NNoO5wgZzBfapO0mGQxgkXgN31YJpOYZWvwNuqr1iO1dIyxKI/hQnAztE7qWh6N
         F9dHpk1yFC0wS8Gch6pCpSFjJn7p0ycFZS39L/naZHA1HRICEF6hxA0dKJh1AXj9oyDc
         pTbA==
X-Gm-Message-State: AOAM530zOVG3xX3b0ySWTqNT9sUVuUXhx9uHtWbiMcM51oGG356yUTuF
        2YW9qLJblkIiAJr4DdPoNb4=
X-Google-Smtp-Source: ABdhPJzxrS/g/O3rgmVbFC64kd0LIoDxabN8omFxdIOqCQWpbb45DFSVKjGOmI9yV73K+KLQUwvt2g==
X-Received: by 2002:a17:90b:3b82:: with SMTP id pc2mr5255527pjb.224.1630606314857;
        Thu, 02 Sep 2021 11:11:54 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h127sm2896583pfe.191.2021.09.02.11.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:11:54 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: remove unneeded variable
To:     cgel.zte@gmail.com, james.smart@broadcom.com
Cc:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chi Minghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
References: <20210831114058.17817-1-lv.ruyi@zte.com.cn>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <4a9cee32-5585-a3e0-aff2-3d3989a1b13f@gmail.com>
Date:   Thu, 2 Sep 2021 11:11:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210831114058.17817-1-lv.ruyi@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/2021 4:40 AM, cgel.zte@gmail.com wrote:
> From: Chi Minghao <chi.minghao@zte.com.cn>
> 
> Fix the following coccicheck REVIEW:
> ./drivers/scsi/lpfc/lpfc_scsi.c:1498:9-12 REVIEW Unneeded variable
> 
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: Chi Minghao <chi.minghao@zte.com.cn>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Looks Good - Thanks!

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
