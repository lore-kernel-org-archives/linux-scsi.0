From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Mon, 29 Mar 2004 02:20:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4067F861.5040605@us.ibm.com>
References: <200403240038.AA03092@fukuchi.jp.fujitsu.com> <1080403035.2078.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:49808 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262802AbUC2LBT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 06:01:19 -0500
In-Reply-To: <1080403035.2078.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2004-03-23 at 19:38, Masao Fukuchi wrote:
> 
>>We propose the following improvements for fastfail.
>>
>>1.Validate fastfail flag for command timeout.
>>  Currently fastfail flag is not valid for command timeout and repeats
>>  4 times.
>>2.Set timeout value to 10sec.
>>  Currently timeout value is set to 30sec.
>>3.Set wait time for bus reset/host reset to 5sec.
>>  Currently wait time is set to 10sec.
>>  (In many cases, abort task command fails for command timeout and it needs
>>  bus reset or host reset operation)
>>
>>Each timeout values come from:
>>  timeout(10sec)+Abort/Bus reset(5sec+)+alt retry timeout(10sec) < 30sec
>>
>>This is one idea for quick response on device/path error.
>>If you have any comments or idea for this improvements, please let me know.
> 
> 
> This isn't the right thing to do.  These timeouts control transport
> recovery; if it's safe to lower them in the fastfail case, then it would
> also be safe to lower them in the general case.
> 
> The correct thing for what you want to do would be to return the command
> with a transient transport error (which we don't actually have yet)
> *before* beginning transport recovery.  This is not going to be easy
> because we need to return a command we're also going to do error
> recovery on (so it can't be freed as normal).  I'd suggest the best way
> to do this would be to refcount the commands.
> 

Could this be a place to start using the transport framework? For 
something like iSCSI the timeout value should probably have the network 
load factored into it. This could be set with a transport class 
attribute (although for scanning this would probably require per host 
values as the device ones would not yet be available), which when a 
driver registers the set/get_timeout functions it could also set a 
add_timer and times_out function. I have something like this now, but 
how it works with the mid layer error handling still has kinks.

Mike
