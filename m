From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: VPD in sysfs
Date: Fri, 20 Aug 2004 14:45:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040820194525.GA13970@cs.umn.edu>
References: <20040814182932.GT12936@parcelfarce.linux.theplanet.co.uk> <20040820142143.GB14144@parcelfarce.linux.theplanet.co.uk>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:61114 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S268688AbUHTTpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 15:45:35 -0400
Content-Disposition: inline
In-Reply-To: <20040820142143.GB14144@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Greg KH <greg@kroah.com>, Patrick Mochel <mochel@osdl.org>, martins@au.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 20, 2004 at 03:21:43PM +0100, Matthew Wilcox wrote:
> On Sat, Aug 14, 2004 at 07:29:32PM +0100, Matthew Wilcox wrote:
> > Thoughts?  Since there's at least four and probably more ways of getting
> > at VPD, we either need to fill in some VPD structs at initialisation or
> > have some kind of vpd_ops that a driver can fill in so the core can get
> > at the data.
> 
> I've tried the first option -- creating a large block of sysfs entries for
> all the VPD entries that are present.  However, I've come upon a problem
> with sysfs that prevents me from doing so.
> 
> Basically, the problem is that sysfs doesn't pass the attribute that's
> being invoked to the attribute ->show method.  So I can't determine
> which one is being read.  This isn't a problem for any other sysfs attribute
> because they're all static, but for dynamically created attributes, it's
> not possible to work this way.

Ya, I ran into some similar restrictions with a driver I was
writing...after talking to gregkh, you are going to have to go down a
level and use kobjects directly...each piece of data will have a kobject, 
and that's what you dereference in the show method. 

-- 
Dave Boutcher
