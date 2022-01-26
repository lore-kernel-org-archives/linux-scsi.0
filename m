Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507A2C2BA4C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 19:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiAZTJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 14:09:28 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:45612 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiAZTJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2022 14:09:28 -0500
Received: by mail-pg1-f178.google.com with SMTP id z131so221054pgz.12
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jan 2022 11:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rSzmF8E2CuZeFJAitvzT7tX0h6phubpSSTno0fsio3g=;
        b=b6MZ03hzTBniTTZxni4jjcvv+xORX2EEgJGoQNLLMehDKRBll55a0moHzmS4NwUxhU
         ylEjRneKL4qtbG5Da/u6n+5dlyQzKpzgnw0A7n5VcwveBsNhFAXT2sqzqAjqnLo17tY1
         qtFCrq+dbDqCgrI0plXtdwopO1v7OXq6O4o3qc3M0bkLkfypLj4U5xDNC+I8jhBkLVGr
         VTb8zPWugFO1lnH5Al49BdIsca+czc9eY5h09RVlT+QAEWwM7QPG54aC2OhFDpNOFLjn
         2E7nSgXSvlgG1xbzulbAb7ybHQLZhlOLNybmUlA/vyjygFCGxVFqT10PLDqoSR3Dlwrl
         /V6A==
X-Gm-Message-State: AOAM532MZ5s/8sJTCrxjXUAqcn2QyHy/rrGhAK/DdlbSIAvjPiQaGikF
        zaaCvtBgzhx/h222cyJYoxlspLxd6/8=
X-Google-Smtp-Source: ABdhPJypOk8LwjqiR0QtAHIu/ofXdX8+/hy7k2AWY+hAYz/l3hI/BTtcgypjLjEJAJ9VJrJxgCkC3A==
X-Received: by 2002:a05:6a00:1a4f:b0:4c9:e7b7:d84b with SMTP id h15-20020a056a001a4f00b004c9e7b7d84bmr12669225pfv.61.1643224167445;
        Wed, 26 Jan 2022 11:09:27 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b9sm2833376pfm.154.2022.01.26.11.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 11:09:26 -0800 (PST)
Message-ID: <960b813a-0e65-c542-420b-7314d329f390@acm.org>
Date:   Wed, 26 Jan 2022 11:09:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] scsi: core: reallocate scsi device's budget map if
 default queue depth is changed
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Martin Wilck <martin.wilck@suse.com>,
        Martin Wilck <mwilck@suse.com>
References: <20220126041756.297658-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220126041756.297658-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/22 20:17, Ming Lei wrote:
> +static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
> +					unsigned int depth)
> +{
> +	int new_shift = sbitmap_calculate_shift(depth);
> +	bool need_alloc = !sdev->budget_map.map;
> +	bool need_free = false;
> +	int ret;
> +	struct sbitmap sb_back;

To me the variable name "sb_back" looks confusing. Consider renaming 
this variable into "sb_backup" or "previous_sb".

> +	/*
> +	 * Request queue has to be freezed for reallocating budget map,
                                    ^^^^^^^
                                    frozen?
> +	 * and here disk isn't added yet, so freezing is pretty fast
> +	 */

Otherwise this patch looks good to me.

Thanks,

Bart.
