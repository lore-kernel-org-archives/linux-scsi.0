From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [linux-iscsi-devel] [question] deferred sense
Date: Tue, 11 Jan 2005 21:44:09 +1000
Message-ID: <41E3BC09.3060408@torque.net>
References: <41DB21D7.5080904@us.ibm.com> <20050104234700.GA18343@visi.com>	 <20050105092144.GB26793@lst.de> <20050105152112.GA8472@visi.com>	 <20050105152333.GA1453@lst.de>  <1104943469.3997.8.camel@mulgrave> <1105029477.20393.187.camel@bianchi.boston.redhat.com> <41DDD275.50500@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:49060 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262729AbVAKLoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 06:44:15 -0500
In-Reply-To: <41DDD275.50500@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Tom Coughlan <coughlan@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, "Scott M. Ferris" <sferris@acm.org>, Mike Christie <mikenc@us.ibm.com>, linux-iscsi-devel <linux-iscsi-devel@lists.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Tom Coughlan wrote:
> 
>> On Wed, 2005-01-05 at 11:44, James Bottomley wrote:
>>
>>> On Wed, 2005-01-05 at 16:23 +0100, Christoph Hellwig wrote:
>>>
>>>> On Wed, Jan 05, 2005 at 09:21:12AM -0600, Scott M. Ferris wrote:
>>>>
>>>>> To be more specific, there were some devices that would fail a command
>>>>> and return deferred sense.  The command didn't complete at the target,
>>>>> and the kernel wasn't retrying it because the sense was deferred
>>>>> rather than current.  For those devices, the translation produced the
>>>>> desired retry.
>>>>
>>>>
>>>> Do you remember these devices?  Might be worth adding a midlayer
>>>> blacklist entry for them.
>>>
>>>
>>> That's certainly possible ... although we'd need a lot more details.
>>> Any device that returns deferred sense for a current error is pretty
>>> badly broken according to the spec.
>>
>>
>>
>> If a current command returns deferred sense, the SCSI spec. requires
>> that the current command shall not have been executed [1]. So, if at
>> some point in the past the kernel did not retry a current command that
>> returned deferred sense, the iscsi folks would have forced the retry by
>> converting deferred sense to current sense. The scenario does not
>> require a device that is working incorrectly.
>>
>> The big flaw in what iscsi did is the case where the deferred sense
>> indicates a non-fatal error. In that case, iscsi converts it to current,
>> the mitlayer examines it and determines that it does not require a
>> retry. This causes the current command to complete to the application
>> even though it was not executed by the device.
>> It looks to me as though the 2.4 iscsi driver is susceptible to this. It
>> is probably not seen in practice because disk devices that return
>> non-fatal deferred sense are rare (it probably requires the PER bit set
>> in the error recovery mode page?). Anyone know for sure?
> 
> 
> Tom,
>  From my reading of SBC-2 (rev 16, 13 Nov 2004) deferred errors
> cannot be turned off by a mode page. The VERIFY and
> WRITE AND VERIFY commands can be used to make sure blocks get
> to the media (or not) without deferred errors. There are also
> the "Force Unit Access" (FUA and FUA_NV) bits in the READ and
> WRITE commands (but not the 6 byte variants).
> 
> The t10 folks have added the idea of non-volatile cache in
> a disk (more likely a RAID) which further complicates things.
> Now a deferred error could theoretically span a power cycle!
> 
> The PER bit in the Read-Write Error Recovery mode page (SBC-2
> rev 16 section 6.3.4) controls whether RECOVERED ERRORs are
> reported or not. Also if the ARRE bit (for reads) and/or the
> AWRE bit (for writes) are set in the same mode
> page, the offending block will be remapped (whether a recovered
> error is reported on not). If PER is 0 then RECOVERED ERRORs
> are not reported. [In any case the Error Counter log pages
> should reflect the problems (and perhaps the "grown" defect
> list) so smartmontools may be of use.]
> 
>> [1] If the task terminates with CHECK CONDITION status and the sense
>> data describes a deferred error the command for the terminated task
>> shall not have been processed. (SPC-3) 
> 
> 
> I fear my tinkering with sense descriptor data in
> the mid level may have tripped up on this case (if
> it wasn't already broken), that is: a deferred error
> report must cause the current command to be retried,
> even if the deferred error was reporting a
> recovered error. This case can only arise when PER=1.

Reviewing the error paths in lk 2.6 for deferred errors
indicates that the effected (innocent) command will be
retried in scsi_softirq() unless:
   - the retry count is exceeded (always true for sg usage)
   - or blk_noretry_request() returns true

Does fast path code want to (or know how to) process
deferred errors?
Even when deferred errors are retried this is done
silently unless an appropriate logging_level happens
to be set at the time (unlikely).

Doug Gilbert
