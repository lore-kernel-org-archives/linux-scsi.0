From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_scan: Cope with kthread_run failing
Date: Sun, 23 Sep 2007 09:17:06 -0500
Message-ID: <1190557027.3378.7.camel@localhost.localdomain>
References: <118762312894-git-send-email-matthew@wil.cx>
	 <20070820152035.GH30019@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46344 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576AbXIWORI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2007 10:17:08 -0400
In-Reply-To: <20070820152035.GH30019@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-08-20 at 09:20 -0600, Matthew Wilcox wrote:
> Oops.  I fail to drive git-send-email properly again.
> James, when you're committing this, please use the
> Subject: [PATCH] scsi_scan: Cope with kthread_run failing
> 
> On Mon, Aug 20, 2007 at 09:18:48AM -0600, Matthew Wilcox wrote:
> > If kthread_run failed, we would fail to scan the host, and leak the
> > allocated async_scan_data.  Since using a separate thread is just an
> > optimisation, do the scan synchronously if we fail to spawn a thread.
> > 
> > Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> > 
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 309b224..a001ca1 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -1799,6 +1799,7 @@ static int do_scan_async(void *_data)
> >   **/
> >  void scsi_scan_host(struct Scsi_Host *shost)
> >  {
> > +	struct task_struct *p;
> >  	struct async_scan_data *data;
> >  
> >  	if (strncmp(scsi_scan_type, "none", 4) == 0)
> > @@ -1810,7 +1811,9 @@ void scsi_scan_host(struct Scsi_Host *shost)
> >  		return;
> >  	}
> >  
> > -	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> > +	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> > +	if (IS_ERR(p))

I fixed this one up in situ, but for future reference, an error
condition that's so unlikely we weren't even checking it before needs
an 

if (unlikely(IS_ERR(p)))

to get the compiler to do the right thing if it can.

James


