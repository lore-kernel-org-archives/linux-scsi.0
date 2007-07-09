From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] blk request timeout handler:
Date: Mon, 09 Jul 2007 10:56:48 -0500
Message-ID: <46925AC0.4020102@cs.wisc.edu>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01B8E0CC@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33632 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbXGIP5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jul 2007 11:57:03 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01B8E0CC@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

I dropped Jen's old suse address and added his oracle one.

Salyzyn, Mark wrote:
> What ever happened to the following (admittedly snipped up) patch from a
> year ago, was there a reason this initiative was dropped? If so, please
> state what I missed?
> 

I have not worked on it because I got busy with iscsi again. I was 
trying to rework the patches, so that the scsi-ml would not have to do 
so much digging in the timers.

In the end I wanted it so the block layer started the timer when the 
command either was queued up or when it was sent to the LLD (I was not 
sure which was better), and the timer was stopped when the command was 
completed or when the LLD requeued it. The starting of the timer is 
easy, but with the stopping of it, scsi-ml needed to do some things like 
stop the timer manually then call a block layer requeue function and I 
wanted the block layer requeue function to stop the timer for scsi-ml so 
the LLD would not have to worry about it at all.

I also got stuck working out the details for situations like when we get 
into aborts and error handling and support for subsystems like DM or MD 
doing timers and stacking them on top of SCSI timers or having MD/DM 
timers calling into the SCSI timeout handlers.
