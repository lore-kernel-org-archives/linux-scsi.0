From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v12 2/6] Avoid calling __scsi_remove_device() twice
Date: Mon, 01 Jul 2013 09:14:38 +0200
Message-ID: <51D12C5E.30801@acm.org>
References: <51CC5176.90609@acm.org> <51CC51FC.5050901@acm.org> <1372662351.2360.24.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:35353 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GAHOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 03:14:41 -0400
In-Reply-To: <1372662351.2360.24.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 07/01/13 09:05, James Bottomley wrote:
>
> On Thu, 2013-06-27 at 16:53 +0200, Bart Van Assche wrote:
>> If something goes wrong during LUN scanning, e.g. a transport layer
>> failure occurs, then __scsi_remove_device() can get invoked by the
>> LUN scanning code for a SCSI device in state SDEV_CREATED_BLOCK. If
>> this happens then the SCSI device has not yet been added to sysfs
>> (is_visible == 0).  Make sure that in that case the transition into
>> state SDEV_DEL occurs. This avoids that __scsi_remove_device() gets
>> invoked a second time by scsi_forget_host().
>
> The patch summary of this one isn't true.  How about "enable destruction
> of blocked devices which fail LUN scanning"

Hello James,

Do you want me to repost the patch series or is this something you can 
fix up ?

Thanks,

Bart.

