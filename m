From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >=
	2.6.22
Date: Tue, 03 Jun 2008 15:15:22 -0500
Message-ID: <1212524122.3329.16.camel@localhost.localdomain>
References: <20080603160902.B120A10805D@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33365 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbYFCUP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 16:15:27 -0400
In-Reply-To: <20080603160902.B120A10805D@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-06-03 at 09:09 -0700, bugme-daemon@bugzilla.kernel.org
wrote: 
> Should we consider, that such a difference is normal. You suggest that before
> the kernel was dangerous at writing data?

It's caching too much streaming data, yes.  The danger is largely the
amount of data you lose on a crash and mismanagement of the cache
starving other applications. It's not that much of a problem.  At an
estimated write speed of ~70MB/s your 1GB of data is only around 15s to
effect a full writeout.

> So unpacking linux kernel (for example) is 5x times slower and it is not a
> problem. That's just new way of caching data? We seldom see crashes (thanks to
> linux) and we have power supply.

There are many factors that could account for that.

> I'd like testing on same hardware windows to see its behaviour and speed.
> Anyway thanks for the clarifying of cache: write through. As you say, it was
> not evident. 
> 
> So, now, what can we do to keep 2.6.21 behaviour? That's for a mail system
> writing lots of little files and performance matters too.

Well, initially, I'd try a benchmark that simulates the actual problem,
like postmark.  A streaming write tells you very little about the entire
system performance under a mail server type load.

James


