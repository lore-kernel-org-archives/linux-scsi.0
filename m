From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 0/7] mptfusion static checker fixups
Date: Wed, 4 Jun 2014 12:49:42 -0400
Message-ID: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:47861 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFDQuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:50:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

While reviewing the mpt2/mpt3 static checker fixup patchset, Christoph
inquired about mptfusion.  None of the sparse / smatch warnings from the
earlier patchset directly apply to fusion, but there were a few easy to
fix warnings (compile tested only).

The patchset is ordered from the smallest/easiest change up to the last
three, which are bit more involved and should be reviewed by LSI,
especially the last one "mptfusion: tweak null pointer checks".  See the
commentary in those patches after the signed-off-by line.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Joe Lawrence (7):
  mptfusion: mark file-private functions as static
  mptfusion: remove redundant kfree checks
  mptfusion: initChainBuffers should return errno
  mptfusion: zero kernel-space source of copy_to_user
  mptfusion: make adapter prod_name[] a pointer
  mptfusion: combine fw_event_work and its event_data
  mptfusion: tweak null pointer checks

 drivers/message/fusion/mptbase.c  |   29 +++++++++----------
 drivers/message/fusion/mptbase.h  |    2 +-
 drivers/message/fusion/mptctl.c   |    2 +-
 drivers/message/fusion/mptfc.c    |    3 +-
 drivers/message/fusion/mptsas.c   |   57 +++++++++++++++++++------------------
 drivers/message/fusion/mptsas.h   |    2 +-
 drivers/message/fusion/mptscsih.c |    7 +++--
 drivers/message/fusion/mptspi.c   |    5 ++--
 8 files changed, 52 insertions(+), 55 deletions(-)

-- 
1.7.10.4

