Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6128FC388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 22:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1E7206B2
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 22:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kOK8vqIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbgKJWYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:24:10 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:16549 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKJWYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Nov 2020 17:24:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605047046; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=R1H4tV57NpCwsIrFGSsbbq3Bv8mEyWC5e4FAWHjBcBI=; b=kOK8vqImTCUhpvZfJBy4O8SEd4j0DxGeiNgHjfMJK9GPEWSuv3ZPui5O16r6/RSBFSQfZXL5
 2eeWilH2wQ6qRQTSwMOYOGRlk9njPMMk/DA7L35fGHR3owVEPo643Ar7PTbas3Do6zAzA105
 8jAmfdA7oVkUaL5DIOI2ETeGRfw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fab1301b8c6a84a5cf2a34a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 22:24:01
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D0D3DC433FF; Tue, 10 Nov 2020 22:24:00 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BBB74C433C9;
        Tue, 10 Nov 2020 22:23:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BBB74C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <d6ef63bb-12e5-b530-d8cb-8f05a47a9e19@codeaurora.org>
Date:   Tue, 10 Nov 2020 14:23:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/2020 10:59 PM, Can Guo wrote:
> Since WB feature has been added, WB related sysfs entries can be accessed
> even when an UFS device does not support WB feature. In that case, the
> descriptors which are not supported by the UFS device may be wrongly
> reported when they are accessed from their corrsponding sysfs entries.
> Fix it by adding a sanity check of parameter offset against the actual
> decriptor length.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 24 +++++++++++++++---------
>   1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a2ebcc8..aeec10d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3184,13 +3184,19 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>   	/* Get the length of descriptor */
>   	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
>   	if (!buff_len) {
> -		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
> +		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (param_offset >= buff_len) {
> +		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, length 0x%x\n",
> +			__func__, param_offset, desc_id, buff_len);
>   		return -EINVAL;
>   	}
>   
>   	/* Check whether we need temp memory */
>   	if (param_offset != 0 || param_size < buff_len) {
> -		desc_buf = kmalloc(buff_len, GFP_KERNEL);
> +		desc_buf = kzalloc(buff_len, GFP_KERNEL);
>   		if (!desc_buf)
>   			return -ENOMEM;
>   	} else {
> @@ -3204,14 +3210,14 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>   					desc_buf, &buff_len);
>   
>   	if (ret) {
> -		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
> +		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d\n",
>   			__func__, desc_id, desc_index, param_offset, ret);
>   		goto out;
>   	}
>   
>   	/* Sanity check */
>   	if (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id) {
> -		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header",
> +		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header\n",
>   			__func__, desc_buf[QUERY_DESC_DESC_TYPE_OFFSET]);
>   		ret = -EINVAL;
>   		goto out;
> @@ -3221,12 +3227,12 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>   	buff_len = desc_buf[QUERY_DESC_LENGTH_OFFSET];
>   	ufshcd_update_desc_length(hba, desc_id, desc_index, buff_len);
>   
> -	/* Check wherher we will not copy more data, than available */
> -	if (is_kmalloc && (param_offset + param_size) > buff_len)
> -		param_size = buff_len - param_offset;
> -
> -	if (is_kmalloc)
> +	if (is_kmalloc) {
> +		/* Make sure we don't copy more data than available */
> +		if (param_offset + param_size > buff_len)
> +			param_size = buff_len - param_offset;
>   		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
> +	}
>   out:
>   	if (is_kmalloc)
>   		kfree(desc_buf);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
