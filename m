From: Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] scsi_execute_async() should add to the tail of the queue
Date: Thu, 21 Dec 2006 09:12:19 +0200
Message-ID: <458A33D3.6020704@monatomic.org>
References: <20061219000234.GA5330@localdomain> <45899FBD.9070803@hayter.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noname.neutralserver.com ([70.84.186.210]:21775 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422787AbWLUHMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2006 02:12:53 -0500
In-Reply-To: <45899FBD.9070803@hayter.me.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Hayter <steven@hayter.me.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James.Bottomley@steeleye.com

Steven Hayter wrote:
> Dan Aloni wrote:
>> Hello,
>>
>> scsi_execute_async() has replaced scsi_do_req() a few versions ago, 
>> but it also incurred a change of behavior. I noticed that 
>> over-queuing a SCSI device using that function causes I/Os to be 
>> starved from low-level queuing for no justified reason.
>>  
>> I think it makes much more sense to perserve the original behaviour 
>> of scsi_do_req() and add the request to the tail of the queue.
>
> As far as I'm aware the way in which scsi_do_req() was to insert at 
> the head of the queue, leading to projects like SCST to come up with 
> scsi_do_req_fifo() as queuing multiple commands using scsi_do_req() 
> with constant head insertion might lead to out of order execution.
>
> Just thought I'd throw some light on the history and what others have 
> done in the past.
>
In Linux 2.4.31 scsi_do_req() still inserts at the tail. This was also 
valid until 2.6.5.
James, is the change you inserted in Linux 2.6.5 still relevant in 2.6 
today?

<James.Bottomley@steeleye.com>
        [PATCH] add device quiescing to the SCSI API
       
        This patch adds the ability to quiesce a SCSI device.  The idea 
is that
        user issued commands (including filesystem ones) would get blocked,
        while mid-layer and device issued ones would be allowed to proceed.
        This is for things like Domain Validation which like to operate 
on an
        otherwise quiet device.
       
        There is one big change: to get all of this to happen correctly,
        scsi_do_req() has to queue on the *head* of the request queue, 
not the
        tail as it was doing previously.  The reason is that deferred 
requests
        block the queue, so anything needing executing after a deferred 
request
        has to go in front of it.  I don't think there are any untoward
        consequences of this.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il

