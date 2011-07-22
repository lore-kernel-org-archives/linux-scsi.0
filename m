From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 00/10] create scsi bsg lib
Date: Fri, 22 Jul 2011 05:04:50 -0500
Message-ID: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab1GVKCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:08 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6MA28Ea022664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2011 06:02:08 -0400
Received: from meanminna.corp.redhat.com (vpn-8-191.rdu.redhat.com [10.11.8.191])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p6MA265H018270
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2011 06:02:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The iSCSI drivers want to use bsg for things like flash updates.
When people were sending patches for this, they were just
cutting and pasting the FC bsg code and renaming structs/functions,
so the following patches move the FC bsg code to a scsi lib.

The Qlogic developers and I have converted the FC drivers to the
new lib, but we have not tested all the driver specific patches
lately. In this sending we are more looking for comments
on the updated approach.

What has changed since the last posting is just that instead
of adding function pointers as args to a lot of the lib
functions we added some fields on the scsi transport template.
There is now 1 for queueing and 1 for timeout handling. It
seems cleaner this way.

The LLD code has not changed from my last posting, so hopefully if
the patches worked before they should still work.


