From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] scsi_transport_fc: Initialize sysfs attributes with
 sysfs_attr_init
Date: Wed, 17 Mar 2010 14:20:18 +0100
Message-ID: <20100317132017.GA15954@schmichrtp.mainz.de.ibm.com>
References: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
 <4B9FEEBB.8090809@cs.wisc.edu>
 <1268772544.30314.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:41555 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0CQNUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 09:20:19 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate5.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o2HDKIs6017823
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 13:20:18 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2HDKIpx811204
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 13:20:18 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2HDKH3g001075
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 13:20:18 GMT
Content-Disposition: inline
In-Reply-To: <1268772544.30314.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Tue, Mar 16, 2010 at 01:49:04PM -0700, James Bottomley wrote:
> On Tue, 2010-03-16 at 15:48 -0500, Mike Christie wrote:
> > On 03/16/2010 05:14 AM, Christof Schmitt wrote:
> > > With the new lockdep tracking in sysfs, sysfs_attr_init has to be used
> > > for initializing all non-static sysfs attributes. Otherwise, lockdep
> > > will warn about the missing initialization with:
> > >
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae350 not in .data!
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae388 not in .data!
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3c0 not in .data!
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3f8 not in .data!
> > >
> > 
> > I think iscsi needs this too, but I am not see this error message. I 
> > just tried iscsi and fc/lpfc with linus's tree and did not see those 
> > errors for either. What .config settings do I need for this? I have:
> 
> It's a lot worse than that ... every transport class plus some of the
> core attributes will need this.
> 
> > CONFIG_LOCKDEP=y
> > CONFIG_DEBUG_LOCKDEP=y
> > 
> > are there other lockdep settings?
> 
> I also don't see a problem in my systems, so I'd appreciate an answer to
> this too.

include/linux/sysfs.h uses CONFIG_DEBUG_LOCK_ALLOC in some places,
e.g.
#ifdef CONFIG_DEBUG_LOCK_ALLOC
#define sysfs_attr_init(attr)				\
do {							\
	static struct lock_class_key __key;		\
							\
	(attr)->key = &__key;				\
} while(0)
#else
#define sysfs_attr_init(attr) do {} while(0)
#endif

So, enabling CONFIG_DEBUG_LOCK_ALLOC should show this problem. I
always use CONFIG_PROVE_LOCKING to enable the lock dependency
checker.

Christof
