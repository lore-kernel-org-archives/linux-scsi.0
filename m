From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sym53c8xx_2 negotiates improperly
Date: Sun, 15 Oct 2006 12:55:02 -0500
Message-ID: <1160934902.3544.14.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0610151329300.8184@monarch.fast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18326 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422642AbWJORzx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 13:55:53 -0400
In-Reply-To: <Pine.LNX.4.64.0610151329300.8184@monarch.fast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Steven N. Hirsch" <shirsch@adelphia.net>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-10-15 at 13:36 -0400, Steven N. Hirsch wrote:
> <6> target0:0:0: ppr msgout: Parallel Protocol Request period = 12.5 ns offset = 62 width = 16 

The driver asks for FAST-80

> <6> target0:0:0: ppr msgin: Parallel Protocol Request period = 25 ns offset = 62 width = 16 

And the device denies the request and suggests FAST-40 instead

> <6> target0:0:0: asynchronous
> <6> 0:0:0:0: M_REJECT to send for : Parallel Protocol Request period = 25 ns offset = 62 width = 16 
> <6> target0:0:0: ppr msgout: Parallel Protocol Request period = 25 ns offset = 31 width = 16 
> <6> target0:0:0: ppr msgin: Parallel Protocol Request period = 25 ns offset = 31 width = 16 
> <6> target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)

Which is what you eventually end up with.

The driver is working as advertised ... the curiosity is why the device
suggests FAST-40 in the first place.  There are reports of devices doing
things like this when they're unhappy with the contents of some of the
flags of the initial PPR message.  A work around for a Quantum Atlas
with this issue went into 2.6.18 ... which kernel was this you were
using?

James


