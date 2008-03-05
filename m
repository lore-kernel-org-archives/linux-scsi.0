From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH] modify the type of element of MessageUnit_B in arcmsr
Date: Wed, 5 Mar 2008 15:38:13 +0800
Message-ID: <000901c87e93$dec71360$8800a8c0@Nick>
References: <1204648787.3091.25.camel@localhost.localdomain>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:50022 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764149AbYCEHiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2008 02:38:25 -0500
In-Reply-To: <1204648787.3091.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk

James,
Thanks for your care.
I agree with your point of labeling the registers with their correct width.
But I did see an error.
I have a script to load/unload driver modules for Type B Adapter repeatedly.
While unloading the former driver modules, it pops up the message,
iounmap: bad address ffffc2000021f000
Call Trace:
 [<ffffffff881ec2a2>] :arcmsr:arcmsr_free_ccb_pool+0x54/0x8f
 [<ffffffff881ec3c8>] :arcmsr:arcmsr_remove+0xeb/0x117
 [<ffffffff802668a2>] klist_release+0x0/0x45
 [<ffffffff8014f69c>] pci_device_remove+0x24/0x3a
 [<ffffffff801af54d>] __device_release_driver+0x79/0x9d
 [<ffffffff801af8c7>] driver_detach+0xad/0x101
 [<ffffffff801aebdd>] bus_remove_driver+0x6d/0x90
 [<ffffffff801af94e>] driver_unregister+0xd/0x16
 [<ffffffff8014f936>] pci_unregister_driver+0x10/0x5f
 [<ffffffff800a39e2>] sys_delete_module+0x196/0x1c5
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0.

Although it has tiny possibility to hang the system, but for the safety I
determine to change.

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, March 05, 2008 12:40 AM
To: nick.cheng@areca.com.tw
Cc: 'Andrew Morton'; linux-scsi@vger.kernel.org; randy.dunlap@oracle.com;
'Tomas Henzl'; viro@ftp.linux.org.uk
Subject: Re: [PATCH] modify the type of element of MessageUnit_B in arcmsr


On Tue, 2008-03-04 at 17:49 +0800, nickcheng wrote:
> Subject: [PATCH] scsi: modify the element type of MessageUnit_B in
> arcmsr-1.20.00.15-80227
> From: Nick Cheng <nick.cheng@areca.com.tw>
> Description:
> *** modify the element type of MessageUnit_B in arcmsr-1.20.00.15-80227 to
> keep off the error while doing iounmap in arcmsr_free_ccb_pool()

What's the actual error this causes?

Looking at the code, all of these registers are genuinely 32 bits long,
so having them defined as uint32_t __iomem * is fine; so is having them
defined as void __iomem *, because void * can be transparently cast to
any pointer.

Because the readX/writeX routines are prototyped in terms of void
__iomem *, they do the casting transparently (and without warning), so
there's no useful typechecking with the uint32_t __iomem * definition,
thus I only have a tiny marginal preference for labelling the registers
with their correct width.  But I would like to understand what the error
is you're seeing.

Thanks,

James


