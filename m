From: Eddie Williams <Eddie.Williams@Steeleye.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 15:37:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098905875.4472.92.camel@gator.sc.steeleye.com>
References: <1098833278.4914.24.camel@zezette>
	 <20041027081713.GC32712@marowsky-bree.de>
	 <1098903759.12464.32.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49871 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262576AbUJ0TiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 15:38:09 -0400
In-Reply-To: <1098903759.12464.32.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2004-10-27 at 15:02, christophe varoqui wrote:

> > 
> I wonder if it's not simpler just to remove the NOSTARTONADD flag on
> this devices in scsi_devinfo.c. I tested that and all the READ CAPACITY
> succeed as expected (DEC HSG80 / COMPAQ HSV*).
> 
> Wasn't this flag in part motivated by the lack of multipath support
> anyway ?
> 
> Even in a cluster context, I don't really buy the annoyance of
> occasional LUN ping-pong.

Yes this change was instigated due to lack of multipath support.  Where
the Qlogic Failover driver intercepts start unit commands this change
would not be necessary.  But with the other multipath endeavors I am not
sure they will affect the need for this feature?

So to the reason for the change, with a single server involved there is
no concern issuing the start unit.  With 2 servers involved it is an
annoyance that can be overlooked for the most part.  However when > 2
servers are involved and especially if the number of LUNs involved is
significant, say > 16, then the annoyance increases such that it is not
easily overlooked.

Switching LUNs from one path to another is not a fast process and if
this happens during periods of heaving IO periods, significant thrashing
can result.

I think if we want to play at the Enterprise level where there are many
servers connected up to large arrays I don't think it is a good idea to
knowingly cause disruptions to others on the SAN.  Causing LUNs to
switch from one path to another is such a behavior.

Eddie Williams

