From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 15:20:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119152036.A13979@infradead.org>
References: <200310231734.10263.krmurthy@cisco.com> <03111920183201.15831@naveenb-lnx.cisco.com> <20031119144809.A13541@infradead.org> <03111920493602.15831@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:36617 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264113AbTKSPUh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 10:20:37 -0500
Content-Disposition: inline
In-Reply-To: <03111920493602.15831@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Wed, Nov 19, 2003 at 08:49:36PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wed, Nov 19, 2003 at 08:49:36PM +0530, Naveen Burmi wrote:
> scsi_scan_host_selected can be used for activating LUNs, selectively.
> But that is the second step.
> First step is to execute the REPORT LUN command without registering a device 
> with scsi mid-layer. That's what we are acheiving through iscsi_do_cmnd .
> Once we know what all luns are available for a target,   
> scsi_scan_host_selected can be used to activate the luns, selectively.

Why do you insist on not using a struct scsi_device?  You acn still free
it if you don't want it. scsi_report_lun is doing all the REPORT_LUNS work
for you, no need to duplicate it.

