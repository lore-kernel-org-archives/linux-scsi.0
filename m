From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: IO transfer limits
Date: Wed, 10 Jan 2007 11:40:30 -0600
Message-ID: <45A5250E.3020205@cs.wisc.edu>
References: <8260533.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42863 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964949AbXAJRkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jan 2007 12:40:37 -0500
In-Reply-To: <8260533.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john clyne <clyne@ucar.edu>
Cc: linux-scsi@vger.kernel.org

john clyne wrote:
> Can anyone give me some guidance on where in the IO stack I might be running
> into a 512KB limit on IO transfer sizes to an external FC device? I've
> checked IO scheduler parameter
> (/sys/block/<dev>/queue/{max_sectors_kb,max_hw_sectors_kb}. Both are set to
> 32767. I'm using Qlogic HBAs (qla2312), but I don't see any relevent
> parameters. I'm running RHEL 4.0 with a 2.6.9-34 kernel. Any pointers would
> be greatly appreciated.
> 

There are also scatterlist limits.

/sys/class/scsi_host/hostX/sg_tablesize is a limit for the number of
scatter list entries. For qla2xxx it is 255.

The scsi layer sets the queue's max_phys_segments to 128 by default. I
thought there was ia scsi compile time option to increase this, but
maybe you have to just modify the SCSI_MAX_PHYS_SEGMENTS define by hand.

So with the default value and with 4 K pages if you end up getting pages
that cannot be clustered you will end up with 4K * 128.
