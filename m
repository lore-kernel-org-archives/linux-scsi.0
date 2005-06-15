From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 10:34:52 -0500
Message-ID: <42B04A9C.7050503@us.ibm.com>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com> <1118849292.5045.27.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:47490 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261181AbVFOPez
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 11:34:55 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5FFYs9q756890
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 11:34:54 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5FFYspl239410
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 09:34:54 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5FFYr81032480
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 09:34:53 -0600
In-Reply-To: <1118849292.5045.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

James Bottomley wrote:
> On Wed, 2005-06-15 at 10:15 -0500, brking@us.ibm.com wrote:
> 
>>Haren found this in some recent kexec testing. Without this fix, the
>>ipr adapter's write cache never gets flushed. I'd like to see this
>>pushed into 2.6.12 if possible.
> 
> 
> Just out of curiosity, what are you doing with the SYNCHRONIZE_CACHE
> that comes down from sd on shutdown?

For scsi disks attached to an ipr adapter, the SYNCHRONIZE_CACHE command
gets sent to the disk and works just like when attached to any other
HBA. The ipr disk array devices, however, do not support the SYNC_CACHE command,
nor do they support the caching mode page, so SYNC_CACHE never gets sent.
So, the shutdown hook is needed to flush the adapter's battery backed write
cache for all attached disk arrays on system shutdown.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
