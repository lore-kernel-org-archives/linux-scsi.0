From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 15:27:37 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031201152737.A3853@infradead.org>
References: <200310231734.10263.krmurthy@cisco.com> <03111920183201.15831@naveenb-lnx.cisco.com> <20031119144809.A13541@infradead.org> <200312011740.09693.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:52494 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262901AbTLAP1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 10:27:40 -0500
Content-Disposition: inline
In-Reply-To: <200312011740.09693.krmurthy@cisco.com>; from krmurthy@cisco.com on Mon, Dec 01, 2003 at 05:40:09PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

On Mon, Dec 01, 2003 at 05:40:09PM +0530, Krishna Murthy wrote:
> scsi_scan_host_selected is exported. 
> 
> 	iscsi driver does probe for devices at two places
> a)Once after session establishment.
> b)Whenever an iSCSI async message indicates a change in
> "REPORTED LUNS DATA". (addition/deletion of luns on the target) 
> 
> 	There are no issues in calling scsi_scan_host_selected() at a).
> 	Addition of luns could be handled by calling scsi_scan_host_selected 
> with rescan parameter set to 1.
> 	Deletion of luns is not handled. scsi_scan_target does not worry about 
> devices which were previously configured, but currently not available.Would 
> you recommend handling this in scsi_scan_target (or a new API) or handle in 
> iSCSI using scsi_request based interfaces?

Case b) could easily use scsi_add_device/scsi_remove_device, couldn't it?

