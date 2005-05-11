From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 21:59:18 +1000
Message-ID: <4281F396.2030607@torque.net>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:34214 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261215AbVEKL7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 07:59:25 -0400
In-Reply-To: <20050510225831.GA4181@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> Hi Alan -
> 
> On Tue, May 10, 2005 at 02:51:44PM -0400, Alan Stern wrote:
> 
>>When a command injected through the sg driver encounters any sort of
>>error, the usual retry mechanism and error handler are brought into play.  
>>Since sg sets the number of retries to 0 by default, the retry mechanism
>>shouldn't cause any difficulty.  But the error handler does.  IMO it
>>should never get involved with requests coming through sg -- sg should
>>provide access that is as transparent as possible so that userspace
>>programs will have a clean shot at managing their device.
> 
> 
> The error handler is mainly a timeout handler, so it has to run to cancel
> the timed out command, we can't complete the timed out command back to the
> upper level until we know the HBA is no longer using it.
> 
> 
>>Consider a case that just came up.  A USB CD drive causes a phase error
>>when it receives a certain READ BUFFER command (buggy firmware on the
>>drive, never mind that now).  You would expect the user program to receive
>>from sg a host_status value indicating DID_ERROR or something of the sort.
>>
>>Instead the error handler takes charge and sends out one or two TEST UNIT 
>>READY commands.  The status information finally received by the user 
>>program is the status from the TEST UNIT READY, not from the failed READ 
>>BUFFER!  How's a program supposed to cope with that sort of obfuscation?
> 
> 
> :-(

Writing and maintaining a clean SCSI command pass-through in a
block-centric environment has not been easy. It often feels
like a one step forward and two steps back process :-)

In my recent "sense descriptor format" changes I did
unclutter some SG_IO error return paths, mainly for usages
via block device nodes (e.g. /dev/sda).

As ever, handling errors sanely is not easy. It also runs the
risk of tripping up some hardware.

>>Something in the SCSI stack (scsi_io_completion ?) should check for 
>>requests coming in via sg and should know to complete the requests 
>>immediately.  No requeuing and no error handling.

The sg driver does not currently call scsi_io_completion().
In the mid level you can see code like:
   if (blk_pc_request(scsi_cmnd->request))
      pass-through
   else
      block-injected [almost always a READ or WRITE]

I think the "_pc_" stands for packet command. Maybe we need more
instances of this.

>>Does this sound like a feasible thing to implement?
> 
> 
> No per above. I think there are still some cases where sg or SG_IO
> commands are not immediately returned, I think for some certain ASC codes,
> some of those probably should be retried, as should cases like QUEUE FULL.
> 
> As you say, what you really want is the correct result going back to the
> user, not the result of the TUR.
> 
> So save and restore the result in scsi_eh_tur, and also in scsi_eh_try_stu.
> The request sense one already saves and restores it.
> 
> And always set result |= (DRIVER_TIMEOUT << 24) if we are not requeueing
> the IO.
> 
> Like (only compile tested) this, against scsi-misc git tree of a few days
> ago. Hopefully, sg or SG_IO programs can handle DRIVER_TIMEOUT :-/ but it
> is certainly better than returning as if no error occurred.

sg3_utils error processing first decodes SCSI status and sense data.
Then if any of the other bits in "result" are set, then it comments
on them.

<snip>
Patch looks fine. Perhaps Alan could try some utility from sg3_utils
in the problem environment once Patrick's patch has been applied.
The sg_dd utility now has a "verbose=<n>" option where <n>=1 should
decode any SCSI status (including DID and DRIVER) errors received.

Doug Gilbert
