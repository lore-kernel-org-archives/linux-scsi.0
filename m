From: michaelc@cs.wisc.edu
Subject: [PATCH 0/4] notify userspace of offline->running transitions (v2)
Date: Thu, 17 May 2012 23:56:55 -0500
Message-ID: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2ERE5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 00:57:00 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4I4v0U9029488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 May 2012 00:57:00 -0400
Received: from meanminna.corp.redhat.com (vpn-10-170.rdu.redhat.com [10.11.10.170])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4I4uxam025664
	for <linux-scsi@vger.kernel.org>; Fri, 18 May 2012 00:56:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over the misc branch of the scsi tree.

The patches fix a issue where if the device is offlined or IO is
failed due to fast_io_fail (fc) /recovery_tmo (iscsi) then comes
back, apps do not have a way a nice way to figure out the state
has transitioned to running. Apps have to either poll the sysfs state
file or send a SG IO to figure it out. With the patch apps can listen
for the KOBJ CHANGE event like some of them (at least udev does) do
already.

v2:
- Rebased to misc.

