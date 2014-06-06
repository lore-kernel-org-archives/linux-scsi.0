From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mpt3sas: delay scsi_add_host call to work with scsi-mq
Date: Fri, 6 Jun 2014 00:13:56 -0700
Message-ID: <20140606071356.GA29477@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958B051A0@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaFFHOA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 03:14:00 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B051A0@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "Nagalakshmi.Nandigama@lsi.com" <Nagalakshmi.Nandigama@lsi.com>, "Sreekanth.Reddy@lsi.com" <Sreekanth.Reddy@lsi.com>, Adam Radford <adam.radford@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Joe Maloy <joe.maloy@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jun 06, 2014 at 01:03:41AM +0000, Elliott, Robert (Server Storage) wrote:
> In _scsih_probe, delay the call to scsi_add_host until
> the host template has been completely filled in.

Beside scsi-mq not picking up the queue depth callng scsi_add_host
on a not fully setup host also is dangerous because scsi_add_host sets
the host life and it can now see userspace LUN scans or removals, so the
fix is needed either.

The late scsi_remove_host also fixed by your patch is just as dangerous.

Given the copy and paste nature of the two driver I suspect mpt2sas will
need the same fix.

> +	if ((scsi_add_host(shost, &pdev->dev))) {
> +		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> +		    ioc->name, __FILE__, __LINE__, __func__);
> +		goto out_add_shost_fail;
> +	}
> +
>  	scsi_scan_host(shost);

No need to fix this now, but discarding the error return from
scsi_add_host is a bad idea, the function should eventually switch to
having an int error variable for it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
