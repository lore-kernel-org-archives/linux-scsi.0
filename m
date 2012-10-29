From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/7] Fix race between starved list processing and device
 removal
Date: Mon, 29 Oct 2012 15:32:15 +0100
Message-ID: <508E936F.7050004@acm.org>
References: <508A7B63.60608@acm.org> <508A7C6D.8070002@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A4C39@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:44700 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2J2OcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2012 10:32:19 -0400
In-Reply-To: <267107B7B5D6404FB174AB273F79D8BD1A4C39@SHSMSX101.ccr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhuang, Jin Can" <jin.can.zhuang@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 10/28/12 19:01, Zhuang, Jin Can wrote:
> I recently ran into the same issue
> The test I did is plug/unplug u-disk in an interval of 1 second. And
 > I found when sdev1 is being removed, scsi_run_queue is triggered by
 > sdev2, which then accesses all the starving scsi device including sdev1.
>
> I have adopted the solution below which works fine for me so far.
> But there's one thing to fix in the patch below. When it put_device
 > in scsi_run_queue, irq is disabled. As put_device may get into sleep,
 > irq should be enabled before it's called.

Hello Jincan,

Thanks for testing and the feedback. However, are you sure that 
put_device() for a SCSI device may sleep ? Have you noticed the 
execute_in_process_context() call in scsi_device_dev_release() ?

Bart.

