From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Fri, 16 Jan 2009 09:09:25 +0100
Message-ID: <497040B5.30601@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53333 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZAPIJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 03:09:52 -0500
In-Reply-To: <496F62CC.8000007@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

I wrote:
> One number is
>   - the number of unfinished transactions (request->response)
> of an sg device. [...] The other number is
>   - the number of contexts which peek and poke at the device
> representation's memory. [...]
> And we need one more thing to finally get all pieces together:  A state
> flag which says "device still open? yes/no".  This flag is necessary to
> decide when to take the device representation out of the idr:

You probably don't need an explicit counter of pending transactions.
This number is implicit in the number of list members in struct
sg_fd.headrp.

So you only need the reference counter and the open-or-closed flag
(which would be different from struct sg_fd.closed).
-- 
Stefan Richter
-=====-==--= ---= =----
http://arcgraph.de/sr/
