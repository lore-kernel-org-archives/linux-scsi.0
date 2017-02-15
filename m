From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 10/16] aacraid: Terminate kthread on controller fw assert
Date: Wed, 15 Feb 2017 09:44:11 +0100
Message-ID: <9d502c4a-a3ad-352e-c3d0-2d08042c5f1b@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-11-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdBOIoO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:44:14 -0500
In-Reply-To: <20170214204446.14808-11-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> When the command thread performs a periodic time sync and the firmware is
> going through an assert during that time, the command thread waits for the
> response that would never arrive. The SCSI Mid layer's error handler would
> eventually reset the controller, but the eh_handler just issues a
> "thread stop" to the command thread which is stuck on a semaphore and the
> eh_thread would in turn goes to sleep waiting for the command_thread to
> respond to the stop which never happens.
> 
> Fixed by allowing SIGTERM for the command thread, and during the eh_reset
> call, sends termination signal to the command thread. As a follow-up, the
> eh_reset handler would take care of the controller reset.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---

This look a bit scary. Can't the kthread be converted to a workqueue so
we could call cancel_work_sync()?


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
