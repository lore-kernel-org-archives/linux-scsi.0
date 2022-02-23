Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5643C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 23:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbiBWXkl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245074AbiBWXk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 18:40:29 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D64F5B3E1;
        Wed, 23 Feb 2022 15:40:00 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id x11so181188pll.10;
        Wed, 23 Feb 2022 15:40:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+Ky8c3SWv/SG02xpFos4fjhqGDxrDNOCARPvRnxfG3k=;
        b=w3sFZGGhQaciDW4FEXpMtNQS5CD0tgt6XT2MXHzUfKq6k9PSCMiN96ixU126rg+nMy
         6kn1m7HyypYI/Y1qisv86Ts2jGf3gF1qtnPZBT+AVRU98oe9JMzWUVIGCInN7qN8Yujb
         rWwfgC6hkVjjQPNMyq22YUVBaX/9IG0Ld4p4nwwTs4Aj5PG8mFU8uNUUMrHbpZO2MHtV
         O3Gnbx2R0IJyhGaCTdfY/oLW+GkH9pLbaU1cb1dgJUjUe6YJ1V2b+ZX2/GHZt9ZkAc6d
         Zn8cKEQE54iB95vNCp03mxCfSLqln26hSZw7BLCw5u0waBG+eUcK6J/j9MC/qpfWrt8K
         pbuA==
X-Gm-Message-State: AOAM533SrPbaJzUezbWxmdu+lwLj1126MdpGzpIGJlIGfttP/1ZNmEHv
        esszE1OAjb2S5WTPIJIttMw=
X-Google-Smtp-Source: ABdhPJzTn5Ns0Xdprz0G0xIX+pBSKQv8OO5t+F7g2QHjyIgbT6X5GRBiQMEvCLEkAvpnN41Jth5wKQ==
X-Received: by 2002:a17:90a:8d82:b0:1bc:6b54:e798 with SMTP id d2-20020a17090a8d8200b001bc6b54e798mr11626353pjo.77.1645659599905;
        Wed, 23 Feb 2022 15:39:59 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id f17sm630228pfd.49.2022.02.23.15.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:39:59 -0800 (PST)
Message-ID: <424d74d5-3150-78d7-20de-40d1a16a495d@acm.org>
Date:   Wed, 23 Feb 2022 15:39:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5/8] scsi: remove the sense and sense_len fields from
 struct scsi_request
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-6-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> @@ -613,10 +614,10 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
>   
>   	err = req->result & 0xff;	/* only 8 bit SCSI status */
>   	if (err) {
> -		if (req->sense_len && req->sense) {
> -			bytes = (OMAX_SB_LEN > req->sense_len) ?
> -				req->sense_len : OMAX_SB_LEN;
> -			if (copy_to_user(sic->data, req->sense, bytes))
> +		if (scmd->sense_len && scmd->sense_buffer) {
> +			bytes = (OMAX_SB_LEN > scmd->sense_len) ?
> +				scmd->sense_len : OMAX_SB_LEN;
> +			if (copy_to_user(sic->data, scmd->sense_buffer, bytes))
>   				err = -EFAULT;
>   		}
>   	} else {

This change would be a good opportunity to remove the two superfluous 
parentheses from the above code.

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 3e432e25645ac..47add5b32f460 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -112,6 +112,7 @@ struct scsi_cmnd {
>   				   reconnects.   Probably == sector
>   				   size */
>   
> +	unsigned sense_len;
>   	unsigned char *sense_buffer;
>   				/* obtained by REQUEST SENSE when
>   				 * CHECK CONDITION is received on original

Isn't "unsigned int" preferred over "unsigned" in new code?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
