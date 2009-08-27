From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [RFC PATCH 1/9] scsi-ml: modify change_queue_depth to take in
 reason why it is being called
Date: Thu, 27 Aug 2009 14:09:28 -0700
Message-ID: <1251407368.14954.29.camel@vi2.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
	 <20090826180320.23396.70657.stgit@vi1.jf.intel.com>
	 <20090827102135.GB5125@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:33067 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbZH0VJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 17:09:51 -0400
In-Reply-To: <20090827102135.GB5125@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>, michaelc@cs.wisc.edu
Cc: Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 12:21 +0200, Christof Schmitt wrote:
> On Wed, Aug 26, 2009 at 11:03:20AM -0700, Vasu Dev wrote:
> > --- a/include/scsi/scsi_host.h
> > +++ b/include/scsi/scsi_host.h
> > @@ -43,6 +43,13 @@ struct blk_queue_tags;
> >  #define DISABLE_CLUSTERING 0
> >  #define ENABLE_CLUSTERING 1
> > 
> > +enum {
> > +	SCSI_QDEPTH_SYSFS_REQ,	/* user requested change through sysfs */
> > +	SCSI_QDEPTH_QFULL,	/* scsi-ml requested due to queue full */
> > +	SCSI_QDEPTH_RAMP_UP,	/* scsi-ml requested due to threshhold event */
> > +	SCSI_QDEPTH_RAMP_DOWN, 	/* LLD/class requested due to lld/class event */
> > +};
> > +
> >  struct scsi_host_template {
> >  	struct module *module;
> >  	const char *name;
> 
> I did not find SCSI_QDEPTH_RAMP_DOWN being used. Would a LLD use this
> internally when changing the queue depth?
> 

Yes it is not used, should be removed before final patches unless Mike
have plan to use this reason code.

	Vasu

