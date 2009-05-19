From: michaelc@cs.wisc.edu
Subject: RFC: handle queue_depth adjustments because of QUEUE_FULLs in scsi_error.c
Date: Tue, 19 May 2009 00:52:42 -0500
Message-ID: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57025 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZESFws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 01:52:48 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4J5qnm6002718
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 01:52:49 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4J5qnRu005786
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 01:52:49 -0400
Received: from localhost.localdomain (vpn-12-139.rdu.redhat.com [10.11.12.139])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4J5qmZB008403
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 01:52:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches were made over scsi-rc-fixes. They are only a RFC.

This is the first step to moving the QUEUE_FULL and then the
ramp up code from drivers like qla2xxx and lpfc to scsi-ml.
In the patches I am using the change_queue_depth callback
to allow the drivers to adjust the queue depth, so LLDs do
not have to worry about parsing the sense.

If these patches are ok, then we can move the ramp up code
from qla2xxx and lpfc to scsi-ml. I was planning on using
the change_queue_depth callback for this by calling it
with the SCSI_QDEPTH_RAMP_UP reason.


Note:

I did not convert the non fc drivers that were only calling
scsi_track_queue_full and did not have a change_queue_depth callback.
I think the behavior would be slightly different so I did not want to
mess with them. The patches I am sending will work fine if we
leave these drivers a long and only convert newer drivers.

mpt2sas was an exception where it is a newer driver and had
a change_queue_depth callback but I did not convert it. I wll
work on this one some more if this patchset is ok.


