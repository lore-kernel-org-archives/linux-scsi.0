From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [Open-FCoE] [PATCH v3] scsi-ml: adds queue_depth ramp up code
Date: Wed, 21 Oct 2009 10:45:28 -0700
Message-ID: <1256147128.16472.89.camel@vi2.jf.intel.com>
References: <20091016004700.22451.42962.stgit@vifc.jf.intel.com>
	 <20091016230824.18916.84116.stgit@vifc.jf.intel.com>
	 <20091020185426.GA5905@schmichrtp.de.ibm.com>
	 <1256077937.16472.60.camel@vi2.jf.intel.com> <4ADE444D.5090307@cisco.com>
	 <20091021074944.GA3563@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:29094 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753945AbZJURqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 13:46:06 -0400
In-Reply-To: <20091021074944.GA3563@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Joe Eykholt <jeykholt@cisco.com>, James.Bottomley@HansenPartnership.com, devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Wed, 2009-10-21 at 09:49 +0200, Christof Schmitt wrote:
> >> Added timestamp comparison checks are straightforward without any
> >> additional conversion on each check since added timestamps and
> >> queue_ramp_up_period both are jiffies, so works better this way
> with
> >> stored queue_ramp_up_period in jiffies. 
> >>
> >> I do see your point as well but jiffies unit is also common in
> Linux.
> >> However if you or some other feels strongly to change this to ms or
> >> seconds unit then I could change store or show sysfs functions to
> handle
> >> this value in ms or second unit while storing it in jiffies in
> >> queue_ramp_up_period.
> >>
> >>      Vasu
> >
> > I agree with Christof on this, HZ may be 100 on some machines and
> 1000
> > on others.  Management tools (if they ever adjust this) would like
> > standard units, so it should be in ms or seconds, and I prefer ms.
> > I would just change the sysfs functions as you say, and use jiffies
> internally.
> 
> I would also vote for ms in sysfs and using jiffies internally. This
> should be fairly easy using the functions jiffies_to_msecs and
> msecs_to_jiffies.

Yeap it will be easy change and I'll do this change to have ms unit for
only sysfs i/f as mostly preferred ms as unit, though Mike Reed said in
other response that ms unit is too fine grained but that should be okay
as oppose to not giving choice of fine granularity and I also don't see
any risk to large value limitation by use of fine ms unit here.

I wasn't against the Christof's suggestion to use ms or sec in first
place since as I said "I do see your point as well". And now all these
responses gives solid confirmation to use ms unit here. 

Thanks all for your inputs.
 
	Vasu

