From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs
	take 2
Date: 07 Sep 2004 16:42:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094589763.2401.143.camel@mulgrave>
References: <20040907191918.C045E76C56@isis.visi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:33236 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268580AbUIGUpn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 16:45:43 -0400
In-Reply-To: <20040907191918.C045E76C56@isis.visi.com>
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: Mike Christie <mikenc@us.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 15:19, Scott M. Ferris wrote:
> James Bottomley wrote:
> >
> > A host is the analogue of a bus.  
> 
> That's not a very helpful analogy, since only SPI and FC-AL resemble a
> bus, and all of the newer SCSI transports are switched fabrics.

Well, I'm at a bit of a loss to make it plainer ... a host is somewhere
you plug your bus  this is an obvious concept even for switched fabrics.

The mid layer concept of the host is designed around managing the
resources that come with such a physical attachment.

However, since the iSCSI driver is virtual, it thinks more in terms of
connected endpoints, so a bus becomes a representation of this virtual
connection.  But the question of where you want your resources managed
seems to have the appropriate answer of "per connection". What you
definitely don't want is to have the entire universe of iSCSI devices
treated as a single set of resources to manage.

> > In iSCSI that's really the other end point.  Using abstractions
> > incorrectly (like a single host for the entire iSCSI system) is
> > bound to end up with problems due to the concept mismatch.
> 
> I have trouble understanding your viewpoint.  Your answers to the
> following questions will hopefully clear things up.

I doubt it, but I'll try.

> Do you think Linux hosts should be used in a similar way by all
> switched SCSI transports (e.g. FC-SW, iSCSI, SAS)?  If not, why not?

Yes.

> Do you think switched SCSI transports should allocate one Linux host
> for each I_T nexus?

No.

> Do you think switched SCSI transports should allocate one Linux host
> for each (SAM-2 or SAM-3) SCSI initiator port?

Yes.

> Do you think switched SCSI transports should allocate one Linux host
> for each (SAM-2 or SAM-3) SCSI initiator device?

No.

James


