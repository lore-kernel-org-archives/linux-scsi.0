From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] scsi: ILLEGAL REQUEST + ASC==27 => target failure
Date: Wed, 27 Sep 2017 09:11:38 -0700
Message-ID: <fe2e2c69-68d5-6f9c-c4e4-2b03f4dc8556@suse.com>
References: <20170927124419.23637-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750799AbdI0QLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 12:11:43 -0400
In-Reply-To: <20170927124419.23637-1-mwilck@suse.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.de>

On 09/27/2017 05:44 AM, Martin Wilck wrote:
> ASC 0x27 is "WRITE PROTECTED". This error code is returned e.g.
> by Fujitsu ETERNUS systems under certain conditions for
> WRITE SAME 16 commands with UNMAP bit set. It should not be
> treated as a path error. In general, it makes sense to assume
> that being write protected is a target rather than a path
> property.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/scsi_error.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 38942050b265..dab876c65473 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -580,7 +580,8 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>  		if (sshdr.asc == 0x20 || /* Invalid command operation code */
>  		    sshdr.asc == 0x21 || /* Logical block address out of range */
>  		    sshdr.asc == 0x24 || /* Invalid field in cdb */
> -		    sshdr.asc == 0x26) { /* Parameter value invalid */
> +		    sshdr.asc == 0x26 || /* Parameter value invalid */
> +		    sshdr.asc == 0x27) { /* Write protected */
>  			set_host_byte(scmd, DID_TARGET_FAILURE);
>  		}
>  		return SUCCESS;
> 

Looks good to me.

Acked-by: Lee Duncan <lduncan@suse.com>

-- 
Lee-Man
