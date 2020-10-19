Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2128DC433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C26C922363
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603118784;
	bh=6MLPIaz9JPGMQ1lMox1e7+tzPnpfZCmpBfHYVQqDvLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uaqmJ7x5GwPGvX/obtp0n2KbnA9vh6UP5qBwcEaMUkIaB12ZPHtOv4weX2Msng/Z5
	 zQUiOid7ErpJ9ZmW6JKoWKp14UNMORoFrln+UD2/iNGC+rgl1RD3uAcYhySiyxAgCV
	 TdfmjLRK93qLUmZvVqJg1fLCjtSJ70tAAPR0L0WI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgJSOqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 10:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbgJSOqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 10:46:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20727C0613CE;
        Mon, 19 Oct 2020 07:46:22 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p9so374862ilr.1;
        Mon, 19 Oct 2020 07:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jH9tOACmpXUPBysf5MfcJ9Ja6eT9Sj9D2qdGKGGFkek=;
        b=p5kCljRgP6SMV3bkc97b6EXsb0T/kx746J4Pl5Br3bD/TqasJEYFTwCxm5eOi+0kkZ
         adB/R2hTn8nmXjOfUsh93W0122NTWr6/U6O9x9MGWaENG2/lvhurVOnM2t4EUREhCwK6
         f384Q/mhWOKPWbi6pmHTKDIdUNGH8J35PoX25DuFtjUqtBEOfa/VrUOXfe3k9+UNy/iB
         jKDrN/n0qsaE6pUT90ySKYPOmuBW+dnJNu378L3qKDKV7g5ZqNTBaf0o6fSDhHVgjINY
         HtcCumJgzIfZ92l2IgMobM+SOrQMVIJ56LNLUF0eFSHkCsTzrLn5bpeyuRsvXHDj5FNk
         1Edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jH9tOACmpXUPBysf5MfcJ9Ja6eT9Sj9D2qdGKGGFkek=;
        b=tO5sB+BT+w35bN1tm2FIWcnGgFexxtE5aTesxSDjUW0pOo06EQdnlB4URNm+aR3VQU
         XoeeaWtKQcgQrVvGTSjlqVRGCwhg1EFHi21GzxZEFfKkxmufUta/gETQWkVNLBcbKgDN
         9tuQxlI5+trxHmGi+nVrK/aNV3qe3bc0sKKTBRMQK6oy+JkLfJQTxAFVDecgm7M/SINT
         gWswF2wQGl0bsvEfAKf4KczY904a+CvBcsULyX31lgN29PtLec+XROyyrUeflwHQj9TG
         rgjyCAiyI1wsH1BiYRhwH6WJy7drf6k7kJ5zQHLZHa+XnCb6U30xh13CRjRBEih15XhL
         ggrQ==
X-Gm-Message-State: AOAM5330ZJHq/+bnku+lChBR/BPkeDWtx5TlUa9v0RB8pXLAijQK7PxC
        NuXwv5Ixtt3c70Ah3sdpXeqqSUUADU0img==
X-Google-Smtp-Source: ABdhPJx0dk/O5UfJ45rshBk7n2a6r7KpML5v6GQOoxGI9+HwAlhbXAPHpfSEUkgTBUN9/TrFv4seIA==
X-Received: by 2002:a92:98c5:: with SMTP id a66mr272692ill.50.1603118781405;
        Mon, 19 Oct 2020 07:46:21 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:b34d])
        by smtp.gmail.com with ESMTPSA id c9sm11840964iow.1.2020.10.19.07.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 07:46:20 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 19 Oct 2020 10:46:19 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com, pbonzini@redhat.com
Subject: Re: [RFC v2 02/18] blkcg: Added a app identifier support for blkcg
Message-ID: <20201019144619.GC4418@mtj.thefacebook.com>
References: <1603093393-12875-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603093393-12875-3-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603093393-12875-3-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 19, 2020 at 01:12:57PM +0530, Muneendra wrote:
> This Patch added a unique application identifier i.e
> app_id  knob to  blkcg which allows identification of traffic
> sources at an individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.
> 
> Provided the interface blkcg_get_app_identifier to
> grab the app identifier associated with a bio.
> 
> Provided the interface blkcg_set_app_identifier to
> set the app identifier in a blkcgrp associated with cgroup id
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> renamed app_identifier to app_id
> removed the  sysfs interface blkio.app_identifie under
> /sys/fs/cgroup/blkio
> Added a new interface blkcg_set_app_identifier
> ---
>  block/blk-cgroup.c         | 31 +++++++++++++++++++++++++++++++
>  include/linux/blk-cgroup.h | 22 ++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 619a79b51068..672971521010 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -546,6 +546,37 @@ static struct blkcg_gq *blkg_lookup_check(struct blkcg *blkcg,
>  	return __blkg_lookup(blkcg, q, true /* update_hint */);
>  }
>  
> +/*
> + * Sets the app_identifier field associted to blkcg
> + * @buf: application identifier
> + * @id: cgrp id
> + * @len: size of appid
> + */
> +int blkcg_set_app_identifier(char *buf, u64 id, size_t len)

Can you please use a name which is more specific?

> +{
> +	struct cgroup *cgrp = NULL;
> +	struct cgroup_subsys_state *css = NULL;
> +	struct blkcg *blkcg = NULL;
> +
> +	cgrp = cgroup_get_from_kernfs_id(id);
> +	if (!cgrp)
> +		return -ENOENT;
> +
> +	css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> +	if (!css)
> +		return -ENOENT;
> +
> +	blkcg = css_to_blkcg(css);
> +	if (!blkcg)
> +		return -ENOENT;
> +
> +	if (len > APPID_LEN)
> +		return -EINVAL;
> +	strlcpy(blkcg->app_id, buf, len);

Shouldn't the cgrp and css be put before exit?

> +	return 0;
> +}
> +EXPORT_SYMBOL(blkcg_set_app_identifier);
> +
>  /**
>   * blkg_conf_prep - parse and prepare for per-blkg config update
>   * @inputp: input string pointer
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index c8fc9792ac77..5bd3f9f397ac 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -30,6 +30,8 @@
>  
>  /* Max limits for throttle policy */
>  #define THROTL_IOPS_MAX		UINT_MAX
> +#define APPID_LEN              128
> +
>  
>  #ifdef CONFIG_BLK_CGROUP
>  
> @@ -55,6 +57,8 @@ struct blkcg {
>  	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
>  
>  	struct list_head		all_blkcgs_node;
> +	char                            app_id[APPID_LEN];

Please use a more specific name and gate them behind a CONFIG.

Thanks.

-- 
tejun
