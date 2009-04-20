From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: RESEND: fix PCI permanent error handler
Date: Mon, 20 Apr 2009 15:18:37 -0500
Message-ID: <49ECD89D.3000005@linux.vnet.ibm.com>
References: <1240246790.7458.112.camel@zeppelin.austin.ibm.com> <1240258429.3315.60.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:50852 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbZDTUSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 16:18:53 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3KKFZxq012597
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 14:15:35 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KKIqrE060448
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 14:18:52 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KKIpIo024077
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 14:18:52 -0600
In-Reply-To: <1240258429.3315.60.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Kleber found the problem, debugged it, and provided a fix to me.
I provided him with an alternate patch to fix it. I'm assuming this
should have been handled by me submitting with my signoff alone and
adding a reported-by tag for Kleber. Sorry for the confusion. Shall
I resend as I just described?

Thanks,

Brian

James Bottomley wrote:
> On Mon, 2009-04-20 at 13:59 -0300, Kleber S. Souza wrote:
>> From: Brian King <brking@linux.vnet.ibm.com>
>>
>> The ipr driver can hang if it encounters enough PCI errors
>> to trigger the permanent error handler. The driver will attempt
>> to initiate a "bringdown" of the adapter and fail all pending
>> ops back. However, this bringdown is unlike any other bringdown
>> of the adapter in the code as the driver. In this code path we
>> end up failing back ops with allow_cmds still set to 1. This results
>> in some commands, the HCAM commands in particular, getting immediately
>> re-issued to the adapter on the done call, which results in
>> an infinite loop in ipr_fail_all_ops. Fix this by setting allow_cmds
>> to zero in this path. 
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> Signed-off-by: Kleber S. Souza <klebers@linux.vnet.ibm.com>
> 
> OK, now I'm really confused.  Originally this patch was your From: but
> had a Brian signoff.  I asked if it shouldn't be acked by him instead
> and he responded "correct".
> 
> Now you've sent the patch as being his original authorship ... whose
> patch is this?
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


