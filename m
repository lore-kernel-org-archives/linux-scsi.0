From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/3] target/iscsi networkportal race fixes
Date: Fri, 24 Jan 2014 16:18:53 -0800
Message-ID: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaAYATL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 19:19:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

see https://bugzilla.redhat.com/show_bug.cgi?id=1055064

Summary: if thread doesn't run before 2nd identical portal is created,
it misses the existing one and the kernel_bind returns an error.

The first one-line patch fixes the issue for a single thread creating
multiple network portals via configfs.

The second two close the race between multiple threads creating
network portals.

Testing: failing test script now works.

Regards -- Andy

Andy Grover (3):
  target/iscsi: Set np_thread_state to ACTIVE before adding to
    g_np_list
  target/iscsi: Convert np_lock from a spinlock to a mutex
  target/iscsi: hold np_lock mutex across adding new net portal to
    g_np_list

 drivers/target/iscsi/iscsi_target.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

