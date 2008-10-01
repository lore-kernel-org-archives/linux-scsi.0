From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/5] block: remove end_{queued|dequeued}_request()
Date: Wed, 01 Oct 2008 10:09:42 -0400 (EDT)
Message-ID: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYJAOOE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2008 10:14:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi Jens,

This patch-set removes end_queued_request() and end_dequeued_request(),
which became identical by the blk_end_request patch-set:
    http://marc.info/?l=linux-kernel&m=119741306502719&w=2

They just calls __blk_end_request() actually, so users of them are
converted to call __blk_end_request() directly.
There should be no functional change.

This patch-set was created on top of the commit below of for-2.6.28.
---------------------------------------------------------------------
commit e857b07acc3f1352224f380fcbf26ef985116cc8
Author: Sven Schuetz <sven@linux.vnet.ibm.com>
Date:   Fri Sep 26 10:58:02 2008 +0200

    include blktrace_api.h in headers_install
---------------------------------------------------------------------

end_request() could be also removed, but it has been used by
many old drivers and auditing all such codes will take a time.
So this patch-set doesn't remove end_request().

Please review and apply.

Thanks,
Kiyoshi Ueda
