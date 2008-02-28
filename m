From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/7] Move hardware handlers from dm layer to SCSI layer
Date: Wed, 27 Feb 2008 17:08:28 -0800
Message-ID: <20080228010828.5535.74088.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43307 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332AbYB1BId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 20:08:33 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1S18UF5002999
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 20:08:30 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1S18U2f093042
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 18:08:30 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1S18Tkf030708
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 18:08:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, agk@redhat.com

Hello,

Set of patches that follow this email facilitate movement of hardware
handlers from dm layer to SCSI layer.

Previous set of patches that implemented this was posted on Jan 24:
http://marc.info/?l=linux-scsi&m=120113462706925&w=2

Changes have been made based on feedback received from James, Alasdair,
Mike Christie and Mike Anderson.

Following are the changes:
 - Removed scsi_dh hardware handler in the dm layer. This means 
   no change (not even a change in the multipath.conf file) is
   required in user space.
 - Replaced REQ_OP_LB_TRANSITION with an activate() function.
 - Removed the SDEV_PASSIVE and added a prep_fn to the device 
   handler, hence giving it the veto power.
 - Replaced blk_execute_rq_nowait() with blk_execute_rq() in
   device handlers to make them synchronous. Added a thread(work queue)
   to dm-multipath to handle requests asynchronously.
 - Added Ed's changes to the EMC hardware handler.
   
Patches are created on top of 2.6.25-rc2-mm1.

Testing has been done with a IBM DS4800 storage device, which means the
infrastructure and the lsi_rdac hardware handler has been tested. Testing
by someone with the EMC hardware and/or HP hardware would be appreciated.

Comments, suggestions solicited.

Thanks,

chandra


-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
