From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] scsi: rescan VPD attributes
Date: Thu, 26 Nov 2015 05:07:01 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444E0362@G4W3219.americas.hpqcorp.net>
References: <1447071868-8509-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:41427 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbKZFIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2015 00:08:04 -0500
In-Reply-To: <1447071868-8509-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.Petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>

Hi Hannes,

I have one probably small nitpick about the patch. I'm not sure how likely what I've put below is likely to happen in real life though.

Is there any chance at all that sdev->vpd_pg83_len could change when updated? If there's any chance of that I'd have expected that both the length of and the pointer to the vpd data would need to be protected not just the pointer so someone would have a consistent picture of the vpd and its length. Without that there is a race where someone could be using a new length with the old vpd data. That leaves the potential for a length that exceeds the vpd size if the new data is larger than the old data - I don't know how likely it is but wanted to at least bring it up as something to consider. 

I'm not so concerned about sdev->vpd_pg80_len changing since it should have 1 of 2 fixed sizes and it seems unlikely that once read the first time a device would increase it in size (but for consistency in the code if you make a change you might want to treat them the same way).

Thanks
Shane
