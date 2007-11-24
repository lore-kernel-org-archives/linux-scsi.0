From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Date: Sat, 24 Nov 2007 15:26:49 +0200
Message-ID: <1195910809.3195.5.camel@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <4744A6F2.4030302@free.fr>
	 <20071121144116.c932727b.akpm@linux-foundation.org>
	 <4746814F.80502@free.fr> <4746866B.5070207@suse.de>
	 <4746BB9D.2030508@suse.de>  <4747135C.60205@free.fr>
	 <1195886569.3195.2.camel@localhost.localdomain>  <47481FA6.9050506@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54134 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbXKXN0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Nov 2007 08:26:54 -0500
In-Reply-To: <47481FA6.9050506@free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2007-11-24 at 13:57 +0100, Laurent Riffard wrote:
> Le 24.11.2007 07:42, James Bottomley a =C3=A9crit :
> > On Fri, 2007-11-23 at 18:52 +0100, Laurent Riffard wrote:
> >> Le 23.11.2007 12:38, Hannes Reinecke a =C3=A9crit :
> >>> Hannes Reinecke wrote:
> >>>> Laurent Riffard wrote:
> >>>>> Le 21.11.2007 23:41, Andrew Morton a =C3=A9crit :
> >>>>>> On Wed, 21 Nov 2007 22:45:22 +0100
> >>>>>> Laurent Riffard <laurent.riffard@free.fr> wrote:
> >>>>>>
> >>>>>>> Le 21.11.2007 05:45, Andrew Morton a =C3=A9crit :
> >>>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.=
6/2.6.24-rc3/2.6.24-rc3-mm1/
> >>>>>>> Hello,=20
> >>>>>>>
> >>>>>>> My system hangs shortly after I logged in Gnome desktop. SysR=
q-W shows
> >>>>>>> that a bunch of task are blocked in "D" state, they seem to w=
ait for
> >>>>>>> some I/O completion. I can try to hand-copy some data if requ=
ested.
> >>>>>>>
> >>>>>>> I found these messages in dmesg:
> >>>>>>>
> >>>>>>> ~$ grep -C2 end_request dmesg-2.6.24-rc3-mm1=20
> >>>>>>> EXT3-fs: mounted filesystem with ordered data mode.
> >>>>>>> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_NO_CONNECT driverbyt=
e=3DDRIVER_OK,SUGGEST_OK
> >>>>>>> end_request: I/O error, dev sda, sector 16460
> >>>>>>> ReiserFS: sda7: found reiserfs format "3.6" with standard jou=
rnal
> >>>>>>> ReiserFS: sda7: using ordered data mode
> >>>>>>> --
> >>>>>>> ReiserFS: sda7: Using r5 hash to sort names
> >>>>>>> sd 0:0:1:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT driverbyt=
e=3DDRIVER_OK,SUGGEST_OK
> >>>>>>> end_request: I/O error, dev sdb, sector 19632
> >>>>>>> sd 0:0:1:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT driverbyt=
e=3DDRIVER_OK,SUGGEST_OK
> >>>>>>> end_request: I/O error, dev sdb, sector 40037363
> >>>>>>> Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priorit=
y:-1 extents:1 across:1048568k
> >>>>>>> lp0: using parport0 (interrupt-driven).
> >>>>>>>
> >>>>>>> These errors occur *only* with 2.6.24-rc3-mm1, they are 100% =
reproducible.
> >>>>>>> 2.6.24-rc3 and 2.6.24-rc2-mm1 are fine.
> >>>>>>>
> >>>>>>> Maybe something is broken in pata_via driver ?
> >>>>>>>
> >>>>>> Could be - libata-reimplement-ata_acpi_cbl_80wire-using-ata_ac=
pi_gtm_xfermask.patch
> >>>>>> and pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-u=
dma-timings.patch
> >>>>>> touch pata_via.c.
> >>>>> None of the above...
> >>>>>
> >>>>> I did a bisection, it spotted git-scsi-misc.patch.=20
> >>>>> I just run 2.6.24-rc3-mm1 + revert-git-scsi-misc.patch, and it =
works fine.
> >>>>>
> >>>>> I guess commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0 "[SCSI]=
 Do not=20
> >>>>> requeue requests if REQ_FAILFAST is set" is the real culprit. T=
he other=20
> >>>>> commits are touching documentation or drivers I don't use. I'll=
 try=20
> >>>>> to revert only this one this evening.
> >> I can confirm : reverting commit 8655a546c83fc43f0a73416bbd126d02d=
e7ad6c0=20
> >> does fix the problem.
> >>
> >>>> Hmm. Weird. I'll have a look into it. Apparently I'll be returni=
ng an error where
> >>>> I shouldn't. Checking ...
> >>>>
> >>> Ok, found it. We are blocking even special commands (ie requests =
with PREEMPT not set)
> >>> when FAILFAST is set. Which is clearly wrong. The attached patch =
fixes this.
> >> Sorry, it's not enough. 2.6.24-rc3-mm1 + your patch still hangs wi=
th I/O errors.
> >=20
> > I think the problem is the way we treat BLOCKED and QUIESCED (the l=
atter
> > is the state that the domain validation uses and which we cannot ki=
ll
> > fastfail on).  It's definitely wrong to kill fastfail requests when=
 the
> > state is QUIESCE.
> >=20
> > This patch (which is applied on top of Hannes original) separates t=
he
> > BLOCK and QUIESCE states correctly ... does this fix the problem?
>=20
>=20
> No, it doesn't help... (2.6.24-rc3-mm1 + your patch still has problem=
s)

OK, could you post dmesgs again, please.  I actually tested this with a=
n
aic79xx card, and for me it does cause Domain Validation to succeed
again.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
