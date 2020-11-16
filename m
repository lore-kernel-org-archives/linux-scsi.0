Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389A4C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0A12224F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgKPHbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:31:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:43454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgKPHbq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:31:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 077E6AF2C;
        Mon, 16 Nov 2020 07:31:45 +0000 (UTC)
Subject: Re: [PATCH v4 02/19] blkcg: Added a app identifier support for blkcg
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-3-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1a779905-e1d2-1c3b-1825-7a406e9b5ed6@suse.de>
Date:   Mon, 16 Nov 2020 08:31:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> This Patch added a unique application identifier i.e
> app_id  knob to  blkcg which allows identification of traffic
> sources at an individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.
> 
> Provided the interface blkcg_get_fc_appid to
> grab the app identifier associated with a bio.
> 
> Provided the interface blkcg_set_fc_appid to
> set the app identifier in a blkcgrp associated with cgroup id
> 
> Added a new config BLK_CGROUP_FC_APPID and moved the changes
> under this config
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v4:
> No change
> 
> v3:
> Renamed the functions and app_id to more specific
> 
> Addressed the reference leaks in blkcg_set_app_identifier
> 
> Added a new config BLK_CGROUP_FC_APPID and moved the changes
> under this config
> 
> Added blkcg_get_fc_appid,blkcg_set_fc_appid as inline functions
> 
> v2:
> renamed app_identifier to app_id
> removed the  sysfs interface blkio.app_identifie under
> ---
>   block/Kconfig              |  9 ++++++
>   include/linux/blk-cgroup.h | 65 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index bbad5e8bbffe..ed22df654ce5 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -144,6 +144,15 @@ config BLK_CGROUP_IOLATENCY
>   
>   	Note, this is an experimental interface and could be changed someday.
>   
> +config BLK_CGROUP_FC_APPID
> +	bool "Enable support to track FC io Traffic across cgroup applications"
> +	depends on BLK_CGROUP=y
> +	help
> +	Enabling this option enables the support to track FC io traffic across
> +	cgroup applications.It enables the Fabric and the storage targets to
> +	identify, monitor, and handle FC traffic based on vm tags by inserting
> +	application specific identification into the FC frame.
> +

Please replace 'io' with 'I/O'.

>   config BLK_CGROUP_IOCOST
>   	bool "Enable support for cost model based cgroup IO controller"
>   	depends on BLK_CGROUP=y
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index c8fc9792ac77..00ea1cfa3420 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -30,6 +30,8 @@
>   
>   /* Max limits for throttle policy */
>   #define THROTL_IOPS_MAX		UINT_MAX
> +#define APPID_LEN              128
> +
>   
>   #ifdef CONFIG_BLK_CGROUP
>   
> @@ -55,6 +57,9 @@ struct blkcg {
>   	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
>   
>   	struct list_head		all_blkcgs_node;
> +#ifdef CONFIG_BLK_CGROUP_FC_APPID
> +	char                            fc_app_id[APPID_LEN];
> +#endif
>   #ifdef CONFIG_CGROUP_WRITEBACK
>   	struct list_head		cgwb_list;
>   #endif

If this is an UUID, wouldn't it be better to use 'uuid_t' here?

> @@ -660,4 +665,64 @@ static inline void blk_cgroup_bio_start(struct bio *bio) { }
>   
>   #endif	/* CONFIG_BLOCK */
>   #endif	/* CONFIG_BLK_CGROUP */
> +
> +#ifdef CONFIG_BLK_CGROUP_FC_APPID
> +/*
> + * Sets the fc_app_id field associted to blkcg
> + * @buf: application identifier
> + * @id: cgrp id
> + * @len: size of appid
> + */
> +static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len)
> +{
> +	struct cgroup *cgrp = NULL;
> +	struct cgroup_subsys_state *css = NULL;
> +	struct blkcg *blkcg = NULL;
> +	int ret  = 0;
> +
> +	cgrp = cgroup_get_from_kernfs_id(id);
> +	if (!cgrp)
> +		return -ENOENT;
> +	css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> +	if (!css) {
> +		ret = -ENOENT;
> +		goto out_cgrp_put;
> +	}
> +	blkcg = css_to_blkcg(css);
> +	if (!blkcg) {
> +		ret = -ENOENT;
> +		goto out_put;
> +	}
> +	if (len > APPID_LEN) {
> +		ret = -EINVAL;
> +		goto out_put;
> +	}
> +	strlcpy(blkcg->fc_app_id, buf, len);

String or UUID?
And will it be NULL-terminated?
Wouldn't it be better to use 'memcpy' here?
And it is NULL terminated: what happens if the user sets a 128-byte 
string? IE shouldn't the app_id be 129 bytes long if it's assumed to be 
NULL-terminated?

> +out_put:
> +	css_put(css);
> +out_cgrp_put:
> +	cgroup_put(cgrp);
> +	return ret;
> +}
> +
> +/**
> + * blkcg_get_fc_appid - grab the app identifier associated with a bio
> + * @bio: target bio
> + *
> + * This returns the app identifier associated with a bio,
> + * %NULL if not associated.
> + * Callers are expected to either handle %NULL or know association has been
> + * done prior to calling this.
> + */
> +static inline char *blkcg_get_fc_appid(struct bio *bio)
> +{
> +	if (bio && bio->bi_blkg &&
> +			strlen(bio->bi_blkg->blkcg->fc_app_id))
> +		return bio->bi_blkg->blkcg->fc_app_id;
> +	return NULL;
> +}

Same question as above: Is the string NULL terminated or not?
And if not, how do you specify the length of the 'app_id' variable?

> +#else
> +static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len) { return -EINVAL; }
> +static inline char *blkcg_get_fc_appid(struct bio *bio) { return NULL; }
> +#endif /*CONFIG_BLK_CGROUP_FC_APPID*/
>   #endif	/* _BLK_CGROUP_H */
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
