From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Thu, 05 Apr 2012 16:29:35 -0500
Message-ID: <4F7E0EBF.80407@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34482 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2DEV3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2012 17:29:33 -0400
In-Reply-To: <4F7DDDCC.1070506@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/05/2012 01:00 PM, Bart Van Assche wrote:
> On 04/05/12 13:58, Tomas Henzl wrote:
> 
>> When a rmmod is tried then in some cases the kernel is not able to handle a paging request:
>> [  727.154296] BUG: unable to handle kernel paging request at ffffffffa01874b8
>> From what I observerved it happens when when we call the rmmod only a while after a modprobe
>> (in this case it is the mpt2sas driver). More accurately said, it happens when rmmod is called
>> while scsi async is still at work. The driver is removed but the scsi_host_template is still filled
>> with now invalid pointers, in this case it is most likely the hostt->scan_finished which causes the BUG.
> 
> 
> Are you sure the above analysis is correct ? I've triggered several
> million device removal events with ib_srp but I haven't ever seen the
> above crash.

ib_srp uses scsi_scan_target when the target is added so you are going
down a different code path. If you are rmmoding ib_srp while the driver
is calling scsi_scan_target() that would be a similar problem.

Tomas's bug occurs when drivers use scsi_scan_host, use the async scsi
device scanning, and then rmmod the LLD while the scan is still in progress.

I think a general problem that we might hit similar to Tomas's issue is
when scanning from userspace then rmmoding the driver. Maybe that means
we need a more generic fix? Or, maybe that could be handled by having
scsi_scan() do a try_module_get before scanning.
