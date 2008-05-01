From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 00/10] scsi_dh: Move hardware handlers from dm to SCSI
Date: Thu, 01 May 2008 14:49:41 -0700
Message-ID: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55721 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbYEAVsk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2008 17:48:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m41LmdQO019132
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:48:39 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41LmdYn226056
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:48:39 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m41Lmckc022742
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:48:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Hello,

This is the latest version of the patchset that was posted on Apr 17:
http://marc.info/?l=linux-scsi&m=120847097122545&w=2

Following are the changes made since last post:
  Based on Alasdair's comments:
    - Split the dm-mpath patch into 4 patches to enhance readabilty
    - Added comments to patch header and inline
    - Added an interface scsi_dh_handler_exist() and used it
      to verify the availability of a hardware handler
    - Do not accept arguments with the hardware handler parameter
    - Make the workqueue single threaded, and change its name
    - removed the usage of path_to_activate and used an existing field
    -renamed activate_passive_path to activate_path
    - Bring back the pg_init_retries.
  Others:
    - Added additional devices to the device list
    - removed few erroneous BUG assertions
    - Fixed an erroneous return code from scsi_dh_rdac.c.

This patch set applies on 2.6.25-mm1.

This patch set has been tested on a DS4800.

Testing has been done earlier with the following storage devices:
 - IBM DS4800 storage device for the lsi_rdac hardware handler
 - HP storage device for the hp_sw hardware handler.
   Thanks to Dave(dwysocha@redhat.com)
 - EMC storage device for the EMC hardware handler.
   Thanks to Arthur(Benoit_Arthur@emc.com) and Ronald(asson_ronald@emc.com)
In effect all hardware handlers are tested.

-------------------- Comment from Patch 01/10 ---------------------
Some of the storage devices (that can be accessed through multiple paths),
do need some special handling for
	1. Activating the passive path of the storage access.
	2. Decode and handle the special sense codes returned by the devices.
	3. Handle the I/Os being sent to the passive path, especially
           during the device probe time.
when accessed through multiple paths.

As of today this special device handling is done at the dm-multipath
layer using dm-handlers. That works well for (1); for (2) to be handled
at dm layer, scsi sense information need to be exported from SCSI to dm-layer,
which is not very attractive; (3) cannot be done at all at the dm layer.

Device handler has been moved to SCSI mainly to handle (2) and (3) properly.
----------------------

Thanks,

chandra

