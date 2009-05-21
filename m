From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: old-EH and SAS (was Re: [PATCH 2/2] block: add function for waiting
 for a specific free tag)
Date: Thu, 21 May 2009 11:34:04 -0500
Message-ID: <4A15827C.6020705@linux.vnet.ibm.com>
References: <20090520065942.GD11363@kernel.dk> <20090520070104.GF11363@kernel.dk> <4A13EFBC.4010005@gmail.com> <4A145B5D.8020607@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:37677 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZEUQeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 12:34:09 -0400
In-Reply-To: <4A145B5D.8020607@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Brian King did a new-EH conversion for ipr, some time ago.  Maybe that
> work could be picked up, extended to libsas, and permit removal of all
> the old-EH code remaining in libata.

There are a couple different ways to accomplish this, and they relate to
how many scsi hosts we end up using for a single SAS HBA.

Single scsi_host solution
This solution really requires libata to more or less stop using scsi core.
At the very least the concept of it "owning" the scsi host must go away.
Additionally, as far as EH goes, quiescing the entire scsi host each time
we want to do some exception handling for a SATA device kills the performance
of the SAS devices on the HBA, so we would need to have a better layered
EH that only quiesced what needs to be quiesced and then called out to
different pluggable EH handling routines.

Multiple scsi_host solution
This is what my patch to ipr did. It was the path of least resistance at
the time and worked reasonably well for ipr, but may not have been the
best solution for libsas without further enhancements. In this solution,
there is a scsi_host for each ATA port found on the SAS fabric. This
allows most of the existing libata code to simply work with minimal changes.
The biggest issue with this approach is we lose adapter queue depth tracking.
We really would need queue groups or some similar solution in order for this
to work for libsas.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


