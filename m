From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Thu, 22 Jan 2004 08:56:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122085639.A14760@beaverton.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org> <400EE5E6.9080709@us.ibm.com> <20040122140248.C11283@infradead.org> <20040122083931.A14612@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:53501 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266249AbUAVQ5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 11:57:24 -0500
Content-Disposition: inline
In-Reply-To: <20040122083931.A14612@beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Jan 22, 2004 at 08:39:31AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

On Thu, Jan 22, 2004 at 08:39:31AM -0800, Patrick Mansfield wrote:

> Also if we can tell via sysfs attributes that a bus (host:channel or maybe
> just a host) has physical disks attached, udev can be used to create
> entries in their own directory, like:
> 
> 	/dev/physical/sdN
> 
> Making the node read only can also be done with udev, but that does not
> help with root write access.

And we can prevent even root from opening for write with blockdev --setro:

elm3b79:~# dd if=/dev/zero of=/udev/physical/sd_f  count=1
1+0 records in
1+0 records out
elm3b79:~# blockdev --setro /udev/physical/sd_f
elm3b79:~# dd if=/dev/zero of=/udev/physical/sd_f  count=1
dd: writing to `/udev/physical/sd_f': Operation not permitted
1+0 records in
0+0 records out

-- Patrick Mansfield
