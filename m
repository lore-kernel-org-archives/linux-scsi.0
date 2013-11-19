From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64171] Block SCSI Generic Driver does not maintain file handle
 context
Date: Tue, 19 Nov 2013 06:16:15 +0000
Message-ID: <bug-64171-11613-qlcSdt8Cd9@https.bugzilla.kernel.org/>
References: <bug-64171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44303 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3KSGQT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 01:16:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C01B32034E
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 06:16:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 098732034B
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 06:16:16 +0000 (UTC)
In-Reply-To: <bug-64171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64171

--- Comment #5 from d gilbert <dgilbert@interlog.com> ---
On 13-11-15 11:42 AM, James Bottomley wrote:
> On Sat, 2013-11-02 at 17:09 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=64171
>>
>> --- Comment #2 from d gilbert <dgilbert@interlog.com> ---
>> On 13-11-01 03:49 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=64171
>>>
>>>               Bug ID: 64171
>>>              Summary: Block SCSI Generic Driver does not keep data
>>>              Product: SCSI Drivers
>>>              Version: 2.5
>>>       Kernel Version: 2.6.32.61
>>>             Hardware: All
>>>                   OS: Linux
>>>                 Tree: Mainline
>>>               Status: NEW
>>>             Severity: high
>>>             Priority: P1
>>>            Component: Other
>>>             Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>>>             Reporter: af300wsm@gmail.com
>>>           Regression: No
>>>
>>> Data written to any given file descriptor should be unique to that descriptor
>>> and processor space.  Currently, the BSG Driver does not keep this uniqueness.
>>> As the attached simple program demonstrates, a SCSI Command queued to the
>>> device in one process is dequeued by another process which has opened a handle
>>> to the same device.
>>>
>>> The attached file sends the simple SCSI "Test Unit Ready" command from the SCSI
>>> Primary Command Spec. to the device using the BSG driver.  As the program
>>> demonstrates, the sg_io_v4.usr_ptr field, which is set in the "push" branch of
>>> the program, is dequeued from the "pop" branch of the code.
>>>
>>> I also tested this behavior on Fedora 19 and the bug exists there as well.  F19
>>> uses kernel 3.9.5.
>>>
>>> Compile the attachment:
>>> g++ -o <out> combined.cpp
>>>
>>>
>>> Execute as follows:
>>> sudo combined pop /dev/bsg/0:0:0:0 &
>>> sudo combined push /dev/bsg/0:0:0:0
>>
>> I ran this test on lk 3.11.6 and it also exhibits this
>> problem.
>>
>> When the bsg driver was originally designed, if my memory is
>> correct, it did not have an asynchronous interface, so it
>> skipped the complexity of keeping a separate context for
>> each file handle within each device.
>>
>> With the addition of the asynchronous interface, the lack of
>> file handle context is exposed by your simple test. I'm
>> pretty sure that parallel test programs could show that
>> synchronous SG_IO ioctls can also be tricked. For example:
>> send INQUIRYs continuously from one process, TURs from
>> another process to the same device. Then, once in a while,
>> I guess that they would pick up the other one's response.
>
> OK, so why do you both think this is a bug not a feature?  The
> read/write interface isn't completion order safe, it was introduced
> for /dev/sg compatibility and somehow got carried forwards when it
> should have been deprecated.  The ioctl interface is, so just use the
> latter.  If you can find a test case where the ioctl interface has the
> same problem, then I'll treat it as a bug.

sg_tst_context is a test program that sends TEST UNIT
READY commands on one thread (or even threads) and START
STOP UNIT commands on another thread (or odd threads).
The SSU commands alternate between start and stop. The
good news is the the bsg ioctl(SG_IO) doesn't break the
way I predicted.

Instead it broke like this:
# sg_tst_context -n 100 -t 2  /dev/bsg/8:0:0:2
   Enter work_thread id=0 num=100 share=0
   Enter work_thread id=1 num=100 share=0
   START STOP UNIT do_scsi_pt() submission error, id=1
     pass through OS error: Invalid argument
   thread id=1 FAILed at iteration: 0  [negated errno: -22]
   thread id=0 normal exit
   Expected not_readys on TEST UNIT READY: 0
   UNEXPECTED not_readys on START STOP UNIT: 0

Try 10 threads and the majority die in the same fashion.
That is with a separate file handle per thread. So if
there are multiple file handles to a bsg device then
subsequent calls to ioctl(SG_IO) may fail with
errno=EINVAL (for no good reason).

If a single file handle is shared between the threads then
the problem goes away:
# sg_tst_context -n 100 -t 2 -s /dev/bsg/8:0:0:2
   Enter work_thread id=0 num=100 share=1
   Enter work_thread id=1 num=100 share=1
   thread id=0 normal exit
   thread id=1 normal exit
   Expected not_readys on TEST UNIT READY: 55
   UNEXPECTED not_readys on START STOP UNIT: 0


Both the sg driver and the block layer (e.g.
ioctl(/dev/sdc, SG_IO) ) perform properly in these tests.

Doug Gilbert

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
