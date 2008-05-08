From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes for 2.6.26
Date: Wed,  7 May 2008 20:43:51 -0500
Message-ID: <1210211032-4590-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbYEHBnz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 21:43:55 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m481hsMH001176
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 21:43:54 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m481hriH022012
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 21:43:53 -0400
Received: from localhost.localdomain (vpn-14-9.rdu.redhat.com [10.11.14.9])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m481hrFJ003210
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2008 21:43:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patch fixes a bug in the iscsi nop processing.
The target sends iscsi nops to ping the initiator and the
initiator has to send nops to reply and can send nops to
ping the target.

In 2.6.25 we moved the nop processing to the kernel to handle
problems when the userspace daemon is not up, but the target
is pinging us, and to handle when scsi commands timeout, but
the transport may be the cause (we can send a nop to check
the transport). When we added this code we added a bug where
if the transport timer wakes at the exact same time we are supposed to check
for a nop timeout we drop the session instead of checking the transport.

The patch was made over scsi-misc.


