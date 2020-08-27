Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC2BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 15:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0917A22BEB
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 15:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgH0PNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 11:13:37 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34292 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgH0PNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 11:13:19 -0400
Received: by mail-lj1-f193.google.com with SMTP id y2so6860178ljc.1;
        Thu, 27 Aug 2020 08:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MEWPiw5piojwJx0HXGqMChFUJz2WVZKjHfpQDVb1WDo=;
        b=pV9IToRuYwYVD0Z5AMTEUTuwrqVy2BQbX+AYMU9RiBLt204l5WuHq68pek+0ml/+9b
         MoP+039T6hfhxXLiPsNAmsFtlm6GlwamoTqkILUL5+CNDmUaYVxRDqU/86Rm8jcEDSD+
         z/Vg9EFrDiyrajELwPlUJYUgkuG6kfk825c/PlzoJ0dn7uRJAxRLrVAHe35Sp3vynemf
         oCWxT1evvg7S+LcUbQcKDgSfgg7ZtMOoZxyHsUahU0S9msgsl8B2ZO4Ii3OLg9K6QTgF
         JTg8U4PDugAexzu4Idfy75PlOElxznWW5H4NCTzrB4iuuxXWdEidNq+0mWm2mVdDiQpd
         botQ==
X-Gm-Message-State: AOAM530Ss32d7/7z557qqQSiMR/DHRKM3PLkVP/UBdoDFC1Ih967foYi
        H3oQbeKlZGBCs1y/9L9bOadxQNVAJL4=
X-Google-Smtp-Source: ABdhPJzRi/K+ZxgMMPN4ye+ZbaySMIF6KnUTgIdlJy+0Sg7cd6oK7qzrmd+SlpIgscCLmvGAMP8lPQ==
X-Received: by 2002:a2e:9d8e:: with SMTP id c14mr10426635ljj.332.1598541196060;
        Thu, 27 Aug 2020 08:13:16 -0700 (PDT)
Received: from [192.168.1.8] ([213.87.147.111])
        by smtp.gmail.com with ESMTPSA id d10sm530058ljg.87.2020.08.27.08.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 08:13:15 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: libcxgbi: use kvzalloc instead of opencoded
 kzalloc/vzalloc
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
References: <20200731215524.14295-1-efremov@linux.com>
 <20200801133123.61834-1-efremov@linux.com>
From:   Denis Efremov <efremov@linux.com>
Autocrypt: addr=efremov@linux.com; keydata=
 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
Message-ID: <d77c0967-d879-14cc-bf75-c38ad8879b76@linux.com>
Date:   Thu, 27 Aug 2020 18:13:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200801133123.61834-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ping?

On 8/1/20 4:31 PM, Denis Efremov wrote:
> Remove cxgbi_alloc_big_mem(), cxgbi_free_big_mem() functions
> and use kvzalloc/kvfree instead. __GFP_NOWARN added to kvzalloc()
> call because we already print a warning in case of allocation fail.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/scsi/cxgbi/libcxgbi.c |  8 ++++----
>  drivers/scsi/cxgbi/libcxgbi.h | 16 ----------------
>  2 files changed, 4 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 4bc794d2f51c..51f4d34da73f 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -77,9 +77,9 @@ int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
>  {
>  	struct cxgbi_ports_map *pmap = &cdev->pmap;
>  
> -	pmap->port_csk = cxgbi_alloc_big_mem(max_conn *
> -					     sizeof(struct cxgbi_sock *),
> -					     GFP_KERNEL);
> +	pmap->port_csk = kvzalloc(array_size(max_conn,
> +					     sizeof(struct cxgbi_sock *)),
> +				  GFP_KERNEL | __GFP_NOWARN);
>  	if (!pmap->port_csk) {
>  		pr_warn("cdev 0x%p, portmap OOM %u.\n", cdev, max_conn);
>  		return -ENOMEM;
> @@ -124,7 +124,7 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
>  	if (cdev->cdev2ppm)
>  		cxgbi_ppm_release(cdev->cdev2ppm(cdev));
>  	if (cdev->pmap.max_connect)
> -		cxgbi_free_big_mem(cdev->pmap.port_csk);
> +		kvfree(cdev->pmap.port_csk);
>  	kfree(cdev);
>  }
>  
> diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
> index 84b96af52655..321426242be4 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.h
> +++ b/drivers/scsi/cxgbi/libcxgbi.h
> @@ -537,22 +537,6 @@ struct cxgbi_task_data {
>  #define iscsi_task_cxgbi_data(task) \
>  	((task)->dd_data + sizeof(struct iscsi_tcp_task))
>  
> -static inline void *cxgbi_alloc_big_mem(unsigned int size,
> -					gfp_t gfp)
> -{
> -	void *p = kzalloc(size, gfp | __GFP_NOWARN);
> -
> -	if (!p)
> -		p = vzalloc(size);
> -
> -	return p;
> -}
> -
> -static inline void cxgbi_free_big_mem(void *addr)
> -{
> -	kvfree(addr);
> -}
> -
>  static inline void cxgbi_set_iscsi_ipv4(struct cxgbi_hba *chba, __be32 ipaddr)
>  {
>  	if (chba->cdev->flags & CXGBI_FLAG_IPV4_SET)
> 
