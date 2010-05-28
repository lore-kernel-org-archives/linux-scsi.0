From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Fri, 28 May 2010 19:30:14 GMT
Message-ID: <201005281930.o4SJUEkl025358@demeter.kernel.org>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38267 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0E1TaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 15:30:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4SJUEjJ025359
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 19:30:14 GMT
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058





--- Comment #7 from Mark Hounschell <dmarkh@cfl.rr.com>  2010-05-28 19:30:11 ---
On 05/28/2010 12:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=16058
>
>
>
>
>
> --- Comment #6 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-05-28 16:34:28 ---
> Reply-To: James.Bottomley@suse.de
>
> On Fri, 2010-05-28 at 10:58 -0400, Alan Stern wrote:
>   
>> On Fri, 28 May 2010, Mark Hounschell wrote:
>>
>>     
>>> First READ(10):
>>>
>>>  sde:
>>> ahc_calc_residual: Entered
>>> ahc_calc_residual: return Case 5-1 resid = 0x800
>>> ahc_calc_residual: return Case 5-2 resid = 0x800
>>>
>>> scsi_finish_command: Entered for cmd(10):0x28 0x00 0x00 0x00 0x00 0x00
>>> 0x00 0x00 0x08 0x00
>>> cmd->result = 0x00000000
>>> good_bytes == old_good_bytes = 0x800  scsi_get_resid(cmd) = 0x800
>>> New good_bytes = 0x0
>>> scsi_finish_command: Complete
>>>
>>> From here it just keeps repeating this read of 8 blocks. (2048 bytes) so
>>> it looks like the machine is hung.
>>>       
>> Probably not hung, just doing a lot of retries.  It should time out 
>> eventually, but it might take a long time (perhaps as long as 15 
>> minutes).  The combination of the block layer and the SCSI layer isn't 
>> very good at knowing when to give up.
>>     
> Actually, I think this is a partition read.  Each partition manager
> tends to read a page through the page cache.  If we get an error, we
> seem to re-read to fill the cache.
>
>   
>>> Now, I know for a fact that _if_ this read CDB is actually being sent to
>>> the drive, it's actual residual count will be zero. These are working
>>> disks and that read CDB is valid.
>>>
>>> Why is ahc_calc_residual saying that the residual count is as though the
>>> read never took place? I noticed that the first read on all the SATA
>>> drives was for 4096 bytes, why is this one only 2048? Should it have
>>> been 4096 and ahc_calc_residual assume that?
>>>       
>> I don't know the answer to any of these questions.  They could well be
>> due to bugs in the driver, and I know nothing about how the aic7xxx
>> driver works.  You should talk to someone who does.
>>     
> I'll take this one ... although we're a bit lacking in documentation for
> this driver.
>
> I think the 2048 is because something is hardcoded to think 8 sectors is
> a page.
>
> James
>
>   
Your probably right. But is a 256 byte sector really a supported sector
size for a linux fs on a SCSI disk? When it sees a 768 byte sector disk,
it says it's an unsupported size and goes on with the boot process
without even doing a read for a partition table. Should maybe it be
doing the same for a 256 byte sector disk???

Regards
Mark

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
