From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/5]  qla2xxx: remote port rework...
Date: Wed, 13 Apr 2005 12:15:48 -0700
Message-ID: <20050413191548.GI9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:42094 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261183AbVDMTPt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 15:15:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>


All,

With the remote port patches in the pipeline for 2.6.12, I'd like to
submit the following set of qla2xxx patches which strip many of the
legacy features from the driver.  Again, these 'features' have been
superceded in functionality and simplicity by additions present with
fc_rports.

Here's the breakdown of patches being submitted:

1) Remove internal command queuing.  This entails removal of the
   driver's *_queue lists as well as modifications and removal of
   routines which used them.  With the queuing removed -- the
   driver will be unable to tolerate cable-pulls.  Thus we depend
   on the next patch for support.

2) Add initial support for FC remote port infrastructure.

3) Remove internal lun discovery routines and support structures.
   The mid-layer has a more exhaustive and fully capable set of
   functions for lun discovery.

4) Clean-up DMA mappings -- patch originally submitted by
   Doug Ledford <dledford@redhat.com>.

	Don't use cmd->request->nr_hw_segments as it may not be initialized
	(SG_IO in particular bypasses anything that initializes this and just
	uses scsi_do_req to insert a scsi_request directly on the head of the
	queue) and a bogus value here can trip up the checks to make sure that
	the number of segments will fit in the queue ring buffer, resulting in
	commands that are never completed.

	Fix up several issues with PCI DMA mapping and failure to check return
	values on the mappings.

	Make the check for space in the ring buffer happen after the DMA mapping
	is done since any checks done before the mapping has taken place are
	bogus.

5) Remove /proc support.


Other patches in the queue:

a) Complete fc_host attributes support.

b) Support new queue-depth operations (via change_queue_depth()).

c) additional hardware (ISP) support.

d) Additional dusting and scrubbing: unused functions and structures
   left over from the cleanup.

e) firmware loading via request_firmware() infrastructure.

f) lock simplification and consolidation.


Regards,
Andrew Vasquez
QLogic Corporation
