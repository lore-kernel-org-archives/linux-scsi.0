From: Brian King <brking@linux.vnet.ibm.com>
Subject: mpt2sas DMA mask
Date: Tue, 12 May 2015 17:07:36 -0500
Message-ID: <555279A8.6060906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:50521 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbbELWHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 18:07:41 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 12 May 2015 16:07:41 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 28CE01FF0023
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 15:58:49 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4CM7c0053608454
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 15:07:38 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4CM7cqo001526
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 16:07:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>

The mpt2sas driver was changed late last year in that it now requests a 64 bit DMA
mask, then requests a 32 bit coherent DMA mask, then later requests a 64 bit coherent
DMA mask. This was 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c. This breaks 64 bit DMA
support for mpt2sas on Power and we always fall back to using 32 bit DMA. Looking
at the commit log, it looks like this was an intentional change.

Ben - you had a patch set you had posted to the list back in Feb of this year, but it
doesn't look like it got merged. 

https://lists.ozlabs.org/pipermail/linuxppc-dev/2015-February/125087.html

This would fix the issue I'm seeing on mpt2sas. Do you plan to dust that patch set
off and upstream it? Were there issues with it that still need to be resolved?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


