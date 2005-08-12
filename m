From: Harald Seipp <SEIPP@de.ibm.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Fri, 12 Aug 2005 10:59:00 +0200
Message-ID: <OFCC226E26.6AB4A1CD-ONC125705B.002B0769-C125705B.003158E2@de.ibm.com>
References: <OFB8A5D53D.2225FFAB-ON8825705A.00611D48-8825705A.0061B7F9@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:49820 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750709AbVHLJcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 05:32:18 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7C9WFxt104530
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 09:32:15 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7C9WEbN141482
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 11:32:15 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7C9WEMo026023
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 11:32:14 +0200
In-Reply-To: <OFB8A5D53D.2225FFAB-ON8825705A.00611D48-8825705A.0061B7F9@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> Don't use /etc/mtab.  Don't use it for anything if you can help it; it
was
> important technology in its day, but we can now go to the horse's mouth
--
> the kernel -- for that information.
> /proc/mounts will tell you what is really mounted.
But:
1. /proc/mounts hides the most important information - the physical device
of the root fs - it will always be /dev/root - so I don't see a way to get
down to the physical device
2. In my understanding, long-term-strategically procfs will only be used
for process information and all other information should be covered by
sysfs. So I doubt that using /proc/mounts will be a long-term solution
>
> As you mentioned in another posting, this isn't really the information
you
> want either -- you want to know if the SCSI disk is in use.  Being the
> device backing a conventional filesystem image is only one way a SCSI
disk
> might be in use.
For our usage, the device ref count information would be enough - we won't
care about the difference if the device is really mounted or if just one
process is sitting inside the sysfs tree of the device, we just would not
issue the remove-single-device to that device.

Harald Seipp
IBM Systems and Technology Group

