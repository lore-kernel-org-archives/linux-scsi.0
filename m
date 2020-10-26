Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AE5C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 16:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F9C221FC
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 16:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tt1jXI5A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786343AbgJZQq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:46:28 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:39343 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780583AbgJZQoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 12:44:54 -0400
Received: by mail-ej1-f68.google.com with SMTP id qh17so14581914ejb.6;
        Mon, 26 Oct 2020 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rO9DdPM05b+m1oOhpt2IrGL5DQ3+ZBkSc2O7qG1+B8E=;
        b=tt1jXI5AVG7zNWPHvloNCf0pf1Tohi+3CVUIm3F/uVslzh0PU4MG3LwvDBhzRqEOwQ
         l7DVdaWqqcm593JYelCxWmBXhNJIOPVt7OHgtoDFpHMwJDsh0z5QOK50I5VO9j1Dxh+p
         NkwxP7FIbvBrFagN7uyxQKamSFK6wgq/+cgBsaFM04vQPZ9AYTEDso+56yRtF0KVI7Xc
         CHGd6VlK1FciWHLXxchsk4fxaPnfHYpP2lqGsVQk0QxG3ZPtQTUTsU2MsK7o71XaTbGz
         r1pPsHaNQaGApRZxn63mS26UWsTwaXWmEVRezdipQ2UkQoaymxRG8a1cxo41mVpyvGXT
         PfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rO9DdPM05b+m1oOhpt2IrGL5DQ3+ZBkSc2O7qG1+B8E=;
        b=bnCXyiewcv6VJe4N2Vt0HRt573C9soga70nEXRVQdH9Q+kMhDxn5CPN/24bbUPn+02
         L05OXgj79Q13l6PCig1rPx1/+Jmxx3Xrdrkuloi+nGEjKC41A3LWR8aX+m2n2RJdEh+w
         TEFh8n61Z62YmZiE7rFtGFBT0RHix0R+H+Frsra6Kp3EJHOolgrlifPmk5ev8hieb4iu
         JPSQfsbno6VMEoihrFcNVsNQZnRjzFYCOgrKYqBA8Zvi5x+bPsVJ8HQKyLIV5lL6hUKH
         gJYoeEWkRfx+zLVrff5UkRcABaIWPPB1JGk38rW2mc9i5yiq7cZj9MVrv1Yqkj3VTFX+
         fy+w==
X-Gm-Message-State: AOAM533HyAvM/1eZB8jd4Ms8qVex4rBJy7xGM/7QIQJtIvSrsZodPNtx
        8UYsK+1uIJSUp9rMtqKElPzhQyyh/lk5+A==
X-Google-Smtp-Source: ABdhPJwgjlmnNsKMqlRLpwMlbwsUGXDIskJoEDXSSiwFrXqaSz5wEO8n0vggIXgcq0/ilWH/4+sdpw==
X-Received: by 2002:a17:906:539a:: with SMTP id g26mr17285079ejo.71.1603730691525;
        Mon, 26 Oct 2020 09:44:51 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc08ad4.dynamic.kabel-deutschland.de. [188.192.138.212])
        by smtp.gmail.com with ESMTPSA id c5sm5590027edx.58.2020.10.26.09.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 09:44:50 -0700 (PDT)
Subject: Re: [PATCH 4/5] scsi: target: split out COMPARE AND WRITE memcmp into
 helper
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201023205723.17880-1-ddiss@suse.de>
 <20201023205723.17880-5-ddiss@suse.de>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <34b6d335-7f72-4ebc-f3b3-873d6d82e4bc@gmail.com>
Date:   Mon, 26 Oct 2020 17:44:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201023205723.17880-5-ddiss@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am 23.10.20 um 22:57 schrieb David Disseldorp:
> In preparation for finding and returning the miscompare offset.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   drivers/target/target_core_sbc.c | 117 ++++++++++++++++++-------------
>   1 file changed, 67 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 5f77dd95f1b9..79216d0355e7 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -434,20 +434,77 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
>   	return ret;
>   }
>   
> +/*
> + * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare return
> + * TCM_MISCOMPARE_VERIFY.
> + */
> +static sense_reason_t
> +compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
> +			 struct scatterlist *cmp_sgl, unsigned int cmp_nents,
> +			 unsigned int cmp_len)
> +{
> +	unsigned char *buf = NULL;
> +	struct scatterlist *sg;
> +	sense_reason_t ret;
> +	unsigned int offset;
> +	size_t rc;
> +	int i;
> +
> +	buf = kzalloc(cmp_len, GFP_KERNEL);
> +	if (!buf) {
> +		pr_err("Unable to allocate compare_and_write buf\n");
> +		ret = TCM_OUT_OF_RESOURCES;
> +		goto out;
> +	}
> +
> +	rc = sg_copy_to_buffer(cmp_sgl, cmp_nents, buf, cmp_len);
> +	if (!rc) {
> +		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
> +		ret = TCM_OUT_OF_RESOURCES;
> +		goto out;
> +	}
> +	/*
> +	 * Compare SCSI READ payload against verify payload
> +	 */
> +	offset = 0;
> +	for_each_sg(read_sgl, sg, read_nents, i) {
> +		unsigned int len = min(sg->length, cmp_len);
> +		unsigned char *addr = kmap_atomic(sg_page(sg));
> +
> +		if (memcmp(addr, buf + offset, len)) {
> +			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
> +				addr, buf + offset);
> +			kunmap_atomic(addr);
> +			ret = TCM_MISCOMPARE_VERIFY;
> +			goto out;
> +		}
> +		kunmap_atomic(addr);
> +
> +		offset += len;
> +		cmp_len -= len;
> +		if (!cmp_len)
> +			break;
> +	}
> +	pr_debug("COMPARE AND WRITE read data matches compare data\n");
> +	ret = TCM_NO_SENSE;
> +out:
> +	kfree(buf);
> +	return ret;
> +}
> +

Since you are going to split out a new helper, did you consider to re-write helper's code to avoid the intermediate buffer?

Douglas Gilbert currently tries to add new functions to lib/scatterlist.c
One of them is sgl_compare_sgl, which directly compares content of two sg lists:
   https://patchwork.kernel.org/project/linux-block/patch/20201019191928.77845-4-dgilbert@interlog.com/

This code - based on the sg_miter_* calls - works without intermediate buffer.
Maybe your helper could use similar code or you could even call Douglas' helper, if he can enhance it to
(optionally) return the miscompare offset.


>   static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool success,
>   						 int *post_ret)
>   {
>   	struct se_device *dev = cmd->se_dev;
>   	struct sg_table write_tbl = { };
> -	struct scatterlist *write_sg, *sg;
> -	unsigned char *buf = NULL, *addr;
> +	struct scatterlist *write_sg;
>   	struct sg_mapping_iter m;
> -	unsigned int offset = 0, len;
> +	unsigned int len;
>   	unsigned int nlbas = cmd->t_task_nolb;
>   	unsigned int block_size = dev->dev_attrib.block_size;
>   	unsigned int compare_len = (nlbas * block_size);
>   	sense_reason_t ret = TCM_NO_SENSE;
> -	int rc, i;
> +	int i;
>   
>   	/*
>   	 * Handle early failure in transport_generic_request_failure(),
> @@ -473,12 +530,13 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   		goto out;
>   	}
>   
> -	buf = kzalloc(cmd->data_length, GFP_KERNEL);
> -	if (!buf) {
> -		pr_err("Unable to allocate compare_and_write buf\n");
> -		ret = TCM_OUT_OF_RESOURCES;
> +	ret = compare_and_write_do_cmp(cmd->t_bidi_data_sg,
> +				       cmd->t_bidi_data_nents,
> +				       cmd->t_data_sg,
> +				       cmd->t_data_nents,
> +				       compare_len);
> +	if (ret)
>   		goto out;
> -	}
>   
>   	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
>   		pr_err("Unable to allocate compare_and_write sg\n");
> @@ -486,41 +544,6 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   		goto out;
>   	}
>   	write_sg = write_tbl.sgl;
> -	/*
> -	 * Setup verify and write data payloads from total NumberLBAs.
> -	 */
> -	rc = sg_copy_to_buffer(cmd->t_data_sg, cmd->t_data_nents, buf,
> -			       cmd->data_length);
> -	if (!rc) {
> -		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
> -		ret = TCM_OUT_OF_RESOURCES;
> -		goto out;
> -	}
> -	/*
> -	 * Compare against SCSI READ payload against verify payload
> -	 */
> -	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, i) {
> -		addr = (unsigned char *)kmap_atomic(sg_page(sg));
> -		if (!addr) {
> -			ret = TCM_OUT_OF_RESOURCES;
> -			goto out;
> -		}
> -
> -		len = min(sg->length, compare_len);
> -
> -		if (memcmp(addr, buf + offset, len)) {
> -			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
> -				addr, buf + offset);
> -			kunmap_atomic(addr);
> -			goto miscompare;
> -		}
> -		kunmap_atomic(addr);
> -
> -		offset += len;
> -		compare_len -= len;
> -		if (!compare_len)
> -			break;
> -	}
>   
>   	i = 0;
>   	len = cmd->t_task_nolb * block_size;
> @@ -568,13 +591,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   
>   	__target_execute_cmd(cmd, false);
>   
> -	kfree(buf);
>   	return ret;
>   
> -miscompare:
> -	pr_warn("Target/%s: Send MISCOMPARE check condition and sense\n",
> -		dev->transport->name);
> -	ret = TCM_MISCOMPARE_VERIFY;
>   out:
>   	/*
>   	 * In the MISCOMPARE or failure case, unlock ->caw_sem obtained in
> @@ -582,7 +600,6 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   	 */
>   	up(&dev->caw_sem);
>   	sg_free_table(&write_tbl);
> -	kfree(buf);
>   	return ret;
>   }
>   
> 
