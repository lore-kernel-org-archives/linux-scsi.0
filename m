From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 10:46:03 +0000
Message-ID: <20041118104603.GA21289@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F27B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:46855 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262723AbUKRKqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 05:46:07 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F27B@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 17, 2004 at 02:03:01PM -0500, James.Smart@Emulex.Com wrote:
> This patch contains the following 2 modifications:
> 
> - Allows scsi_scan_host() to be called at times other than just first attachment.

I'm not too happy about that, and we had that discussion already when
discussing the aacraid dynamic container addition / removal. 

> - Provides a new interface to scan a single target entity.
> 
> This allows our LLDD to automatically detect new device additions after a cable/fabric change, or upon insertion of a new FC device.
> 
> Note: We opted for a "scan target" interface as, on large configurations, scanning everything on the link via scsi_scan_host() was overkill.
> 

>  	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> -				SCAN_WILD_CARD, 0);
> +				SCAN_WILD_CARD, shost->rescan);
> +	shost->rescan=1;

this is missing whitespaces.  Also ->rescan is not used anywhere.

