From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] advansys: use shared host tag map for command
	lookup
Date: Thu, 4 Dec 2014 10:20:43 +0100
Message-ID: <20141204092043.GD23891@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57375 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaLDJUq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:20:46 -0500
Content-Disposition: inline
In-Reply-To: <1417607105-85455-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

>  typedef struct asc_scsiq_2 {
> -	ASC_VADDR srb_ptr;
> +	__le32 srb_tag;

Given that the tag has no meaning for the hardware why do you
want to endian switch it?  Keeping the ASC_VADDR for now makes
it easier to verify the hardware structures don't change.

> @@ -6132,6 +6077,13 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
>  		AdvResetChipAndSB(adv_dvc_varp);
>  		break;
>  
> +	case ADV_ASYNC_CARRIER_READY_FAILURE:
> +		/*
> +		 * Carrier not ready; abort the command.
> +		 */
> +		ASC_DBG(0, "ADV_ASYNC_CARRIER_READY_FAILURE\n");
> +		break;
> +

Where does this one come from?

