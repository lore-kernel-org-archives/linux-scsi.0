From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Fri, 31 Oct 2003 22:09:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067656195.3112.551.camel@compaq.xsintricity.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
	 <1067447490.1829.30.camel@mulgrave>
	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
	 <1067450547.3112.363.camel@compaq.xsintricity.com>
	 <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
	 <1067453148.3112.369.camel@compaq.xsintricity.com>
	 <4159000000.1067644546@aslan.btc.adaptec.com>
	 <1067644902.1782.20.camel@mulgrave>
	 <1067645285.3112.538.camel@compaq.xsintricity.com>
	 <4168130000.1067645818@aslan.btc.adaptec.com>
	 <20031101012231.GA2346@beaverton.ibm.com>
	 <1067654044.2464.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:1805 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263697AbTKADLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 22:11:37 -0500
In-Reply-To: <1067654044.2464.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Matthew Wilcox <willy@debian.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2003-10-31 at 21:34, James Bottomley wrote:
> On Fri, 2003-10-31 at 19:22, Mike Anderson wrote:
> > It is called from scsi_remove_device.
> 
> But that's only called for configured devices.  The original intent was
> to call slave_destroy for all slave_alloc'd devices (whether configured
> or not).
> 
> It originally was in scsi_free_sdev, but was moved with
> 
> ChangeSet 1.1046.597.3 2003/08/02 12:17:19 andmike@us.ibm.com
>   [PATCH] scsi host / scsi device ref counting take 2 [3/3]
> 
> The changelog isn't very explicit about why this was done, what was the
> particular reason?

It really should be called on all devices, not just configured devices. 
The assumption that a device driver doesn't need to allocate local
storage to even do something as simple as INQUIRY and can wait until
slave_configure() to allocate anything is an invalid assumption.  In
fact, when I originally was working on this I think I modified the
aic7xxx_old driver to get rid of as much static array type data as
possible and move it to a struct allocated in slave_alloc.  Whether the
device is kept or not, it still has to alloc to work.  At one point
there was also another optimization in there so that if a driver didn't
do anything besides simply kfree() the memory pointed to by
sdptr->hostdata then you could skip defining a slave_destroy() function
and instead just let scsi_free_sdev do a simple kmalloc for you.  I
think that was argued against as a special case just confuses people,
can't remember.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


