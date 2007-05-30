From: michaelc@cs.wisc.edu
Subject: iscsi features bugfixes
Date: Wed, 30 May 2007 12:57:06 -0500
Message-ID: <11805478452886-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbXE3R51 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:27 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l4UHvRlG027424
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 13:57:27 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l4UHvQiW016320
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 13:57:26 -0400
Received: from localhost.localdomain (vpn-14-203.rdu.redhat.com [10.11.14.203])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l4UHvPfE014359
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 13:57:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made against scsi-misc. They contain fixes
and features including:

- Features:
1. Export sysfs values needed for OF/BIOS assisted iscsi boot.
2. Export sysfs values needed to be able to bind sessions to
a hba/port/NIC/netdev. This is needed for software iscsi so it can
bind a session to a netdevice and qla4xxx so it can bind sessions to 
a specific port, and will be used for broadcom management.
3. Add a host level set param event that works like the session level
one, so for qla4xxx we can set port values like ip address or
initiator name.
4. Not a feature, but some cleanups that are needed for bidi, but
are nice cleanups on their own.

- Fixes
1.  The send state machine was calculating the header wrong
when partially sending headers.
2. The cmdsn allocation could allocation and pdu transmit code
were racing which caused targets to drop sessions.
3. The xmitmutex use and transmit code were starving the mgmt queue,
so noops would timeout waiting to be sent or queued
4. FDs were being leaked
5. Padding was assumed to be in the same skb as the data/header.
This is the simple fix. We are working on merging Olaf's recv
path rewrite for the next patchset.



