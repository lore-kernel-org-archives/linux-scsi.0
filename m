From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/17] smartpqi: change aio sg processing
Date: Tue, 30 Aug 2016 09:23:01 +0200
Message-ID: <20160830072301.kwqdbjcr2aisvtwv@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222985137.31214.834009335820995162.stgit@brunhilda>
 <20160829085427.jq6sakyherfhtqgh@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916398CA4@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753163AbcH3HXC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Aug 2016 03:23:02 -0400
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1916398CA4@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 29, 2016 at 09:44:36PM +0000, Don Brace wrote:
> > -----Original Message-----
> > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]

[...]

> > > +     while (1) {
> > 
> > Is there any compelling reason why you didn't use scsi_for_each_sg()
> > here? I don't see a reason for the while (1) construct.
> > 
> The PQI chaining makes using scsi_for_each_sg a little more difficult to
> maintain. We would prefer to leave the code as is.

Hmmm OK. The only other thing that springs to my mind is this:

     for (i = 0; i <= sg_count; i++) {
     	 pqi_set_sg_descriptor(sg_descriptor, sg);
	 if (!chained)
	    num_sg_in_iu++;
	 if (i == sg_count)
	    break;

which isn't neccesserily better to read...

> 
> > 
> > > +             pqi_set_sg_descriptor(sg_descriptor, sg);
> > > +             if (!chained)
> > > +                     num_sg_in_iu++;
> > > +             i++;
> > > +             if (i == sg_count)
> > > +                     break;

I guess we'll have to live with it then.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
