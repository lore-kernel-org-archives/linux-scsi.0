From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: avoid DMA bounce buffers for ORBs
Date: Fri, 8 Aug 2008 19:54:52 +0200 (CEST)
Message-ID: <tkrat.88534ca0167e536b@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
 <1217877676.3318.32.camel@localhost.localdomain>
 <48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
 <48986B55.80403@s5r6.in-berlin.de> <489871B7.5050904@panasas.com>
 <tkrat.4aaf6794a4dd49c1@s5r6.in-berlin.de>
 <tkrat.6abbce7c47a1f236@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49587 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYHHRzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 13:55:12 -0400
In-Reply-To: <tkrat.6abbce7c47a1f236@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On  8 Aug, Stefan Richter wrote:
> --- linux-2.6.27-rc2.orig/drivers/ieee1394/sbp2.c
> +++ linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
> @@ -531,7 +531,7 @@ static int sbp2util_create_command_orb_p
>  	int i, orbs = sbp2_serialize_io ? 2 : SBP2_MAX_CMDS;
>  
>  	for (i = 0; i < orbs; i++) {
> -		cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +		cmd = kzalloc(sizeof(*cmd), GFP_KERNEL | GFP_DMA32);
>  		if (!cmd)
>  			return -ENOMEM;
>  		cmd->command_orb_dma = dma_map_single(hi->host->device.parent,
> 

This patch is bogus.

I cannot use GFP_DMA32 in slab allocations.
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/

