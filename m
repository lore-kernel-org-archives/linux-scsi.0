From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Thu, 6 Nov 2003 09:07:27 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031106090727.A14452@infradead.org>
References: <1067453148.3112.369.camel@compaq.xsintricity.com> <4159000000.1067644546@aslan.btc.adaptec.com> <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com> <4168130000.1067645818@aslan.btc.adaptec.com> <20031101012231.GA2346@beaverton.ibm.com> <1067654044.2464.29.camel@mulgrave> <20031103181051.GA21012@beaverton.ibm.com> <20031104071001.A10128@infradead.org> <20031106090408.GA1398@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:2575 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263466AbTKFJHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 04:07:31 -0500
Content-Disposition: inline
In-Reply-To: <20031106090408.GA1398@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Nov 06, 2003 at 01:04:08AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

> @@ -282,24 +301,9 @@ out:
>   **/
>  void scsi_free_sdev(struct scsi_device *sdev)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(sdev->host->host_lock, flags);
> -	list_del(&sdev->siblings);
> -	list_del(&sdev->same_target_siblings);
> -	spin_unlock_irqrestore(sdev->host->host_lock, flags);
> -
> -	if (sdev->request_queue)
> -		scsi_free_queue(sdev->request_queue);
> -
> -	spin_lock_irqsave(sdev->host->host_lock, flags);
> -	list_del(&sdev->starved_entry);
> -	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
> -		kfree(sdev->sdev_target);
> -	spin_unlock_irqrestore(sdev->host->host_lock, flags);
> -
> -	kfree(sdev->inquiry);
> -	kfree(sdev);
> +	if (sdev->host->hostt->slave_destroy)
> +		sdev->host->hostt->slave_destroy(sdev);
> +	put_device(&sdev->sdev_gendev);

The name of this function is rather misleading now, I'd rather kill
it and inline it into the caller - it's just three lines anyway.

Otherwise the patch looks ok to me, but I need to look at a tree
with it applied before coming to final conclusions..


-- 
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
