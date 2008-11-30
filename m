From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 00/11] st: remove scsi_execute_async usage (the first half)
Date: Sun, 30 Nov 2008 17:07:54 +0900
Message-ID: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38562 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYK3IRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:17:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This patchset removes the majority of scsi_execute_async in st
driver. IOW, this converts st driver to use the block layer functions.

We are in the process of removing scsi_execute_async and
scsi_req_map_sg. scsi_execute_async in sg driver were removed in
2.6.27. Now only st and osst drivers use scsi_execute_async().

st driver uses scsi_execute_async for two purposes, performing sort
management SCSI commands internally and data transfer between user and
kernel space (st_read and st_write). This patchset converts the
former.

The former performs SCSI commands synchronously. It uses a liner
in-kernel buffer (not scatter gather) for data transfer. To perform
such commands, other upper layer drivers (e.g. sd) use
scsi_execute_req (internally uses blk_rq_map_kern and and
blk_execute_rq). scsi_execute_req is not fully fit for st so I adds a
helper function similar to scsi_execute_req and replace
scsi_execute_async in st driver (I might modify scsi_execute_req for
st and remove the helper function later).

I'm still working on converting scsi_execute_async for data transfer
between user and kernel space but I want to get this first half be
merged.

Thanks,


