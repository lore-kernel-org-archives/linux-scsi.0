From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3 ver 2] SCSI: implement runtime Power Management
Date: Wed, 28 Jul 2010 10:53:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1007281047300.1744-100000@iolanthe.rowland.org>
References: <1280289480.2833.1418.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33249 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754768Ab0G1Oxa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 10:53:30 -0400
In-Reply-To: <1280289480.2833.1418.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 27 Jul 2010, James Bottomley wrote:

> > > @@ -147,7 +148,18 @@ static inline void scsi_netlink_exit(voi
> > >  /* scsi_pm.c */
> > >  #ifdef CONFIG_PM_OPS
> > >  extern const struct dev_pm_ops scsi_bus_pm_ops;
> > > +#ifdef CONFIG_PM_RUNTIME
> > > +extern void scsi_autopm_get_target(struct scsi_target *);
> > > +extern void scsi_autopm_put_target(struct scsi_target *);
> > > +extern int scsi_autopm_get_host(struct Scsi_Host *);
> > > +extern void scsi_autopm_put_host(struct Scsi_Host *);
> > >  #else
> > > +static inline void scsi_autopm_get_target(struct scsi_target *) {}
> > > +static inline void scsi_autopm_put_target(struct scsi_target *) {}
> > > +static inline int scsi_autopm_get_host(struct Scsi_Host *) { return 0; }
> > > +static inline void scsi_autopm_put_host(struct Scsi_Host *) {}
> > 
> > You didn't compile this, did you?  The compiler gets distinctly annoyed
> > to see an inline function with no actual variable for the argument ...

Arggh!  I hate changes that are affected by multiple configuration 
options.

In fact I did test an earlier version of the patch, but it's entirely
possible that I missed one of the four combinations.

> > I fixed up this and the one in scsi_device.h
> 
> Since there were actually 3 relevant config variations, this turned out
> to be the final fix.

Yep, you're absolutely right.  Many thanks for fixing this up.

Alan Stern

