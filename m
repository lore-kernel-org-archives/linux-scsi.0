From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] include/scsi/scsi.h replace u8 in 2.5.69
Date: Wed, 14 May 2003 23:10:27 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC24043.6070109@torque.net>
References: <3EC1E4AF.6040404@torque.net> <20030514090218.A7371@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:27147 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262161AbTENM5K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 08:57:10 -0400
In-Reply-To: <20030514090218.A7371@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 14, 2003 at 04:39:43PM +1000, Douglas Gilbert wrote:
> 
>>Here is a simple patch to replace the single occurrence
>>of "u8" with "u_char" in include/scsi/scsi.h .
> 
> 
> That's wrong.  No userland should include kernwel headers.
> (and u_char is a non-standard type, too).

Christoph,
That's naive. In some case glibc's headers and libraries
(e.g. mknod) are an impediment to development.

If I add one define to ~linux/include/scsi/sg.h just
how long do you think it takes for it to appear in
/usr/include/scsi/sg.h?
It can take over a year in my experience.

Put another way, the sg.h header that applications use
should match the sg driver in the kernel not the glibc
version. The glibc maintainers add nothing to the
interface (apart from inertia and some bugs once in a
while).

Applications that include sg.h typically include scsi.h
as well. Only when I change sg.h does this problem arise.

It is one thing to state a policy (e.g. "no user program
should include kernel headers") it is another thing to
gratuitously break those few programs that have good
reason not to follow that policy.

Doug Gilbert



