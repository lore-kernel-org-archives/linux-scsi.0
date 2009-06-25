From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: sd_ref_mutex and cpu_add_remove_lock deadlock
Date: Thu, 25 Jun 2009 11:14:55 -0700
Message-ID: <4A43BE9F.2000804@cisco.com>
References: <4A42F7D4.8070102@cisco.com> <4A4396C7.2030106@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:12032 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZFYSOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2009 14:14:52 -0400
In-Reply-To: <4A4396C7.2030106@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> On 06/24/2009 11:06 PM, Joe Eykholt wrote:
>> Has anyone seen this?
>>
>> I'm getting a hang due to three threads in a deadly
>> embrace involving two mutexes.
>>
>> A user process doing a close on /dev/sdx has the sd_ref_mutex
>> and is trying to get cpu_add_remove_lock.
>>
>> Another process is doing a /sys write to destroy an fcoe
>> instance. It is in destroy_workqueue() which holds the
>> cpu_add_remove_lock() waiting for a work item to complete.
>>
>> The third thread is running the work item, and waiting on
>> the sd_ref_mutex.
>>
>> To summarize:
>> Worker thread wants sd_ref_mutex
>> Close thread has sd_ref_mutex and wants cpu_add_remove_lock
>> Destroy thread has cpu_add_remove_lock and waits
>> for worker_thread to exit.
>>
>> The stacks are shown below.
>>
>> I'm not sure what the best solution would be or which
>> locking rule is being broken here.
>>
>> Also, it seems to me there's a possible deadlock where
>> sd_remove() has the sd_ref_mutex locked and is doing a
>> put_device(). The release function for this device is
>> scsi_disc_release(), which also takes the sd_ref_mutex().
>> Maybe it's known that this can't be the last put_device().
>>
>> This is based on the open-fcoe.org fcoe-next.git tree, which is
>> fairly up-to-date.
>>
> 
> I think I am seeing a similar warning from the lock dependency checking. 
> I just started seeing it. Have you seen yours in older kernels?

No, just this once.

	Joe

