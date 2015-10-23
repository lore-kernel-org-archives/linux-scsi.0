From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v6 32/37] cxlflash: Fix to avoid potential deadlock on EEH
Date: Fri, 23 Oct 2015 16:01:13 +0200
Message-ID: <562A3DA9.4070904@redhat.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458552-61150-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbbJWOBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 10:01:17 -0400
In-Reply-To: <1445458552-61150-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 21.10.2015 22:15, Matthew R. Ochs wrote:
> Ioctl threads that use scsi_execute() can run for an excessive amount
> of time due to the fact that they have lengthy timeouts and retry logic
> built in. Under normal operation this is not an issue. However, once EEH
> enters the picture, a long execution time coupled with the possibility
> that a timeout can trigger entry to the driver via registered reset
> callbacks becomes a liability.
>
> In particular, a deadlock can occur when an EEH event is encountered
> while in running in scsi_execute(). As part of the recovery, the EEH
> handler drains all currently running ioctls, waiting until they have
> completed before proceeding with a reset. As the scsi_execute()'s are
> situated on the ioctl path, the EEH handler will wait until they (and
> the remainder of the ioctl handler they're associated with) have
> completed. Normally this would not be much of an issue aside from the
> longer recovery period. Unfortunately, the scsi_execute() triggers a
> reset when it times out. The reset handler will see that the device is
> already being reset and wait until that reset completed. This creates
> a condition where the EEH handler becomes stuck, infinitely waiting for
> the ioctl thread to complete.
>
> To avoid this behavior, temporarily unmark the scsi_execute() threads
> as an ioctl thread by releasing the ioctl read semaphore. This allows
> the EEH handler to proceed with a recovery while the thread is still
> running. Once the scsi_execute() returns, the ioctl read semaphore is
> reacquired and the adapter state is rechecked in case it changed while
> inside of scsi_execute(). The state check will wait if the adapter is
> still being recovered or returns a failure if the recovery failed. In
> the event that the adapter reset failed, the failure is simply returned
> as the ioctl would be unable to continue.
>
> Reported-by: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

