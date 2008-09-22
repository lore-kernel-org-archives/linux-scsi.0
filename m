From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Mon, 22 Sep 2008 10:24:40 +0300
Message-ID: <48D74838.9090009@panasas.com>
References: <Pine.LNX.4.44L0.0809211658310.4210-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:26938 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbYIVHYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 03:24:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809211658310.4210-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Sun, 21 Sep 2008, James Bottomley wrote:
> 
>>> For example, suppose a buggy device (without removable media) always
>>> replies with UNIT ATTENTION without making any forward progress.  
>>> We'll just call scsi_requeue_command each time and get stuck.
>> That's a separate bug from the current one ... fortunately one I don't
>> think we've actually seen manifest.
> 
>>> But I'm still concerned about the possibility of getting stuck doing
>>> the same command or request over and over.  Both structures have a
>>> "retries" field, but I'm not clear on how/where they get used.
>> Block relies on the lower layers for retry ... it just transmits the
>> status, so we get to fix it.
> 
> Okay -- I'll keep it in the back of my mind for later...
> 
>>> To be honest, I don't know what sort of requests get marked as
>>> non-retryable in the block layer.  Maybe you're right and we don't need 
>>> to worry about them.
>> They tend to be device mapper ones.  Anything that wants a fast failure
>> to do path switch over for instance.
> 
> If all the retry paths in scsi_io_completion jump to a common location, 
> it will be easy to add the test there.
> 
>>> I tested your simple fix, and it does indeed solve the problem of tasks
>>> hanging because of an uncompleted request.  In view of Boaz's concerns,
>>> should this change be postponed until 2.6.27.stable so that it can get
>>> wider testing?
>> We can ... I think it's safe enough though given it only affects
>> multiple transaction commands.
> 

James, I see your point. Thanks. I have one small request. Please kill
the comment Just below the: "this_count = blk_rq_bytes(req);"

Now it is totally wrong, it used to be mostly wrong before.

(See here: http://www.spinics.net/lists/linux-scsi/msg28763.html)

> The decision's yours.  Let me know when and in which tree it is merged,
> so I can start writing some patches for a more-complete fix.
> 
> Alan Stern
> 

Boaz
