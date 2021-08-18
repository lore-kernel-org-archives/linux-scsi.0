Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614AEC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4600360F11
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhHRQh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhHRQh4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 12:37:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC3DC061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:37:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 18so2705510pfh.9
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gGEpZ3+oeKv5GEi0pFDmne0eKiXYn8bAEPIoHBdBjiw=;
        b=liZzO1tm5TVhrlG6zTUDOQptA3Eza/D1z4Ec+s2NltLfy9ybzQiVP8U8CVQSagQ6Hr
         MvMmMmY4H+X9XhZq4hxq0x+p9PetDPF192jfxowpbfOUyJVCwG8M1g6pJ8+rLMybMkXB
         ZHbBIt2wDu5YoHSblSf4FV3v8AlCU4xct8rm/VYQkRQXnkpDSDztsVgu452xrX3ZfH5V
         chPisG/oWkH9ywrOpE33vDAS9WCv542yrxwcKq90YNA2N4IHP8oePT7T9EnPSWaFJoT+
         7uZ4ly97qjBJu33dFB/R2JvzkmgFI+BGbR8tDhPzeFgbix0CK0iix4Y+fgBW2kyX3Y45
         bviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gGEpZ3+oeKv5GEi0pFDmne0eKiXYn8bAEPIoHBdBjiw=;
        b=uXP9tkh5JYqZQqAT9S0MhaKMkdzgHC2DB1xZt6xjMSy2GAVMB/qVOyrp+2miEo67fZ
         ooQeVYYQIpVRXoqZf4p5sbae7VI8pbIc+sVZpOPe/+YaRREQeEX3ceb9vQoQJjW+R4J5
         k5GMIOpTZ8XH7vghNvrhfoa4EcWEfnZCfS5TkV3wUyL54tvYRjcit556jR6bsQJkHjM1
         gCxIUOikPoPnonXzbAzlaoPXRTsMkmFRbXnfUylV/MjxnvLYho5jdtFkkpgs0BBCcyht
         MVyEephaaL4MqwpgXVb5aggtZFIW3Sjjic94Eo92eTTfW5gvKy58REWRnkeZpGySLvw4
         4xqg==
X-Gm-Message-State: AOAM532cExKS+NyzTtXe/Rc2YvtdnQkwdks61ijvlnSVN57q/MRTYC0Z
        JmKqIJgOl9SkWHb6NA5igow=
X-Google-Smtp-Source: ABdhPJyuZjIBE4ITWGqd93crVMHMx+EOSuriXr2KExdXcLd2WnHnJGT7gbniyZ+Wok5y58OZQZx89Q==
X-Received: by 2002:a65:6648:: with SMTP id z8mr5306663pgv.418.1629304641862;
        Wed, 18 Aug 2021 09:37:21 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b13sm269044pfr.72.2021.08.18.09.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 09:37:21 -0700 (PDT)
Subject: Re: [PATCH 36/51] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-37-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <ef319d9d-e22f-5cc4-73a2-eb92ee5e5c22@gmail.com>
Date:   Wed, 18 Aug 2021 09:37:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-37-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 2:14 AM, Hannes Reinecke wrote:
> The target reset function should only depend on the scsi target,
> not the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   Documentation/scsi/scsi_eh.rst              | 10 ++++
>   Documentation/scsi/scsi_mid_low_api.rst     | 18 +++++++
>   drivers/message/fusion/mptsas.c             | 10 +++-
>   drivers/message/fusion/mptscsih.c           | 27 ++++------
>   drivers/message/fusion/mptscsih.h           |  2 +-
>   drivers/message/fusion/mptspi.c             |  8 ++-
>   drivers/s390/scsi/zfcp_scsi.c               |  7 ++-
>   drivers/scsi/aacraid/linit.c                |  9 ++--
>   drivers/scsi/be2iscsi/be_main.c             |  4 +-
>   drivers/scsi/bfa/bfad_im.c                  |  3 +-
>   drivers/scsi/bnx2fc/bnx2fc.h                |  2 +-
>   drivers/scsi/bnx2fc/bnx2fc_io.c             |  4 +-
>   drivers/scsi/esas2r/esas2r.h                |  2 +-
>   drivers/scsi/esas2r/esas2r_main.c           | 38 +++++++-------
>   drivers/scsi/ibmvscsi/ibmvfc.c              |  3 +-
>   drivers/scsi/libiscsi.c                     |  4 +-
>   drivers/scsi/libsas/sas_scsi_host.c         |  9 ++--
>   drivers/scsi/lpfc/lpfc_scsi.c               | 10 ++--
>   drivers/scsi/megaraid/megaraid_sas.h        |  3 +-
>   drivers/scsi/megaraid/megaraid_sas_base.c   | 10 ++--
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 56 +++++++++++++--------
>   drivers/scsi/mpi3mr/mpi3mr_os.c             | 34 +++++--------
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 38 +++++++-------
>   drivers/scsi/pmcraid.c                      |  8 +--
>   drivers/scsi/qedf/qedf_main.c               |  3 +-
>   drivers/scsi/qla2xxx/qla_os.c               | 38 +++++++-------
>   drivers/scsi/qla4xxx/ql4_os.c               | 14 +++---
>   drivers/scsi/scsi_debug.c                   | 21 +++-----
>   drivers/scsi/scsi_error.c                   |  5 +-
>   drivers/scsi/sym53c8xx_2/sym_glue.c         |  3 +-
>   drivers/target/loopback/tcm_loop.c          |  9 ++--
>   include/scsi/libiscsi.h                     |  2 +-
>   include/scsi/libsas.h                       |  2 +-
>   include/scsi/scsi_host.h                    |  2 +-
>   34 files changed, 226 insertions(+), 192 deletions(-)
> 

lpfc part looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


