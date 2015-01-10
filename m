From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 9/9] scsi_error: do not display kernel pointer in
 message logs
Date: Sat, 10 Jan 2015 19:17:07 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A730091@G9W0745.americas.hpqcorp.net>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
 <1420699430-9492-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:24611 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbAJTTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 14:19:19 -0500
In-Reply-To: <1420699430-9492-10-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Thursday, January 08, 2015 12:44 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 9/9] scsi_error: do not display kernel pointer in
> message logs
> 
> It is not good practice to display the kernel pointer
> in any message logs, and it doesn't display any additional
> information. And as we know have block-layer assigned tags
> we can use them to differentiate the messages.
> So remove any pointer references from the displayed messages.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 49 +++++++++++++++++++---------------------
> -------
>  1 file changed, 20 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index e42fff6..10ffa21 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -124,41 +124,37 @@ scmd_eh_abort_handler(struct work_struct *work)
...
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_INFO, scmd,
> -						    "scmd %p eh timeout, "
> -						    "not retrying aborted "
> -						    "command\n", scmd));
> +						    "eh timeout, not retrying "
> +						    "aborted command\n"));

checkpatch allows/encourages keeping strings on one line even when
they go past the 80th column.  So, I recommend joining those two
lines.

Reviewed-by: Robert Elliott <elliott@hp.com>


