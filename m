From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 4/4] fusion: do not check serial_number in the abort
 handler
Date: Wed, 25 May 2011 19:11:40 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157F7C03E@inbmail01.lsi.com>
References: <20110404134203.GA29525@infradead.org>
 <20110404134241.GD32522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:41350 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157Ab1EYNls convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2011 09:41:48 -0400
In-Reply-To: <20110404134241.GD32522@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Monday, April 04, 2011 7:13 PM
> To: James.Bottomley@suse.de
> Cc: linux-scsi@vger.kernel.org; Moore, Eric
> Subject: [PATCH 4/4] fusion: do not check serial_number in the abort
> handler
> 
> The SCSI midlayer stops all command processing when in error handling,
> which
> means there is no chance for command reuse when the abort handler is
> called.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/message/fusion/mptscsih.c
> ===================================================================
> --- linux-2.6.orig/drivers/message/fusion/mptscsih.c	2011-04-04
> 06:25:45.526096602 -0700
> +++ linux-2.6/drivers/message/fusion/mptscsih.c	2011-04-04
> 06:26:07.036096337 -0700
> @@ -1773,7 +1773,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  	int		 scpnt_idx;
>  	int		 retval;
>  	VirtDevice	 *vdevice;
> -	ulong	 	 sn = SCpnt->serial_number;
>  	MPT_ADAPTER	*ioc;
> 
>  	/* If we can't locate our host adapter structure, return FAILED
> status.
> @@ -1859,8 +1858,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  			 vdevice->vtarget->id, vdevice->lun,
>  			 ctx2abort, mptscsih_get_tm_timeout(ioc));
> 
> -	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
> -	    SCpnt->serial_number == sn) {
> +	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx) {
>  		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  		    "task abort: command still in active list! (sc=%p)\n",
>  		    ioc->name, SCpnt));
> @@ -1873,9 +1871,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>  	}
> 

This change looks good to me.!

>   out:
> -	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p)
> (sn=%ld)\n",
> +	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p)\n",
>  	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"),
> retval,
> -	    SCpnt, SCpnt->serial_number);
> +	    SCpnt);

Can't we keep serial_number print for debugging purpose. ?

> 
>  	return retval;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
