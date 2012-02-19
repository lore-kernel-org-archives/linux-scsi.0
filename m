From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/29] qla2xxx: Add ha->max_fibre_devices to keep track
 of the maximum number of targets.
Date: Sun, 19 Feb 2012 08:33:44 -0600
Message-ID: <1329662024.2806.2.camel@dabdike.int.hansenpartnership.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
	 <1328814961-21866-26-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51048 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443Ab2BSOdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2012 09:33:47 -0500
In-Reply-To: <1328814961-21866-26-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 2012-02-09 at 11:15 -0800, Chad Dupuis wrote: 
> @@ -882,7 +892,7 @@ qla2x00_sns_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
>  	uint16_t	i;
>  	struct sns_cmd_pkt	*sns_cmd;
>  
> -	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
> +	for (i = 0; i < ha->max_fibre_devices; i++) {
>  		/* Issue GPN_ID */
>  		/* Prepare SNS command request. */
>  		sns_cmd = qla2x00_prep_sns_cmd(vha, GPN_ID_CMD,

You missed adding

-       int             rval;
+       int             rval = QLA_SUCCESS;

Here, which causes a compile warning:

Since you did the above in every other case, I've just fixed it up.

James


