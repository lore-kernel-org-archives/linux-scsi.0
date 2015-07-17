From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] Using the local variable instead of I/O flag to acquire io_req_lock in fnic_queuecommand() to avoid deadloack
Date: Thu, 16 Jul 2015 21:56:02 -0400
Message-ID: <yq1pp3rmtsd.fsf@sermon.lab.mkp.net>
References: <1436882937-11741-1-git-send-email-hishah@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19124 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbGQB4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2015 21:56:11 -0400
In-Reply-To: <1436882937-11741-1-git-send-email-hishah@cisco.com> (Hiral
	Shah's message of "Tue, 14 Jul 2015 07:08:57 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Shah <hishah@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

>>>>> "Hiral" == Hiral Shah <hishah@cisco.com> writes:

Hiral> We added changes in fnic driver patch 1.6.0.16 to acquire
Hiral> io_req_lock in fnic_queuecommand() before issuing I/O so that io
Hiral> completion is serialized. But when releasing the lock we check
Hiral> for the I/O flag and this could be modified if IO abort occurs
Hiral> before I/O completion. In this case we wont release the lock and
Hiral> causes deadlock in some scenerios. Using the local variable to
Hiral> check the IO lock status will resolve the problem.

Maybe bool instead of int?

Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
