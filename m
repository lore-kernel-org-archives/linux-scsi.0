From: michaelc@cs.wisc.edu
Subject: iscsi update for 2.6.27
Date: Wed, 21 May 2008 15:53:55 -0500
Message-ID: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936601AbYEUUy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:28 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4LKsSDg017705
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2008 16:54:28 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4LKsLxi016978
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2008 16:54:22 -0400
Received: from localhost.localdomain (vpn-14-6.rdu.redhat.com [10.11.14.6])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4LKsLoe011907
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2008 16:54:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches were made over scsi-rc-fixes but are for 2.6.27.
There are features and cleanups so this should not go into 2.6.26.
I could not make them over scsi-misc because scsi-rc-fixes (and linus's
tree) has some bug fixes that went into 2.6.26-rc3 and scsi-misc is
based on a older 2.6.26.rc.

These patches do a lot of cleanup in prepartion for braodcom, but
this batch of patches are good for iscsi_tcp and iser so I sending
them now. They include patches to do the following:
- fix the dma_mask for iser (bnx2i would have had a similar problem)
- modify libiscsi so you do not have to use a workqueue to send IO
(offload cards can send from queuecommand context), 
- merges a lot of duplicated code and structs.

This also includes from cleanup patches from Harvey Harrison. It does
include the patch from Boaz since I goofed and forgot that we were
going to cleanup the iscsi_ecdb_ahdr 260 hardcoding usage and Boaz and James
are discussing where to define that. That can go in later when Boaz is
ready and those issues are resolved.



