Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CAEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 19:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiBXTtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 14:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiBXTtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 14:49:35 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA15253BF9
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 11:49:03 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id x18so2772225pfh.5
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 11:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JLAJXRAsOA0nPPKQhG1zeuJxEZgiYYAJ+zx+6m7gEos=;
        b=pldR2J3Dj69KyK6mJEOoAQp7Jk9jp2dih209Q6IZehXAFe6EeqHTA5kE02GrmI6prf
         b3jcDIkz+recP7BbxOw3Pu1Y0KJ4G7eWrjAYXFBO1/ELw/WzteXq47qQ/c7c3c42oBRx
         vd8jmGAp1FiZQ4Ova6Wrw+Zty5IHZdTmD8xfwkA1nM90kTs3TllwqOWnZW9Yb3rhPU/M
         hzYCc5q/z55o7u51GZsfb9WloK6YUuU+rrP/RARiHfGUZQGzB72r2h6f6/+2rJEtavRD
         4IJ4T8QR4c8bEfgbo65r9um/FtVoAEZUUXBdxWfkCkoElPZnxErx9yQ/htcvucJN/WrV
         OyTQ==
X-Gm-Message-State: AOAM532hAizl1FpDqkwVm1KVizZdI0zjAncwu/srI4A922Pg84zvAZkD
        XWwYvHWTFQc+6U0to7+HiU0=
X-Google-Smtp-Source: ABdhPJwtKuVwKZXFVtvISCoyfJsGzl/MK23r5BvOjHdnZZdQ/3LtHhb76I6HqCU6WZF/7WQLteKqDg==
X-Received: by 2002:a65:6093:0:b0:373:9c75:19ec with SMTP id t19-20020a656093000000b003739c7519ecmr3476767pgu.539.1645732143190;
        Thu, 24 Feb 2022 11:49:03 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id lw12-20020a17090b180c00b001b8a61a0ea5sm162831pjb.38.2022.02.24.11.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 11:49:02 -0800 (PST)
Message-ID: <4143bc11-1c0c-e51f-f012-595c59bc8fdd@acm.org>
Date:   Thu, 24 Feb 2022 11:49:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/5] scsi: mpt3sas: fix Mpi2SCSITaskManagementRequest_t
 TaskMID handling
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
 <20220224101129.371905-2-damien.lemoal@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220224101129.371905-2-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/22 02:11, Damien Le Moal wrote:
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
> index 8f1b903fe0a9..80bcf7d83184 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
> @@ -428,7 +428,7 @@ typedef struct _MPI2_SCSI_TASK_MANAGE_REQUEST {
>   	U16 Reserved3;		/*0x0A */
>   	U8 LUN[8];		/*0x0C */
>   	U32 Reserved4[7];	/*0x14 */
> -	U16 TaskMID;		/*0x30 */
> +	__le16 TaskMID;		/*0x30 */
>   	U16 Reserved5;		/*0x32 */
>   } MPI2_SCSI_TASK_MANAGE_REQUEST,
>   	*PTR_MPI2_SCSI_TASK_MANAGE_REQUEST,

Is this change necessary? From drivers/scsi/mpt3sas/mpi/mpi2_type.h:

typedef __le16 U16;

BTW, I think the U16 etc. typedefs should disappear.

Thanks,

Bart.
