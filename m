From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic94xx: Skip reading user settings if flash is not
 found
Date: Wed, 26 Aug 2015 07:14:16 -0700
Message-ID: <1440598456.2196.7.camel@HansenPartnership.com>
References: <1436180878-81565-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48257 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbbHZOOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 10:14:18 -0400
In-Reply-To: <1436180878-81565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, 2015-07-06 at 13:07 +0200, Hannes Reinecke wrote:
> If no user settings are found it's pointless trying to
> read them from flash. So skip that step.
> This also fixes a compilation warning about uninitialized variables in
> aic94xx.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

This patch looks fine to me but needs a second review, please.

James

>  drivers/scsi/aic94xx/aic94xx_sds.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
> index edb43fd..c831e30 100644
> --- a/drivers/scsi/aic94xx/aic94xx_sds.c
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c
> @@ -983,7 +983,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
>  {
>  	int err, i;
>  	u32 offs, size;
> -	struct asd_ll_el *el;
> +	struct asd_ll_el *el = NULL;
>  	struct asd_ctrla_phy_settings *ps;
>  	struct asd_ctrla_phy_settings dflt_ps;
>  
> @@ -1004,6 +1004,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
>  
>  		size = sizeof(struct asd_ctrla_phy_settings);
>  		ps = &dflt_ps;
> +		goto out_process;
>  	}
>  
>  	if (size == 0)
> @@ -1028,7 +1029,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
>  		ASD_DPRINTK("couldn't find ctrla phy settings struct\n");
>  		goto out2;
>  	}
> -
> +out_process:
>  	err = asd_process_ctrla_phy_settings(asd_ha, ps);
>  	if (err) {
>  		ASD_DPRINTK("couldn't process ctrla phy settings\n");



