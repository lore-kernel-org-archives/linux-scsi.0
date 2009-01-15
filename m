From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 17:44:35 +0100
Message-ID: <496F67F3.6050305@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53188 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZAOQog (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 11:44:36 -0500
In-Reply-To: <496F62CC.8000007@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

I wrote:
> You can do a little trick here and combine this flag with the counter t:
> Simply say t = 1 for "this device is open and has no outstanding
> transactions yet".  Then increment and decrement for requests and
> responses.  Also do t-- once on close().  Then t == 0 means "closed and
> all transactions completed".  And any t != 0 means of course "there are
> t - 1 transactions pending".  You could also shift it all by one and say
> "t == -1 means device closed and 0 transactions pending" but the former
> way allows you to use the kref API.  (However, if you ever need to know
> whether the device is open or closed, independently whether there are
> transactions pending or not, then you can't fold this "open?" flag into
> the transaction counter t.)

Also, of course you can't use the kref API for this counter t if you
want to read the number of pending transactions somewhere.  Use an
atomic_t then, or an int whose accessors are serialized by a lock.
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/
