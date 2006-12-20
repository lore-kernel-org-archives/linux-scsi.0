From: Steven Hayter <steven@hayter.me.uk>
Subject: Re: [PATCH] scsi_execute_async() should add to the tail of the queue
Date: Wed, 20 Dec 2006 20:40:29 +0000
Message-ID: <45899FBD.9070803@hayter.me.uk>
References: <20061219000234.GA5330@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 85.189.5.98 ([85.189.5.98]:38502 "EHLO zombie.undead"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030373AbWLTVyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 16:54:33 -0500
In-Reply-To: <20061219000234.GA5330@localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

Dan Aloni wrote:
> Hello,
> 
> scsi_execute_async() has replaced scsi_do_req() a few versions ago, 
> but it also incurred a change of behavior. I noticed that over-queuing 
> a SCSI device using that function causes I/Os to be starved from 
> low-level queuing for no justified reason.
>  
> I think it makes much more sense to perserve the original behaviour 
> of scsi_do_req() and add the request to the tail of the queue.

As far as I'm aware the way in which scsi_do_req() was to insert at the 
head of the queue, leading to projects like SCST to come up with 
scsi_do_req_fifo() as queuing multiple commands using scsi_do_req() with 
constant head insertion might lead to out of order execution.

Just thought I'd throw some light on the history and what others have 
done in the past.

Steve
