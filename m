From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Mon, 29 Mar 2004 21:17:51 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403291217.AA03115@fukuchi.jp.fujitsu.com>
References: <1080403035.2078.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57007 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262852AbUC2MSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 07:18:48 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73]) by fgwmail7.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i2TCIjEr019301 for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2004 21:18:46 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s4.gw.fujitsu.co.jp by m3.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i2TCIj2l031169 for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2004 21:18:45 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail502.fjmail.jp.fujitsu.com (fjmail502-0.fjmail.jp.fujitsu.com [10.59.80.98]) by s4.gw.fujitsu.co.jp (8.12.10)
	id i2TCIcI6009963 for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2004 21:18:38 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan502-0.fjmail.jp.fujitsu.com [10.59.80.122])
 by fjmail502.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HVC00HFS7ICK6@fjmail502.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Mon, 29 Mar 2004 21:18:13 +0900 (JST)
In-reply-to: <1080403035.2078.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,
Thank you for response to my mail.

I'm understand what I have to do.
I'll more study about the way to return transient transport error to
upper layer and to process transport recovery using refcount.

By the way, how about item 1.
I think this is bug and we need to validate fastfail for command timeout.
If you agree with this, please put it into official patch.
(See attached patch)

Next, I tested the fastfail recovery using Kernel 2.6.4.
But the command didn't complete forever.
Then I installed following Mike Christie's patch and it worked fine.
 http://marc.theaimsgroup.com/?l=linux-scsi&m=107904932710899&w=2
Please put it into official patch.

Thanks,
Masao Fukuchi

James Bottomley wrote:
>On Tue, 2004-03-23 at 19:38, Masao Fukuchi wrote:
>> We propose the following improvements for fastfail.
>> 
>> 1.Validate fastfail flag for command timeout.
>>   Currently fastfail flag is not valid for command timeout and repeats
>>   4 times.
>> 2.Set timeout value to 10sec.
>>   Currently timeout value is set to 30sec.
>> 3.Set wait time for bus reset/host reset to 5sec.
>>   Currently wait time is set to 10sec.
>>   (In many cases, abort task command fails for command timeout and it needs
>>   bus reset or host reset operation)
>> 
>> Each timeout values come from:
>>   timeout(10sec)+Abort/Bus reset(5sec+)+alt retry timeout(10sec) < 30sec
>> 
>> This is one idea for quick response on device/path error.
>> If you have any comments or idea for this improvements, please let me know.
>
>This isn't the right thing to do.  These timeouts control transport
>recovery; if it's safe to lower them in the fastfail case, then it would
>also be safe to lower them in the general case.
>
>The correct thing for what you want to do would be to return the command
>with a transient transport error (which we don't actually have yet)
>*before* beginning transport recovery.  This is not going to be easy
>because we need to return a command we're also going to do error
>recovery on (so it can't be freed as normal).  I'd suggest the best way
>to do this would be to refcount the commands.
>
>James
>

diff -urN linux-2.6.4/drivers/scsi/scsi_error.c linux-2.6.4FF/drivers/scsi/scsi_error.c
--- linux-2.6.4/drivers/scsi/scsi_error.c       2004-02-18 12:57:12.000000000 +0900
+++ linux-2.6.4FF/drivers/scsi/scsi_error.c     2004-03-18 16:59:50.000000000 +0900
@@ -1421,7 +1421,8 @@
                scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
                list_del_init(lh);
                if (scmd->device->online &&
-                       (++scmd->retries < scmd->allowed)) {
+                       (++scmd->retries < scmd->allowed) &&
+                       (!blk_noretry_request(scmd->request))) {
                        SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
                                                          " retry cmd: %p\n",
                                                          current->comm,
