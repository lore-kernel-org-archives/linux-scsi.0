From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 23:02:37 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FBA186D.2060907@torque.net>
References: <OF1494DF8F.2FB4A44D-ONC2256DE2.004036A3-C2256DE2.0040B333@il.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:65037 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261817AbTKRNGF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 08:06:05 -0500
In-Reply-To: <OF1494DF8F.2FB4A44D-ONC2256DE2.004036A3-C2256DE2.0040B333@il.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Liran Schour wrote:
> 
> 
> 
> Christoph Hellwig wrote:
> 
> 
>>You'd have to enlarge MAX_COMMAND_SIZE, that'S the whole point of it :)
>>What exactly are you trying to do and for what kernel release?  We've
>>been through increasing it from 12 to 16 at some point in 2.4.
> 
> 
> I am trying to find a way to do that without the need to recompile the
> kernel.
> I am trying to support an OSD device see t10 OSD draft, I think that 2.6 is
> my target kernel release.

Liran,
Yep, I knew that I'd seen really big SCSI commands somewhere.
OSD, now there is a storage paradigm that doesn't fit
the block subsystem:-)

Perhaps we should starting thinking about kmalloc()ing
scsi_cmnd::cmnd (rather than having it as a fixed array).
The mid-level owns that structure so it can take care
of allocation and de-allocation. We would have to
find code that does sizeof(scsi_cmnd::cmnd) and fix it.

Doug Gilbert



