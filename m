From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Problem with tape drive: illegal seek
Date: Sat, 26 Feb 2005 10:42:52 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0502261037220.9787@kai.makisara.local>
References: <200502260016.11954.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:23513 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261861AbVBZIlr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Feb 2005 03:41:47 -0500
In-Reply-To: <200502260016.11954.chrivers@iversen-net.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Iversen <chrivers@iversen-net.dk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 26 Feb 2005, Christian Iversen wrote:

> 
> Whenever I use --verify for tar, I get problems. Specifically, I get 
> "Illegal seek" when tar gets to the verify phase. 
> 
I looked at tar 1.13.25 sources and this looks like a tar bug: verify from 
tape does not work for the first file (and I am not sure about other 
files). After writing, tar tries to skip backwards over two filemarks. 
When writing the first file, there is no second filemark to skip over: 
this fails and gives you the error. If you do verify with a second call to 
tar (tar --compare) after skipping backwards with mt, this should work.

...
> Please note that I can restore the data just fine, if I use tar. If I try to 
> use dd, I get strange errors as well:
> 
> [root@boreas]/tmp #dd if=/dev/tape of=dump
> dd: reading `/dev/tape': Cannot allocate memory
> 0+0 records in
> 0+0 records out
> 0 bytes transferred in 3,699040 seconds (0 bytes/sec)
> 
Guy already solved this problem. The message (Cannot allocate memory) is 
not very clear but this is what other Unices use.

-- 
Kai
