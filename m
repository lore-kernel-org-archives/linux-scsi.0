From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [RFC PATCH 9/9] libfc: adds queue_depth ramp up to libfc
Date: Thu, 27 Aug 2009 13:56:31 -0700
Message-ID: <1251406591.14954.19.camel@vi2.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
	 <20090826180403.23396.61277.stgit@vi1.jf.intel.com>
	 <20090827101957.GA5125@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:46573 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752716AbZH0U4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 16:56:30 -0400
In-Reply-To: <20090827101957.GA5125@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Vasu Dev <vasu.dev@intel.com>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 12:19 +0200, Christof Schmitt wrote:
> On Wed, Aug 26, 2009 at 11:04:03AM -0700, Vasu Dev wrote:
> > Increases queue_depth by one on fc_change_queue_depth call back
> > with reason SCSI_QDEPTH_RAMP_UP.
> > 
> > Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> > ---
> > 
> >  drivers/scsi/libfc/fc_fcp.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> > index dda4162..92e8a1b 100644
> > --- a/drivers/scsi/libfc/fc_fcp.c
> > +++ b/drivers/scsi/libfc/fc_fcp.c
> > @@ -2054,6 +2054,11 @@ int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
> >  	case SCSI_QDEPTH_QFULL:
> >  		scsi_track_queue_full(sdev, qdepth);
> >  		break;
> > +	case SCSI_QDEPTH_RAMP_UP:
> > +		if (qdepth + 1 <= FC_FCP_DFLT_QUEUE_DEPTH)
> > +			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> > +						qdepth + 1);
> > +		break;
> >  	default:
> >  		return -EOPNOTSUPP;
> >  	}
> 
> Overall the approach looks good to me.
> 
> I am trying to find out how this applies to the zfcp driver. Is the
> approach in fc_change_queue_depth a good example for a driver that
> does not have to adjust internal resources when changing the queue
> depth?
> 

Yes, this is the case with libfc also since libfc also doesn't make any
additional resource adjustments on this call back. However If needed
then this call back can be used to make additional resource adjustments
also as needed by lpfc driver in lpfc_change_queue_depth.

	Vasu


