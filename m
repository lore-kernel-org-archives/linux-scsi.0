From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 14:48:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119144809.A13541@infradead.org>
References: <200310231734.10263.krmurthy@cisco.com> <20031027153932.A16679@infradead.org> <03111920183201.15831@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:61192 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264110AbTKSOsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 09:48:10 -0500
Content-Disposition: inline
In-Reply-To: <03111920183201.15831@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Wed, Nov 19, 2003 at 08:18:32PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wed, Nov 19, 2003 at 08:18:32PM +0530, Naveen Burmi wrote:
> On Monday 27 October 2003 09:09 pm, Christoph Hellwig wrote:
> 
> > iscsi-probe.c:
> > 	- the whole iscsi_do_cmnd use looks very very strange.  
> 
> After a device gets detected by iSCSI LLD, it uses iscsi_do_cmnd to send scsi 
> commands to that device even before registering it with the scsi mid-layer.
>  
> For example user can configure in iscsi LLD configuration (iscsi.conf) file 
> what various LUNs of a particular target needs to be activated. To acheive 
> this we need to execute REPORT LUN command on target, to find out what 
> various luns are present and selectively issue scsi_add_device for luns that 
> needs to be activated.

Couldn't you just use scsi_scan_host_selected from scsi_scan.c for that
if it was exported?  We already have all that big and perfectly multi-lun
capable probing code in the scsi midlayer and it would be a shame to not
use it.

