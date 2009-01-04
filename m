From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 4 of 4] sd: Correctly handle 6-byte commands with DIX
Date: Sun, 4 Jan 2009 06:28:55 -0700
Message-ID: <20090104132855.GC2002@parisc-linux.org>
References: <patchbomb.1231056270@sermon.lab.mkp.net> <8676e77c49d4bc933338.1231056274@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57837 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZADN3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 08:29:14 -0500
Content-Disposition: inline
In-Reply-To: <8676e77c49d4bc933338.1231056274@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, Jan 04, 2009 at 03:04:34AM -0500, Martin K. Petersen wrote:
> @@ -374,7 +374,10 @@ void sd_dif_op(struct scsi_cmnd *scmd, u
>  	else
>  		csum_convert = 0;
>  
> +	BUG_ON(dif && (scmd->cmnd[0] == READ_6 || scmd->cmnd[0] == WRITE_6));

This BUG_ON gave me a 'Huh?' moment.  I immediately wondered if it was
user-triggerable.  The answer is "no, this is kosher".  sd_dif_op() is
only called from sd.c where it has chosen which READ_*/WRITE_* opcode to
set up, and it would indeed be an internal bug for this combination of
conditions to exist.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

> +
>  	switch (scmd->cmnd[0]) {
> +	case READ_6:
>  	case READ_10:
>  	case READ_12:
>  	case READ_16:
> @@ -390,6 +393,7 @@ void sd_dif_op(struct scsi_cmnd *scmd, u
>  
>  		break;
>  
> +	case WRITE_6:
>  	case WRITE_10:
>  	case WRITE_12:
>  	case WRITE_16:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
