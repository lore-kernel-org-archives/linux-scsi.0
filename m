Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA2BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 11:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355386AbiCPLjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 07:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiCPLji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 07:39:38 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F5C37BDA
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 04:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647430704; x=1678966704;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CA7ohyySipfkOmxuHDSFEb5ZzJ4yO/s6nSLzC1xdF0A=;
  b=Uhrsg2ZOyC9gHyCvQsjMT2fDn8n6GCZuHRVB/VtWiIpXmR+abA7jjGYc
   T9oVqIOqJ0gnFqbf30RYIhA5JAiViEi2YmCAPN3bsz9FHudgXGUx1bYjP
   G9Acd8Wb7trSjmW1ZAdLsNsbONf+TYlK0x0RQMNvwl6MK9BgZGi9ovq0p
   H9gxAzf7b1R0pJSA38wnrh11DzrWCOERlF+LM2Trkh/aiBeuC4KpmcwQM
   hY6j2GKyCW4KXiJoEpZWLFLFF5Oo0PolT6jh5/1IpFkMtCKXMEGpOA4Nu
   qQEnzzLIWp1UeuzhGMdqzPIObsLXCVEsjW/TInRNrj1C7cgrQEK8r/GPj
   A==;
X-IronPort-AV: E=Sophos;i="5.90,186,1643644800"; 
   d="scan'208";a="194417919"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2022 19:38:23 +0800
IronPort-SDR: lPZ6cp6ZzGf1Tj5KvPj0UosFGhNEceukPIcjYXXl85FK4OOvU+Br+aHU2T0Qvnt0fpv+dGwZqS
 c/WXlXePb/YuVQIoSQYKd4iQpSAiZPSQblbs57HMYDBoccWnmEqFcgBBAL4Vyk5hj8R/mRldUZ
 nqkusgRjsxNcD4vDeCdgRUY+nvtbBAfNnBizVok7xJVs13tfxk58G3oYnj5l2/kyE4ZAaAc0ff
 fgk7gnhwnsmNIjSsXVx/+KSo0iW9sirLQf+CJPOiLKkrgKcFQBMgpohyIVlRzpeaQ53mAREtL1
 yAiCi37K9XGgjGMu4kzFNGY7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 04:09:30 -0700
IronPort-SDR: 1NPRj8HEHSrGiSF7s3Bjh1Q8/uVpD19UH0x2iIQvSJY4WBu4sRcVV2aL8UNXCPDw3tqcGf/Zwx
 Vj4IBUcNjtBDZPpLHmne/am0pna7GD76+vS4cWUPCziMqdxnTSYbgpKMY28iyw2dXyW7KBbKMh
 /XxqSkxzCUkC+StTjlzSKqyfNRyquZZHe7MIkWmOWu5kBLXPtCfSXb94nKj4R2fkbVrlyMZEL4
 GjF1kFFaVfPJWXrXFGFmCX2pmuFAn9A+mGN4cYKS4JaljrbTsqXIOwWGhNQhfEw07uIxBylpWa
 nzg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 04:38:24 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KJSvg22Gwz1SVnx
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 04:38:23 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1647430702; x=1650022703; bh=CA7ohyySipfkOmxuHDSFEb5ZzJ4yO/s6nSL
        zC1xdF0A=; b=qTUcGQpmuiedPgvfI2epiNTd4Vxd8yFRi0U/caaeTz+sc3CulvZ
        vY7MZJIkeu4A8zd2P9eys+5PZ9B1pyoLep6CGZTEkUSwc0+voujqiFmnVN5lkmrz
        zBk3hk/1RIJKfcpxUimlJax3vmBEiOUoqxwCxNbEgtsobBLQgp237WWutb+0lnfu
        bR1knAHJwhEGLIYFDEW/a9XVtgdMgYYak4i/EtiWX80DWtx4K6Uc7g1XoUKxrfV+
        vwq16noUTf1ZUuKE3lnaYhSzTIhgtB9GEHyxph9WqsU1JAAN0oSEJk7l29Kybj2E
        8JKy8MAkhZAZ2MLKNJFsFLEaUT2Qp0X9xdg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ELhNvi6s6VF1 for <linux-scsi@vger.kernel.org>;
        Wed, 16 Mar 2022 04:38:22 -0700 (PDT)
Received: from [10.225.163.101] (unknown [10.225.163.101])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KJSvc3tj9z1Rvlx;
        Wed, 16 Mar 2022 04:38:20 -0700 (PDT)
Message-ID: <9768fa36-27ed-834f-0462-3b79fd8b3478@opensource.wdc.com>
Date:   Wed, 16 Mar 2022 20:38:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v2] scsi: core: Fix sbitmap depth in
 scsi_realloc_sdev_budget_map()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        bvanassche@acm.org, martin.wilck@suse.com, ming.lei@redhat.com,
        hch@lst.de, hare@suse.de
References: <1647423870-143867-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1647423870-143867-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/22 18:44, John Garry wrote:
> In commit edb854a3680b ("scsi: core: Reallocate device's budget map on
> queue depth change"), the sbitmap for the device budget map may be
> reallocated after the slave device depth is configured.
> 
> When the sbitmap is reallocated we use the result from
> scsi_device_max_queue_depth() for the sbitmap size, but don't resize to
> match the actual device queue depth.
> 
> Fix by resizing the sbitmap after reallocating the budget sbitmap. We do
> this instead of init'ing the sbitmap to the device queue depth as the user
> may want to change the queue depth later via sysfs or other.
> 
> Fixes: edb854a3680b ("scsi: core: Reallocate device's budget map on queue depth change")
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> ---
> Changes since v1 (apart from sending as a separate patch):
> - Add fixes and RB tag (thanks)
> - mention in commit message why we don't init sbitmap at queue depth
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f4e6c68ac99e..2ef78083f1ef 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -223,6 +223,8 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  	int ret;
>  	struct sbitmap sb_backup;
>  
> +	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
> +
>  	/*
>  	 * realloc if new shift is calculated, which is caused by setting
>  	 * up one new default queue depth after calling ->slave_configure
> @@ -245,6 +247,9 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  				scsi_device_max_queue_depth(sdev),
>  				new_shift, GFP_KERNEL,
>  				sdev->request_queue->node, false, true);
> +	if (!ret)
> +		sbitmap_resize(&sdev->budget_map, depth);
> +
>  	if (need_free) {
>  		if (ret)
>  			sdev->budget_map = sb_backup;

Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
