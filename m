From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 10 Nov 2003 09:43:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031110094322.A22518@beaverton.ibm.com>
References: <20031027153932.A16679@infradead.org> <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com> <20031106100906.A15382@infradead.org> <3FAB5DE5.2080000@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:36034 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264027AbTKJRqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 12:46:50 -0500
Content-Disposition: inline
In-Reply-To: <3FAB5DE5.2080000@torque.net>; from dougg@torque.net on Fri, Nov 07, 2003 at 06:55:01PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Fri, Nov 07, 2003 at 06:55:01PM +1000, Douglas Gilbert wrote:
> 'Christoph Hellwig' wrote:
> > On Thu, Nov 06, 2003 at 03:12:51PM +0530, Sachin Mhatre (smhatre) wrote:

> >>The iSCSI driver receives a CHECK CONDITION with sense key, NOT READY
> >>and ASC/ASCQ=04/02 (i.e. an initialization command required). The Linux
> >>SCSI mid-layer does not handle this condition. Hence the TUR and START
> >>STOP initialization commands are sent from the iSCSI driver.
> >>
> >>Should this condition be necessarily handled in the SCSI mid-layer or
> >>the low-level driver?
> > 
> > 
> > I think we should handle it in the midlayer.  Could you come up with a
> > patch to implement it?

Why doesn't the iscsi target handle the problem?

We already spun the drive up in sd.c during scan + probe, or for removable
or write protected media, on open (sd_open calls check_disk_change).

That is, whoever spun down the drive should spin it up.

In Doug's example, he knows he spun it down, and can spin it up again before
mounting the disk.

-- Patrick Mansfield
