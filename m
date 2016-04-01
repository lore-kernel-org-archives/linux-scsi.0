From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/5] bnx2fc: Print netdev device name when FCoE is
 successfully initialized.
Date: Fri, 01 Apr 2016 15:58:53 +0200
Message-ID: <7007693da84d5e6613ba8c1ed321780b@suse.de>
References: <1459516223-32106-1-git-send-email-chad.dupuis@qlogic.com>
 <1459516223-32106-4-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbcDAN6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 09:58:55 -0400
In-Reply-To: <1459516223-32106-4-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-04-01 15:10, Chad Dupuis wrote:
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index d95eee6..60423cf 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2044,6 +2044,8 @@ static void bnx2fc_ulp_init(struct cnic_dev *dev)
>  		return;
>  	}
> 
> +	pr_err(PFX "FCoE initialized for %s.\n", dev->netdev->name);
> +
>  	/* Add HBA to the adapter list */
>  	mutex_lock(&bnx2fc_dev_lock);
>  	list_add_tail(&hba->list, &adapter_list);

I don't think KERN_ERR is the appropriate log level for this, can you 
change it to pr_info()?
