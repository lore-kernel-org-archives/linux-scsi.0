From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 01/22] libfc: Revisit kref handling
Date: Thu, 18 Aug 2016 10:43:50 -0400
Message-ID: <alpine.OSX.2.00.1608181039030.529@administrators-macbook-pro.local>
References: <1470230002-37737-1-git-send-email-hare@suse.de> <1470230002-37737-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0136.outbound.protection.outlook.com ([104.47.38.136]:49950
	"EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767811AbcHROpx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2016 10:45:53 -0400
In-Reply-To: <1470230002-37737-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>, Chad Dupuis <chad.dupuis@qlogic.com>



On Wed, 3 Aug 2016, 1:13pm -0000, Hannes Reinecke wrote:

> The kref handling in fc_rport is a mess. This patch updates
> the kref handling according to the following rules:
> 
> - Take a reference whenever scheduling a workqueue
> - Take a reference whenever an ELS command is send
> - Drop the reference at the end of the workqueue function
> - Drop the reference at the end of handling ELS replies
> - Take a reference when allocating an rport
> - Drop the reference when removing an rport
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/libfc/fc_rport.c | 134 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 103 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> index 93f5961..6a98bb8 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -44,6 +44,17 @@
>   * path this potential over-use of the mutex is acceptable.
>   */
>  

<-- snip -->

Yes, this took quite a few iterations to get right but your rules make 
sense.  I've tested with this patch and it successfully passed.

Tested-by: Chad Dupuis <chad.dupuis@qlogic.com>
