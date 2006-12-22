From: FUJITA Tomonori <tomof@acm.org>
Subject: SG v4 task tag
Date: Fri, 22 Dec 2006 13:47:41 +0900
Message-ID: <20061222134741J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:47427 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945928AbWLVErZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2006 23:47:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

The bsg tree has SG v4 basic support (Jens, thanks for merging the
patches). Next I try to add task tag support.

- LLDs use their own internal value (pointer, counter, etc) or the
  block tagging code for task tags.

- task tags need to be always unique (though they might be generated
  in kernel or specified by user space via SG v4).

If LLDs are going to be converted to use the block tagging code, then
we can narrow down the problems to the tag collision between
user-space and the block layer. But still I'm not sure how to
implement it nicely; sgv4 returns an assigned tag when user-space
submits a SCSI command (but SG_IO cannot handle this), exporting
available tags to user space somehow; reserving some tags for sg v4.

Suggestions?
