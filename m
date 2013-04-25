From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi_debug: fix data integrity support on highmem machine
Date: Wed, 24 Apr 2013 22:13:18 -0400
Message-ID: <yq11u9ztl1d.fsf@sermon.lab.mkp.net>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
	<1366535879-20775-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27129 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3DYCND (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 22:13:03 -0400
In-Reply-To: <1366535879-20775-2-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Sun, 21 Apr 2013 18:17:57 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> kmap_atomic() is now using stack based implementation and
Akinobu> doesn't take the KM_type argument anymore.  So nesting
Akinobu> kmap_atomic() calls must be properly stacked.

Akinobu> This fixes nesting kmap_atomic() calls for scsi_sglist and
Akinobu> scsi_prot_sglist in prot_verify_write().

I don't see how the prog_sglist is incorrectly nested? Also, with your
code you also end up mapping and unmapping the protection page for every
data segment. The two scatterlists have different cadence.


Akinobu> This also fixes another issue that invalid kmap address is used
Akinobu> for kunmap_atomic(): the kmap address 'daddr' is incremented in
Akinobu> the loop for each data page, and it can reach the next page
Akinobu> boundary.

That fix is fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
