Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D38C48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A8461376
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhFIT5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:57:15 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:35499 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFIT5N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 15:57:13 -0400
Received: by mail-pj1-f47.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso2225620pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 12:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9s7fQ8EOJ4NtavBvLqTB9pogT28DH2aZIX03kvkCS4c=;
        b=fboB89S8jRkrBSQqW6jbp7b+FZJA5nK+QJY8qhx38iVsQSG+odeADEdUSqO2xbJi2u
         ogCMrIRwXCGoHplEvmfXieW3CWbdLybytHaNh4uPdSU69SeWZtzTF9Nfpr6BjpUX3mNA
         V8LbAcQGSwwBd4F4xDBvBEr/iYFMtD0OaCVowTAkSMdNG5qlErMgioA01NwszNg3dqq5
         JeS+1Zeg9a2yxJyCCLKpu+dMxSFt9hZUSKHss/blRAijhuPPNjVKc249p4NqpHmQVFP7
         K4EhQWV55GQOaQj0h6JKU2mYbYObIcB6B/1CWGoyWi2Es0zczw6F19WzkbarrnhAlBcL
         k55Q==
X-Gm-Message-State: AOAM530rRzs/ZHpO+OOPEpDnJAdBeYjJTtlvGG+96byNYhvuV03PXE1a
        jaJwFLsAuw8AmHZPMixLzML5xkkA/Pg=
X-Google-Smtp-Source: ABdhPJyAF2VhFnJq5Ha8P/SYc6hLcAP1rPi2xb9Dm6RZhNVx7es/6ZgqEJv3sOmo2VsmDLFvzVH75Q==
X-Received: by 2002:a17:902:c78a:b029:109:edbb:44de with SMTP id w10-20020a170902c78ab0290109edbb44demr1379795pla.6.1623268502315;
        Wed, 09 Jun 2021 12:55:02 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v6sm364206pfi.46.2021.06.09.12.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 12:55:01 -0700 (PDT)
Subject: Re: [PATCH 01/15] scsi: core: Add scsi_prot_ref_tag() helper
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-2-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8178394f-d6a3-eaf2-fe57-e22d4b7c677d@acm.org>
Date:   Wed, 9 Jun 2021 12:55:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210609033929.3815-2-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 8:39 PM, Martin K. Petersen wrote:
> We are about to remove the request pointer from struct scsi_cmnd and
> that will complicate getting to the ref_tag via t10_pi_ref_tag() in
> the various drivers. Introduce a helper function to retrieve the
> reference tag so drivers will not have to worry about the details.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  include/scsi/scsi_cmnd.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 779a59fe8676..301b9cd4ddd0 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -287,6 +287,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
>  	return blk_rq_pos(scmd->request);
>  }
>  
> +static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = blk_mq_rq_from_pdu(scmd);
> +
> +	return t10_pi_ref_tag(rq);
> +}
> +
>  static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
>  {
>  	return scmd->device->sector_size;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
