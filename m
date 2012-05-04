From: michaelc@cs.wisc.edu
Subject: [PATCH 0/4] notify userspace of offline->running transitions
Date: Fri,  4 May 2012 05:23:20 -0500
Message-ID: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab2EDKX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:23:28 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q44ANSmU022419
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 4 May 2012 06:23:28 -0400
Received: from meanminna.corp.redhat.com (vpn-11-171.rdu.redhat.com [10.11.11.171])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q44ANR9f013949
	for <linux-scsi@vger.kernel.org>; Fri, 4 May 2012 06:23:27 -0400
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


