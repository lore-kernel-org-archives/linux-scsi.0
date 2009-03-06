From: scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 6 Mar 2009 15:18:32 -0600
Message-ID: <20090306211832.GV15340@beardog.cca.cpqcorp.net>
References: <20090306085529.GP11787@kernel.dk> <20090306181302X.fujita.tomonori@lab.ntt.co.jp> <20090306092114.GS11787@kernel.dk> <20090306182705P.fujita.tomonori@lab.ntt.co.jp> <20090306093520.GV11787@kernel.dk> <20090306143856.GT15340@beardog.cca.cpqcorp.net> <da824cf30903061259j4a37ab7cneea308c736da469d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39884 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZCFVSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 16:18:33 -0500
Content-Disposition: inline
In-Reply-To: <da824cf30903061259j4a37ab7cneea308c736da469d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Fri, Mar 06, 2009 at 12:59:48PM -0800, Grant Grundler wrote:
> On Fri, Mar 6, 2009 at 6:38 AM,  <scameron@beardog.cca.cpqcorp.net> w=
rote:
> ...
> > The command buffers have to be in the first 4GB of memory, as the c=
ommand
> > register is only 32 bits, so they are allocated by pci_alloc_consis=
tent.
>=20
> Huh?!!
> ISTR the mpt2sas driver is indicating it can handle 64-bit DMA masks =
for
> both streaming and control data. I need to double check to be sure of=
 that.

it is something specific to smart array.  The command register that we
stuff the bus address of the command into is only 32 bits wide.  Everyt=
hing
else it does is 64 bits.
>=20
>=20
> > However, the chained SG lists don't have that limitation, so I thin=
k they
> > can be kmalloc'ed, and so not chew up and unreasonable amount of th=
e
> > pci_alloc_consistent memory and get a larger number of SGs. =A0 ...=
right?
> > Maybe that's the better way to do it.
>=20
> I thought the driver was tracking this and using the appropriate cons=
truct
> based on which DMA mask is in effect.

The DMA mask is insufficiently expressive to describe the limitations a=
nd
capabilities of the Smart array.  There's no way to describe with a sin=
gle
DMA mask that the command register is 32-bits, but everything else is 6=
4
bits.

-- steve

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
