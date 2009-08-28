From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 9/9] libfc: adds queue_depth ramp up to libfc
Date: Fri, 28 Aug 2009 12:44:43 +0200
Message-ID: <20090828104442.GA4550@schmichrtp>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com> <20090826180403.23396.61277.stgit@vi1.jf.intel.com> <20090827101957.GA5125@schmichrtp> <1251406591.14954.19.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:48483 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZH1Kom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 06:44:42 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.1/8.13.1) with ESMTP id n7SAii3h001713
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 10:44:44 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7SAihRM2519072
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 12:44:44 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7SAihHp002154
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 12:44:43 +0200
Content-Disposition: inline
In-Reply-To: <1251406591.14954.19.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2009 at 01:56:31PM -0700, Vasu Dev wrote:
> On Thu, 2009-08-27 at 12:19 +0200, Christof Schmitt wrote:
> > On Wed, Aug 26, 2009 at 11:04:03AM -0700, Vasu Dev wrote:
> > > Increases queue_depth by one on fc_change_queue_depth call back
> > > with reason SCSI_QDEPTH_RAMP_UP.
> > > 
> > > Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> > > ---
> > > 
> > >  drivers/scsi/libfc/fc_fcp.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> > > index dda4162..92e8a1b 100644
> > > --- a/drivers/scsi/libfc/fc_fcp.c
> > > +++ b/drivers/scsi/libfc/fc_fcp.c
> > > @@ -2054,6 +2054,11 @@ int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
> > >  	case SCSI_QDEPTH_QFULL:
> > >  		scsi_track_queue_full(sdev, qdepth);
> > >  		break;
> > > +	case SCSI_QDEPTH_RAMP_UP:
> > > +		if (qdepth + 1 <= FC_FCP_DFLT_QUEUE_DEPTH)
> > > +			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> > > +						qdepth + 1);
> > > +		break;
> > >  	default:
> > >  		return -EOPNOTSUPP;
> > >  	}
> > 
> > Overall the approach looks good to me.
> > 
> > I am trying to find out how this applies to the zfcp driver. Is the
> > approach in fc_change_queue_depth a good example for a driver that
> > does not have to adjust internal resources when changing the queue
> > depth?
> > 
> 
> Yes, this is the case with libfc also since libfc also doesn't make any
> additional resource adjustments on this call back. However If needed
> then this call back can be used to make additional resource adjustments
> also as needed by lpfc driver in lpfc_change_queue_depth.

There are also no resource adjustments necessary inside the zfcp
driver, i attached a first patch to adapt the zfcp change_queue_depth
callback.

I reused the default_depth settings for checking the maximum queue
depth. But i am wondering if the check should happen differently.
Would it make more sense to have an adjustable maximum_depth attribute
for each SCSI device? Or would it be possible to always increase the
queue depth until the storage returns QUEUE_FULL again?

Christof

---
zfcp: Adapt change_queue_depth for queue full tracking

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Adapt the change_queue_depth callback in zfcp for the new reason
parameter. Simply pass each call back to the SCSI midlayer, there are
no resource adjustments necessary for zfcp.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-28 12:00:12.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-28 12:01:27.000000000 +0200
@@ -28,9 +28,25 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
 	return fcp_sns_info_ptr;
 }
 
-static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth)
+static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
+					int reason)
 {
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+	switch (reason) {
+	case SCSI_QDEPTH_SYSFS_REQ:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, depth);
+		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		depth++;
+		if (depth <= default_depth)
+			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+						depth);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
 	return sdev->queue_depth;
 }
 
