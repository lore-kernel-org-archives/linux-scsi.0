From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: 31 Jan 2003 08:46:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044020591.2002.16.camel@mulgrave>
References: <20030129104731.A2811@beaverton.ibm.com>
	<3E382E2C.4030201@splentec.com> <20030129121117.A3389@beaverton.ibm.com>
	<20030130225738.1874c2e0.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id FAA19445
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jan 2003 05:46:52 -0800
In-Reply-To: <20030130225738.1874c2e0.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, luben@splentec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-01-31 at 01:57, Andrew Morton wrote:
> Please do not reinvent the mm/mempool.c functionality.
> 
> 'twould be better to just use it ;)

Unfortunately, in this instance, mempool is a slight overkill.  The
problem is that we need to guarantee that a command (or set of commands)
be available to a given device regardless of what's going on in the rest
of the system.  Thus we might need a mempool for each active device,
rather than a mempool for all devices and a mechanism for giving fine
grained control to the pool depth per device.  Mempool would fit all of
the above, I was just concerned that it looks to be a rather heavy
addition (in terms of structure size) per device.

James


