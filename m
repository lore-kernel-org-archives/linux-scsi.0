Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEF3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 21:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiFMVHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351768AbiFMVGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 17:06:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86B53BBC3;
        Mon, 13 Jun 2022 13:42:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h192so6606101pgc.4;
        Mon, 13 Jun 2022 13:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zksiAjqc+ofCnYjvBYw1PF+pN6ibTOkQH6elqHNAtYU=;
        b=byTHm3x89jOX7huHSgYMmmBJBFc1mQLA0hFsAIojFyto3o1MCbca/Jtzr7C9w6tGVl
         9L3XlNPoqkjbYwvuGNyMnhaINfbjM0wJomBTYadE73vbAbXCxs3hPxlGVCVPEF5m3N7q
         GglBlOwCsppYhs6ZGLtBYvLMrIBXGPExiQoK+XhhjvfdTx8Lubees3Bq2CGUqGvGH2rz
         /bBFohpxycCtfV6IbakJqPJ9a4GWN3sDGmIQelrLQDfbEwx95MmpZeS71DTpDp3cryQb
         w5p3E/+LM0z0sTsXdSDaGczfR/dA8mpnRN5qwOs85z//PrRHQQDsl5RxK9KFR5YSBt1B
         UZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zksiAjqc+ofCnYjvBYw1PF+pN6ibTOkQH6elqHNAtYU=;
        b=o85L6J01GPsayNi4g5687tIBQRZ5NS4okF7s+8VddSUEiMg2q40BluUZDqSajQnjOQ
         zr7zK81WgOWUuJjHaWlZL/7qf2ojDwKy9csJcl6eFNPBrasBzJnSM8mzqFy48h1OE7Su
         k5QSOzwXuSm8yhGkYUL+cPlJsUBVOTozDecqy5/KKhi74V/YZMrqwLCt122LyvQ+gKLW
         lZVIS+cvKn6a4qo01OXBKtlS8rllHyFj2nR8qs6h5cMy11iDGTL8A7lOAS1sPvQOxu9V
         7n1v8sjUvM5Gctj1zJBDqdKzzT9+2x5lRLoPGnJD7CVi8bz3afgzbuPfkYhHIsyP9sPs
         LnhA==
X-Gm-Message-State: AOAM530k+3FIdGqI/+LlDqLJgs2nbci1dm0hBDFhEQjXs95PN/3J73YY
        cOyYv5VxVsKw5kCbZJBT3YZSzyt0gHw=
X-Google-Smtp-Source: ABdhPJxVPL7iI/NqVCP2IhMcUJgHvWpVv13j+JY8VWlh+P9qdQSAmkx79Mr9Ta+C+hvvFuxCnO01Cw==
X-Received: by 2002:a65:6912:0:b0:3fc:907b:e05 with SMTP id s18-20020a656912000000b003fc907b0e05mr1233288pgq.414.1655152971369;
        Mon, 13 Jun 2022 13:42:51 -0700 (PDT)
Received: from [10.69.47.244] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c20600b00163e4410b82sm5547670pll.239.2022.06.13.13.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 13:42:51 -0700 (PDT)
Message-ID: <634ce85d-362a-5563-8af5-ddf9f2e379f9@gmail.com>
Date:   Mon, 13 Jun 2022 13:42:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RESEND --next] scsi: lpfc: Use memset_startat() helper in
 lpfc_nvmet_xmt_fcp_op_cmp
Content-Language: en-US
To:     Xiu Jianfeng <xiujianfeng@huawei.com>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613021851.59699-1-xiujianfeng@huawei.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20220613021851.59699-1-xiujianfeng@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/2022 7:18 PM, Xiu Jianfeng wrote:
> Use memset_startat() helper to simplify the code, no functional change
> in this patch.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
