From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: Tue, 8 Jul 2003 15:24:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708152440.A373@beaverton.ibm.com>
References: <20030708134016.A32161@beaverton.ibm.com> <1057697416.1825.10.camel@mulgrave> <20030708221350.A19804@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:5794 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267736AbTGHWKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 18:10:31 -0400
Content-Disposition: inline
In-Reply-To: <20030708221350.A19804@infradead.org>; from hch@infradead.org on Tue, Jul 08, 2003 at 10:13:51PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jul 08, 2003 at 10:13:51PM +0100, Christoph Hellwig wrote:
> On Tue, Jul 08, 2003 at 03:50:15PM -0500, James Bottomley wrote:
> > I'm not convinced we need a bus file for this.  What's the reason we
> > can't have a per host file instead?
> > 
> > I'm thinking of the hotplug case where you know the sysfs path to the
> > card just inserted.  Translating that to a hostid will be rather hard.
> 
> After thinking about this again I tend to agree with you that a per-host
> file sounds like the better idea.

James/Christoph -

There is not much of a difference either way.

Scanning makes more sense as a host attribute (or as a target attribute,
but we don't have a target device today). Deletion of a scsi_device makes
more sense as a /sysfs/bus/scsi (or even scsi_device) attribute that takes
a bus_id. 

But we should be symmetrical for a user space interface. (And it is easier
to catch sscanf errors using spaces as a separator.)

I'll go ahead and redo it as per-host, and move string parsing into
scsi_sysfs.c.

Thanks for the feedback.

-- Patrick Mansfield
