From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] scsi: smartpqi: Replace semaphore sync_request_sem with mutex
Date: Thu, 20 Oct 2016 11:06:58 +0200
Message-ID: <2193537.0Se2hussi4@wuerfel>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org> <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:57817 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbcJTJHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:07:16 -0400
In-Reply-To: <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thursday, October 20, 2016 2:24:01 PM CEST Binoy Jayan wrote:
> Semaphores are going away in the future, so replace the semaphore
> sync_request_sem with the a mutex lock. timeout_msecs is not used
> for the lock sync_request_sem, so remove the timed locking too.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>

The patch looks correct to me, but I think if you remove the support
for handling timeouts, you should update the prototype of
pqi_submit_raid_request_synchronous to no longer pass the timeout
argument in the first place.

	Arnd
