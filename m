From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Bugme-new] [Bug 9018] New: Kernel bug in aic94xx driver shipped
 with kernel 2.6.21.7
Date: Fri, 14 Sep 2007 17:13:09 -0400
Message-ID: <46EAF965.1040701@garzik.org>
References: <bug-9018-10286@http.bugzilla.kernel.org/> <20070914135600.67f798e3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38064 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbXINVNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 17:13:17 -0400
In-Reply-To: <20070914135600.67f798e3.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-new@lists.osdl.org, martijn@databoss.nl, "Darrick J. Wong" <djwong@us.ibm.com>, Gilbert Wu <Gilbert_Wu@adaptec.com>

Andrew Morton wrote:
> On Fri, 14 Sep 2007 07:11:54 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=9018
>>
>>            Summary: Kernel bug in aic94xx driver shipped with kernel
>>                     2.6.21.7
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.21.7
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Other
>>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>>         ReportedBy: martijn@databoss.nl
>>
>>
>> While rebuilding a MD raid5, every time I try to rebuild:
>>
>> -- START DUMP --
>> RAID5 conf printout:
>>  --- rd:3 wd:2
>>  disk 0, o:1, dev:sdb1
>>  disk 1, o:1, dev:sdc1
>>  disk 2, o:1, dev:sdd1
>> md: recovery of RAID array md0
>> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec)
>> for recovery.
>> md: using 128k window, over a total of 71681920 blocks.
>> ------------[ cut here ]------------
>> kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:354!
> 
> whee!  That's BUG_ON(!list_empty(&ascb->list));
> 
> yet anoher scsi driver with no entry in MAINTAINERS.  Darrick, maybe?

Quite honestly, that's the reality of the situation for (IMO) the 
majority of SCSI drivers.  They just don't really have maintainers at 
all, so it winds up falling onto the subsystem maintainer(s) by default.

Gilbert_Wu@adaptec.com just posted a patch to the driver, so he should 
probably be kept in the loop.

	Jeff


