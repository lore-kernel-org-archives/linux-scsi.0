From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock
Date: Fri, 25 Apr 2003 12:47:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425104745.GK1012@suse.de>
References: <20030424100229.A32098@beaverton.ibm.com> <20030425111212.A28577@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13734 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263870AbTDYKfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 06:35:54 -0400
Content-Disposition: inline
In-Reply-To: <20030425111212.A28577@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25 2003, Christoph Hellwig wrote:
> > -		spin_lock_irqsave(&d->list_lock, flags);
> > +		spin_lock_irqsave(&d->sdev_lock, flags);
> >  		list_for_each_entry(cmd, &d->cmd_list, list) {
> >  			if(cmd->serial_number == 0){
> 
> <snip>
> 
> > -	spin_lock_irqsave(&sdev->list_lock, flags);
> > +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> >  	list_for_each_entry(scmd, &sdev->cmd_list, list) {
> 
> 
> Oh, please, please use the lock consistantly.  Yes, I know that the
> two are the same currently, but it might not be obvious to every reader
> and queue_lock might change to something else in the future.

Again... Besides, this alias _must_ only be used by the block layer.
Every other driver should use the real one.

-- 
Jens Axboe

