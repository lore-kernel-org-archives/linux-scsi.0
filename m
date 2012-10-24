From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 17/19] be2iscsi: Fix for MBX timeout issue
Date: Wed, 24 Oct 2012 01:45:36 -0500
Message-ID: <50878E90.1000800@cs.wisc.edu>
References: <fc49c9f1-3026-472d-9dfb-bf256bc95627@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43487 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331Ab2JXGpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2012 02:45:45 -0400
In-Reply-To: <fc49c9f1-3026-472d-9dfb-bf256bc95627@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 10/19/2012 06:15 PM, John Soni Jose wrote:
> @@ -763,26 +750,14 @@ static int beiscsi_get_port_speed(struct Scsi_Host *shost)
>  			    "BS_%d : Getting Port Speed Failed\n");
>  
>  		 return -EBUSY;
> -	 } else
> -		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
> -				phba->ctrl.mcc_numtag[tag]);
> -
> -	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
> -	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
> -	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
> -
> -	if (status || extd_status) {
> +	 }
> +	rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
> +	if (rc) {
>  		beiscsi_log(phba, KERN_ERR,

There was some small whitespace issues in this patch. Maybe James will
fix it up when it is merged. I do not know why checkpatch.pl and git did
not warn about them.
