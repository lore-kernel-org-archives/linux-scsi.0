Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E0AECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 16:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiIIQYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 12:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIIQYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 12:24:53 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0178A5283F
        for <linux-scsi@vger.kernel.org>; Fri,  9 Sep 2022 09:24:50 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso2082838pjd.4
        for <linux-scsi@vger.kernel.org>; Fri, 09 Sep 2022 09:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ny58MeGEYOmYz+4vabuoXZ+psjIv37l1/nfv+pC9cbg=;
        b=0EMgN36rRTh/IIxCwvEoZs0vb5I4YUoLvwWe2nmioR3YMp+Tl/760wci3sd1rX1JkQ
         jv5sAinmSAnfHEEJvoGoTj3C5RFAoUQmlzYXa2J600R45tLQQcnEDUNe9yATjdXplQQs
         uYrvlJA2FTvR9ROabFkWK+GKS4zVrCB83PkxIuV7ayiDAxkcrN+N3I5IQeXtWeGZYakp
         5eP82d4euaFfzM1ILSpvl8AxZhbyjlboNT9BVjJGNOMfMoETUi5fKOj1NRyIVnofZW9v
         BpwoIC4FQPR7RzZ3M9lb6/UatKub45TetuVIk5/9KgwOLb3dFuzo1fOM70NfhLGktAKF
         3biA==
X-Gm-Message-State: ACgBeo2vKyQVRaNmc7g4eQYCiAHuAkxVnxxR5tuHERh2BfoQEJJ+ApC6
        YX5IybsHD/k+RrCE0NgOtNo=
X-Google-Smtp-Source: AA6agR5bh3oWbPi81bM7YIDI5bHO2N/kJneJLhRWe15LlMlIXmFUojB3LP2mIu9uQBQNvDFIYK4cFQ==
X-Received: by 2002:a17:90b:1b12:b0:200:5dbd:ae02 with SMTP id nu18-20020a17090b1b1200b002005dbdae02mr10205710pjb.11.1662740688706;
        Fri, 09 Sep 2022 09:24:48 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t62-20020a625f41000000b0053e72ed5252sm763071pfb.42.2022.09.09.09.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 09:24:47 -0700 (PDT)
Message-ID: <fd6a94cd-6d71-f241-fc7b-d8613c1c2616@acm.org>
Date:   Fri, 9 Sep 2022 09:24:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] scsi: stex: properly zero out the passthrough command
 structure
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org, hdthky <hdthky0@gmail.com>,
        stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220908145154.2284098-1-gregkh@linuxfoundation.org>
 <YxrjN3OOw2HHl9tx@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YxrjN3OOw2HHl9tx@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/22 23:54, Greg Kroah-Hartman wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> The passthrough structure is declared off of the stack, so it needs to
> be set to zero before copied back to userspace to prevent any
> unintentional data leakage.  Switch things to be statically allocated
> which will fill the unused fields with 0 automatically.
> 
> Reported-by: hdthky <hdthky0@gmail.com>
> Cc: stable <stable@kernel.org>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   v2: Linus's updated version that moves the initialization to be
>       statically defined and changes the function prototype and structure
>       to be const.
> 
>   drivers/scsi/stex.c      | 17 +++++++++--------
>   include/scsi/scsi_cmnd.h |  2 +-
>   2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index e6420f2127ce..8def242675ef 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -665,16 +665,17 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
>   		return 0;
>   	case PASSTHRU_CMD:
>   		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
> -			struct st_drvver ver;
> +			const struct st_drvver ver = {
> +				.major = ST_VER_MAJOR,
> +				.minor = ST_VER_MINOR,
> +				.oem = ST_OEM,
> +				.build = ST_BUILD_VER,
> +				.signature[0] = PASSTHRU_SIGNATURE,
> +				.console_id = host->max_id - 1,
> +				.host_no = hba->host->host_no,
> +			};
>   			size_t cp_len = sizeof(ver);
>   
> -			ver.major = ST_VER_MAJOR;
> -			ver.minor = ST_VER_MINOR;
> -			ver.oem = ST_OEM;
> -			ver.build = ST_BUILD_VER;
> -			ver.signature[0] = PASSTHRU_SIGNATURE;
> -			ver.console_id = host->max_id - 1;
> -			ver.host_no = hba->host->host_no;
>   			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
>   			if (sizeof(ver) == cp_len)
>   				cmd->result = DID_OK << 16;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index bac55decf900..7d3622db38ed 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -201,7 +201,7 @@ static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
>   	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
>   
>   static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
> -					   void *buf, int buflen)
> +					   const void *buf, int buflen)
>   {
>   	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
>   				   buf, buflen);

Please split this patch into one patch for the SCSI core and another patch
for the STEX driver.

Thanks,

Bart.
