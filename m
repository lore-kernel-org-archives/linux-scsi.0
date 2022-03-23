Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5462DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 13:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbiCWNgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244298AbiCWNgq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 09:36:46 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822231F616
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2022 06:35:17 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id i11so1562057plr.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2022 06:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oudDCTfDcsfjOLD59OkmWUfh87BNxaBsbaxb2UNlrGk=;
        b=QE0y7gw49uq5lAJmGL4ekPbIoIyALMmzdIFLWqTQS2ZQwsSwvUK+ytZpShKBzJozC6
         Zg8Ld97OhM0a/esY4ih+R5m+qvNPUn3FbSnn4LJlHckBqt2R/rmFcVtoBxq5wQeFHIRd
         72lePWVDEf22P6JjEH6hmmAAPE0K9s0063YrEqoNZZfT5os84MhkiNpF0CW6X43kqj04
         GhM/1C+sJgiOWS4VhKuUO886G0bhQVnptJogLkysGgszXtBVl/Ev/VFKrJG+W3buuJUx
         ZFNWIiku1P+tztifpy1ukfGkhdu/Y3mUW+9DlDtL0qV3hpF6hjzuXmbcBFzs1F+4rWdi
         HT8g==
X-Gm-Message-State: AOAM531BcHRxfdmA7S1dZliJTB09u+G8wzh5n/cSCb34kU18Z++SFnAr
        M17L6MdIVSZ/2xDMUMZgFyXXMMjuHD0=
X-Google-Smtp-Source: ABdhPJxwUMSu2eygaq2wfKIFdLzY6C6hSfLgqdL8LNu9GaJmnvqssVMcjow16aU0w0lqxQS1vHtXig==
X-Received: by 2002:a17:90b:4f8d:b0:1c6:408b:6b0d with SMTP id qe13-20020a17090b4f8d00b001c6408b6b0dmr11636848pjb.90.1648042516765;
        Wed, 23 Mar 2022 06:35:16 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q15-20020a056a00150f00b004fac01c0198sm18975pfu.40.2022.03.23.06.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 06:35:16 -0700 (PDT)
Message-ID: <982a8a95-e431-6ce7-767a-8d67c01cd6be@acm.org>
Date:   Wed, 23 Mar 2022 06:35:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/7] mpi3mr: add support for driver commands
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com
References: <20220322122107.8482-1-sumit.saxena@broadcom.com>
 <20220322122107.8482-3-sumit.saxena@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220322122107.8482-3-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/22 05:21, Sumit Saxena wrote:
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.h b/drivers/scsi/mpi3mr/mpi3mr_app.h
> index 4bc31d45c610..d324a13c672c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.h
> @@ -10,6 +10,476 @@
>   #ifndef MPI3MR_APP_H_INCLUDED
>   #define MPI3MR_APP_H_INCLUDED
>   
> +
> +/* Definitions for BSG commands */
> +#define MPI3MR_IOCTL_VERSION			0x06
> +
> +#define MPI3MR_APP_DEFAULT_TIMEOUT		(60) /*seconds*/
> +
> +#define MPI3MR_BSG_ADPTYPE_UNKNOWN		0
> +#define MPI3MR_BSG_ADPTYPE_AVGFAMILY		1
> +
> +#define MPI3MR_BSG_ADPSTATE_UNKNOWN		0
> +#define MPI3MR_BSG_ADPSTATE_OPERATIONAL		1
> +#define MPI3MR_BSG_ADPSTATE_FAULT		2
> +#define MPI3MR_BSG_ADPSTATE_IN_RESET		3
> +#define MPI3MR_BSG_ADPSTATE_UNRECOVERABLE	4
> +
> +#define MPI3MR_BSG_ADPRESET_UNKNOWN		0
> +#define MPI3MR_BSG_ADPRESET_SOFT		1
> +#define MPI3MR_BSG_ADPRESET_DIAG_FAULT		2
> +
> +#define MPI3MR_BSG_LOGDATA_MAX_ENTRIES		400
> +#define MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ	4
> +
> +#define MPI3MR_DRVBSG_OPCODE_UNKNOWN		0
> +#define MPI3MR_DRVBSG_OPCODE_ADPINFO		1
> +#define MPI3MR_DRVBSG_OPCODE_ADPRESET		2
> +#define MPI3MR_DRVBSG_OPCODE_ALLTGTDEVINFO	4
> +#define MPI3MR_DRVBSG_OPCODE_GETCHGCNT		5
> +#define MPI3MR_DRVBSG_OPCODE_LOGDATAENABLE	6
> +#define MPI3MR_DRVBSG_OPCODE_PELENABLE		7
> +#define MPI3MR_DRVBSG_OPCODE_GETLOGDATA		8
> +#define MPI3MR_DRVBSG_OPCODE_QUERY_HDB		9
> +#define MPI3MR_DRVBSG_OPCODE_REPOST_HDB		10
> +#define MPI3MR_DRVBSG_OPCODE_UPLOAD_HDB		11
> +#define MPI3MR_DRVBSG_OPCODE_REFRESH_HDB_TRIGGERS	12

Most if not all definitions in this file are needed by user space 
applications that use the new BSG interface. Please move the definitions 
from this file that are used by user space applications into a header 
file under include/uapi/.

Thanks,

Bart.
