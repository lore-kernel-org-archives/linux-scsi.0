From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [2/2]
Date: Fri, 9 May 2003 00:50:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030509075046.GC3387@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <20030509063453.GB3259@beaverton.ibm.com> <20030509063545.GC3259@beaverton.ibm.com> <20030509075946.A10204@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:2957 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262355AbTEIHgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 03:36:14 -0400
Content-Disposition: inline
In-Reply-To: <20030509075946.A10204@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Thu, May 08, 2003 at 11:35:45PM -0700, Mike Anderson wrote:
> > --- sysfs-scsi-misc-2.5/drivers/scsi/hosts.h~scsi_shost_sysfs-misc-fix	Thu May  8 22:46:53 2003
> > +++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.h	Thu May  8 22:46:53 2003
> > @@ -556,6 +556,7 @@ extern int scsi_unregister_device(struct
> >   */
> >  extern struct Scsi_Host * scsi_register(Scsi_Host_Template *, int);
> >  extern void scsi_unregister(struct Scsi_Host *);
> > +extern void scsi_free_shost(struct Scsi_Host *);
> 
> This should go into scsi_priv.h
> 

Ok I will move this and resend to James.

> >  
> >  /*
> >   * HBA registration/unregistration.
> > @@ -570,6 +571,7 @@ extern int scsi_register_host(Scsi_Host_
> >  extern int scsi_unregister_host(Scsi_Host_Template *);
> >  
> >  extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
> > +extern void scsi_host_get(struct Scsi_Host *);
> >  extern void scsi_host_put(struct Scsi_Host *);
> 
> This should go either into scsi_priv.h or exported if we see
> a use for it in driver (I'd rather avoid drivers messing with
> reference counts, though)
> 

I think it should go into scsi_priv.h. I thought it would be good to have
a symmetric interface, but would worry about drivers messing with the
counts if it was exported.

Note: scsi_host_get_next and scsi_host_hn_get need ref counting, but
I wanted to look at this a bit and see if we could utilize some
sysfs interfaces.

-andmike
--
Michael Anderson
andmike@us.ibm.com

