From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Monitoring FileSystem cache
Date: Thu, 7 Aug 2003 08:34:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFB722312A.084B48B7-ON87256D7B.00548C0A-88256D7B.00557482@us.ibm.com>
References: <3F310375.2040207@nospam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:23284 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S270324AbTHGPeQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 11:34:16 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h77FYFc8265180
	for <linux-scsi@vger.kernel.org>; Thu, 7 Aug 2003 11:34:15 -0400
Received: from d03nm124.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h77FY9sG095582
	for <linux-scsi@vger.kernel.org>; Thu, 7 Aug 2003 09:34:13 -0600
In-Reply-To: <3F310375.2040207@nospam.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org





>Are there hi water marks that limit the
>size of the buffer cache or does it consume
>as such memory VM as possible ?
>
>I looked through /proc ( 2.4.20 kernel )
>and I don't see anything of interest.

How about /proc/meminfo?

The buffer cache does not consume as much memory as possible; its size is
controlled by a complex policy which is controlled by 9 sysctl variables,
which you can find in /proc/sys/vm/bdflush.  The policy is implemented in
fs/buffer.c.  That's the only documentation I know of for those sysctl
parameters.

The buffer cache will consume all available memory if there is no other
demand for that memory, and this frequently causes people to suspect buffer
cache overuse is causing a memory shortage problem.  In reality, you rarely
have to "turn down" the buffer cache memory usage; it goes down at the
right times automatically.

By the way, it's worth mentioning that "the buffer cache" and "filesystem
caches" is not the same thing.  An individual filesystem driver can cache
file data any way it wants.  Conventionally, it uses the buffer cache
(every popular filesystem driver I know of does), but it could do other
things, including using the page cache directly.  The page cache itself has
no sophisticated allocation strategy like the buffer cache.  It competes
equally with virtual memory and every other use of memory for the finite
real memory.

