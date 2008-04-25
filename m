From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Fri, 25 Apr 2008 11:15:36 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI>
 <48118DDD.8010507@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43021 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYDYIPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 04:15:38 -0400
In-Reply-To: <48118DDD.8010507@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>

Hi Stefan,

On Fri, 25 Apr 2008, Stefan Richter wrote:
> > Index: linux-2.6/drivers/scsi/scsi_scan.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/scsi/scsi_scan.c
> > +++ linux-2.6/drivers/scsi/scsi_scan.c
> > @@ -1802,6 +1802,7 @@ static int do_scan_async(void *_data)
> >   struct async_scan_data *data = _data;
> >   do_scsi_scan_host(data->shost);
> >   scsi_finish_async_scan(data);
> > +	complete_root_scan();
> >  	return 0;
> >  }
> >  
> > @@ -1823,6 +1824,7 @@ void scsi_scan_host(struct Scsi_Host *sh
> >   	return;
> >   }
> > 
> > +	begin_root_scan();
> >   p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> >   if (unlikely(IS_ERR(p)))
> >    do_scan_async(data);
> 
> Looks like you want complete_root_scan() after IS_ERR(p).  Are there any other
> thread exit paths which don't call complete_root_scan() yet?

No, we call complete_root_scan() in do_scan_sync() which is either called 
asynchronously from the kernel thread or synchronously on IS_ERR(p).

On Fri, 25 Apr 2008, Stefan Richter wrote:
> Besides, can't you use the generic async scan facility of the SCSI stack for
> your purpose?  If not, can it be extended to make it usable?

So you mean drivers/scsi/scsi_scan.c, right? We probably can and 
should so I'll take a look.

		Pekka
