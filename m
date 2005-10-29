From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: 2.6.14: aic7xxx broken with blktool
Date: Sat, 29 Oct 2005 10:44:01 +1000
Message-ID: <4362C5D1.80308@torque.net>
References: <20051028040227.37dfef86.akpm@osdl.org> <1130512908.3328.8.camel@mulgrave> <Pine.SOC.4.61.0510282124200.16664@math.ut.ee>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:56287 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750946AbVJ2Amz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:42:55 -0400
In-Reply-To: <Pine.SOC.4.61.0510282124200.16664@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@ut.ee>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Meelis Roos wrote:
>>> It outputs random data from memory as a response to the scsi command,
>>> different recent strings different times.
>>
>>
>> This is a bug in blktool, so please refile appropriately.
> 
> 
> Yes, I see. blktools seems to buggy, yes.

May I suggest that you try sdparm for SCSI devices until
blktool is fixed.

> But blktool outputs memory fragments that seems to come from other
> processes. I saw string "bash", "lled with unallocated bl" and other
> strings that do not appear in blktools image. Without further
> investigation it seems that in case of the error, soma data ise leaked
> from kernel to the buggy program in userspace (blktool in this case).

After analysing the blktool code (4.2), and having
a similar worrying report concerning sdparm, what you
may have seen was the uninitialized contents of a
auto variable (buf[128]) in blktool. As James B. pointed
out, the failure in the aic7xxx driver was due to an
INQUIRY command issued with a cdb length set to 12 bytes
(it should be 6). Given that failure there should have
been no DMA from the device back to the kernel memory.
If kernel memory was still moved back to the user space
then that is an issue.

The sg driver zeroes its kernel buffers for all non-root
users before data is moved through them as a safeguard.
There can also be "short" DMA transfer back from a
device, indicated by resid>0 that should be
considered in this context.

Doug Gilbert

