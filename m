From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] allow NULL dev argument to scsi_add_host
Date: Sun, 12 Jan 2003 11:40:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030112194030.GB1414@beaverton.ibm.com>
References: <20030111203317.A25836@lst.de> <20030112011720.GC1878@beaverton.ibm.com> <20030112090647.A28861@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030112090647.A28861@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> > If there are going to be many pseudo adapters that do not want to go
> > through the overhead of creating a sysfs bus entry like ide-scsi
> > then maybe I should work on a sysfs SCSI sub-system like block and if
> > dev is null it means you are pseudo and we would create an entry for
> > the adapter under (? /sysfs/scsi/pseudo ?). This could then be the value
> > we stuff in host_gendev. Though the sysfs entry would not be much use to
> > the caller, but useful for SCSI.
> 
> I'm all for useful entries in sysfs, but what about doing that
> implicitly in scsi_add_host when dev is null?  (and getting rid of the
> separate __scsi_add_host)

Yes, This is what I meant in the previous comment about create it on
the fly if dev is null and clean it up on the scsi_remove_host post call
to scsi_forget_host.

Currently we have a couple of issues that might be solved by the creation of a
scsi subsystem in /sysfs/scsi:

	1. Non converted scsi hosts that need an entry in sysfs.
	2. The creation of a sg(n) to scsi_device relationship.

I will start working on a RFC patch for addition of a scsi sub-system.
Prior to getting this done the scsi sysfs nodes will just be inconstant
for hopefully a short period.

-andmike
--
Michael Anderson
andmike@us.ibm.com

