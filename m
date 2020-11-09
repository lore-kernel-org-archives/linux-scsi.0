Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACD7C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FFF2076E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604930135;
	bh=GeHqDeWzN0NgMShpJMw1r7uKCs2FS/IaxePMYnotcKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MnPszfGO910ZXyZh38DUyMLLyFKlVOGHWF8/43EvhNHpVVdop3IxaKM78AhLBH0V9
	 sbWlCRdpoa748Qffv1z1gLobMwHkobLBIozeSoFH2hq32lASR9l9UXvEY93yEIKgay
	 1tr/BTj/iNKuZmNinn5lK1SmEfcZ5Y1W2K3RO0tQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgKINze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 08:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729974AbgKINzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 08:55:33 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2B9C0613CF;
        Mon,  9 Nov 2020 05:55:33 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id p12so5961846qtp.7;
        Mon, 09 Nov 2020 05:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GMJ4mpfGxerOX0IArSsoe0rUQxIJkHjRxiT6nbHNgbk=;
        b=NfkaFzLo8TyiwTISMf9KmkM1ixinP22m3KHeSu7YytvWhnPsXLSYbMKgNHEsPMp6fC
         vuIiH4OBfgZzvZ1f6Dot66OYsK4vEjvHpqafQ+q6EydZoagUbYtwbkhutxnSlCVGc48G
         7oLOtrwsGQekbHud0HADFBKA/fNwK5it0hQChCVaGa7R/xpB8rQD9pfm6J93R6mzYJpg
         bykijqclyRcE1oAxwvACyH+NyX5cuEOTQ//Yj9uLGD9XNB6UKVYjpKeO/l3REEyWz0rP
         NOYsnHr1Oz9KE2yslCdbxzUWb0/qJrqIl/tRSg/BfMmj7m+/UIXRbPvb2cxJDqaNlq2g
         BmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GMJ4mpfGxerOX0IArSsoe0rUQxIJkHjRxiT6nbHNgbk=;
        b=s0/vVjUZj1BpaeejtR5XpPLLV61Xeh03iBtNv7ZO380Jh4vFv9/TRS1UZhhJdcSLyu
         y8IyY2UlVH3MBFXClhWyMFVLmE5RGgYQpOz5td0NOByqWhjkk8vhNJQR7TuVvrZ3Jv0U
         6eeEQCofzvWFS79xiD5k517P81EAGMkVC1OVp79lNePvtz8YjGH/tOIqHxFlMQHNpLoH
         Otk1YCDayHg7Y8OLcQiyRmfyi2Db4OVYqwUVDy8zX319YzrpVwedrSXNUFzqCV7I4Ved
         Hl2aWSMUL5YrBzSr7TSJPzBNdh+qDOjMaS/v/u3KO36jP0pQOy88BmO2WY9zuPDBD0Wp
         v1WQ==
X-Gm-Message-State: AOAM533vlNlXkJYag/3LEaRTgK6LD+J2jwFP4yMskinz4Ew6XhPLjrKL
        q09XDsO4uELxjj2hsSIHS/0=
X-Google-Smtp-Source: ABdhPJy/utpYjERO98eQpMFyeNQiowofecq1/I3Qc+4nrhWq9ZVxnExma/TCcQS8NSvhAp7xEi+uyA==
X-Received: by 2002:ac8:6608:: with SMTP id c8mr6394223qtp.203.1604930132665;
        Mon, 09 Nov 2020 05:55:32 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:fc2b])
        by smtp.gmail.com with ESMTPSA id o63sm6275514qkd.96.2020.11.09.05.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 05:55:32 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 9 Nov 2020 08:55:19 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH v4 02/19] blkcg: Added a app identifier support for blkcg
Message-ID: <20201109135519.GD7496@mtj.duckdns.org>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-3-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604895845-2587-3-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Again, some nits.

On Mon, Nov 09, 2020 at 09:53:48AM +0530, Muneendra wrote:
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

Please reflow the paragraphs.

> +config BLK_CGROUP_FC_APPID
> +	bool "Enable support to track FC io Traffic across cgroup applications"
> +	depends on BLK_CGROUP=y
> +	help
> +	Enabling this option enables the support to track FC io traffic across
> +	cgroup applications.It enables the Fabric and the storage targets to
                            ^
                            space

> +	identify, monitor, and handle FC traffic based on vm tags by inserting
> +	application specific identification into the FC frame.
...
>  /* Max limits for throttle policy */
>  #define THROTL_IOPS_MAX		UINT_MAX
> +#define APPID_LEN              128

Can you add the FC prefix for the above too?

> +#ifdef CONFIG_BLK_CGROUP_FC_APPID
> +/*

/**

> + * Sets the fc_app_id field associted to blkcg
> + * @buf: application identifier
> + * @id: cgrp id
> + * @len: size of appid
> + */
> +static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len)

I find the arguments really confusing, how about (@cgrp_id, @app_id,
@app_id_len)?

> +{
> +	struct cgroup *cgrp = NULL;
> +	struct cgroup_subsys_state *css = NULL;
> +	struct blkcg *blkcg = NULL;

No need to set these to NULL.

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

css_to_blkcg() can't fail. It's a simple pointer cast.

> +	if (len > APPID_LEN) {
> +		ret = -EINVAL;
> +		goto out_put;
> +	}

This is input validation. Maybe do this at the beginning?

> +	strlcpy(blkcg->fc_app_id, buf, len);
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

Reflow.

> + */
> +static inline char *blkcg_get_fc_appid(struct bio *bio)
> +{
> +	if (bio && bio->bi_blkg &&
> +			strlen(bio->bi_blkg->blkcg->fc_app_id))

You can test fc_app_id[0] against '\0' instead of scanning the whole string.

> +		return bio->bi_blkg->blkcg->fc_app_id;
> +	return NULL;

Thanks.

-- 
tejun
