From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/3] zfcp FC BSG timeout fixes for 2.6.33-rc4
Date: Thu, 14 Jan 2010 17:18:59 +0100
Message-ID: <20100114161859.790342000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:52188 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0ANQdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 11:33:46 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id o0EGXj7G029176
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 16:33:45 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0EGXjbq1298600
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:45 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o0EGXiiW022360
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

Here is the patch series for the FC BSG timeout problem. It is based
on the initial proposal here:
http://marc.info/?l=linux-scsi&m=126043474110957&w=2

To summarize the problem and the approach taken: The block layer runs
a timer for each FC BSG request. When the timer expires, the LLD's
bsg_timeout function is called to abort the request.  With zfcp, the
hardware does not support aborting the CT or ELS request. Instead the
hardware runs an internal timer that is setup from Linux for each CT
and BSG request. When the request times out in the block layer, the
request data structures are destroyed. When the still pending hardware
request returns, it will access already freed memory.

The solution taken here is to add a special return code to the
bsg_timeout callback to indicate that the block layer timer should be
reset. zfcp uses this to prevent the block layer timeout. To return
the FC BSG request in the time requested by the user, the hardware
timer is setup with the timeout value from the FC BSG request.

The patches apply cleanly on top of 2.6.33-rc4 and the zfcp fixes
posted yesterday.

--
Christof Schmitt
