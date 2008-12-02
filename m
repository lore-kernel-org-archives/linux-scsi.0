From: michaelc@cs.wisc.edu
Subject: iscsi update for 2.6.29
Date: Tue,  2 Dec 2008 00:32:03 -0600
Message-ID: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52378 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbYLBGcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:19 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mB26WJ8s020074
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2008 01:32:19 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB26WIsE024872
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2008 01:32:18 -0500
Received: from localhost.localdomain (vpn-12-47.rdu.redhat.com [10.11.12.47])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mB26WH78001031
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2008 01:32:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patchset is for 2.6.29. This should be the final patches
to prepare the iscsi layer for cxgb3i, which looks like it
has gone through the netdev review and will be sent here next
shortly.

This patchset was made over scsi-misc, and the fix here.
http://marc.info/?l=linux-scsi&m=122815519326207&w=2
(the fix in that email does not conflict with this patchset
and can be applied over or before these patches).

cxgb3i adds a new offload model. Where qla4xxx offloaded pretty
much everything, and bnx2i offloaded the iscsi sequence processing
(give it the iscsi scsi command pdu and the offload engine will
handle everything between), cxgb3i offloads operations like
digest, padding, and data transfers. It relies on the iscsi layer
for the sequence state machine, so this patchset is basically
just breaking up iscsi_tcp into a lib layer so cxgb3i can share
the code.



