From: Christoph Hellwig <hch@infradead.org>
Subject: [hch@infradead.org: Re: [PATCH] fix 2.5 scsi queue depth setting]
Date: Wed, 6 Nov 2002 21:05:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106210542.A32241@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 189XMs-0008OS-00
	for linux-scsi@vger.kernel.org; Wed, 06 Nov 2002 21:05:42 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Urgg, removed abit to much than just me from the cc line..

----- Forwarded message from Christoph Hellwig <hch@infradead.org> -----

Date: Wed, 6 Nov 2002 21:01:13 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
To: Patrick Mansfield <patmans@us.ibm.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	inux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 03:50:50PM -0500, Doug Ledford wrote:
> if(sdev->hostdata)
>   kfree(sdev->hostdata);

kfree(NULL) is fine, btw..

> sdev->hostdata = NULL;
> 
> after the slave_detach call.  The other option is to slightly refine the 
> slave_attach/slave_detach API to specificy that if your attach routine 
> allocates and hangs memory off of sdev->hostdata, then you *must* 
> implement a slave_detach() routine and you must free said memory yourself 
> (and NULL out the pointer to be safe).

I'm all for the second option, but I don't think we should specify the
NULLing out, the device will go away anyway.


----- End forwarded message -----
