Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F62C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C2D361360
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhDZD4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:56:31 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:45660 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhDZD4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:56:30 -0400
Received: by mail-pj1-f51.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so748667pjb.4
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/l1lgatMpMf3lc8Fhz2bK4ZNNZHvb1mD1C8gd3vpxbI=;
        b=JXdy+B6LL9CGvjND6JzXYfcpVXXParwxXOt80e7Zso4xYEldqeEMUqRlyAR0XKLG3C
         b+4wE/peyf7ERSbMkwkV7pC43xzVz/R0HilPZRbS9DzkC7Lsvl9RJZgRIiXGjLDIXoNu
         5g/bw1BVMeAOYHYHRSiEN3sg2pl1jhPTMvO3Tm+3mUjB/xrm4Vwd1OvVFzDTANTu0HwK
         tJN4AacfWkF3H1BgqmHn6+HcTIBHbPXG2G4NkXbFpk+xdbjrn2kVY4DTIiAPlpeAY8M6
         McuRYRkuGsY4AxPcTvxQWyLGoYvhK2T0hc3gM7yd9Ktp+PzBijhS3GGqa/V6xS11LKMP
         5Ckw==
X-Gm-Message-State: AOAM531ZAAWSbeLNHquHXSf2z0SZ+ZQu0F6croCEb6Gge5IY4tkXUmTG
        SAE7lZKV3WCRfi2TcbBU7R0BQuTUVh7a5w==
X-Google-Smtp-Source: ABdhPJxye9MPCnhiVGKo1C4BIDsz79kB/9IC0Bgm/sJOkEj+lpjEamjXp3jhQTxaie+J74K8d/YQWA==
X-Received: by 2002:a17:902:70c5:b029:ec:9a57:9cc8 with SMTP id l5-20020a17090270c5b02900ec9a579cc8mr16487539plt.73.1619409347918;
        Sun, 25 Apr 2021 20:55:47 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i14sm9628115pfa.156.2021.04.25.20.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:55:47 -0700 (PDT)
Subject: Re: [PATCH 39/39] scsi: drop obsolete linux-specific SCSI status
 codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-40-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <08129fcc-98ab-fc65-b372-b86633d93669@acm.org>
Date:   Sun, 25 Apr 2021 20:55:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-40-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Original the SCSI subsystem has been using 'special' SCSI status
  ^^^^^^^^
  Originally?

> +/*
> + *  Original linux SCS Status codes. They are shifted 1 bit right
                      ^^^
                      SCSI?
> + *  from those found in the SCSI standards.
> + */
> +
> +#define GOOD                 0x00
> +#define CHECK_CONDITION      0x01
> +#define CONDITION_GOOD       0x02
> +#define BUSY                 0x04
> +#define INTERMEDIATE_GOOD    0x08
> +#define INTERMEDIATE_C_GOOD  0x0a
> +#define RESERVATION_CONFLICT 0x0c
> +#define COMMAND_TERMINATED   0x11
> +#define QUEUE_FULL           0x14
> +#define ACA_ACTIVE           0x18
> +#define TASK_ABORTED         0x20
> +
> +/* Obsolete status_byte() declaration */
> +#define status_byte(result) (((result) >> 1) & 0x7f)

If the above comments are addressed, please add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
