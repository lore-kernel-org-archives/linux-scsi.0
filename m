From: michaelc@cs.wisc.edu
Subject: iscsi update for 2.6.25
Date: Tue,  4 Dec 2007 18:42:14 -0600
Message-ID: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbXLEAmr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:42:47 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB50gk28011401
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 19:42:46 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB50gk11023681
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 19:42:46 -0500
Received: from localhost.localdomain (vpn-14-127.rdu.redhat.com [10.11.14.127])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB50ghqO005879
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 19:42:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patchset was made over scsi-rc-fixes (it also applies to Linus's git
tree). It will not apply over scsi-misc, because there are some patches
which went into scsi-rc-fixes/2.6.24-rc4 and scsi-misc has not been updated
for the scsi-rc-fixes patches.

Sorry for the bigger than normal update. There are patches from Olaf and
Boaz which do the following:

- Rewrite iscsi_tcp data path (from Olaf), so we do not have two ulgy
abstractions for the send and recv path. Now we have one nice iscsi_segment
struct that works for both paths.
- Add basic iscsi spec handling we will need for Bidi support (from Boaz).
This does not add bidi support. It just adds code that is common.
- Device reset support. Some clustering software needed at least
device reset support, so I cleaned up that code and added device
logical unit reset support. I will add warm target reset support
later.
- Lots of fixes for things like shutdown, r2t leaks, and lots of clean
up from Olaf.
- sg chaining support.


