From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: end to end error recovery musings
Date: Wed, 28 Feb 2007 12:27:23 -0500
Message-ID: <yq1tzx642h0.fsf@sermon.lab.mkp.net>
References: <664A4EBB07F29743873A87CF62C26D705D7112@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:61136 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161AbXB1R2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Feb 2007 12:28:03 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D705D7112@NAMAIL4.ad.lsil.com> (Eric Moore's message of "Wed, 28 Feb 2007 08:19:17 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:

[Trimmed the worldwide broadcast CC: list down to linux-scsi]

Eric> I from the scsi lld perspective, all we need 32 byte cdbs, and a
Eric> mechinism to pass the tags down from above.  

Ok, so your board only supports Type 2 protection?


Eric> It appears our driver to firmware insterface is only providing
Eric> the reference and application tags. 

My current code allows the submitter to specify which tags are valid
between the OS and the HBA.  Your inbound scsi_cmnd will have a 
protection_tag_mask which tells you which fields are provided.

Similarly, there's a mask in scsi_host which allows the HBA to
identify which protection types it supports.  I hadn't envisioned that
an HBA might only provide a subset.  I'll ponder a bit.


Eric> I assume that for transfers greater than a sector, that the
Eric> controller firmware updates the tags for all the other sectors
Eric> within the boundary.  

In other words you only support one app tag per request and not per
sector?

-- 
Martin K. Petersen	Oracle Linux Engineering

