From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: Replace semaphores with wait_even
Date: 24 Oct 2004 19:01:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098658889.10906.361.camel@mulgrave>
References: <1098300579.20821.65.camel@thomas>
	<1098647869.10824.247.camel@mulgrave>  <1098648414.22387.46.camel@thomas>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62614 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261612AbUJXXBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 19:01:50 -0400
In-Reply-To: <1098648414.22387.46.camel@thomas>
List-Id: linux-scsi@vger.kernel.org
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-10-24 at 16:06, Thomas Gleixner wrote:
> Hmm, strange. It works on two systems here and others using this
> modification had no problem either. 
> I will check again.

Yes, very strange given what the mistake is:

-               down_interruptible(&sem);
+               wait_event_interruptible(eh_wait, shost->eh_kill ||
+                               (shost->host_busy ==
shost->host_failed));

This condition is always true when the eh thread first starts because
the default quiescent state of a scsi host is

shost->host_busy = shost->host_failed = 0

so your change makes the eh_thread spin forever locking everything else
off the CPU.  On a UP system, this is a complete hang.

James


