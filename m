From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] bidi support
Date: Sat, 05 May 2007 18:02:29 +0900
Message-ID: <200705050902.l4592YeE009469@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:45214 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423160AbXEEJDk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 May 2007 05:03:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

This patchset add bidi support for block pc requests.

With Jens' linked request proposal, there aren't many changes to the
block layer, just adding one pointer (next_rq) to the request
structure. And there is no changes to the existing block-layer
functions. A bidi request uses two request structures (one in request
and one out request). The in request is linked and the out request is
en-queued.


We need some changes to the scsi mid-layer.

A new structure, scsi_data_buffer is introduced to hold the in-buffer
information.

With James' comments via IRC, we should not make the scsi_cmnd
structure fatter. So the scsi mid-layer uses req->next_rq->special
pointer for a scsi_data_buffer structure. LLDs don't touch the second
request (req->next_rq) so it's safe to use req->special. There is no
change to the scsi_cmnd structure.

The rest of changes include sgtable allocation and deallocation for
scsi_data_buffer in the block pc request path.


I created a new tree, including this patchset and bsg patches:

http://git.kernel.org/?p=linux/kernel/git/tomo/linux-2.6-bidi.git;a=summary

I modified and put Boaz's open-iscsi bidi patch in the tree so you can
test bidi requests via bsg.

I'll put the SMP pass through patches in the tree later.
