Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62E1C47095
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 16:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B473020756
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 16:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgJEQGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:06:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40855 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgJEQGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 12:06:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id i2so2566891pgh.7
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 09:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RsEpVcdipKgElTIiQULkg8ujBZ9f7awQ0x0/62IDiJM=;
        b=BahUk+pl7nUeJ/4iryEOe8DlCoF3eX9Mj1YJBjTV8KUKYg4T8Kva60AHpYtyqMukrS
         e9fjUpHboVs+PqoqnHDaKnIhpTy9sbmjkJSjdBwg0QUfRQoxPGCHdDqDfoalOEF8BFE3
         6UXhEZe6RmlL5Q6YGbMAJGsRfVUeXCo9qLyDoLBETovMfR+fGE8NL8fcrs1VvM6MPYBE
         5hxF1/bHMfG332BsEilX9PQQUreIiLqcle3gDRNVV7htVCr8O+Bzm1rsXdRzdETpi6YP
         fACCdUljQIq11RmXSfN6Rj2E1aT2uotAGxYiJv3H4gsCC1TgVXLm7XTSRVG2rW3vFP8n
         mbOw==
X-Gm-Message-State: AOAM531JGCpGZfX8ztOElNAZ8oo8Is0pTsyo5J0po24xrpay4/pO4qli
        e0XsSS/XuEvM06+c0sg2O6k2WThWZWM=
X-Google-Smtp-Source: ABdhPJz0FoGtaGkPL43/qPzYgBAiGT38nw2oEMCEbt/YUPJDGhhCFOAH529X/LfN/qXWd4ZeUkqlqw==
X-Received: by 2002:a63:f803:: with SMTP id n3mr148134pgh.231.1601914010605;
        Mon, 05 Oct 2020 09:06:50 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l14sm327560pfc.170.2020.10.05.09.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 09:06:49 -0700 (PDT)
Subject: Re: [PATCH 04/10] scsi: simplify varlen CDB length checking
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-5-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7f975da0-e793-ff23-064e-a4cf91396b09@acm.org>
Date:   Mon, 5 Oct 2020 09:06:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 1:41 AM, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index 8ea44c6595efa7..b6222df7254a3a 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -111,7 +111,7 @@ static size_t scsi_format_opcode_name(char *buffer, size_t buf_len,
>   
>   	cdb0 = cdbp[0];
>   	if (cdb0 == VARIABLE_LENGTH_CMD) {
> -		int len = scsi_varlen_cdb_length(cdbp);
> +		int len = cdbp[7] + 8;
>   
>   		if (len < 10) {
>   			off = scnprintf(buffer, buf_len,
> diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
> index 731ac09ed23135..297fc1881607b6 100644
> --- a/include/scsi/scsi_common.h
> +++ b/include/scsi/scsi_common.h
> @@ -9,20 +9,15 @@
>   #include <linux/types.h>
>   #include <scsi/scsi_proto.h>
>   
> -static inline unsigned
> -scsi_varlen_cdb_length(const void *hdr)
> -{
> -	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
> -}
> -
>   extern const unsigned char scsi_command_size_tbl[8];
>   #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
>   
>   static inline unsigned
>   scsi_command_size(const unsigned char *cmnd)
>   {
> -	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
> -		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
> +	if (cmnd[0] == VARIABLE_LENGTH_CMD)
> +		return cmnd[7] + 8;
> +	return COMMAND_SIZE(cmnd[0]);
>   }
>   
>   /* Returns a human-readable name for the device */
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index c3686011193224..c57f9cd8185526 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -176,16 +176,6 @@
>   
>   #define SCSI_MAX_VARLEN_CDB_SIZE 260
>   
> -/* defined in T10 SCSI Primary Commands-2 (SPC2) */
> -struct scsi_varlen_cdb_hdr {
> -	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
> -	__u8 control;
> -	__u8 misc[5];
> -	__u8 additional_cdb_length;         /* total cdb length - 8 */
> -	__be16 service_action;
> -	/* service specific data follows */
> -};

I'm OK with removing struct scsi_varlen_cdb_hdr but not with the removal of the
scsi_varlen_cdb_length() function. I'd like to keep that function because I think
it makes code that handles variable length CDBs easier to read.

Thanks,

Bart.
