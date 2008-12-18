From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: READ CAPACITY 16
Date: Thu, 18 Dec 2008 16:38:28 +0200
Message-ID: <494A6064.70601@panasas.com>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com> <20081217180640.GE19967@parisc-linux.org> <494A1272.8040008@panasas.com> <20081218140851.GI19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:9601 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422AbYLROif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 09:38:35 -0500
In-Reply-To: <20081218140851.GI19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Dec 18, 2008 at 11:05:54AM +0200, Boaz Harrosh wrote:
>> Matthew Wilcox wrote:
>>>>> Algorithm B:
>>>>>
>>>>> Issue RC10
>>>>> Issue RC16
>>>>>  -> If it succeeds, use its results in preference to those from RC10
>>>>>  -> If it fails, carry on with the results from RC10
>>>>>  -> If it times out, reset the device, carry on with the results from RC10
>>>> I fail to see an effective difference between Algo A and B.
>>> Whether to issue an RC10 before issuing an RC16 or not.  It matches what
>>> we currently do better (we currently issue an RC10 and then issue an
>>> RC16 if RC10 reports we have 0xffffffff LBAs).
>>>
>> Sorry to barge in but I think this is the most practical solution and the one
>> to go to T10 with.
>>
>> If a (new) device supports RC16 it should return LBAs==0xffffffff for RC10 even
>> if it's capacity is smaller, to indicate an RC16 request.
> 
> That breaks compatibility with older software that doesn't know that
> RC16 exists.
> 
>> If LBAs!=0xffffffff and !SCSI_3 then do not risk RC16 unless a white list
>> or load parameter.
>>
>> Since you are going to T10 with this the white list should be, as you said
>> in other mail, zero length.
> 
> I don't need to go to T10 for anything except Algorithm D.
> 

OK Then I say D, go to T10, while white list the (0) devices that currently
report !SCSI_3 but do support UNMAP. These are only USB right?

Your tested devices report SCSI_3? Do all devices that are scsi_level > SCSI_2
suppose to support RC16?

My point is make the standard, which is still a draft, crystal clear
in a backward compatible way. All new, supporting, devices can be easily
identified, and the very few devices that do support the new fixture but
were released prior to the finalization of the draft be white-listed.
And in any event don't let the standard be broken like that.

Boaz
