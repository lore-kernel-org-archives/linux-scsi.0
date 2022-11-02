Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A03C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 22:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiKBWrr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKBWrq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 18:47:46 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43400646E;
        Wed,  2 Nov 2022 15:47:46 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso3486136pjg.5;
        Wed, 02 Nov 2022 15:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4wIJC4qmLD8sZv7FELeKq1bWLCLMI4X8kEQubd/l6g=;
        b=l1Y1CG5rrIod/X/S+NH5kEg+D66C1vAqy6osserWaJKvfnXBQRA/jxZ6F56cbx52Og
         6Nu7AI6FI28f2B6K3A9uIMQTJsJntRDnzD0ZeFj0/sJCunyxXUu07dZS4P9/Ry0p9ZvT
         BYqbMPVNkV5KKkIYHh3QsZSkKLkdSUKEid3e2fpQDBFQxIoNHBxv1o54a+McmwCNU7ma
         8U5kkxWycfmrx/at75Bf4qxurxPYaGwO2hSEPRdN0fuQsfrPL+4NOsKqreUH/TLjz2bU
         hehOqQMXVX9LnOiyLg/w6nwXKK5+yMv5MQXzg5MjTWVRqHZexOyEyA/VGaL7dLoICe+n
         rJow==
X-Gm-Message-State: ACrzQf2wRTndNU5QSS98Kn+EwOE9FgAV7b8f/r+k0yjJkgiO66t+/FO/
        4fS+7HaqTUQ7XtdykuobAwA=
X-Google-Smtp-Source: AMsMyM7oTR2d5lchMffcmjpS1vJGXh4SAt69GYPXVjFJ2dUHdIGIroDKm3Sonab/kAsDMsRgrqXqvA==
X-Received: by 2002:a17:902:bf08:b0:178:90fb:8cda with SMTP id bi8-20020a170902bf0800b0017890fb8cdamr26566977plb.9.1667429265258;
        Wed, 02 Nov 2022 15:47:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89? ([2620:15c:211:201:22d3:f380:fa84:4b89])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709027b9600b0017f7628cbddsm8842988pll.30.2022.11.02.15.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 15:47:44 -0700 (PDT)
Message-ID: <0123db70-6217-135a-4101-0609512e723b@acm.org>
Date:   Wed, 2 Nov 2022 15:47:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/22 16:19, Mike Christie wrote:
> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
> +{
> +	switch (type) {
> +	case PR_WRITE_EXCLUSIVE:
> +		return SCSI_PR_WRITE_EXCLUSIVE;
> +	case PR_EXCLUSIVE_ACCESS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS;
> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +};

Please leave out "default: return 0;" from the switch statement and add 
"return 0;" after the switch statement. That will make the compiler emit 
a warning if a value is added in enum pr_type but not in the above function.

Thanks,

Bart.

