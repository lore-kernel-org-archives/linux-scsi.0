From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 14:43:19 +0000
Message-ID: <1247755399.6606.4.camel@mulgrave.site>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
	 <4A5F3975.70503@s5r6.in-berlin.de>  <20090716143828.GB13924@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757573AbZGPOnX@vger.kernel.org>
In-Reply-To: <20090716143828.GB13924@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-07-16 at 15:38 +0100, Matthew Garrett wrote:
> On Thu, Jul 16, 2009 at 04:30:13PM +0200, Stefan Richter wrote:
> > Matthew Garrett wrote:
> > > @@ -447,6 +448,11 @@ struct scsi_host_template {
> > >  	unsigned ordered_tag:1;
> > >  
> > >  	/*
> > > +	 * True if host supports hotplugging
> > > +	 */
> > > +	unsigned hotpluggable:1;
> > > +
> > 
> > The comment should specify what the actual effects of the flag are.
> > 
> > (Provides the default for Scsi_Host.hotpluggable?)
> 
> Ok.
> 
> > >  
> > > +	/* 1 if hotpluggable, 0 if not */
> > > +	unsigned hotpluggable:1;
> > > +
> > 
> > Ditto here.
> 
> There's no in-kernel effect of this flag - it's just exposed to 
> userspace.
> 
> > (Is used by power management infrastructure to decide over runtime PM
> > policy?  I.e. don't enter power states which would prevent the port from
> > detecting/ reporting hotplug events?)
> 
> Exactly.

OK, so if this is only in relation to SATA power management, put it in
libata and call it something like pm_capable.  That way we don't have to
work out what to do with it for the rest of SCSI.

James
