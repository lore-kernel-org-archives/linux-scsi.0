From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Open/iSCSI] Memory leak in repetitive --login/--logout with
	v2.0-870.1
Date: Tue, 13 Jan 2009 10:32:46 -0800
Message-ID: <1231871566.1274.32.camel@haakon2.linux-iscsi.org>
References: <1231539756.4560.1028.camel@haakon2.linux-iscsi.org>
	 <496AA4D1.9060701@cs.wisc.edu>
	 <1231806432.1274.6.camel@haakon2.linux-iscsi.org>
	 <496BED4A.7030006@cs.wisc.edu>  <496BFF49.5030204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:34817 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752150AbZAMSdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 13:33:11 -0500
In-Reply-To: <496BFF49.5030204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Mon, 2009-01-12 at 20:41 -0600, Mike Christie wrote:
> Mike Christie wrote:
> > Nicholas A. Bellinger wrote:
> > 
> >> Ok, I still have my hands full with LIO v3.0 code atm, so I am not sure
> >> how soon I could get to this..
> >>
> > 
> > Don't worry about it. I can replicate it here.
> > 
> 
> Crazy, I guess it is a leak we always had (at least back to 2.6.22 (did 
> not look firther)), and no one noticed. Here is a patch. I will send it 
> to James with some other patches I had.
> 
> Thanks for the report.
> 

Thanks Mike!!!

--nab

> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To post to this group, send email to open-iscsi@googlegroups.com
> To unsubscribe from this group, send email to open-iscsi+unsubscribe@googlegroups.com
> For more options, visit this group at http://groups.google.com/group/open-iscsi
> -~----------~----~----~----~------~----~------~--~---
> 
> plain text document attachment (libiscsi-fix-pool-queue-leak.patch)
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 7225b6e..257c241 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1981,6 +1981,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
>  		kfree(q->pool[i]);
>  	if (q->pool)
>  		kfree(q->pool);
> +	kfree(q->queue);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_pool_free);
>  

