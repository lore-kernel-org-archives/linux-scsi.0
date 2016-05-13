From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Thu, 12 May 2016 22:32:23 -0400
Message-ID: <yq1a8jun0w8.fsf@sermon.lab.mkp.net>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
	<20160512040433.GA20240@ad.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16435 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbcEMCcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 22:32:33 -0400
In-Reply-To: <20160512040433.GA20240@ad.usersys.redhat.com> (Fam Zheng's
	message of "Thu, 12 May 2016 12:04:33 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

>>>>> "Fam" == Fam Zheng <famz@redhat.com> writes:

Fam,

Fam> This looks wrong to me, maybe I'm missing the obvious? Here sdkp->
Fam> opt_xfer_blocks is in block size unit, and rw_max is in byte sdkp->
Fam> unit.

Oh, joy. It's the commit that keeps on giving!

Back when the I/O topology was added we were set on eradicating block
layer sectors from the stack and count everything in bytes. So the new
fields were added as bytes but for various reasons the existing values
were never transitioned. And now we have an error prone interface. I
think that for 4.8 I'll fix this up properly. I'll post a fix for 4.7
and older tomorrow...

-- 
Martin K. Petersen	Oracle Linux Engineering
