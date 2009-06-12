From: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 12 Jun 2009 09:50:50 +0200
Message-ID: <20090612075050.GW5139@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com> <20090611081032.GN5139@amd.com> <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17423
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbZFLHvD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 03:51:03 -0400
Content-Disposition: inline
In-Reply-To: <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
> I tried this patch, but I still get a wrong warning from the DMA-API:
> Jun 11 19:24:57 treogen [    9.451064] raid1: raid set md2 active wit=
h
> 2 out of 2 mirrors
> Jun 11 19:24:57 treogen [    9.479278] md2: bitmap initialized from
> disk: read 10/10 pages, set 0 bits
> Jun 11 19:24:57 treogen [    9.479282] created bitmap (153 pages) for=
 device md2
> Jun 11 19:24:57 treogen [    9.513544] md: ... autorun DONE.
> Jun 11 19:24:57 treogen [    9.517590]  md3: unknown partition table
> Jun 11 19:24:57 treogen [   20.718608] XFS mounting filesystem dm-0
> Jun 11 19:24:57 treogen [   21.220452] ------------[ cut here ]------=
------
> Jun 11 19:24:57 treogen [   21.220477] WARNING: at lib/dma-debug.c:53=
2
> check_unmap+0x49e/0x620()
> Jun 11 19:24:57 treogen [   21.220482] Hardware name: KFN5-D SLI
> Jun 11 19:24:57 treogen [   21.220488] sata_sil24 0000:04:00.0:
> DMA-API: device driver tries to free DM A memory it has not allocated=
 [device address=3D0x000000011e4c3000]

This happens with the best-fit if there is no perfect fit but multiple
matches. This warning needs to be adjusted to also cover this case. I
have this on my list and will fix it soon.

Joerg

--=20
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei M=FCnchen
 System    |=20
 Research  | Gesch=E4ftsf=FChrer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
           | Registergericht M=FCnchen, HRB Nr. 43632

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
