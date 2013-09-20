From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/5] scsi_debug: avoid partial copying PI from prot_sglist to dif_storep
Date: Fri, 20 Sep 2013 18:23:06 -0400
Message-ID: <yq11u4jf7zp.fsf@sermon.lab.mkp.net>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
	<1379507248-15929-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29445 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITWXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:23:14 -0400
In-Reply-To: <1379507248-15929-4-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Wed, 18 Sep 2013 21:27:26 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> If data integrity support is enabled, prot_verify_write() is
Akinobu> called in response to WRITE commands and it verifies protection
Akinobu> info from prot_sglist by comparing against data sglist, and
Akinobu> copies protection info to dif_storep.

Akinobu> When multiple blocks are transfered by a WRITE command, it
Akinobu> verifies and copies these blocks one by one.  So if it fails to
Akinobu> verify protection info in the middle of blocks, the actual data
Akinobu> transfer to fake_storep isn't proceeded at all although
Akinobu> protection info for some blocks are already copied to
Akinobu> dif_storep.  Therefore, it breaks the data integrity between
Akinobu> fake_storep and dif_storep.

Akinobu> This fixes it by ensuring that copying protection info to
Akinobu> dif_storep is done after all blocks are successfully verified.
Akinobu> Reusing dif_copy_prot() with supporting the opposite direction
Akinobu> simplifies this fix.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
