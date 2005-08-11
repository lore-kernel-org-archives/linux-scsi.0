From: Harald Seipp <SEIPP@de.ibm.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 17:44:46 +0200
Message-ID: <OF8F47C8EA.7E82D4E6-ONC125705A.0053F6D2-C125705A.00567F16@de.ibm.com>
References: <1123771874.5062.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:3779 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S932188AbVHKPsf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 11:48:35 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7BFmYOA113582
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 15:48:34 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BFmXo2120908
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 17:48:33 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7BFmXVl021806
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 17:48:33 +0200
In-Reply-To: <1123771874.5062.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote on 11.08.2005 16:51:14:
> On Thu, 2005-08-11 at 16:32 +0200, Harald Seipp wrote:
> Not really.  We remove as much as we can and leave it up to the hotplug
> scripts to detach the mount point (any further I/O's will error).
>
> If there's a reattachment udev should identify the device (even if it's
> on a different node) and do the right thing.
>
> Essentially in 2.6 resolution of this problem is pushed up to the user
> as a policy decision.
>
Thank you for your quick responses! It finally looks like the task I need
to do - fully rescan all hosts for newly attached/changed devices - must
include the logic to skip devices with mounted fs for 2.6. This has been so
easy with 2.4...
I assume the right way would be to read the mounted fs from /etc/mtab,
identify the mounted partitions, track them back to the device Id/Lun's by
using the SCSI_IOCTL_GET_ID_LUN ioctl and put these devices into a
blacklist that will be excluded from remove-single-devices during the scan
process.
Can I rely on the mtab information? I recognized that e.g. submountd will
add permanent entries even when the devices are not present...
What about udev, devfsd, usbmount?

Harald Seipp
IBM Systems and Technology Group

