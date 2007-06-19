From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 19 Jun 2007 18:12:17 +0100
Message-ID: <20070619171217.GA30099@infradead.org>
References: <200706191025.30986.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47559 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbXFSRMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 13:12:22 -0400
Content-Disposition: inline
In-Reply-To: <200706191025.30986.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, christof.schmitt@de.ibm.com

On Tue, Jun 19, 2007 at 10:25:30AM +0200, Swen Schillig wrote:
> +	unit->scsi_lun = scsilun_to_int((struct scsi_lun *)&unit->fcp_lun);
> +	

fcp_lun is an unsigned long long (and should be a __be64), so casting
this to a struct type is not very nice.  Care to add a version that takes
a __be64 intead?  In fact using that variant in scsi_scan.c might be
benefical aswell, so you could aswell just convert over the existing
scsilun_to_int.
