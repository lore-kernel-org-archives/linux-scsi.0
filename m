From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 11:54:02 +0200
Message-ID: <4F7EBD3A.8070509@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org> <4F7E0EBF.80407@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2DFJyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 05:54:14 -0400
In-Reply-To: <4F7E0EBF.80407@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/05/2012 11:29 PM, Mike Christie wrote:
> On 04/05/2012 01:00 PM, Bart Van Assche wrote:
>> On 04/05/12 13:58, Tomas Henzl wrote:
>>
>>> When a rmmod is tried then in some cases the kernel is not able to handle a paging request:
>>> [  727.154296] BUG: unable to handle kernel paging request at ffffffffa01874b8
>>> From what I observerved it happens when when we call the rmmod only a while after a modprobe
>>> (in this case it is the mpt2sas driver). More accurately said, it happens when rmmod is called
>>> while scsi async is still at work. The driver is removed but the scsi_host_template is still filled
>>> with now invalid pointers, in this case it is most likely the hostt->scan_finished which causes the BUG.
>>
>> Are you sure the above analysis is correct ? I've triggered several
>> million device removal events with ib_srp but I haven't ever seen the
>> above crash.
> ib_srp uses scsi_scan_target when the target is added so you are going
> down a different code path. If you are rmmoding ib_srp while the driver
> is calling scsi_scan_target() that would be a similar problem.
If the driver doesn't define the 'scsi_host_template.scan_finished' then the problem
is less visible. It's because in do_scsi_scan_host another path is taken and  
the scsi_host_scan_allowed test is used to skip further scanning, which I think reduces
the risk significantly. ib_srp doesn't define scan_finished so it is not safe but it is less
likely it will hit this.

>
> Tomas's bug occurs when drivers use scsi_scan_host, use the async scsi
> device scanning, and then rmmod the LLD while the scan is still in progress.
>
> I think a general problem that we might hit similar to Tomas's issue is
> when scanning from userspace then rmmoding the driver. Maybe that means
> we need a more generic fix? Or, maybe that could be handled by having
> scsi_scan() do a try_module_get before scanning.
I like this idea(try_module_get) it is easy/elegant and it is used in scsi_rescan_device,
but a scan can take a lot of time and during that time the driver couldn't be removed.
When a flag in scsi_remove_host is set then the scan can be cancelled, if the user 
rmmods the driver.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

