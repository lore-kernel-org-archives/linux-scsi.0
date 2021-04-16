Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6959EC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 16:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E92B610FA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 16:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbhDPQMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 12:12:17 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:42876 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbhDPQMQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 12:12:16 -0400
Received: by mail-pg1-f172.google.com with SMTP id g35so19479130pgg.9;
        Fri, 16 Apr 2021 09:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h9Y99zdlPbvFkMqDEZrfXfHWzGvdhVoPnWQq5jQuyxM=;
        b=GX8x4iIaiM8J1K9EtSJsFJrqL2TJUwUgU15qe5mx7aC9kLDIA4xMkiM7ylBpbspGel
         fgiwCOb4M6vUj9/QYQAEXyeg1Mxf/7lXF39GSmmpJqPxTdhBKfMPJCx7obygxh6VGFn9
         2w2srWPg12+ehaIHHIrMVPR/Neab/n/eE0xLYF4OmvCEgcEInupuLh49mZgXbj0LxczQ
         ZiWQczPHdQ2xpUlGXEFLXpBnhE+adm++3H7qBB1n1P8ECvD8ltengCGqYlLa48JAAuED
         I0IssgEtxd5yWmJZc3f+cJNz+hE3b7CQ2mOLxQslnozawQpBurwqRX26NuHFdav1fWEj
         basg==
X-Gm-Message-State: AOAM5306oEQqUeEGhob5sDMRLqB3iqQjGZ/Us7niNZBr+r61CcEsHkOQ
        fMn3PeaWTiE8of4FWG5iH61mz8xfI9Ns5w==
X-Google-Smtp-Source: ABdhPJzh/e2oJmtpQOqA28XAl1bLCXbS1dgzBi8/2H2x3dqLdUL/wMMLiGRqzxihKy8uE5RLjvgE3Q==
X-Received: by 2002:a63:4442:: with SMTP id t2mr9020677pgk.232.1618589510339;
        Fri, 16 Apr 2021 09:11:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:deb4:c899:3eb6:a154? ([2601:647:4000:d7:deb4:c899:3eb6:a154])
        by smtp.gmail.com with ESMTPSA id m188sm5482967pga.23.2021.04.16.09.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 09:11:49 -0700 (PDT)
Subject: Re: [PATCH v4 1/7] target: core: add common tpg/enable attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210416082632.2000-1-d.bogdanov@yadro.com>
 <20210416082632.2000-2-d.bogdanov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1d9bebdd-84e6-db6d-c21b-9516d6ab7ed1@acm.org>
Date:   Fri, 16 Apr 2021 09:11:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210416082632.2000-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 1:26 AM, Dmitry Bogdanov wrote:
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -89,6 +89,7 @@ struct target_core_fabric_ops {
>  	void (*add_wwn_groups)(struct se_wwn *);
>  	struct se_portal_group *(*fabric_make_tpg)(struct se_wwn *,
>  						   const char *);
> +	int (*fabric_enable_tpg)(struct se_portal_group *se_tpg, bool enable);
>  	void (*fabric_drop_tpg)(struct se_portal_group *);
>  	int (*fabric_post_link)(struct se_portal_group *,
>  				struct se_lun *);

A nit: the "fabric_" prefix is not useful inside struct
target_core_fabric_ops. If the new callback would be called "enable_tpg"
no clarity would be lost. Additionally, the "fabric_" prefix is
deprecated. New target code should use the "target_" prefix for new
functions.

Thanks,

Bart.


