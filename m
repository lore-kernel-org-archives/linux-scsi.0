From: michaelc@cs.wisc.edu
Subject: RESEND: iscsi update for 2.6.25
Date: Thu, 13 Dec 2007 12:43:19 -0600
Message-ID: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbXLMSns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:43:48 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lBDIhmHE005433
	for <linux-scsi@vger.kernel.org>; Thu, 13 Dec 2007 13:43:48 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lBDIhlWx017947
	for <linux-scsi@vger.kernel.org>; Thu, 13 Dec 2007 13:43:47 -0500
Received: from localhost.localdomain (vpn-15-132.rdu.redhat.com [10.11.15.132])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lBDIhicA022285
	for <linux-scsi@vger.kernel.org>; Thu, 13 Dec 2007 13:43:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Between the time I made my last patchset and when James rebased
scsi-misc a patch to scsi_transport_iscsi.c got merged and that
broke my patchset. This is a resend of the patchset, but rebased
against scsi-misc.

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


