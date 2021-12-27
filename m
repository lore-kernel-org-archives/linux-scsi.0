Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7DEC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Dec 2021 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhL0RZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Dec 2021 12:25:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56012 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhL0RZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2021 12:25:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 512EF6112A
        for <linux-scsi@vger.kernel.org>; Mon, 27 Dec 2021 17:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B7CC36AEA;
        Mon, 27 Dec 2021 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640625946;
        bh=4iN0FX8tYwraxgWoiYyflN/g98ltq7WczqWNu5oyKd0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0EhTraDUbeLoBrW4ulhg4TvAwZTTzr9VpOv4YMxV+PeowlT4dF8F5uLNgcnYM848
         +2pY6CuIDMaWldtU7vGVA4Gl1h5Ic5JatadG54qnJoTRx6TN0d5m5Qn59I6SzwHTws
         wdF2jAdjimCduCMZ4eJt55OF/Z4rSf3063HSYXC2VcCELymdH9yBoMG8K9DdIZzc4l
         Jx9Hlt28HREPJAjhQz6xPEQrNOP7u/dl8z10kcHaiYDXXR04FgdLkNGHxO3bqTft+f
         3QkioQ+/j007s0RRQXLANEkx0LpMy+wx3V82iTnN9BYTGqUpO1No5y0p/LvJK79Dve
         8nHdii/ZP4zyg==
Date:   Mon, 27 Dec 2021 10:25:42 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        john.garry@huawei.com, llvm@lists.linux.dev
Subject: Re: [PATCH v2 05/15] scsi: hisi_sas: Fix some issues related to
 asd_sas_port->phy_list
Message-ID: <Ycn3FoW9eOZNFMiL@archlinux-ax161>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
 <1639999298-244569-6-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639999298-244569-6-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Xiang,

On Mon, Dec 20, 2021 at 07:21:28PM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> Most places that use asd_sas_port->phy_list are protected by spinlock
> asd_sas_port->phy_list_lock, but there are some places which lack of it
> in hisi_sas driver, so add it in function hisi_sas_refresh_port_id() when
> accessing asd_sas_port->phy_list. But it has a risk that list mutates while
> dropping the lock at the same time in function
> hisi_sas_send_ata_reset_each_phy(), so read asd_sas_port->phy_mask
> instead of accessing asd_sas_port->phy_list to avoid the risk.
> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Acked-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index ad64ccd41420..051092e294f7 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1428,11 +1428,13 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
>  		sas_port = device->port;
>  		port = to_hisi_sas_port(sas_port);
>  
> +		spin_lock(&sas_port->phy_list_lock);
>  		list_for_each_entry(sas_phy, &sas_port->phy_list, port_phy_el)
>  			if (state & BIT(sas_phy->id)) {
>  				phy = sas_phy->lldd_phy;
>  				break;
>  			}
> +		spin_unlock(&sas_port->phy_list_lock);
>  
>  		if (phy) {
>  			port->id = phy->port_id;
> @@ -1509,22 +1511,25 @@ static void hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
>  	struct ata_link *link;
>  	u8 fis[20] = {0};
>  	u32 state;
> +	int i;
>  
>  	state = hisi_hba->hw->get_phys_state(hisi_hba);
> -	list_for_each_entry(sas_phy, &sas_port->phy_list, port_phy_el) {
> +	for (i = 0; i < hisi_hba->n_phy; i++) {
>  		if (!(state & BIT(sas_phy->id)))
>  			continue;
> +		if (!(sas_port->phy_mask & BIT(i)))
> +			continue;
>  
>  		ata_for_each_link(link, ap, EDGE) {
>  			int pmp = sata_srst_pmp(link);
>  
> -			tmf_task.phy_id = sas_phy->id;
> +			tmf_task.phy_id = i;
>  			hisi_sas_fill_ata_reset_cmd(link->device, 1, pmp, fis);
>  			rc = hisi_sas_exec_internal_tmf_task(device, fis, s,
>  							     &tmf_task);
>  			if (rc != TMF_RESP_FUNC_COMPLETE) {
>  				dev_err(dev, "phy%d ata reset failed rc=%d\n",
> -					sas_phy->id, rc);
> +					i, rc);
>  				break;
>  			}
>  		}
> -- 
> 2.33.0
> 
> 

Please ignore this if it was already reported, I do not see any reports
of it on lore.kernel.org nor a commit fixing it in Martin's tree.

This commit as commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues
related to asd_sas_port->phy_list") in -next causes the following clang
warning, which will break the build under -Werror:

drivers/scsi/hisi_sas/hisi_sas_main.c:1536:21: error: variable 'sas_phy' is uninitialized when used here [-Werror,-Wuninitialized]
                if (!(state & BIT(sas_phy->id)))
                                  ^~~~~~~
./include/vdso/bits.h:7:30: note: expanded from macro 'BIT'
#define BIT(nr)                 (UL(1) << (nr))
                                           ^~
drivers/scsi/hisi_sas/hisi_sas_main.c:1528:29: note: initialize the variable 'sas_phy' to silence this warning
        struct asd_sas_phy *sas_phy;
                                   ^
                                    = NULL
1 error generated.

It seems like this variable is entirely unused now, should it be removed
along with this check?

Cheers,
Nathan
