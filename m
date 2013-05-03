From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] scsi: ufs: add support for query requests
Date: Fri, 03 May 2013 11:31:40 -0700
Message-ID: <1367605900.5981.47.camel@dabdike>
References: <1367495736-8927-1-git-send-email-santoshsy@gmail.com>
	 <1367495736-8927-4-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55648 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934023Ab3ECSbm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 14:31:42 -0400
In-Reply-To: <1367495736-8927-4-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Dolev Raviv <draviv@codeaurora.org>

On Thu, 2013-05-02 at 17:25 +0530, Santosh Y wrote:
> From: Dolev Raviv <draviv@codeaurora.org>
> 
> Add support for sending UFS query requests through tagged command
> queuing. This design allows queuing query requests in any open slot
> along with other SCSI commands. In this way there is no need to
> save a slot in the requests queue and decrease its size.
> 
> A query request is posing to a SCSI command to use native flow. But
> unlike normal SCSI command flow, the data and response fields are
> filled in UFS host data structure instead of passing as arguments
> while queuing into SCSI mlqueue (mid-layer SCSI queue, the requests
> from this queue are submitted to the device queue). As per specification
> only one query request is allowed to be processed by device. Hence a
> mutex lock for protecting data and response fields (hba->query.request and
> hba->query.response) needs to be held while query request is in
> progress.
> 
> The API for submitting a query request is ufs_query_request() in
> ufshcd.c. This function is responsible for:
> 1. Obtaining the SCSI device from the host
> 2. Keeping the query mutex to prevent multiple queries
> 3. Storing the required data for sending a query request in ufs_hba
> 4. Queuing a SCSI vendor specific command to trigger a query request
>    in the UFS driver.
> 
> The callers of ufs_query_request() are expected to fill the query
> command data fields and are to provide an allocated response field
> for the driver to fill response fields after request completion.
> 
> The request and response upiu is extended in a union to enable using the
> same data structure, both for command upiu and query request upiu.
> 
> The query request flow is separated from the scsi command flow in:
> 1. Preparing the request
> 2. Validating response (error) codes
> 3. Copying data (only used for descriptor read/write query requests)
> 4. Copying response/sense
> 
> Data error can't be handled in the scsi command native flow. Hence,
> we pass the code as without a change back to the submitting layer.
> 
> UPIU (UFS Protocol Information Unit) size is increased to 512 bytes
> from 128. The UPIU header and the transaction specific fields (SCSI
> command or Query Request OSF - Op-code Specific Fields) are 32 bytes
> together, the rest is used to transfer extra request data (such as
> descriptor in query requests). In order to accommodate the largest
> descriptor in the UFS spec (256 bytes) we need to increase the UPIU
> size.
> 
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Santosh Y <santoshsy@gmail.com>
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 35faf24..82417d6 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -35,6 +35,7 @@
>  config SCSI_UFSHCD
>  	tristate "Universal Flash Storage Controller Driver Core"
>  	depends on SCSI
> +	default y
>  	---help---
>  	This selects the support for UFS devices in Linux, say Y and make
>  	  sure that you know the name of your UFS host adapter (the card

I don't think you want to force this on in every configuration since
it's only appropriate to non server/desktop.  I stripped this hunk.

James


