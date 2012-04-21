From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [isci PATCH v3 1/4] libata: export ata_port suspend/resume infrastructure
 for sas
Date: Sat, 21 Apr 2012 02:26:04 -0400
Message-ID: <4F9252FC.9020706@garzik.org>
References: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com> <20120314071353.7223.5361.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36655 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2DUG0H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2012 02:26:07 -0400
In-Reply-To: <20120314071353.7223.5361.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

On 03/14/2012 03:13 AM, Dan Williams wrote:
> Reuse ata_port_{suspend|resume}_common for sas.  This path is chosen
> over adding coordination between ata-tranport and sas-transport because
> libsas wants to revalidate the domain at resume-time at the host level.
> It can not validate links have resumed properly until libata has had a
> chance to perform its revalidation, and any sane placing of an ata_port
> in the sas-transport model would delay it's resumption until after the
> host.
>
> Export the common portion of port suspend/resume (bypass pm_runtime),
> and allow sas to perform these operations asynchronously (similar to the
> libsas async-ata probe implmentation).  Async operation is determined by
> having an external, rather than stack based, location for storing the
> result of the operation.
>
> Reviewed-by: Jacek Danecki<jacek.danecki@intel.com>
> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/ata/libata-core.c |   58 ++++++++++++++++++++++++++++++++++++---------
>   include/linux/libata.h    |   11 +++++++++
>   2 files changed, 57 insertions(+), 12 deletions(-)

Now that libata's runtime PM problems seem to be fixed for the moment, 
we can revisit port PM here.  Just checking...  Is this patch still needed?



