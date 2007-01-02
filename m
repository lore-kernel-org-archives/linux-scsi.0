From: Peter Osterlund <petero2@telia.com>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118
 caused by "pktsetup dvd /dev/sr0"
Date: Tue, 2 Jan 2007 15:00:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0701021458150.14522@r3000.localdomain>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org>
 <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de>
 <20061212132600.GA19912@lst.de> <20070102115940.GA7032@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:61920 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbXABPPh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 10:15:37 -0500
In-Reply-To: <20070102115940.GA7032@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, laurent.riffard@free.fr, Adrian Bunk <bunk@stusta.de>

On Tue, 2 Jan 2007, Christoph Hellwig wrote:

> On Tue, Dec 12, 2006 at 02:26:00PM +0100, Christoph Hellwig wrote:
>> On Tue, Dec 12, 2006 at 11:38:42AM +0100, Christoph Hellwig wrote:
>>> This is because the packet driver tries to send down read/write
>>> BLOCK_PC commands that don't use a bio and do not use sg lists.
>>> As part of the patch you mentioned I added strict assertations for that
>>> case because the scsi layer doesn't handle those anymore.
>>>
>>> The right fix is to replace all the packet_command stuff in the packet
>>> driver by scsi_execute() which needs to be lifted from scsi code to
>>> the block code for that.  I'll prepare a patch this weekend unless
>>> someone beets me in doing that work.
>>
>> Please try the patch below to fix the bug for now.  It's not the
>> full way to a generic execute block pc infrastcuture but should fix
>> the bug for the time beeing:
>
> Given that we now have a tester that confirms this fix can we please
> put this into 2.6.20 so we avoid a regression that makes pktcdvd
> entirely unusable?

Works for me using an IDE drive too. Thanks.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Peter Osterlund <petero2@telia.com>

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
