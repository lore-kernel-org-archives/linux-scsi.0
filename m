From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Limit number of integrity segments
Date: Fri, 10 Sep 2010 01:32:08 -0400
Message-ID: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:27127 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab0IJFeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 01:34:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com
Cc: linux-scsi@vger.kernel.org


[My script defaulted to Jens' old address.  Sorry about the repost]

First patch moves min_not_zero() to kernel.h.  It's currently defined
several places throughout the block layer and I was about to introduce
another instance.  So let's make this generic.

Second patch works around the limitations in the zfcp hardware by
introducing a limit on the number of integrity scatterlist elements.
Christof will post a separate patch that updates the zfcp driver to take
advantage of this.

I'd prefer we if could feed everything, including the SCSI changes,
through the block tree.  I have had to change some existing interfaces
so a post-merge tree will not cut it and compatibility wrappers seem
like an overkill for this.

-- 
Martin K. Petersen      Oracle Linux Engineering
