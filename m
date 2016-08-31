From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 11/17] smartpqi: minor tweaks to update time support
Date: Wed, 31 Aug 2016 09:33:21 +0200
Message-ID: <20160831073321.zxy4tp57vlxszfda@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222991200.31214.16478440159265351246.stgit@brunhilda>
 <20160829093338.3juwfp6xcjzib26h@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916398BE9@avsrvexchmbx1.microsemi.net>
 <20160830071735.mobvb4v4y45tn5mt@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916398EE9@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932789AbcHaHdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 03:33:24 -0400
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1916398EE9@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Aug 30, 2016 at 03:26:15PM +0000, Don Brace wrote:
> > -----Original Message-----
> > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> > Sent: Tuesday, August 30, 2016 2:18 AM
> > To: Don Brace
> > Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> > hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benesh;
> > elliott@hpe.com; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH 11/17] smartpqi: minor tweaks to update time support
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > On Mon, Aug 29, 2016 at 08:29:20PM +0000, Don Brace wrote:
> > > > -----Original Message-----
> > > > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> > 
> > [...]
> > 
> > >
> > > The reason is that we want it run immediately (or close to immediately).
> > >
> > > The code could be restructured to avoid calling this function with a 0, but it
> > would result in more code and no benefit.
> > 
> > OK, now I'm not sure if we talked past each other. I didn't mean
> > "don't call schedule_delayed_work() with a delay of 0" but "why aren't
> > you using schedule_work() instead". But maybe it's just too early in
> > the morning and I didn't have enough coffee yet.
> 
> Because the two functions take different work structures as arguments:
> 
> static inline bool schedule_delayed_work(struct delayed_work *dwork,
> 					 unsigned long delay)
> 
> static inline bool schedule_work(struct work_struct *work)

If that's the only concern, schedule_work(&dwork->work);

Anyway, that's probably just cosmetics.

With or without schedule_work()
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

But I bet someone comes up with a coccinelle spatch to change this
pattern some day.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
