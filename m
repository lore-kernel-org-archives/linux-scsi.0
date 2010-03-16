From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_transport_fc: Initialize sysfs attributes with
 sysfs_attr_init
Date: Tue, 16 Mar 2010 13:49:04 -0700
Message-ID: <1268772544.30314.1.camel@mulgrave.site>
References: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
	 <4B9FEEBB.8090809@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab0CPUzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2010 16:55:33 -0400
In-Reply-To: <4B9FEEBB.8090809@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 2010-03-16 at 15:48 -0500, Mike Christie wrote:
> On 03/16/2010 05:14 AM, Christof Schmitt wrote:
> > With the new lockdep tracking in sysfs, sysfs_attr_init has to be used
> > for initializing all non-static sysfs attributes. Otherwise, lockdep
> > will warn about the missing initialization with:
> >
> > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae350 not in .data!
> > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae388 not in .data!
> > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3c0 not in .data!
> > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3f8 not in .data!
> >
> 
> I think iscsi needs this too, but I am not see this error message. I 
> just tried iscsi and fc/lpfc with linus's tree and did not see those 
> errors for either. What .config settings do I need for this? I have:

It's a lot worse than that ... every transport class plus some of the
core attributes will need this.

> CONFIG_LOCKDEP=y
> CONFIG_DEBUG_LOCKDEP=y
> 
> are there other lockdep settings?

I also don't see a problem in my systems, so I'd appreciate an answer to
this too.

James


