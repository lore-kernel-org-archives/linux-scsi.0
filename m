From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 3/3] Farther clean up of stex.c driver
Date: Thu, 14 Jun 2007 12:29:05 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F036011DF@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:18766 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413AbXFNTk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 15:40:58 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Boaz Harrosh [mailto:bharrosh@panasas.com] 
> Sent: Thursday, June 14, 2007 9:34 AM
> To: FUJITA Tomonori; Ed Lin; Guennadi Liakhovetski
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 3/3] Farther clean up of stex.c driver
> 
> 
> From 2b82909202cab8dc35184daef45b4b388f93112a Mon Sep 17 00:00:00 2001
> From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
> Date: Thu, 14 Jun 2007 19:14:40 +0300
> Subject: [PATCH] Farther clean up of stex.c driver
> 
>  - now that scsi-ml accessors do not allow modifying of 
> sg_count bufflen and
>    sglist. The code in question is open coded to directly 
> hack the scsi_cmnd
>    structure. When implementation changes the driver will 
> need to change with it.
> 
>  - Maintainer of this driver should please review again if we 
> absolutely need this
>    read-sense length fixing. What if less bytes are read and 
> 0 are left at the end.
>    Also no check is made if the buffer is large enough.
> ---
>  drivers/scsi/stex.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index adda296..d784b58 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -719,7 +719,7 @@ static void stex_ys_commands(struct st_hba *hba,
> 
>  	if (ccb->cmd->cmnd[0] == MGT_CMD &&
>  		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
> -		scsi_bufflen(ccb->cmd) =
> +		ccb->cmd->request_bufflen =
>  			le32_to_cpu(*(__le32 *)&resp->variable[0]);
>  		return;
>  	}
> -- 
> 1.5.0.4.402.g8035
> 
> 
> 

The software allocates a big enough buffer(so don't worry about this),
and it trims the data size based on returned length. So it needs the
actual data length. So this length fix is necessary if software doesn't
change policy. The whole thing is guaranteed by both software and
firmware, software will do a check, firmware will do a check, so a check
in driver is not necessary.

I wonder whether the following will go upstream:
#define scsi_sg_count(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sg_count
: 0)
#define scsi_sglist(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sglist :
NULL)
#define scsi_bufflen(cmd) ((cmd)->sg_table ? (cmd)->sg_table->length :
0)

For this particular case, because there is data exchange, so
(cmd)->sg_table is not NULL, so we can have something like:
		ccb->cmd->sg_table->length =
  			le32_to_cpu(*(__le32 *)&resp->variable[0]);
Although I am not sure whether the software can work without change
after the scsi_sgtable approach becomes upstream. But I just wonder why
we use some code that is known to be temporary even before its
introduction.

--Ed Lin
