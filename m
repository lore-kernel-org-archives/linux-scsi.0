From: michaelc@cs.wisc.edu
Subject: [RFC] FC class: misc fixes
Date: Thu, 23 Sep 2010 00:17:18 -0500
Message-ID: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab0IWFL3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:29 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8N5BTqO000649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2010 01:11:29 -0400
Received: from meanminna.corp.redhat.com (vpn-11-160.rdu.redhat.com [10.11.11.160])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8N5BSGO021116
	for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2010 01:11:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix some FC issues I have found
while doing some testing and porting the code.

The first issue is that there seem to be some races
in the fc_remote_port_add and dev_loss_tmo handling.
Those are fixed with the first two patches:

[RFC PATCH 1/7] fc class: fix rport re-add dev_loss handling race
[RFC PATCH 2/7] fc class: remove fc_flush_work in fc_remote_port_add

The second issue is that there seems to be a race
with fc_block_scsi_eh and the terminate_rport_io
callback. This is fixed with:

[RFC PATCH 3/7] scsi error: rename FAST_IO_FAIL to TRANSPORT_FAILED
[RFC PATCH 4/7] fc class: don't return from fc_block_scsi_eh until IO has been cleaned up

And then I added support for fc_block_scsi_eh to
the remaining fc drivers that implement the terminate_port_io
callback:
[RFC PATCH 5/7] libfc: hook scsi eh into fc_block_scsi_eh
[RFC PATCH 6/7] fnic: hook scsi eh into fc_block_scsi_eh
[RFC PATCH 7/7] qla2xxx: hook scsi eh into fc_block_scsi_eh

The patches were made over scsi-misc.
