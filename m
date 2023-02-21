Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC38DC6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 07:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjBUH2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 02:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBUH2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 02:28:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C83B23678;
        Mon, 20 Feb 2023 23:28:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE42160F97;
        Tue, 21 Feb 2023 07:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC9AC433D2;
        Tue, 21 Feb 2023 07:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676964512;
        bh=yrEXHlD+OGvdKZR47aQcY+a66pmfUFJm1C18b22BmkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pzq2UwLbV8oJcbduSvS38Q+3wATyxt1VIUgplYDzUNqQXXGRstOt80Khkd122WQPM
         l4c985Od9zzW8xxGcWGhxG0SXqionhv68Ig5RYURlyo2c9IumK7ZeSBu0EjlXZjH8l
         w3DXaIcGjFNcoNmE2z15twbFO7iYpjyAjheG7ZnY/0bEAevnDVw7oRD5H3NeLXY7WM
         zPHyHkvTbf5F4aXB0V0TtGnkDZ438ZTOLaDIgkkS+fyz35J8knc1NVM+JRJ5aXhjxD
         eA9boBX2iehs+wL7Oi7cuC6Exd0rKZK/fcTxXJZu9zxbcI1OgyF5KJAn3V+qTyMzCe
         ySh7RPbMuc9Fw==
Date:   Tue, 21 Feb 2023 12:58:22 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     jejb@linux.ibm.com, artin.petersen@oracle.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        beanhuo@micron.com, bvanassche@acm.org, avri.altman@wdc.com,
        yoshihiro.shimoda.uh@renesas.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, zhangshida@kylinos.cn,
        k2ci <kernel-bot@kylinos.cn>
Subject: Re: [PATCH v2] scsi: ufs: Guard the ufs_mtk_runtime_suspend and
 ufs_mtk_runtime_resume with CONFIG_PM
Message-ID: <20230221072822.GA99958@thinkpad>
References: <20230221025055.1031342-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230221025055.1031342-1-zhangshida@kylinos.cn>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 21, 2023 at 10:50:55AM +0800, Stephen Zhang wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 

Subject could be fixed as:

"scsi: ufs: mediatek: Guard runtime PM functions"

> In a configuration with CONFIG_SCSI_UFS_MEDIATEK set to 'm' and
> CONFIG_PM set to 'n', errors occur at compile time:
> 
> ====
> ../drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_runtime_suspend’:
> ../drivers/ufs/host/ufs-mediatek.c:1621:8: error: implicit declaration of function ‘ufshcd_runtime_suspend’; did you mean ‘ufs_mtk_runtime_suspend’? [-Werror=implicit-function-declaration]
> ../drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_runtime_resume’:
> ../drivers/ufs/host/ufs-mediatek.c:1636:9: error: implicit declaration of function ‘ufshcd_runtime_resume’; did you mean ‘ufs_mtk_runtime_resume’? [-Werror=implicit-function-declaration]
> ====
> 
> This patch fixes these by guarding these functions with CONFIG_PM.
> 

Remove reference to "patch" in the commit message as it will be meaningless
once merged. The line could be reworded as,

"Fix these errors by guarding the runtime PM functions with CONFIG_PM"

> Reported-by: k2ci <kernel-bot@kylinos.cn>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>

With the changes,

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
> Changes in v2:
>   Guarding these functions with CONFIG_PM instead of selecting the config.
> 
>  drivers/ufs/host/ufs-mediatek.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 21d9b047539f..73e217260390 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1613,6 +1613,7 @@ static int ufs_mtk_system_resume(struct device *dev)
>  }
>  #endif
>  
> +#ifdef CONFIG_PM
>  static int ufs_mtk_runtime_suspend(struct device *dev)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> @@ -1635,6 +1636,7 @@ static int ufs_mtk_runtime_resume(struct device *dev)
>  
>  	return ufshcd_runtime_resume(dev);
>  }
> +#endif
>  
>  static const struct dev_pm_ops ufs_mtk_pm_ops = {
>  	SET_SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend,
> -- 
> 2.27.0
> 

-- 
மணிவண்ணன் சதாசிவம்
