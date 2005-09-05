From: Christoph Hellwig <hch@infradead.org>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 5 Sep 2005 13:31:49 +0100
Message-ID: <20050905123149.GB15791@infradead.org>
References: <OF2D6CD10B.4BD0B2F3-ONC125706C.0036B5BA-C125706C.0036F30A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43711 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751158AbVIEMby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Sep 2005 08:31:54 -0400
Content-Disposition: inline
In-Reply-To: <OF2D6CD10B.4BD0B2F3-ONC125706C.0036B5BA-C125706C.0036F30A@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On Mon, Aug 29, 2005 at 12:02:15PM +0200, Andreas Herrmann wrote:
> On 29.08.2005 10:48 Christoph Hellwig <hch@infradead.org> worte:
> 
>   > Never use scsi_add_device with the fc_transport code. 
> fc_remote_port_add
>   > will do a proper lun scan if the added rport is a scsi target.
> 
> Won't work for all zSeries FC host adapters because they are
> virtualized and you can have several virtual adapters using the same
> WWPN/WWNN.  Using LUN masking and zoning it is not possible to
> configure the SAN such that one virtual adapter sees just that LUNs
> that are supposed to be used by it. There is a tool to write an access
> control table to the adapter. This ACT specifies which virtual adapter
> can access which ports and FCP LUNs ...

Ugly.

Maybe we could pass down a bitmap of exluded luns down the scanning path?
Starting from fc_rport_create down to scsi_scan_target and the underlying
fuctions?

