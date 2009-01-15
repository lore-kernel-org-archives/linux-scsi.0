From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 20:14:20 +0100
Message-ID: <496F8B0C.1010309@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40549 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZAOTOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 14:14:47 -0500
In-Reply-To: <496F84AA.9060708@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

I wrote:
> If you only count pending transactions, you know when to deregister the
> device from the idr.  But you don't know when it's OK to free the
> device's memory.
> 
> If you cont only references to the memory, you know when it is OK to
> free it but you don't know when to deregister from the idr.

PS:
However, if you never copy the idr's reference, then you don't need that
other ref-counter.  To avoid such copies, every site which looks up the
device in the idr would have to perform all its accesses to the device
while inside an sg_index_lock protected section.

Then only the transactions have copies of the pointer to the device
representation in memory.  This of course means that the transaction
counter is equal to the reference counter (plus the one reference of the
idr which you don't need to count because you remove that reference when
there is also no transaction anymore).
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/
