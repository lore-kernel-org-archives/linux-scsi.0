From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: next Feb 13 drivers/scsi/aha1542.ko build break
Date: Fri, 13 Feb 2009 11:13:50 -0800
Message-ID: <4995C66E.1000800@cisco.com>
References: <20090213175526.d0590862.sfr@canb.auug.org.au> <49955D00.2020707@in.ibm.com> <4995BA4B.9050209@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:49973 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZBMTN4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2009 14:13:56 -0500
In-Reply-To: <4995BA4B.9050209@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Randy Dunlap wrote:
> Sachin P. Sant wrote:
>> Feb 13 next x86 allmodconfig build breaks with
>>
>> ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!
>>
>> .config attached.
> 
> 
> I'm seeing that also.  I think that it's this line in aha1542.c:
> 
> 495:		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);
> 
> since I can comment out the "/ sizeof(struct ccb)" and the driver builds successfully.
> 
> This may need a patch to use one of the div() macros (?).

In the above case, this problem might not occur if sizeof(struct ccb) happened to
be a power of 2, since the compiler generates a shift in that case.
Then later someone could increase the size of the struct and introduce this problem.

The kernel infrastructure should fix that without requiring the driver to change.
Drivers ought to be allowed to divide.

I've also seen this in another driver that divided a u64 by a constant.
I noticed that linux/math64.h provides div_u64(), but it seems awkward to call
that when the compiler generates a call to __udivdi3 (apparently).

Can't we just provide __udivdi3, since gcc generates that call?
Otherwise, problems like this will continue to crop up.

	Joe


