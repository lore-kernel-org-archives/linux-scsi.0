From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Sat, 1 Jan 2011 10:08:54 -0700
Message-ID: <20110101170854.GB32652@parisc-linux.org>
References: <4D1F5A17.4010807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55991 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1AARI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jan 2011 12:08:56 -0500
Content-Disposition: inline
In-Reply-To: <4D1F5A17.4010807@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Cc: nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Sat, Jan 01, 2011 at 05:45:11PM +0100, roel kluin wrote:
> The WRITE_{6,10,12} are defined numbers, so the branch was always taken.

You're right, but even this will basically always set the write flag,
since some bits will be set the same, even for reads.  Eg:

#define READ_10               0x28
#define WRITE_10              0x2a

It should instead be:

> +	if (pcmd->cmnd[0] == WRITE_6 || pcmd->cmnd[0] == WRITE_10 ||
> +			pcmd->cmnd[0] == WRITE_12 ){

That will of course miss other commands which do writes, such as UNMAP
and WRITE_32.  So we should do it properly:

	if (pcmd->sc_data_direction == DMA_TO_DEVICE)
		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;

I don't have an Areca card to test with.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> See include/scsi/scsi.h:58-123 for
> #define WRITE_6               0x0a
> #define WRITE_10              0x2a
> #define WRITE_12              0xaa
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 17e3df4..a6e5222 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -1171,7 +1171,8 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
>  	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
>  	if ( arccdbsize > 256)
>  		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
> -	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
> +	if (pcmd->cmnd[0] & WRITE_6 || pcmd->cmnd[0] & WRITE_10 ||
> +			pcmd->cmnd[0] & WRITE_12 ){
>  		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
>  	}
>  	ccb->arc_cdb_size = arccdbsize;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
