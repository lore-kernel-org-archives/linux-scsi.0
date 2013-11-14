From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
Date: Wed, 13 Nov 2013 22:15:22 -0800
Message-ID: <1384409722.2062.4.camel@dabdike.int.hansenpartnership.com>
References: <cover.1384304973.git.decot@googlers.com>
	 <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
	 <52836B53.4080204@acm.org>
	 <CAG88wWa-U5LoXOvBb+eOAutidgV-cyteQ5aS5EQKDkswSJnH-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43701 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab3KNGPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Nov 2013 01:15:24 -0500
In-Reply-To: <CAG88wWa-U5LoXOvBb+eOAutidgV-cyteQ5aS5EQKDkswSJnH-w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Decotigny <decot@googlers.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, 2013-11-13 at 18:50 -0800, David Decotigny wrote:
> Hello,
> 
> Thank you for looking into this. I could reproduce the oops on some
> Dell Poweredge R720 with the following config flags, otherwise the
> problem goes un-noticed:
> 
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_DEBUG_SLAB=y
> 
> [    4.924033] BUG: unable to handle kernel paging request at ffff88000004dd10
> [    4.931823] IP: [<ffffffff8139797f>] __scsi_scan_target+0x3ef/0x6f0
> [    4.938846] PGD 1ba1067 PUD 1ba2067 PMD 1ba3067 PTE 800000000004d060
> [    4.945985] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    4.951074] Modules linked in:
> [    4.954492] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-smp-scsi01 #1
> 
> This points to this line on the return path of scsi_report_lun_scan:
> if (scsi_device_created(sdev))
> 
> Kernel is jejb/scsi/for-next at 2aee240c68ed32 and I could reproduce
> the bug with other 3.x kernels on same hardware. For me, it is 100%
> reproducible.
> 
> The ref counter values I indicated in my previous email are the result
> of a basic instrumentation. It shows that ref count drops from 3 to 1
> as a result of scsi_probe_and_add_lun(). I believe this is because the
> latter calls __scsi_remove_device(sdev).
> 
> Now, if sdev reclaiming is not allowed to happen at the end of
> scsi_report_lun_scan by design because someone else is expected to
> hold a reference to it, then I'd be happy to add a BUG_ON() on the
> return path and explicit the post-condition in the function
> documentation, and also try to find out where a ref is killed by
> mistake. However, if sdev relcaiming at the end of
> scsi_report_lun_scan is allowed, then I'd argue that the "if
> (scsi_device_created(sdev))" on the potentially reclaimed sdev is not
> right, that's why I was proposing this patch.

Heh, perhaps this is why bug reports are so useful.  Your patch told me
where you thought the bug was but this report actually tells me where
the bug is: it's in scsi_probe_and_add_luns().  There's no way that
routine should reduce the refcount of a struct scsi_device.  It should
either leave it as it is, or if an sdevp is specified, increment the
reference and return the sdev in sdevp.  This should be enough
information for you to come up with the fix.  Please document it with
the actual bug details like you have above and I'll apply it.

James


