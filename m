From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/5] sd: Support disks formatted with DIF Type 2
Date: Fri, 18 Sep 2009 15:57:44 -0600
Message-ID: <1253311064.14224.17.camel@mulgrave.site>
References: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
	 <1253309583-22170-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZIRV5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 17:57:50 -0400
In-Reply-To: <1253309583-22170-5-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-09-18 at 17:33 -0400, Martin K. Petersen wrote:
> Disks formatted with DIF Type 2 reject READ/WRITE 6/10/12/16 commands
> when protection is enabled.  Only the 32-byte variants are supported.
> 
> Implement support for issusing 32-byte READ/WRITE and enable Type 2
> drives in the protection type detection logic.

All looks fine (in all patches [well, except the signed-off-by from doug
should be acked-by]), except this:

> @@ -1108,6 +1149,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
>  		sd_dif_complete(SCpnt, good_bytes);
>  
> +	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
> +	    == SD_DIF_TYPE2_PROTECTION)
> +		mempool_free(SCpnt->cmnd, sd_cdb_pool);
> +
>  	return good_bytes;
>  }

If you look at Christoph's discard patch set, you'll see they come back
through this path in scsi_finish_io(), which would cause a bogus free
for discard on DIF/DIX systems.

I'd really rather this check were tightened to something like

if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd)

So we're totally positive we fiddled with the command pointer before we
free it.

James



