From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: 27 Mar 2003 09:42:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048779761.1789.21.camel@mulgrave>
References: <20030325100704.GC3868@beaverton.ibm.com>
	<1048613872.2070.12.camel@mulgrave>
	<20030325184530.GA1202@beaverton.ibm.com>
	<1048618939.1790.29.camel@mulgrave>
	<20030325232920.GB2692@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030325232920.GB2692@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-03-25 at 17:29, Mike Anderson wrote:
> I thought we where looking at a solution for all traversals of the list?
> There are currently ~52 refs to my_devices, while some traversals can be
> evalutated and possibly removed there maybe valid ones that happen
> without user context.

Sorry, I was thinking both short and long term.

Short term, it's probably easiest for the firewire stuff to access the
offline and removal functions from user land hotplug scripts (so they
don't actually need the in-kernel hook).

Long term we do need to see if we can go to a nice refcounted model for
all 50 odd list traversals.  At least auditing them to see if we can use
a semaphore everywhere.

James


