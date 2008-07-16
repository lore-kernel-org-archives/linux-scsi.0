From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Wed, 16 Jul 2008 15:41:04 +0200
Message-ID: <87vdz63q1b.fsf@denkblock.local>
References: <804dabb00806232109k32437d04jeed373b7d38abdb3@mail.gmail.com>
	<Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:38009 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbYGPNlc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 09:41:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> This patch (as1108) fixes a problem that can occur with certain USB
> mass-storage devices: They return invalid data together with a residue
> indicating that the data should be ignored.  Rather than leave the
> invalid data in a transfer buffer, where it can get misinterpreted,
> the patch clears the invalid portion of the buffer.

I've only just stumbled upon this patch and I don't quite understand how
it is supposed to work.

>
> This solves a problem (wrong write-protect setting detected) reported
> by Maciej Rutecki and Peter Teoh.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Peter Teoh <htmldeveloper@gmail.com>
>
> ---
>
> Index: usb-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> +++ usb-2.6/drivers/scsi/scsi_lib.c
> @@ -207,6 +207,15 @@ int scsi_execute(struct scsi_device *sde
>  	 */
>  	blk_execute_rq(req->q, NULL, req, 1);
>  
> +	/*
> +	 * Some devices (USB mass-storage in particular) may transfer
> +	 * garbage data together with a residue indicating that the data
> +	 * is invalid.  Prevent the garbage from being misinterpreted
> +	 * and prevent security leaks by zeroing out the excess data.
> +	 */
> +	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
> +		memset(buffer + (bufflen - req->data_len), 0, req->data_len);

Sorry, I don't understand that line at all. Surely, we want to zero out
either the excess data, i.e. buffer -> buffer + req->data_len, or the
residue, i.e. buffer + req->data_len -> buffer + bufflen. Your patch
implies that there are bufflen - req->data_len bytes of valid data at
the beginning of buffer. If this is intentional, please bear with me and
explain. Otherwise, what about the following patch to 2.6.26? On the
other hand, the same could probably be achieved by setting req->data_len
to 0. Oh dear, it would appear that I'm completely lost here.

Elias


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cbf55d5..977f22b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -214,7 +214,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
 	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
-		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
+		memset(buffer + req->data_len, 0, bufflen - req->data_len);
 
 	ret = req->errors;
  out:
