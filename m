From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Thu, 18 Mar 2010 10:33:54 GMT
Message-ID: <201003181033.o2IAXsfr015339@demeter.kernel.org>
References: <bug-15565-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58704 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0CRKd4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 06:33:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2IAXslm015340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2010 10:33:54 GMT
In-Reply-To: <bug-15565-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15565





--- Comment #3 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-03-18 10:32:31 ---
Reply-To: bharrosh@panasas.com

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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
