From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Mon, 11 May 2009 07:59:10 -0700 (PDT)
Message-ID: <20090511235852Z.fujita.tomonori@lab.ntt.co.jp>
References: <4A06DFAB.40205@panasas.com>
	<4A0767E5.5050205@kernel.org>
	<4A080C9D.9000109@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:29047 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZEKO7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 10:59:10 -0400
In-Reply-To: <4A080C9D.9000109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tj@kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com

On Mon, 11 May 2009 14:31:41 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> >>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> >>> index 3da02e4..6605ec9 100644
> >>> --- a/drivers/scsi/libsas/sas_expander.c
> >>> +++ b/drivers/scsi/libsas/sas_expander.c
> >>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> >>>  			       bio_data(rsp->bio), rsp->data_len);
> >>>  	if (ret > 0) {
> >>>  		/* positive number is the untransferred residual */
> >>> -		rsp->data_len = ret;
> >>> -		req->data_len = 0;
> >>> +		rsp->resid_len = ret;
> >>>  		ret = 0;
> >>> -	} else if (ret == 0) {
> >>> -		rsp->data_len = 0;
> >>> -		req->data_len = 0;
> >>>  	}
> >>>  
> >>>  	return ret;
> >> This is actually a bug fix, as well as a strait conversion
> > 
> > Can you elaborate a bit about the bug fix part?
> > 
> 
> Nothing big really, just that before (according to the comment), the theoretical
> negative case would be full-residual. and now it is zero (untouched).
> 
> I know that in iscsi a negative residual is possible which means over-flow. That is:
> the target had more data to give then the buffer had space for. (which is not an error at all)

Hmm, iSCSI? This code is for SAS management Protocol.

smp_execute_task returns a negative value for some errors (ENOMEM, the
hardware doesn't respond, etc). It's not related with 'transferred
buffer length' at all.
