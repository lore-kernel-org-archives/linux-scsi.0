From: "HighPoint Linux Team" <linux@highpoint-tech.com>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Thu, 3 Aug 2006 11:12:41 +0800
Message-ID: <0e0d01c6b6aa$b2973f70$1200a8c0@gmm>
References: <20060730171336.GA31646@lst.de> <08ce01c6b44c$82b8ef70$1200a8c0@gmm> <1154559337.2861.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stats.hypersurf.com ([209.237.0.12]:28424 "EHLO
	stats.hypersurf.com") by vger.kernel.org with ESMTP id S932132AbWHCDLW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 23:11:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org, jejb@steeleye.com, Christoph Hellwig <hch@lst.de>

Arjan van de Ven wrote:
> > Christoph Hellwig wrote:
> > > The hptiop just got merged with a horrible amount of really bad ioctl
> > > code that is against the standards for new scsi drivers.  This patch
> > > backs it out (and fixes a small bug where scsi_add_host is called to
> > > early).  We can re-add proper APIs once we agree on them.
> > 
> > What is the standard implemetation of private ioctls for scsi drivers?
> > Thanks.
>
> Hi,
>
> the real answer is: try really hard to use generic ioctls for your
> functionality. What exactly do you need private ioctls for?
> It's quite possible that there is a generic way to do the same thing
> already, or something that can easily be extended to do what you need...

We use private ioctls for RAID management. The driver registers a char
device for application to access the IOP. Several scsi drivers
(aacraid, 3w-9xxx, megaraid) use register_chrdev() for ioctls - is
this deprecated?

Another way is using scsi_host_template.ioctl interface but application
has no device node to open when there is no device on the controller.
Same problem on using sg_ioctl or scsi passthrough interface.


HighPoint Linux Team

