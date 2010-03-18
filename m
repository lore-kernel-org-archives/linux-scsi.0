From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bug 15565] New: SCSI Generic queueing completes commands in
 reverse order
Date: Thu, 18 Mar 2010 11:56:27 +0200
Message-ID: <4BA1F8CB.9070406@panasas.com>
References: <bug-15565-11613@http.bugzilla.kernel.org/> <4BA18DA5.6000902@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:43108 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579Ab0CRJ4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 05:56:33 -0400
In-Reply-To: <4BA18DA5.6000902@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 03/18/2010 04:19 AM, Douglas Gilbert wrote:
> bugzilla-daemon@bugzilla.kernel.org wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=15565
>>
>>            Summary: SCSI Generic queueing completes commands in reverse
>>                     order
>>            Product: IO/Storage
>>            Version: 2.5
>>     Kernel Version: 2.6.18-2.6.32
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: SCSI
>>         AssignedTo: linux-scsi@vger.kernel.org
>>         ReportedBy: mh-linux-kernel@loup.net
>>         Regression: No
>>
>>
>> I've noticed after queueing the first command, subsequent commands
>> appear to be executed and complete in reverse order.  The SCSI Generic
>> HOWTO says "By default, read() will return the oldest completed
>> request that is queued up."
>>
>> This could also be a performance defect if it's what's really
>> happening since it isn't desirable behavior if, for example, ios are
>> typically ordered by lba and issued one at a time by kernel to a non
>> queueing block device.
>>
>> This reverse order behavior is trivial to reproduce; just queue 16
>> concurrent INQUIRY commands.  The following are typical results I get
>> from initially queueing 16 READ_10 commands.
>>
>>    Completion Command #  hdr.driver_duration (us)
>>    Order
>>    1          22         14979
>>    2          20         14981
>>    3          19         14982
>>    4          17         14984
>>    5          16         14985
>>    6          15         14986
>>    7          14         14988
>>    8          12         14990
>>    9          11         14991
>>    10         10         14992
>>
> 
> I have been told that is a feature :-)
> 
> The SCSI mid level processes commands from
> pass-throughs (e.g. sg and bsg) in LIFO order.
> For certain types of error processing it makes
> sense. For READs and WRITEs it makes no sense.
> 

I have fixed that for bsg long ago. There is a flag
that you put:
	sg.flags = BSG_FLAG_Q_AT_TAIL;
Which will do the by order, queue at tail. Zero was kept compatible
to sg meaning "queue at head" i.e. jump the line.

> Doug Gilbert
> 

It could be added to sg as well if needed

Boaz
