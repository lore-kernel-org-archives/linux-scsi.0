From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: SCSI API generics (was Re: [PATCH] add block/unblock to iscsi
 class)
Date: Wed, 23 Feb 2005 11:55:26 -0800
Message-ID: <421CDFAE.4090108@us.ibm.com>
References: <421C3CA4.8070009@cs.wisc.edu> <20050223181705.GA8694@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from e33.co.us.ibm.com ([32.97.110.131]:24971 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261553AbVBWTzY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 14:55:24 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1NJtL0D165238
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 14:55:21 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1NJtLIv137008
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 12:55:21 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1NJtLpW009067
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 12:55:21 -0700
In-Reply-To: <20050223181705.GA8694@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> On Wed, 23 Feb 2005, Mike Christie wrote:
> 
> 
>>The attached patch copies the code from the fc transport
>>class which allows a LLD to block and unblock a device.
>>The block/unblock code is used by the iscsi-sfnet
>>driver in replacement of a internal timer doing the
>>same thing.
>>
>>I understand that the target code is under construction
>>and our group as well as the HW iSCSI guys are trying to move
>>to something closer to the fc's rport model, so I was not
>>sure if it is better to wait or get this basic functionality in
>>first so we (and other SW and HW iSCSI drivers) can kill some
>>of our duplicated code sooner and then incrementally update
>>the class.
>>
> 
> 
> Speaking of which, are there any major objections to the patches
> proposed here:
> 
> Add scsi_target_[un]block() and scsi_target_remove() generics
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110867050306738&w=2
> 
> [RFC] adding per scsi-host workqueues for defered processing
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110903148407438&w=2
> 

When using single_threaded_workqueues do all single threaded ones
in the system use the same cpu_workqueue_struct? Will this be
a potential bottleneck if we end up using the workqueue for more
operations in the future?

