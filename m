From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] support for sysfs string based properties for SCSI (1/3)
Date: Mon, 5 May 2003 13:08:07 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030505200807.GA1314@beaverton.ibm.com>
References: <1051989099.2036.7.camel@mulgrave> <1051989565.2036.14.camel@mulgrave> <20030505170202.GA1296@kroah.com> <1052154516.1888.33.camel@mulgrave> <20030505171745.GA1477@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030505171745.GA1477@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Greg KH [greg@kroah.com] wrote:
> On Mon, May 05, 2003 at 12:08:35PM -0500, James Bottomley wrote:
> > On Mon, 2003-05-05 at 12:02, Greg KH wrote:
> > > On Sat, May 03, 2003 at 02:19:23PM -0500, James Bottomley wrote:
> > > > diff -Nru a/drivers/base/core.c b/drivers/base/core.c
> > > > --- a/drivers/base/core.c	Sat May  3 14:18:21 2003
> > > > +++ b/drivers/base/core.c	Sat May  3 14:18:21 2003
> > > > @@ -42,6 +42,8 @@
> > > >  
> > > >  	if (dev_attr->show)
> > > >  		ret = dev_attr->show(dev,buf);
> > > > +	else if (dev->bus->show)
> > > > +		ret = dev->bus->show(dev, buf, attr);
> > > >  	return ret;
> > > 
> > > Can't you do this by using the class interface instead?
> > 
> > I don't know, I haven't digested the class interface patches yet, since
> > they just appeared this morning.
> 
> I think Mike has a patch queued up that takes advantage of the class
> code, which might address all of these issues.  Mike?
> 

The patches I sent add class support for scsi_host, but this only gives
granularity of attributes specific to scsi_host. There is no built in
functionality to override show or store handler functions.


-andmike
--
Michael Anderson
andmike@us.ibm.com
