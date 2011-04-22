From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [Open-FCoE] deadlock during fc_remove_host
Date: Thu, 21 Apr 2011 22:47:09 -0700
Message-ID: <4DB1165D.7020106@broadcom.com>
References: <4DAF7944.6060909@broadcom.com>
 <4DAF9C15.1010808@cs.wisc.edu> <4DAFA2CF.2080102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2928 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1DVFrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 01:47:20 -0400
In-Reply-To: <4DAFA2CF.2080102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/20/2011 8:21 PM, Mike Christie wrote:
> On 04/20/2011 09:53 PM, Mike Christie wrote:
>> Is the reason that rport b's terminate_rport_io has not been called,
>> because that workqueue is queued behind rport a's workqueue and rport
>> b's workqueue function is not called? If so, have you tested this with
>> the current upstream kernel?
>
> Oh wait, I think you also need to change the fc class to use
> alloc_workqueue instead of create_singlethread_workqueue.
>
This seem to work, except that I had to use allow_workqueue with flags 
WQ_UNBOUND and max_active set to WQ_UNBOUND_MAX_ACTIVE.  It didn't help 
With flags 0 and max_active set to 0. Test has been going on for the 
last 4 hours.  I'll let it run overnight.

Thanks,
Bhanu

