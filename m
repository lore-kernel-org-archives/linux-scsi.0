From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 12:22:26 -0500
Message-ID: <4F7F2652.8030306@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org> <4F7E0EBF.80407@cs.wisc.edu> <4F7EB658.9060109@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35841 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab2DFRWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 13:22:36 -0400
In-Reply-To: <4F7EB658.9060109@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/06/2012 04:24 AM, Bart Van Assche wrote:
> On 04/05/12 21:29, Mike Christie wrote:
> 
>> Tomas's bug occurs when drivers use scsi_scan_host, use the async scsi
>> device scanning, and then rmmod the LLD while the scan is still in progress.
>>
>> I think a general problem that we might hit similar to Tomas's issue is
>> when scanning from userspace then rmmoding the driver. Maybe that means
>> we need a more generic fix? Or, maybe that could be handled by having
>> scsi_scan() do a try_module_get before scanning.
> 
> That suggestion certainly makes sense to me. But Tomas' approach has the
> advantage that it guarantees that scanning will have finished once
> scsi_remove_hosts() returned and hence has less potential for triggering
> race conditions than an approach based on try_module_get().

Tomas's approach works when scsi_scan_host and the async scsi scanning
is used. However, I was saying that I think we have a 2nd problem that
is similar to Tomas's issue but initiated from a different path and will
bypass Tomas's checks. The host async scanning code does not come into
play when scanning from userspace. In the user scan case we could end up
having:

1. A transport class or scsi_sysfs.c initiate a scan.
2. A user could rmmod the LLD.
3. The LLD will call the transport remove host if there is one and then
scsi_remove_host.

Note that for fc_remove_host there are checks to flush the scanning
workqueue but we will bypass the scan workqueue flush checks since for
this case we are scanning from the user thread and not from the host's
workqueue the fc classes normally uses for scanning.
4. scsi_remove_host would move right past Tomas's code, because the user
initiated scan does not set any of those host async bits Tomas's is
checking.
5. The LLD would then get removed and we would hit the same problem
Tomas's described where the scanning code is now accessing invalid
scsi_host_template fields.
