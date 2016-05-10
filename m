From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Tue, 10 May 2016 11:33:07 -0700
Message-ID: <57322963.7040507@sandisk.com>
References: <1461571293-953-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0094.outbound.protection.outlook.com ([157.56.110.94]:8656
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752214AbcEJSdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2016 14:33:16 -0400
In-Reply-To: <1461571293-953-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.orgEwan Milne <emilne@redhat.com>

On 04/25/2016 01:01 AM, Hannes Reinecke wrote:
> We cannot use an embedded mutex in a structure with reference
> counting, as mutex unlock might be delayed, and the waiters
> might then access an already freed memory area.
> So convert it to a spinlock.
 >
 > For details cf https://lkml.org/lkml/2015/2/11/245

Hello Hannes,

Is what you describe a theoretical concern or have you observed any 
issues that could have been caused by the rport mutex? I'm asking this 
because my interpretation of the thread you refer to is different. My 
conclusion is that it is safe to embed a mutex in a structure that uses 
reference counting but that the mutex_unlock() call may trigger a 
spurious wakeup. I think that the conclusion of that thread was that 
glibc and kernel code should tolerate such spurious wakeups.

Bart.
