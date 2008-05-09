From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] libiscsi regression in 2.6.25: fix setting of recv
 timer
Date: Fri, 09 May 2008 10:16:58 -0500
Message-ID: <48246AEA.7080800@cs.wisc.edu>
References: <1210295734-6278-1-git-send-email-michaelc@cs.wisc.edu>	 <1210295734-6278-2-git-send-email-michaelc@cs.wisc.edu> <e2e108260805090757s4ed00c29w21da11a38515ab57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYEIPRB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2008 11:17:01 -0400
In-Reply-To: <e2e108260805090757s4ed00c29w21da11a38515ab57@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Fri, May 9, 2008 at 3:15 AM,  <michaelc@cs.wisc.edu> wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> If the ping tmo is longer than the recv tmo then we could miss a window
>> where we were supposed to check the recv tmo. This happens because
>> the ping code will set the next timeout for the ping timeout, and if the
>> ping executes quickly there will be a long chunk of time before the
>> timer wakes up again.
>>
>> This patch has the ping processing code kick off a recv
>> tmo check when getting a nop in response to our ping.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> Hello Mike,
> 
> Did you already consider to submit this patch for inclusion in a
> 2.6.25.x stable release ? See also
> Documentation/stable_kernel_rules.txt for the details.
> 

James does some magic where if we mark it as a regression against a 
previous kernel, when he merges it to send it upstream he will send cc 
the stable kernel guys for us. It is pretty neat like some sort of 
JamesBot :)
