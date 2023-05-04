Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CB3C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 21:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjEDVQ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjEDVQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 17:16:28 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 0DDAF9EE6
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 14:16:23 -0700 (PDT)
Received: (qmail 427485 invoked by uid 1000); 4 May 2023 16:25:57 -0400
Date:   Thu, 4 May 2023 16:25:57 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Message-ID: <a5a78513-58f2-4d74-a8c2-a48558345fda@rowland.harvard.edu>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
 <20230503102440.GL18384@t480-pf1aa2c2.fritz.box>
 <941e8420-f99f-5832-2ea9-3ba5eca545ad@suse.com>
 <20230503125137.GA1032383@t480-pf1aa2c2.fritz.box>
 <d25bfa50-b5a0-bd0e-fd14-94967e374033@suse.com>
 <97a67f78-4888-4fe7-9bfc-87d0bb6cc8b2@rowland.harvard.edu>
 <20230504085226.GC1032383@t480-pf1aa2c2.fritz.box>
 <83fac55c-4005-416d-aad7-04bcb3fcaea2@rowland.harvard.edu>
 <ZFPEB3lbEV90OJ91@sakura>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZFPEB3lbEV90OJ91@sakura>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 04, 2023 at 04:41:11PM +0200, Maxime Bizon wrote:
> 
> On Thursday 04 May 2023 à 10:05:38 (-0400), Alan Stern wrote:
> 
> > Maxime, would you like to submit a revised version of your patch?  The 
> > key difference is that it should abort the currently executing command 
> > (if there is one), regardless of whether the srb value matches.
> 
> Yes
> 
> before I do a format submission, is this what you have in mind ?

Yes, except that I would not make command_abort_any() a separate 
routine.  Just put it inline in device_reset().

Alan Stern

> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index 8931df5a85fd..380b04273969 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -406,10 +406,8 @@ static DEF_SCSI_QCMD(queuecommand)
>   ***********************************************************************/
>  
>  /* Command timeout and abort */
> -static int command_abort(struct scsi_cmnd *srb)
> +static int command_abort_matching(struct us_data *us, struct scsi_cmnd *srb_match)
>  {
> -	struct us_data *us = host_to_us(srb->device->host);
> -
>  	usb_stor_dbg(us, "%s called\n", __func__);
>  
>  	/*
> @@ -418,10 +416,17 @@ static int command_abort(struct scsi_cmnd *srb)
>  	 */
>  	scsi_lock(us_to_host(us));
>  
> -	/* Is this command still active? */
> -	if (us->srb != srb) {
> +	/* is there any active pending command to abort ? */
> +	if (!us->srb) {
>  		scsi_unlock(us_to_host(us));
>  		usb_stor_dbg(us, "-- nothing to abort\n");
> +		return SUCCESS;
> +	}
> +
> +	/* Does the command match the passed srb if any ? */
> +	if (srb_match && us->srb != srb_match) {
> +		scsi_unlock(us_to_host(us));
> +		usb_stor_dbg(us, "-- pending command mismatch\n");
>  		return FAILED;
>  	}
>  
> @@ -444,6 +449,16 @@ static int command_abort(struct scsi_cmnd *srb)
>  	return SUCCESS;
>  }
>  
> +static int command_abort_any(struct us_data *us)
> +{
> +	return command_abort_matching(us, NULL);
> +}
> +
> +static int command_abort(struct scsi_cmnd *srb)
> +{
> +	return command_abort_matching(host_to_us(srb->device->host), srb);
> +}
> +
>  /*
>   * This invokes the transport reset mechanism to reset the state of the
>   * device
> @@ -455,6 +470,8 @@ static int device_reset(struct scsi_cmnd *srb)
>  
>  	usb_stor_dbg(us, "%s called\n", __func__);
>  
> +	command_abort_any(us);
> +
>  	/* lock the device pointers and do the reset */
>  	mutex_lock(&(us->dev_mutex));
>  	result = us->transport_reset(us);
> 
> 
> -- 
> Maxime
