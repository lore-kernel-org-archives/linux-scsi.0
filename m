From: Jens Axboe <axboe@suse.de>
Subject: Re: cciss update [1/2] updates our SCSI support to not use deprecated headers pass 3
Date: Thu, 14 Oct 2004 02:08:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014000804.GA1454@suse.de>
References: <20041013211302.GA9866@beardog.cca.cpqcorp.net> <20041013212105.GA4438@havoc.gtf.org> <20041013213626.GA10273@beardog.cca.cpqcorp.net> <1097704228.3062.1.camel@localhost.localdomain> <20041013223344.GB6019@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:7098 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S269789AbUJNAJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 20:09:46 -0400
Content-Disposition: inline
In-Reply-To: <20041013223344.GB6019@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net
Cc: Joe Perches <joe@perches.com>, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 13 2004, mike.miller@hp.com wrote:
> @@ -552,11 +547,16 @@ cciss_scsi_setup(int cntl_num)
>  static void
>  complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
>  {
> -	Scsi_Cmnd *cmd;
> +	struct scsi_cmnd *cmd;
>  	ctlr_info_t *ctlr;
>  	u64bit addr64;
>  	ErrorInfo_struct *ei;
>  
> +	cmd = kmalloc(sizeof(struct scsi_cmnd), GFP_ATOMIC);
> +	if(cmd == NULL) {
> +		printk(KERN_WARNING "out of memory\n");
> +		return;
> +	}
>  	ei = cp->err_info;
>  
>  	/* First, see if it was a message rather than a command */
> @@ -565,7 +565,7 @@ complete_scsi_command( CommandList_struc
>  		return;
>  	}
>  
> -	cmd = (Scsi_Cmnd *) cp->scsi_cmd;	
> +	cmd = (struct scsi_cmnd *) cp->scsi_cmd;	
>  	ctlr = hba[cp->ctlr];

This makes zero sense. First of all, you can't just quit out of
completing a command based on a weird allocation failure. Secondly, why
are you allocation cmd at completion time (??) and then overwriting it a
few lines later.

-- 
Jens Axboe

