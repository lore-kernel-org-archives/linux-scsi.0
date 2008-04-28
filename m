From: Ke Wei <kecore@gmail.com>
Subject: Re: [PATCH scsi-rc-fixes-2.6] mvsas: fix error handling.
Date: Tue, 29 Apr 2008 00:05:17 +0800
Message-ID: <4815F5BD.5030804@gmail.com>
References: <47FB498A.2010107@marvell.com>  <4811FE09.10209@garzik.org> <1209139637.3087.12.camel@localhost.localdomain>
Reply-To: kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:54258 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934086AbYD1QFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 12:05:25 -0400
Received: by wf-out-1314.google.com with SMTP id 28so4080271wff.4
        for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 09:05:24 -0700 (PDT)
In-Reply-To: <1209139637.3087.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, kewei@marvell.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2008-04-25 at 11:51 -0400, Jeff Garzik wrote:
>> Ke Wei wrote:
>>>  Changed error handling: Add a internal queue to send command in mvs_task_abort function.
>>>  Set max_id and max_lun to a valid value. It's good for 64xx chip.
>>>  BTW, DVD-ROM compatibility needs to test carefully.
>>>
>>>
>>> Signed-off-by: Ke Wei <kewei@marvell.com>
>> James, ping?
>>
>> Did this get missed?  Are we waiting on Marvell to update this patch?
> 
> Actually, the patch contains a red flag:
> 
>> -       mvi->shost->max_id = 21;
>> -       mvi->shost->max_lun = ~0;
>> +       mvi->shost->max_id = 128;
>> +       mvi->shost->max_lun = 1;
> 
> Setting max_lun to 1 can't be right.  My suspicion is that it's done to
> turn off the REPORT_LUN scan that I've already said twice is necessary.
> 
> The DVD that's showing the problems needs to be blacklisted.
> 
> So, it's on my list to check carefully to see what else might have been
> quietly slipped in there ... unfortunately, I haven't had much time
> recently (and probably won't until the merge window closes) to give this
> patch the thorough scrutiny it needs.
> 

First, Thank you for your help, Jeff and James. 
I am investigating whether other devices have the same issue as my testing DVD caused by REPORT_LUNS command.
So I think I doesn't need to add this device to blacklists before I check. My colleague is working on the libsas module so that we hope SAS transport is more powerful and stable.

Ke
