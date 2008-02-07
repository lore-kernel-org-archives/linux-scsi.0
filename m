From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Thu, 07 Feb 2008 16:45:07 +0300
Message-ID: <47AB0B63.20500@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1202144767.3096.38.camel@localhost.localdomain>	 <47A7488B.4080000@vlnb.net>	 <1202145901.3096.49.camel@localhost.localdomain>	 <47A751C5.60600@vlnb.net>	 <1202149322.3096.66.camel@localhost.localdomain>	 <47A75B8A.3020503@vlnb.net>	 <1202151293.3096.80.camel@localhost.localdomain>	 <47A8B210.8040202@vlnb.net>	 <1202238802.3133.71.camel@localhost.localdomain> <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:45894 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYBGNpV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 08:45:21 -0500
In-Reply-To: <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

Bart Van Assche wrote:
> Since the focus of this thread shifted somewhat in the last few
> messages, I'll try to summarize what has been discussed so far:
> - There was a number of participants who joined this discussion
> spontaneously. This suggests that there is considerable interest in
> networked storage and iSCSI.
> - It has been motivated why iSCSI makes sense as a storage protocol
> (compared to ATA over Ethernet and Fibre Channel over Ethernet).
> - The direct I/O performance results for block transfer sizes below 64
> KB are a meaningful benchmark for storage target implementations.
> - It has been discussed whether an iSCSI target should be implemented
> in user space or in kernel space. It is clear now that an
> implementation in the kernel can be made faster than a user space
> implementation (http://kerneltrap.org/mailarchive/linux-kernel/2008/2/4/714804).
> Regarding existing implementations, measurements have a.o. shown that
> SCST is faster than STGT (30% with the following setup: iSCSI via
> IPoIB and direct I/O block transfers with a size of 512 bytes).
> - It has been discussed which iSCSI target implementation should be in
> the mainstream Linux kernel. There is no agreement on this subject
> yet. The short-term options are as follows:
> 1) Do not integrate any new iSCSI target implementation in the
> mainstream Linux kernel.
> 2) Add one of the existing in-kernel iSCSI target implementations to
> the kernel, e.g. SCST or PyX/LIO.
> 3) Create a new in-kernel iSCSI target implementation that combines
> the advantages of the existing iSCSI kernel target implementations
> (iETD, STGT, SCST and PyX/LIO).
> 
> As an iSCSI user, I prefer option (3). The big question is whether the
> various storage target authors agree with this ?

I tend to agree with some important notes:

1. IET should be excluded from this list, iSCSI-SCST is IET updated for 
SCST framework with a lot of bugfixes and improvements.

2. I think, everybody will agree that Linux iSCSI target should work 
over some standard SCSI target framework. Hence the choice gets 
narrower: SCST vs STGT. I don't think there's a way for a dedicated 
iSCSI target (i.e. PyX/LIO) in the mainline, because of a lot of code 
duplication. Nicholas could decide to move to either existing framework 
(although, frankly, I don't think there's a possibility for in-kernel 
iSCSI target and user space SCSI target framework) and if he decide to 
go with SCST, I'll be glad to offer my help and support and wouldn't 
care if LIO-SCST eventually replaced iSCSI-SCST. The better one should win.

Vlad
