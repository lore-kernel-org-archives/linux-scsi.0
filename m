Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E160EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 18:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A2361130
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 18:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhIOSBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 14:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhIOSB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 14:01:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EB9C061793;
        Wed, 15 Sep 2021 11:00:06 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso2647782wmd.5;
        Wed, 15 Sep 2021 11:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=edZuonNncjeUnTwsHSKjKHYwLFmD/HrFs5tvhk4V4a4=;
        b=XBkl/47M1CLbqUV3veXEzxntT+w3FS90QYKEFSktpDBPaGTfj4t21XMhVz+VJLLS/d
         JlqVfeLQ2J57gRu0vsGqg/NvNH7MPUQ5tgxk1IoWtLiO6MYaKuhNIT2bUYw0noCgR3vm
         BcSukQhLkc20Oxajv4ipfGZO5AS6OZI5p4HyMaJXqnoEaNSdG5pswHvNGmNk0k96Drwq
         NqI6KSdXs0YBgC/iUk36UFGomTrdcXaCLqgxNhYqcIUw2SF3n4qGLCSIRIqjOXqHKPUF
         yjYWWngZg1DOgI+nkBnQk1luXISVx/AQdpvBl4Zg3Vds6uucU6keeX8eCZ8o6QNww8fy
         G01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=edZuonNncjeUnTwsHSKjKHYwLFmD/HrFs5tvhk4V4a4=;
        b=RpHFecgS0LTyqkV9peHTrVDH0vbuSREoNBM1pOuteF3uPq8rCa3IKTIDieMxr4VqPQ
         jDAa4mqDljCzCV+juw286oqMc9cbGUuAjdJJgXg2SQlHXWc0kEkWwS5tiRNGSnyr0zCV
         jtgg14Pd558Ggt8moRoTzTBWcT23dyeWanVPi44SqTtWbxY/sZcxICR8d565uUq9kwKI
         nyndLO8uw7jKOdCgJLqRZVh9/OL/H/DfOy3rBOoTbV+qaNDBym4YFmkcKMtVqk5W74mx
         rPHDFOhaiXLKt9EFjTeJLyvlbNtSf+4HxLtm0SnenaWr/o0bqSkStyk7KTNR76TXabSi
         2LrA==
X-Gm-Message-State: AOAM532ffAv0TBgCczvHJkdWyR14oBgLqBUWDPcuVFl/KnCiMFOCrn3/
        eEqaPSx6xo7ovx21oicjVz4=
X-Google-Smtp-Source: ABdhPJzoZPUq2AAXcCDIHR7t8gydOaL3wnFf30sEzAWPXgsPw8amZ1d+SzbJbsy6347cQrlcnZ+FeA==
X-Received: by 2002:a1c:2541:: with SMTP id l62mr1029570wml.1.1631728805195;
        Wed, 15 Sep 2021 11:00:05 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc061e7.dynamic.kabel-deutschland.de. [188.192.97.231])
        by smtp.gmail.com with ESMTPSA id v191sm598726wme.36.2021.09.15.11.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 11:00:04 -0700 (PDT)
Subject: Re: [PATCH v5 1/7] target: core: add common tpg/enable attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
 <20210910084133.17956-2-d.bogdanov@yadro.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <39eadb0e-6f25-6a72-e69d-64d55328f6f7@gmail.com>
Date:   Wed, 15 Sep 2021 20:00:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910084133.17956-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10.09.21 10:41, Dmitry Bogdanov wrote:
> Many fabric modules provide their own implementation of enable
> attribute in tpg.
> The change provides a way to remove code duplication in the fabric
> modules and automatically add "enable" attribute if a fabric module has
> an implementation of fabric_enable_tpg() ops.
> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/target/target_core_configfs.c        |  1 +
>   drivers/target/target_core_fabric_configfs.c | 78 +++++++++++++++++++-
>   include/target/target_core_base.h            |  1 +
>   include/target/target_core_fabric.h          |  1 +
>   4 files changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 102ec644bc8a..3b9e50c1ccef 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -490,6 +490,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
>   			 * fabric driver unload of TFO->module to proceed.
>   			 */
>   			rcu_barrier();
> +			kfree(t->tf_tpg_base_cit.ct_attrs);
>   			kfree(t);
>   			return;
>   		}
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index fc7edc04ee09..0b65de9f2df1 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -815,8 +815,76 @@ static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
>   	.release		= target_fabric_tpg_release,
>   };
>   
> -TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops, NULL);
> +static ssize_t target_fabric_tpg_base_enable_show(struct config_item *item,
> +						  char *page)
> +{
> +	return sysfs_emit(page, "%d\n", to_tpg(item)->enabled);
> +}
> +
> +static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
> +						   const char *page,
> +						   size_t count)
> +{
> +	struct se_portal_group *se_tpg = to_tpg(item);
> +	int ret;
> +	bool op;
> +
> +	ret = strtobool(page, &op);
> +	if (ret)
> +		return ret;
> +
> +	if (se_tpg->enabled == op)
> +		return count;

Sorry for jumping in lately.

Just one nit:
In case someone tries to enable or disable the same tpg a second time,
with the change we always do nothing and return count (--> OK).

I just checked iscsi and qla2xxx. AFAICS iscsi before the patch rejected
the second enable or disable with -EINVAL, while qla2xxx accepts the
second disable and rejects the second enable with -EEXIST.

Of course it sounds good to unify the behavior of existing enable
attributes. OTOH: even if enabling/disabling the same tpg twice can be
seen as suspicious behavior, are we sure to not confuse existing user 
space tools by changing the result?

Bodo


