From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 07/10] scsi: add common queue_depth ramp up code
Date: Fri, 11 Sep 2009 16:45:13 -0700
Message-ID: <1252712713.13165.144.camel@vi2.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
	 <20090903222304.24946.11721.stgit@vi1.jf.intel.com>
	 <4AAA7B64.6050309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:59025 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757015AbZIKXpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 19:45:11 -0400
In-Reply-To: <4AAA7B64.6050309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vasu Dev <vasu.dev@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Fri, 2009-09-11 at 11:31 -0500, Mike Christie wrote:
> > +     /*
> > +      * Walk all devices of a target and do
> > +      * ramp up on them.
> > +      */
> > +     shost_for_each_device(tmp_sdev, sdev->host) {
> > +             if ((tmp_sdev->channel != sdev->channel) ||
> > +                 (tmp_sdev->id != sdev->id))
> > +                     continue;
> 
> I just noticed that while on the ramp down we just check the id, but
> why 
> on the ramp up do we check the channel and id?
> 

Currently qla2xxx does ramp down on all luns of a target using
starget_for_each_device, so I added check for channel also just as
starget_for_each_device does. The ramp down should be doing same, I'll
add channel check to ramp down code also.

> Do we just want to adjust the devices on one specific target? If so is
> starget_for_each_device() better to use?

I considered that but call back parameters in starget_for_each_device
were not compatible with required parameters to change_queue_depth call
back, later starget_for_each_device should be fixed to use it here also
and that would be another API change.

	Thanks
	Vasu

