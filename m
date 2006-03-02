From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Thu, 2 Mar 2006 08:29:41 +0100
Message-ID: <20060302072941.GT4816@suse.de>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local> <20060301152929.GZ4816@suse.de> <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local> <20060301204345.GP4816@suse.de> <Pine.LNX.4.63.0603020011500.5789@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:44367 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751420AbWCBHaB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 02:30:01 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0603020011500.5789@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, Mar 02 2006, Kai Makisara wrote:
> On Wed, 1 Mar 2006, Jens Axboe wrote:
>=20
> > On Wed, Mar 01 2006, Kai Makisara wrote:
> > > On Wed, 1 Mar 2006, Jens Axboe wrote:
> > >=20
> > > > On Tue, Feb 28 2006, Kai Makisara wrote:
> > > > > This patch enables clustering and sets max_sectors to 0xffff =
to enable=20
> > > > > reading and writing of large blocks with tapes (and large tra=
nsfers with=20
> > > > > sg). This change is needed after the sg and st drivers starte=
d using=20
> > > > > chained bios through scsi_request_async() in 2.6.16.
> > > > >=20
> > > > > Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> > > > >=20
> > > > > --- linux-2.6.16-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006=
-02-04 13:25:48.000000000 +0200
> > > > > +++ linux-2.6.16-rc5-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2=
006-02-18 09:45:24.000000000 +0200
> > > > > @@ -1978,7 +1978,8 @@ static struct scsi_host_template sym2_t=
e
> > > > >  	.eh_bus_reset_handler	=3D sym53c8xx_eh_bus_reset_handler,
> > > > >  	.eh_host_reset_handler	=3D sym53c8xx_eh_host_reset_handler,
> > > > >  	.this_id		=3D 7,
> > > > > -	.use_clustering		=3D DISABLE_CLUSTERING,
> > > > > +	.use_clustering		=3D ENABLE_CLUSTERING,
> > > > > +	.max_sectors		=3D 0xFFFF,
> > > >=20
> > > > Strictly speaking, the clustering bit is unrelated.
> > >=20
> > > It is related. The number of scatter/gather segments in the SCSI =
HBAs is=20
> > > limited. In order to fit the large requests into these limits, th=
e=20
> > > adjacent pages (that have been split to bios) have to be recombin=
ed.
> >=20
> > As James also described, you cannot rely on clustering at all to ge=
t you
> > bigger requests. I'm thinking you are perhaps misunderstanding what=
 that
> > option does - it only potentially limits the number of sg segments =
in a
> > request, if the pages happen to be physically contig. So it'll only=
 help
> > you to a certain degree, IFF the pages are indeed adjacent in memor=
y.
> > It's an extra optimization that isn't deterministic at all.
> >=20
> The computer is deterministic. In this case we know what pages are
> physically contiguous because they have been allocated in kernel spac=
e
> with alloc_pages(). The st driver has made sure that the buffer can b=
e
> described with the scatter/gather list supported by the SCSI HBA.
>=20
> In general, you should not rely on coalescing. Here I agree with you.
> If you know what the buffer structure is, then you may be able to rel=
y
> on coalescing.

Yes your case is special, since you are the producer of the pages and
thus can control them.

> > And it definitely is unrelated to how many sectors you can support.=
 As
> > such, these two unrelated patches should submitted seperately. The
> > clustering bit is potentially more dangerous, as the hardware can h=
ave
> > all sorts of 'issues' related to the size and alignment of sg segme=
nts.
> >=20
> They are related if in the sense that both are needed in order to sup=
port=20
> large requests. However, I don't mind if someone splits those changes=
 into=20
> two patches if both go in. Otherwise I don't recommend sym53c8xx_2 an=
d/or=20
> sym53c8xx chips for any serious work any more.

=46or debug and bisect reasons alone I think it should be two patches. =
The
cluster change cannot go into 2.6.16, it's way too late for that (I
would not personally be against the max_sectors changes...).

> > > >                                                     I seem to r=
ecall
> > > > Gerard years ago talking about some sym chips that did not like
> > > > clustering, hence it was disabled.
> > > >=20
> > > Facts?
> >=20
> > I'm just reporting what Gerald (who definitely knows this hardware =
very
> > well) told me, when I submitted a patch to him enabling clustering =
a
> > long time ago. This might have been about 5 years ago, I seem to re=
call
> > it happening when I used a un ultra10 workstation which had a sym s=
csi
> > board.
> >=20
> A bit vague but I guess this is all we know. Unless Matthew knows mor=
e?

So I dig out the old mail from Gerard from April 2000, it's pasted
below.

--------------

Hi Jens,

On Sun, 23 Apr 2000, Jens Axboe wrote:

> Hi Gerard,
>=20
> I've been using my onboard adaptec 7890, but since it does not want t=
o
> do TCQ for me, I switched adapters and I'm now using your driver. Now
> I'm wondering, what is the reason that you disable clustering in the
> host template??

This had been numerous historical reasons for that. :)
(Note that the 53c7,8xx driver also disables clustering and clustering=20
does guarantee larger IO to be always possible given a max number of SG
entries).

The initial reasons were the following:

1) The ncr drivers uses a simple array of MOVE scripts instructions and
   clustering the data to decrease the number of SG entries didn't=20
   significantly increase performances.
2) Instead, th ncr/ncr53c8xx driver tried to use 512 byte sized SG
   entries if possible with a JUMP between each MOVE in order to avoid=20
   phase mismatch interrupts.

The 53c7,8xx uses the same trick, but just leave the SG sizes unchanged
(was 1K with 1K block FS).

I have removed this complexity from the sym53c8xx driver (it seemed to
me rather a loss than a win), for numerous reasons, notably:

1) The handling of unaligned transfer (notbaly WSR bit) for Wide transf=
er
   would have still complexified the SCRIPTS.
2) Starting with the 896, phase mismatches are handled from SCRIPTS and=
=20
   the additionnal JUMP between each MOVE was a penalty.
3) The trick was only interesting for small IOs but clever disk firmwar=
es=20
   mostly disconnect just after the COMMAND phase for small IOs, making=
 =20
   the MOVE+JUMP trick just useless complexity.

On paper, there is no reason to not cluster SG entries with the sym53c8=
xx
driver, but since it should not increase significantly performances nor
guarantee larger IO to be always possible, my opinion is that there is =
no
strong reason to enabled clustering by default and for Ultra <=3D 2. (F=
or 4K
=46S / 80 MB/s, I am sure there is no significant performance impact if
clustering is not enabled.

The other reason that let me hesitate to enable clustering by default, =
for
the moment, is that the size of a scatter entry must be limited to 16 M=
B.
The size is not a problem, but I would prefer to _also_ guarantee that =
a
scatter entry will not cross a 24 bit boundary given the chip core
performing 24 bit calculation. By experience, I avoid everything that m=
ay
trigger chip bugs and such a crossing smelt so to me. Btw, the 896 rev.=
 1
has such a bug documented.

Btw, in my opinion, a _usable_ clustering scheme must allow to specify:

1) A maximum length for scatter entries.
2) A bus physical boundary address to not cross within all=20
   scatter entries.

AFAIR, the Linux approach for clustering does not allow that.

However, as you can see in the sym53c8xx source, there is some provisio=
n
that catches the 16MB boundary problem of the 896 rev. 1, but this hasn=
't
been ever triggerred. If, on the other hand, your controller isn' a 896
rev. 1, clustering should normally not make problems (based on currentl=
y=20
documented chip erratas).

Speaking about current `sym' drivers for both Linux and FreeBSD. The us=
e
of the kernel Bus Dma abstraction in both O/Ses does not prevent the Dm=
a=20
interface from performing SG clustering. :-)

The clustering of SGs is, in fact, actually in use with the FreeBSD
-current sym_hipd driver (which is similar to sym53c8xx in design) sinc=
e a
couple of weeks, with some provision for the 896 rev. 1 errata. Such a
provision for 896 rev.1 also exists under Linux, obviously. No problem =
has
been reported, as expected. :-)

As you can see, the use of clustering is currently under experimentatio=
n,
somewhere. In fact, for Ultra-160, the clustering of SGs may have
mesurable good effects on performances, IMO, and I actually want it to =
be
used.

Regards,
   G=E9rard.

----------------------


--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
