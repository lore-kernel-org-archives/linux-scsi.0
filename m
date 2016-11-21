From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Mon, 21 Nov 2016 15:13:36 +0100
Message-ID: <20161121141336.gkc35pjmlojhxm35@linux-x5ow.site>
References: <20161121140429.12788-1-mwilck@suse.de>
 <20161121140429.12788-2-mwilck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37659 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752889AbcKUONj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 09:13:39 -0500
Content-Disposition: inline
In-Reply-To: <20161121140429.12788-2-mwilck@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.de>
Cc: don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de

On Mon, Nov 21, 2016 at 03:04:28PM +0100, Martin Wilck wrote:
> When the hpsa module is unloaded using rmmod, dangling
> symlinks remain under /sys/class/sas_phy. Fix this by
> calling sas_phy_delete() rather than sas_phy_free (which,
> according to comments, should not be called for PHYs that
> have been set up successfully, anyway).
> 
> References: bsc#1010946.

I don't think the SUSE bugzilla tag is of relevance upstream. But for sake of
completeness we could add a 
Link: https://bugzilla.suse.com/show_bug.cgi?id=1010946

> Signed-off-by: Martin Wilck <mwilck@suse.de>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index efe2f36..8ec77c3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -9547,9 +9547,9 @@ static void hpsa_free_sas_phy(struct hpsa_sas_phy *hpsa_sas_phy)
>  	struct sas_phy *phy = hpsa_sas_phy->phy;
>  
>  	sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
> -	sas_phy_free(phy);
>  	if (hpsa_sas_phy->added_to_port)
>  		list_del(&hpsa_sas_phy->phy_list_entry);
> +	sas_phy_delete(phy);
>  	kfree(hpsa_sas_phy);
>  }
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
