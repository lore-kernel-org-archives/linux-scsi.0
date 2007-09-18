From: Martijn Prummel <martijn@databoss.nl>
Subject: Re: [Bugme-new] [Bug 9018] New: Kernel bug in aic94xx driver	shipped with kernel 2.6.21.7
Date: Tue, 18 Sep 2007 22:14:22 +0200
Message-ID: <019BB005-14D0-4238-9664-072F2F730DBE@databoss.nl>
References: <bug-9018-10286@http.bugzilla.kernel.org/> <20070914135600.67f798e3.akpm@linux-foundation.org> <1189804923.3343.28.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:60666 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757527AbXIRUOP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 16:14:15 -0400
In-Reply-To: <1189804923.3343.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-new@lists.osdl.org, "Darrick J. Wong" <djwong@us.ibm.com>


I applied the patch and it's rebuilding now.. It used to crash during  
a rebuild sometimes, aswell. But this seems to have been gone already.
I'll stress it for some time and will let you all know whether it  
crashes again.

Thanks a lot for your help thusfar!

Best regards,

-- 
Martijn Prummel

On Sep 14, 2007, at 11:22 PM, James Bottomley wrote:

> On Fri, 2007-09-14 at 13:56 -0700, Andrew Morton wrote:
>> On Fri, 14 Sep 2007 07:11:54 -0700 (PDT)
>> bugme-daemon@bugzilla.kernel.org wrote:
>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=9018
>>>
>>>            Summary: Kernel bug in aic94xx driver shipped with kernel
>>>                     2.6.21.7
>>>            Product: Drivers
>>>            Version: 2.5
>>>      KernelVersion: 2.6.21.7
>>>           Platform: All
>>>         OS/Version: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: Other
>>>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>>>         ReportedBy: martijn@databoss.nl
>>>
>>>
>>> While rebuilding a MD raid5, every time I try to rebuild:
>>>
>>> -- START DUMP --
>>> RAID5 conf printout:
>>>  --- rd:3 wd:2
>>>  disk 0, o:1, dev:sdb1
>>>  disk 1, o:1, dev:sdc1
>>>  disk 2, o:1, dev:sdd1
>>> md: recovery of RAID array md0
>>> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>>> md: using maximum available idle IO bandwidth (but not more than  
>>> 200000 KB/sec)
>>> for recovery.
>>> md: using 128k window, over a total of 71681920 blocks.
>>> ------------[ cut here ]------------
>>> kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:354!
>>
>> whee!  That's BUG_ON(!list_empty(&ascb->list));
>
> Yes; it means the task was still in use when we tried to free it.  I
> surmise that this is the tascb not the ascb in asd_abort_task(). What
> this seems to indicate is some sort of race between the abort  
> completing
> the task and the owning entity taking it off the sequencer list.
>
> I don't understand this piece of the driver enough yet to fix a more
> definite cause.
>
>> yet anoher scsi driver with no entry in MAINTAINERS.  Darrick, maybe?
>
> Gilbert Wu should be taking over eventually, but for now it's a bit
> unmaintained.
>
> James
>
>

