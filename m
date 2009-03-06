From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 6 Mar 2009 13:55:13 -0800
Message-ID: <da824cf30903061355m4e5368b0q938776cf5d61a46a@mail.gmail.com>
References: <20090306085529.GP11787@kernel.dk>
	 <20090306181302X.fujita.tomonori@lab.ntt.co.jp>
	 <20090306092114.GS11787@kernel.dk>
	 <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
	 <20090306093520.GV11787@kernel.dk>
	 <20090306143856.GT15340@beardog.cca.cpqcorp.net>
	 <da824cf30903061259j4a37ab7cneea308c736da469d@mail.gmail.com>
	 <20090306211832.GV15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:41846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZCFVzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 16:55:17 -0500
In-Reply-To: <20090306211832.GV15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Fri, Mar 6, 2009 at 1:18 PM,  <scameron@beardog.cca.cpqcorp.net> wro=
te:
> On Fri, Mar 06, 2009 at 12:59:48PM -0800, Grant Grundler wrote:
>> On Fri, Mar 6, 2009 at 6:38 AM, =C2=A0<scameron@beardog.cca.cpqcorp.=
net> wrote:
>> ...
>> > The command buffers have to be in the first 4GB of memory, as the =
command
>> > register is only 32 bits, so they are allocated by pci_alloc_consi=
stent.
>>
>> Huh?!!
>> ISTR the mpt2sas driver is indicating it can handle 64-bit DMA masks=
 for
>> both streaming and control data. I need to double check to be sure o=
f that.
>
> it is something specific to smart array. =C2=A0The command register t=
hat we
> stuff the bus address of the command into is only 32 bits wide. =C2=A0=
Everything
> else it does is 64 bits.

Sorry...I'm spacing out and confusing my drivers.

thanks,
grant

>>
>> > However, the chained SG lists don't have that limitation, so I thi=
nk they
>> > can be kmalloc'ed, and so not chew up and unreasonable amount of t=
he
>> > pci_alloc_consistent memory and get a larger number of SGs. =C2=A0=
 ...right?
>> > Maybe that's the better way to do it.
>>
>> I thought the driver was tracking this and using the appropriate con=
struct
>> based on which DMA mask is in effect.
>
> The DMA mask is insufficiently expressive to describe the limitations=
 and
> capabilities of the Smart array. =C2=A0There's no way to describe wit=
h a single
> DMA mask that the command register is 32-bits, but everything else is=
 64
> bits.
>
> -- steve
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
