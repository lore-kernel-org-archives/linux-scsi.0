From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Mon, 04 Feb 2008 13:19:30 -0800
Message-ID: <1202159970.13537.19.camel@linuxchandra>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	 <1202151498.3096.84.camel@localhost.localdomain>
	 <1202156151.13537.14.camel@linuxchandra>
	 <1202156914.3096.112.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54066 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438AbYBDVTd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 16:19:33 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m14LJXPg015390
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 16:19:33 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14LJWHR150210
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 14:19:32 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14LJVhg012712
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 14:19:32 -0700
In-Reply-To: <1202156914.3096.112.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, jens.axboe@oracle.com

On Mon, 2008-02-04 at 14:28 -0600, James Bottomley wrote:
> On Mon, 2008-02-04 at 12:15 -0800, Chandra Seetharaman wrote:
> > On Mon, 2008-02-04 at 12:58 -0600, James Bottomley wrote:
> > > On Wed, 2008-01-23 at 16:32 -0800, Chandra Seetharaman wrote:
> > > > Subject: scsi_dh: Add support for SDEV_PASSIVE
> > > > 
> > > > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > > > 
> > > > This patch adds a new device state SDEV_PASSIVE, to correspond to the
> > > > passive side access of an active/passive multipathed device.
> > > 
> > > Really, no; this isn't right.  The state field of a SCSI device is for
> > > the SCSI state model.  Passive might be a valid device mapper state, but
> > 
> > Hi James,
> > 
> > It is not the "device mapper state", it is the state of the device
> > itself. These devices have active/passive paths, the passive paths will
> > be represented by SDEV_PASSIVE device state in SCSI.
> 
> Yes, it is .. you're killing commands on the basis of being in this
> state, which nothing in SCSI ever sets.
> 
> A proper return from a passive path is the SCSI standard NOT_READY
> LOGICAL UNIT NOT READY, INITIALIZING COMMAND REQUIRED.  We expect to see
> this, not the command being killed.

The device does send these error messages currently, but it takes some
time to get the check condition back, which adds up the time to boot
especially when the # of LUNS is huge.

For example, in my test configuration, I had 40 luns, and the time
difference (with this patch and without it) to boot is 171 seconds and
1426 seconds.

We thought we will get it short circuited so as to return the failure
back faster.

Also, we only short circuit REQ_TYPE_FS.


> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


