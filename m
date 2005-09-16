From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/5] convert st and sg to always use scatterlists take 2
Date: Thu, 15 Sep 2005 23:39:31 -0500
Message-ID: <1126845571.9276.40.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35018 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751227AbVIPEjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 00:39:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

The following patches are a second (actually third if you count when I
tried to fixup all their duplicated code but broke a lot of features the
first time) try at converting sg and st to not use scsi_requests and
always use scatterlists.

It is not the grand cleanups I had hoped to do. It does allow us to
finish converting scsi-ml and LLDs without breaking anything though. It
is also a nice bit of cleanup for sg. I do hope to still move the the
ULDs to use the block layer blk_rq_map_user* functions for DIO and
copy_to/from_user cases so we can kill a lot of their code. And we
should be able to consolidate their buffer allocation code soon.

If these patches are ok, we just have to convert gdth, osst and cpqfc.

