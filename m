From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 19:12:50 -0400
Message-ID: <46FC38F2.2070206@garzik.org>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <46FBBBEB.4020605@garzik.org> <46FBBE52.1080507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43378 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbXI0XMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 19:12:55 -0400
In-Reply-To: <46FBBE52.1080507@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Michael Reed wrote:
> I'm curious about the problem you're trying to solve.  Generally a missing WWN,

I'm writing two SAS HBA drivers, Marvell 6440 and Broadcom 8603/HT1100, 
and must deal with this scenario.


> as having a unique WWN should be a product requirement, is an indicator of
> a problem.  Shouldn't the proper solution be to have the card repaired?
> Arbitrarily assigning a WWN could mask or introduce other problems, in particular
> with regard to storage connectivity.

If you are an admin suffering from the /common/ problem of missing or 
invalid NVRAM, would you rather wait for card repair or get it going 
immediately?

The standard Linux policy for unique ids like ethernet MAC has been, for 
the 98% case where you have a useful MAC from the hardware, of course 
use it.  For the 2% case, you give the admin solutions for supplying a 
useful MAC.

Mirroring decades of ethernet NIC history, the HBA silicon and the 
source of the unique id are most often vastly different.  Normally it is 
a different chip on the same board, but sometimes the unique id source 
is not on the same board at all.

For those reasons and more, Linux users have a LONG history of running 
into situations where, for one reason or another, their silicon is fine 
but their unique id is not.  I've heard them all:
	- hw from government auction, had NVRAM intentionally wiped
	- hw resale w/ NVRAM wiped by paranoid corporate IT staff
	- hw with NVRAM chip missing
	- old hw out of warranty
	- old dev kit (they rarely ship with useful NVRAM data)
	- and plenty more

We have to behave sanely in the 2% case.  "refuse to operate" is just 
not an option, when this problem case is so historically clear, and so 
easy to work around.

Linux drivers have to continue operating long after support contracts 
run out, long after chip EOL, and sometimes, long after companies go out 
of business.

	Jeff


