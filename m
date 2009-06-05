From: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 14:44:12 +0200
Message-ID: <20090605124412.GF24836@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:10748
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345AbZFEMoY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jun 2009 08:44:24 -0400
Content-Disposition: inline
In-Reply-To: <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, lethal@linux-sh.org, just.for.lkml@googlemail.com, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 05, 2009 at 08:38:22PM +0900, FUJITA Tomonori wrote:
> On Fri, 5 Jun 2009 12:41:33 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:

> I thought about something like this fix however we can do better; wit=
h
> this fix, we could overlook a bad hardware IOMMU bug.

I don't buy this yet. Can you explain what kind of hardware IOMMU bug w=
e
can miss here? For the match in my patch it is still strictly necessary
that the dma address matches.

> I think that the better fix can handle both cases per device:
>=20
> - multiple identical dma addresses should not happen (with devices
>   behind hardware IOMMU)
> - multiple identical dma addresses could happen
>=20
>=20
> It's better to use a strict-fit algorithm (as we do now) with the
> former. It's pretty difficult to do something better than a best-fit
> algorithm with the latter though.

When we understand the same under 'strict-fit' this will not work I
think. The idea behind dma-debug is to find the cases where the
dma_unmap parameters are not equal to the dma_map parameters. If we use
strict-fit we risk to oversee some sets of these cases because there is
no dma_debug_entry which strictly matches the reference value.

Regards,

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
