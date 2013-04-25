From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] scsi_debug: call map_region() and unmap_region() only when needed
Date: Wed, 24 Apr 2013 21:59:51 -0400
Message-ID: <yq18v47tlns.fsf@sermon.lab.mkp.net>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	<1366117920-11740-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23834 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab3DYB7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:59:40 -0400
In-Reply-To: <1366117920-11740-2-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Tue, 16 Apr 2013 22:11:55 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> If the logical block provisioning is not enabled, map_region()
Akinobu> and unmap_region() have no effect and they don't need to be
Akinobu> called.

Akinobu> So this makes map_region() and unmap_region() to be called only
Akinobu> when scsi_debug_lbp() returns true, i.e. logical block
Akinobu> provisioning is enabled.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>


Akinobu> Because scsi_debug_unmap_granularity cannot be zero with usual
Akinobu> setting: scsi_debug_unmap_granularity is 1 by default, and it
Akinobu> can be changed to zero with explicit module parameter setting
Akinobu> only when the logical block provisioning is disabled.  But it
Akinobu> is only meaningful module parameter when the logical block
Akinobu> provisioning is enabled.

As you have found out, I generally allow module parameter values and
combinations thereof that do not make strict sense. That's because the
main reason for adding these parameters in the first place is to test
the block and SCSI layer code that queries them. scsi_debug is a test
vehicle and being able to simulate a device with broken reporting is
something I use a lot.

That said, I don't think we have any test scripts that actually depend
on this combination of unmap parameters so I'm ok with you cleaning them
up.

-- 
Martin K. Petersen	Oracle Linux Engineering
