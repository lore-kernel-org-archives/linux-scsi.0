From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 08/24] fas216: Update logging messages
Date: Fri, 3 Oct 2014 00:43:42 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBD5A@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:8475 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJCAp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 20:45:56 -0400
In-Reply-To: <1412144580-72880-9-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> @@ -2079,12 +2078,12 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd
> *SCpnt, unsigned int result)
>  			break;
> 
>  		default:
> -			printk(KERN_ERR "scsi%d.%c: incomplete data transfer "
> -				"detected: res=%08X ptr=%p len=%X CDB: ",
> -				info->host->host_no, '0' + SCpnt->device->id,
> -				SCpnt->result, info->scsi.SCp.ptr,
> -				info->scsi.SCp.this_residual);
> -			__scsi_print_command(SCpnt->cmnd);
> +			scmd_printk(KERN_ERR, SCpnt,
> +				    "incomplete data transfer "
> +				    "detected: res=%08X ptr=%p len=%X\n",

checkpatch lets you keep strings on one line even if the code
exceeds 80 characters.

> +				    SCpnt->result, info->scsi.SCp.ptr,
> +				    info->scsi.SCp.this_residual);
> +			scsi_print_command(SCpnt);
>  			set_host_byte(SCpnt, DID_ERROR);
>  			goto request_sense;
>  		}
> @@ -2157,12 +2156,12 @@ static void fas216_done(FAS216_Info *info, unsigned
> int result)
>  	 * to transfer, we should not have a valid pointer.
>  	 */
>  	if (info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
> -		printk("scsi%d.%c: zero bytes left to transfer, but "
> -		       "buffer pointer still valid: ptr=%p len=%08x CDB: ",
> -		       info->host->host_no, '0' + SCpnt->device->id,
> -		       info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
> +		scmd_printk(KERN_INFO, SCpnt,
> +			    "zero bytes left to transfer, but "
> +			    "buffer pointer still valid: ptr=%p len=%08x\n",

checkpatch lets you keep strings on one line even if the code
exceeds 80 characters.


---
Rob Elliott    HP Server Storage



