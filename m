From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: aac_convert_sgraw2() masks -ENOMEM
Date: Tue, 08 Aug 2017 12:58:32 +0200
Message-ID: <87inhyqqav.fsf@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751464AbdHHK6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 06:58:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hey,

today, I have run smatch and it reports, that aac_convert_sgraw2()
returns -1 instead of -ENOMEM on kmalloc(). This is easy to fix, but
nobody tests what aac_convert_sgraw2() returns in aac_build_sgraw2()

Since commit 0b4334473d48 ("[SCSI] aacraid: SCSI dma mapping failure
case handling"), aac_build_sgraw2() should have better error propagation
in aac_{read,write}_raw_io().

The question is, that if it's intentional (and I hope it's not) or it's
just leftover fix?

-- 
Nikola
