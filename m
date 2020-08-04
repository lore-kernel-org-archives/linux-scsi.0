Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B18C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 11:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44112070A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 11:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHDLbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 07:31:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:43612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgHDLbc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Aug 2020 07:31:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6590CAC50;
        Tue,  4 Aug 2020 11:31:46 +0000 (UTC)
Date:   Tue, 4 Aug 2020 13:31:30 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio
 controller
Message-ID: <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

[cc Tejun]

On Tue, Aug 04, 2020 at 07:43:01AM +0530, Muneendra wrote:
> This Patch added a unique application identifier i.e
> blkio.app_identifier knob to  blkio controller which
> allows identification of traffic sources at an
> individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.

Is there any specific reason the commit message is formatted in this
way? It looks a bit strange not using a bit more of horizontal space.

> Also provided an interface blkcg_get_app_identifier to
> grab the app identifier associated with a bio.
> 
> Added a sysfs interface blkio.app_identifier to get/set the appid.
> 
> This capability can be utilized by multiple block transport infrastructure
> like fc,iscsi,roce ..
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>  block/blk-cgroup.c         | 32 ++++++++++++++++++++++++++++++++
>  include/linux/blk-cgroup.h | 19 +++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 0ecc897b225c..697eccb3ba7a 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -492,6 +492,33 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
>  	return 0;
>  }
>  
> +static int blkcg_read_appid(struct seq_file *sf, void *v)
> +{
> +	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
> +
> +	seq_printf(sf, "%s\n", blkcg->app_identifier);
> +	return 0;
> +}
> +
> +static ssize_t blkcg_write_appid(struct kernfs_open_file *of,
> +					 char *buf, size_t nbytes, loff_t off)
> +{
> +	struct cgroup_subsys_state *css = of_css(of);
> +	struct blkcg *blkcg = css_to_blkcg(css);
> +	struct blkcg_gq *blkg;
> +	int i;
> +
> +	buf = strstrip(buf);
> +	if (blkcg) {
> +		if (nbytes < APPID_LEN)
> +			strlcpy(blkcg->app_identifier, buf, nbytes);

strstrip() shortens the string but you still copy nbytes. 

> +		else
> +			return -EINVAL;
> +	}
> +	return nbytes;
> +}
> +
> +
>  const char *blkg_dev_name(struct blkcg_gq *blkg)
>  {
>  	/* some drivers (floppy) instantiate a queue w/o disk registered */
> @@ -844,6 +871,11 @@ static struct cftype blkcg_legacy_files[] = {
>  		.name = "reset_stats",
>  		.write_u64 = blkcg_reset_stats,
>  	},
> +	{
> +		.name = "app_identifier",
> +		.write = blkcg_write_appid,
> +		.seq_show = blkcg_read_appid,
> +	},

I am no expert with cgroups. Isn't this just adding it to cgroup v1 only?

>  	{ }	/* terminate */
>  };
>  
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index a57ebe2f00ab..3676d7ebb19f 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -30,6 +30,7 @@
>  
>  /* Max limits for throttle policy */
>  #define THROTL_IOPS_MAX		UINT_MAX
> +#define APPID_LEN		128
>  
>  #ifdef CONFIG_BLK_CGROUP
>  
> @@ -55,6 +56,7 @@ struct blkcg {
>  	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
>  
>  	struct list_head		all_blkcgs_node;
> +	char				app_identifier[APPID_LEN];
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head		cgwb_list;
>  #endif
> @@ -239,6 +241,23 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
>  	return css ? container_of(css, struct blkcg, css) : NULL;
>  }
>  
> +/**
> + * blkcg_get_app_identifier - grab the app identifier associated with a bio
> + * @bio: target bio
> + *
> + * This returns the app identifier associated with a bio,
> + * %NULL if not associated.
> + * Callers are expected to either handle %NULL or know association has been
> + * done prior to calling this.
> + */
> +static inline char *blkcg_get_app_identifier(struct bio *bio)
> +{
> +	if (bio && (bio->bi_blkg) &&
> +			(strlen(bio->bi_blkg->blkcg->app_identifier)))
> +		return bio->bi_blkg->blkcg->app_identifier;

Too many brackets

Thanks,
Daniel
