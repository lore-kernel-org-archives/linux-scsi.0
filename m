From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Tue, 05 Feb 2008 16:46:12 -0800
Message-ID: <1202258772.13537.39.camel@linuxchandra>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	 <1202151498.3096.84.camel@localhost.localdomain>
	 <1202156151.13537.14.camel@linuxchandra>
	 <1202156914.3096.112.camel@localhost.localdomain>
	 <47A8C14A.3030207@cs.wisc.edu>  <20080205215657.GA20963@linux.vnet.ibm.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:48120 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760819AbYBFAqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 19:46:15 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m160kF9I030506
	for <linux-scsi@vger.kernel.org>; Tue, 5 Feb 2008 19:46:15 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m160kEXp210974
	for <linux-scsi@vger.kernel.org>; Tue, 5 Feb 2008 17:46:14 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m160kEp7001414
	for <linux-scsi@vger.kernel.org>; Tue, 5 Feb 2008 17:46:14 -0700
In-Reply-To: <20080205215657.GA20963@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 2008-02-05 at 13:56 -0800, Mike Anderson wrote:
> Mike Christie <michaelc@cs.wisc.edu> wrote:
> > When IO is sent to a path that cannot execute IO optimally, the scsi hw 
> > handler hook for sense processing (see rdac_check_sense in "[PATCH 8/9] 
> > scsi_dh: add lsi rdac device handler" and the scsi_error.c hook in in 
> > "scsi_dh: add skeleton for SCSI Device Handlers") will detect this and set 
> > the state to passive so future IO is not execute on the path 
> > (SG_IO/passthrough is allowed).
> >
> > I am not sure about alternatives. If we just exported the port access state 
> > in sysfs, but did not fail IO from scsi_prep_state_check, then the users 
> > could still check the state before sending IO. Would it be horrible to 
> > convert apps to do this?
> 
> The majority of the boot up delays is caused by the kernel partition
> scanning and other kernel init code (Chandra please correct if that is not

Yes, this is the case.

Some level of scanning happens at the rc scripts level too. That can be
reduced by what Mikec is suggesting. But, as andmike is suggesting, it
won't be a complete solution.

> true). Sysfs attributes would not help here. One option maybe to add
> handling of the newer BLKERR_ codes in the generators of IO or some
> similar solution with a rollout possibly focused at the top generators of

are you suggesting the partition scanners (kernel) and lvm(user space
scanner) should stop sending I/Os to a passive device once they realize
that the device is passive (thru BLKERR_ return codes) ?

> IO.
> 
> A number of user apps like lvm scanning that execute media access commands
> already have filter capability to filter devices that one does not want to

Yes, it will help. But, it will lead to additional instructions to the
users which if they do not follow (due to not knowing it or some such)
will lead to a delayed boot.

IMO, It will be good if it works nicely out of the box.

> scan. Another class of device scanners just use inquiries which are not
> effected by the passive state (though some could probably use udevinfo and
> reduce the amount of repeated SCSI inquiries execute on the system.
> 
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


