From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Wed, 19 Nov 2014 21:21:55 +0100
Message-ID: <546CFBE3.6080407@laposte.net>
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net> <54647C10.4070506@laposte.net> <20141113142907.GB29354@infradead.org> <5464E6E6.3090606@laposte.net> <20141113175402.GA27327@infradead.org> <546536EA.4070705@laposte.net> <20141114073214.GA1879@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141114073214.GA1879@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

I solved the mystery,

I found that the element who triggers the bug ( random hang at boot wit=
h
kernel 3.17 and 3.18 ) is the combination of 3 elements :

- the use of a SATA DVD burner ( Liteon iHAS124 C ) on a ICH7 Sata cont=
roler
- the use of a gigabyte motherboard GA-P31-DSL3 ( bios F10A, ICH7
controler, intel P31 chipset )
- commit 74665016086615bbaa3fa6f83af410a0a4e029ee ( scsi: convert
host_busy to atomic_t )

If I connect this Sata DVD burner and a sata harddisk by using the SATA
ports of the motherboard then the bug will occur ( but the bug will
occur only on kernels 3.17 and 3.18, there is no problems with older
kernels, and no problems with Windows 7 )

If I disconnect the SATA DVD burner then the bug is gone, no problems
with kernels 3.17 and 3.18,

And if I connect the SATA DVD burner on my JMicron SATA/IDE PCIe card
then there is no problem, no bugs, this is a perfect workaround for my
problem, because I can use kernel 3.17/3.18 without problem with this
configuration.

But I don't know which element I should blame, my gigabyte motherboard =
?
( faulty bios ? ) The use of "atomic_t" in scsi source code ? (
innapropriate way to handle SATA devices, it breaks compatibility with
some PC configurations ? )




Le 14/11/2014 08:32, Christoph Hellwig a =E9crit :
> On Thu, Nov 13, 2014 at 11:55:38PM +0100, Barto wrote:
>> it's interesting, with this commit
>> 74665016086615bbaa3fa6f83af410a0a4e029ee I have the bug :
>>
>> scsi: convert host_busy to atomic_t :
>=20
> At this point we'll need a bisction between v3.16 as the last good
> point, and 74665016086615bbaa3fa6f83af410a0a4e029ee as the known bad
> point.
>=20
