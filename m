From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] support for sysfs string based properties for SCSI (1/3)
Date: 05 May 2003 12:08:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052154516.1888.33.camel@mulgrave>
References: <1051989099.2036.7.camel@mulgrave>
	<1051989565.2036.14.camel@mulgrave>  <20030505170202.GA1296@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:4614 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263700AbTEEQ4M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 12:56:12 -0400
In-Reply-To: <20030505170202.GA1296@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>, Mike Anderson <andmike@us.ibm.com>

On Mon, 2003-05-05 at 12:02, Greg KH wrote:
> On Sat, May 03, 2003 at 02:19:23PM -0500, James Bottomley wrote:
> > diff -Nru a/drivers/base/core.c b/drivers/base/core.c
> > --- a/drivers/base/core.c	Sat May  3 14:18:21 2003
> > +++ b/drivers/base/core.c	Sat May  3 14:18:21 2003
> > @@ -42,6 +42,8 @@
> >  
> >  	if (dev_attr->show)
> >  		ret = dev_attr->show(dev,buf);
> > +	else if (dev->bus->show)
> > +		ret = dev->bus->show(dev, buf, attr);
> >  	return ret;
> 
> Can't you do this by using the class interface instead?

I don't know, I haven't digested the class interface patches yet, since
they just appeared this morning.

> This also forces you to do a lot of string compares within the bus show
> function (as your example did) which is almost as unwieldy as just
> having individual show functions, right?  :)

Nothing prevents users from doing it the callback way.  However,
callbacks aren't a scaleable interface for properties that have to be
shared and overridden.

I agree string compares are unwieldy (and smack of XML), so I'm open to
suggestions of a better way of doing it that has the same flexibility of
the string method...

James


