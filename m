From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: aligned /dev/scd$n reads less rare how
Date: 24 Oct 2003 08:41:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067006475.16062.10.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2>  <1064850600.25057.7.camel@patehci2>
	 <1064858121.4262.0.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:45253 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262228AbTJXOli
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2003 10:41:38 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 5522920E8
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2003 08:41:37 -0600 (MDT)
In-Reply-To: <1064858121.4262.0.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Anything easy I can do
> to make aligned reads more common?

Instead we first could/ should ask:

How does Linux align write/read of cd-rw/dvd+rw?

We know 2.6 vs. 2.4 newly connects cd-rw as writeable, by
http://kniggit.net/wwol26.html of l=kernelnewbies.  And "everybody
knows" cd-rw needs 64 KiB write alignment, dvd+rw needs 32 KiB write
alignment, and both prefer write alignment in reads, right?  How then
does Linux hint at the mounted fs to align write/read to something other
than the 0.5 KiB that was optimal for legacy hdd?

> I ask because often thru /dev/scd$n
> I see seemingly pointless misalignment,
> ...
> $ sudo blockdev --flushbufs /dev/scd0
> $ time sudo dd if=/dev/scd0 bs=1M
> ...
> usb-storage:  x 28 00 00 00 00 00 00 00 20 00

Initially we see aligned in address and length to x20 blocks = 64 KiB.

> usb-storage:  x 28 00 00 00 00 20 00 00 24 00

Soon we see aligned in address but, whoops, not in length.

> usb-storage:  x 28 00 00 00 00 44 00 00 40 00
> usb-storage:  x 28 00 00 00 00 84 00 00 40 00
> usb-storage:  x 28 00 00 00 00 C4 00 00 40 00
> ...
> usb-storage:  x 28 00 00 07 FE C4 00 00 40 00

Mostly we see contiguous after a misaligned access, so not aligned in
address though yes aligned in length.  Ouch.

Pat LaVarre


