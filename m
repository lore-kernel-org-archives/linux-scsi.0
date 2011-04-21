From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: deadlock during fc_remove_host
Date: Wed, 20 Apr 2011 22:32:17 -0700
Message-ID: <4DAFC161.6040708@broadcom.com>
References: <4DAF7944.6060909@broadcom.com>
 <4DAF9C15.1010808@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3179 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1DUFc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2011 01:32:26 -0400
In-Reply-To: <4DAF9C15.1010808@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 4/20/2011 7:53 PM, Mike Christie wrote:
> On 04/20/2011 07:24 PM, Bhanu Prakash Gollapudi wrote:
>> Hi,
>>
>> We are seeing a similar issue to what Joe has observed a while back -
>> http://www.mail-archive.com/devel@open-fcoe.org/msg02993.html.
>>
>> This happens in a very corner case scenario by creating and destroying
>> fcoe interface in a tight loop. (fcoeadm -c followed by fcoeadm -d). The
>> system had a simple configuration with a single local port 2 remote ports.
>>
>> Reason for the deadlock:
>>
>> 1. destroy (fcoeadm -d) thread hangs in fc_remove_host().
>> 2. fc_remove_host() is trying to flush the shost->work_q, via
>> scsi_flush_work(), but the operation never completes.
>> 3. There are two works scheduled to be run in this work_q, one belonging
>> to rport A, and other rport B.
>> 4. The thread is currently executing rport_delete_work (fc_rport_final
>> _delete) for rport A. It calls fc_terminate_rport_io() that unblocks the
>> sdev->request_queue, so that __blk_run_queue() can be called. So, IO for
>> rport A is ready to run, but stuck at the async layer.
>> 5. Meanwhile, async layer is serializing all the IOs belonging to both
>> rport A and rport B. At this point, it is waiting for IO belonging to
>> rport B to complete.
>> 6. However, the request_queue for rport B is stopped and
>> fc_terminate_rport_io on rport B is not called yet to unblock the
>> device, which will only be called after rport A completes. rport A does
>
> Is the reason that rport b's terminate_rport_io has not been called,
> because that workqueue is queued behind rport a's workqueue and rport
> b's workqueue function is not called? If so, have you tested this with
> the current upstream kernel?
>
Yes, this has been tested with upstream kernel.

