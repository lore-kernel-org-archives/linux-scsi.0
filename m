From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 04/13] scsi: remove meaningless volatile qualifiers from structure definitions
Date: Fri, 1 Apr 2005 14:15:32 +0900
Message-ID: <20050401051532.GD11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.57213FBA@htj.dyndns.org> <20050331101145.GA13842@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.195]:14769 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262632AbVDAFPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:15:41 -0500
Received: by rproxy.gmail.com with SMTP id j1so561830rnf
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:15:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050331101145.GA13842@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Chritoph.

On Thu, Mar 31, 2005 at 11:11:45AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 31, 2005 at 06:08:10PM +0900, Tejun Heo wrote:
> >  	struct list_head    siblings;   /* list of all devices on this host */
> >  	struct list_head    same_target_siblings; /* just the devices sharing same target id */
> >  
> > -	volatile unsigned short device_busy;	/* commands actually active on low-level */
> > +	unsigned short device_busy;	/* commands actually active on
> > +					 * low-level. protected by sdev_lock. */
> 
> You should probably switch it to just unsigned.  The other 16bit are wasted
> due to alignment anyway, and some architectures produce better code for 32bit
> accesses.
> 
> > -	volatile unsigned short host_busy;   /* commands actually active on low-level */
> > -	volatile unsigned short host_failed; /* commands that failed. */
> > +
> > +	/*
> > +	 * The following two fields are protected with host_lock;
> > +	 * however, eh routines can safely access during eh processing
> > +	 * without acquiring the lock.
> > +	 */
> > +	unsigned short host_busy;	   /* commands actually active on low-level */
> > +	unsigned short host_failed;	   /* commands that failed. */
> 
> Here it would actually increase the struct size but might make sense anyway.

 Sure, I'll make them unsigned.

 Thanks.

-- 
tejun

