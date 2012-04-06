From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 18:37:23 +0000
Message-ID: <4F7F37E3.7000601@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org> <4F7E0EBF.80407@cs.wisc.edu> <4F7EB658.9060109@acm.org> <4F7F2652.8030306@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:39219 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab2DFSh2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 14:37:28 -0400
In-Reply-To: <4F7F2652.8030306@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/06/12 17:22, Mike Christie wrote:

> Tomas's approach works when scsi_scan_host and the async scsi scanning
> is used. However, I was saying that I think we have a 2nd problem that
> is similar to Tomas's issue but initiated from a different path and will
> bypass Tomas's checks. The host async scanning code does not come into
> play when scanning from userspace. In the user scan case we could end up
> having:
> 
> 1. A transport class or scsi_sysfs.c initiate a scan.
> 2. A user could rmmod the LLD.
> 3. The LLD will call the transport remove host if there is one and then
> scsi_remove_host.
> 
> Note that for fc_remove_host there are checks to flush the scanning
> workqueue but we will bypass the scan workqueue flush checks since for
> this case we are scanning from the user thread and not from the host's
> workqueue the fc classes normally uses for scanning.
> 4. scsi_remove_host would move right past Tomas's code, because the user
> initiated scan does not set any of those host async bits Tomas's is
> checking.
> 5. The LLD would then get removed and we would hit the same problem
> Tomas's described where the scanning code is now accessing invalid
> scsi_host_template fields.

Good catch. Has it already been considered to remove the sysfs scan (and
other) attributes explicitly from inside scsi_remove_host() ? As far as
I can see that would prevent this race to occur because it would force
scsi_remove_host() to wait until the scan that was triggered from user
space has finished. It would also prevent that other SCSI callbacks
could be triggered from user space after scsi_remove_host() finished and
before the associated devices are removed entirely.

Bart.
