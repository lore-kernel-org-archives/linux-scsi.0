From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH: (as33) Remove /proc/scsi directory in scsi_remove_host()
Date: Wed, 11 Jun 2003 11:23:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030611182323.GC1596@beaverton.ibm.com>
References: <20030521180308.GD1116@beaverton.ibm.com> <Pine.LNX.4.44L0.0306111328330.696-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:56227 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262720AbTFKSHV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2003 14:07:21 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0306111328330.696-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan,
	This is bug, but I do not think this fix will work for non
	legacy callers. LLDDs that just use scsi_add_host and
	scsi_remove_host would have the remove_proc_entry called
	possibly too early.

	I do not have another fix to offer right now as "present" has race
	issues and just moving it might not be a good idea.

Alan Stern [stern@rowland.harvard.edu] wrote:
> ===== scsi_proc.c 1.11 vs edited =====
> --- 1.11/drivers/scsi/scsi_proc.c	Mon May 26 14:01:11 2003
> +++ edited/drivers/scsi/scsi_proc.c	Wed Jun 11 13:22:43 2003
> @@ -149,8 +149,8 @@
>  
>  	sprintf(name,"%d", shost->host_no);
>  	remove_proc_entry(name, shost->hostt->proc_dir);
> -	if (!shost->hostt->present)
> -		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
> +	remove_proc_entry(shost->hostt->proc_name, proc_scsi);
> +	shost->hostt->proc_dir = NULL;
>  }
>  
>  static void proc_print_scsidevice(struct scsi_device* sdev, char *buffer,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-andmike
--
Michael Anderson
andmike@us.ibm.com

