From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] zfcp: provide support for NPIV
Date: Thu, 15 Sep 2005 13:26:39 +0100
Message-ID: <20050915122639.GA26916@infradead.org>
References: <20050913195116.GA7699@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15253 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751181AbVIOM0l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:26:41 -0400
Content-Disposition: inline
In-Reply-To: <20050913195116.GA7699@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

On Tue, Sep 13, 2005 at 09:51:16PM +0200, Andreas Herrmann wrote:
> From: Maxim Shchetynin <maxim@de.ibm.com>
> 
> zfcp: provide support for NPIV
> 
> N_Port ID Virtualization (NPIV) allows a single FCP port to appear as
> multiple, distinct ports providing separate port identification. NPIV
> is supported by FC HBAs on System z9. zfcp was adapted to support this
> new feature.

I have a hard time understanding much of the driver and thus this
patch aswell, but it looks like you're adding the luns using scsi_add_device
instead of using the proper midlayer lun scan.

> @@ -68,6 +68,8 @@ ZFCP_DEFINE_ADAPTER_ATTR(s_id, "0x%06x\n
>  ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
>  ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
>  ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
> +ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, "0x%016llx\n", adapter->physical_wwpn);

this information belongs into the transport class, not the driver.
What's the peer information above?  is that for point-to-point FC
connections?

>  ZFCP_DEFINE_ADAPTER_ATTR(fc_link_speed, "%d Gb/s\n", adapter->fc_link_speed);

dito this one belongs only in the transport class.

