From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 00/10] sg buffer copy helper functions
Date: Sun,  9 Mar 2008 13:44:27 +0900
Message-ID: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47343 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYCIEq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Tony Luck <tony.luck@intel.com>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>, Ed Lin <ed.lin@promise.com>, Adam Radford <linuxraid@amcc.com>

This patchset adds new two helper functions to copy data between an SG
table and liner buffer, and converts severl LLDs to use them.

The new APIs are used mainly in the code to spoof SCSI commands
(INQUIRY, READ CAPACITY, MODE SENSE etc), that is, LLDs build a fake
reposense and copy it to the sg list in scsi_cmnd struct. Several LLDs
have similar functions for such code. This patchset removes such
duplication.

Another reason to do this work is that because we relaxed the default
alignment requirements (from 511 to 3) post 2.6.24, the above commands
might come with multiple scatter gather entries but several LLDs make
the assumption that such commands come with only one sg entries and
can't handle multiple sg entries. The new APIs can handle multiple sg
entries so LLDs don't need to care about anything.

The first patch adds the new APIs to lib/scatterlist.c and the rest
are for SCSI. I like to push the whole patchset via scsi-misc (since
it's easier).

This is against scsi-misc (a6680f71ca27ea78c4c4e577076aecb9ace476f1).

 arch/ia64/hp/sim/simscsi.c    |   23 ++--------
 drivers/scsi/3w-9xxx.c        |   21 ++++-----
 drivers/scsi/3w-xxxx.c        |   12 +----
 drivers/scsi/aacraid/aachba.c |   49 ++++++++--------------
 drivers/scsi/ips.c            |   50 ++++-------------------
 drivers/scsi/ps3rom.c         |   92 ++++------------------------------------
 drivers/scsi/scsi_debug.c     |   79 ++++++-----------------------------
 drivers/scsi/stex.c           |   66 ++++-------------------------
 include/linux/scatterlist.h   |    5 ++
 include/scsi/scsi_cmnd.h      |   14 ++++++
 lib/scatterlist.c             |   90 ++++++++++++++++++++++++++++++++++++++++
 11 files changed, 182 insertions(+), 319 deletions(-)


