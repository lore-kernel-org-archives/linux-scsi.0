From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: Fix double-free when drives detach during SG_IO
Date: Mon, 02 Nov 2015 23:52:23 -0500
Message-ID: <yq1ziyv3cs8.fsf@sermon.lab.mkp.net>
References: <944215ec334c3c5b3af98210acf8f6479f5539c8.1445634103.git.calvinowens@fb.com>
	<5637CE3F.6020706@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45986 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbbKCEwe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 23:52:34 -0500
In-Reply-To: <5637CE3F.6020706@interlog.com> (Douglas Gilbert's message of
	"Mon, 2 Nov 2015 21:57:35 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Calvin Owens <calvinowens@fb.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

>> In sg_common_write(), we free the block request and return -ENODEV if
>> the device is detached in the middle of the SG_IO ioctl().
>> 
>> Unfortunately, sg_finish_rem_req() also tries to free srp->rq, so we
>> end up freeing rq->cmd in the already free rq object, and then free
>> the object itself out from under the current user.
>> 
>> This ends up corrupting random memory via the list_head on the rq
>> object. The most common crash trace I saw is this:

>> Signed-off-by: Calvin Owens <calvinowens@fb.com>

Doug> Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
