From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH: (as33) Remove /proc/scsi directory in scsi_remove_host()
Date: Wed, 11 Jun 2003 23:51:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030612065122.GA1877@beaverton.ibm.com>
References: <20030521180308.GD1116@beaverton.ibm.com> <Pine.LNX.4.44L0.0306111328330.696-100000@ida.rowland.org> <20030611182323.GC1596@beaverton.ibm.com> <20030612070445.A15899@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:39618 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264761AbTFLGgB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2003 02:36:01 -0400
Content-Disposition: inline
In-Reply-To: <20030612070445.A15899@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> On Wed, Jun 11, 2003 at 11:23:24AM -0700, Mike Anderson wrote:
> > Alan,
> > 	This is bug, but I do not think this fix will work for non
> > 	legacy callers. LLDDs that just use scsi_add_host and
> > 	scsi_remove_host would have the remove_proc_entry called
> > 	possibly too early.
> 
> Why should we care when the proc entry is remove?  The whole ->proc_info
> mess is marked obsolete in 2.5 so no one should rely on it.  It's certainly
> better than leaking the proc_dir_entry :)

While it is marked obsolete, but it should still function shouldn't it? 
Even if we use the proc_info replacement you suggested in previous mail:
http://marc.theaimsgroup.com/?l=linux-scsi&m=105112638920306&w=2
we should have a similar cleanup issue.

The patch suggested gives the output shown below which leaves "n" number of file
entries not accessible.

Ex.
# ls /proc/scsi/scsi_debug/
1  2  3
# echo "-1" > add_host
Synchronizing SCSI cache: 
# ls /proc/scsi
device_info  ips  scsi  sg

This proc cleanup routine also races with the read / write routines that
previously where "protected" by the procfs try_module_get. 

I was looking into closing this race, but if you feel it is not
worthwhile I can go look at other issues we have.

-andmike
--
Michael Anderson
andmike@us.ibm.com

