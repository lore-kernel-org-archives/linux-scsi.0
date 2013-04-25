From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
Date: Wed, 24 Apr 2013 22:29:56 -0400
Message-ID: <yq1sj2fs5p7.fsf@sermon.lab.mkp.net>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
	<1366535879-20775-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31290 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3DYC3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 22:29:43 -0400
In-Reply-To: <1366535879-20775-3-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Sun, 21 Apr 2013 18:17:58 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> The protection info dif_storep is allocated only when parameter
Akinobu> dif is not zero.  But it will be accessed when reading or
Akinobu> writing to the storage installed with parameter dix is not
Akinobu> zero.

Akinobu> So kernel crashes if scsi_debug module is loaded with
Akinobu> parameters dix=1 and dif=0.

The full story is that scsi_debug does not support DIF and DIX correctly
by virtue of simultaneously being the HBA and the target. And since
there is no actual data transfer between the HBA and the target the
notion of DIF is weak at best.

I did look into making scsi_debug do the right thing but it's quite a
bit of code and I lost interest about halfway through the effort. If
you'd like to fix this properly I can probably find the patch to use as
baseline?

In this particular case I'm ok with your patch keying off of
scsi_debug_dix. But it's very important to me that I'm able to set
P_TYPE and the host protection mask as I see fit using the module
parameters. Even when the combination of options don't make strict
sense.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
