From: Kern Sibbald <kern@sibbald.com>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 16:26:14 +0200
Message-ID: <200704041626.15298.kern@sibbald.com>
References: <200704031508.37222.kern@sibbald.com> <20070403145728.d8f83320.akpm@linux-foundation.org> <150283e90704032000p7f447a26pe3752b22024a1b67@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matou.sibbald.com ([194.158.240.20]:22782 "EHLO
	matou.sibbald.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbXDDO0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 10:26:32 -0400
In-Reply-To: <150283e90704032000p7f447a26pe3752b22024a1b67@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Wednesday 04 April 2007 05:00, Willem Riede wrote:

> > Kern Sibbald <kern@sibbald.com> wrote:
...

Hello Willem,

> 
> Osst supports both scsi and ide models of the Onstream dirves it is
> designed for.
> It uses ide-scsi for the ide model. In the past, I did look at
> ide-tape to see if it could be made to work properly for the ide
> Onstream tape, but that would have taken so much work, I decided to
> limit myself to ide-scsi.
> 
> For other ide tape drives, the same could be done, using Kai's st
> driver (of which osst is a clone). Ide-tape could be deprecated, left
> to use for drives/applications it happens to work for. Given that the
> new sata world is using st also, this concentrates effort where it has
> maximum leverage.

 I'm all in favor of deprecating ide-tape if ide-scsi is a viable alternative, 
and if that is the only one you kernel guys would like to support. Let's 
concentrate on the drivers that will be the most important over the next few 
years (SATA?)

> 
> If there are issues using Bacula on ide drives with ide-scsi and st,
> we should debug those. If my previous experience getting osst to work
> properly with Bacula can be of any use, I'll be happy to help where I
> can.

Your previous experience could be particularly helpful. Thanks for the offer.

I'm in the process of taking a mini-Bacula survey of the problems. Here are 
the results for the moment:

===
Sebastiaan: He returned his Quantum DLT-V4 SATA drive, which did not work with 
Bacula, in exchange for a SCSI drive.

Bob: He has a SDX-260V ATAPI AIT-E and reports the following:
1. Sony SDX-260V
2. ATAPI
3. Tried both ide-scsi and ide-tape
4. ide-scsi simply locked up my machine after ANY attempt to write data
to the tape.  I tried various combinations of block sizes and such.
ide-tape would wirte to the tape and could read it but failed the
positioning tests under btape.  Specifically it would read any block
from the first file on the tape.  When a block from the second file was
requested, the machine would lock up.
5. Gentoo Linux 2.6.20 - gcc 4.1.2 - glibc 2.5 - paludis 0.22.2 - bacula
2.0.3

Robert: Reports:
A year ago I used the IDE drive on Linux.  If I remember
correctly the problem only occurred when using DMA, PIO worked but was very,
very slow.  The symptoms changed depending on whether I used the
SCSI driver stack or the ide-tape driver; but neither worked properly.
===

Please tell me the best way to proceed. I don't have the hardware, but 
understand Bacula, the users have the hardware, but don't understand Bacula's 
needs  (Robert knows Bacula in detail) -- not the best of situations.  I will 
buy the hardware if required, but I'd like to limit ($$$) to what is going to 
be mostly used in the future.


On the other general issues of the tape API (read/write/open/ioctl), I briefly 
sketched my problems/concerns.  If anyone is interested in any of those 
points, I can be a lot more specific.

