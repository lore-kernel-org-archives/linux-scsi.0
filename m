From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Wed, 10 Feb 2016 15:05:22 +0100
Message-ID: <20160210140522.GT27969@c203.arch.suse.de>
References: <568FE922.9090004@sandisk.com>
 <yq1oachqehs.fsf@sermon.lab.mkp.net>
 <1453251809.2320.56.camel@HansenPartnership.com>
 <56B025E4.9010009@sandisk.com>
 <1454413585.2349.11.camel@HansenPartnership.com>
 <20160203233816.00004da7@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbcBJOPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2016 09:15:08 -0500
Content-Disposition: inline
In-Reply-To: <20160203233816.00004da7@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Dick Kennedy <dick.kennedy@avagotech.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>, Hannes Reinecke <hare@suse.de>

On Wed, Feb 03, 2016 at 11:38:16PM +0100, Sebastian Herbszt wrote:
> James Bottomley wrote:
> > On Mon, 2016-02-01 at 19:43 -0800, Bart Van Assche wrote:
> > > On 01/19/16 17:03, James Bottomley wrote:
> > > > On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote:
> > > > > > > > > > "Bart" =3D=3D Bart Van Assche <bart.vanassche@sandi=
sk.com>
> > > > > > > > > > writes:
> > > > >=20
> > > > > Bart> Instead of representing the states "visible in sysfs" a=
nd
> > > > > "has
> > > > > Bart> been removed from the target list" by a single state
> > > > > variable,
> > > > > use
> > > > > Bart> two variables to represent this information.
> > > > >=20
> > > > > James: Are you happy with the latest iteration of this? Shoul=
d I
> > > > > queue
> > > > > it?
> > > >=20
> > > > Well, I'm OK with the patch: it's a simple transformation of th=
e
> > > > enumerated state to a two bit state.  What I can't see is how i=
t
> > > > fixes
> > > > any soft lockup.
> > > >=20
> > > > The only change from the current workflow is that the DEL
> > > > transition
> > > > (now the reaped flag) is done before the spin lock is dropped w=
hich
> > > > would fix a tiny window for two threads both trying to remove t=
he
> > > > same
> > > > target, but there's nothing that could possibly fix an iterativ=
e
> > > > soft
> > > > lockup caused by restarting the loop, which is what the changel=
og
> > > > says.
> > >=20
> > > Hello James,
> > >=20
> > > scsi_remove_target() doesn't lock the scan_mutex which means that=
=20
> > > concurrent SCSI scanning activity is not prohibited. Such scannin=
g=20
> > > activity can postpone the transition of the state of a SCSI targe=
t=20
> > > into STARGET_DEL. I think if the scheduler decides to run the thr=
ead=20
> > > that executes scsi_remove_target() on the same CPU as the scannin=
g=20
> > > code after the scanning code has obtained a reap ref and before t=
he=20
> > > scanning code has released the reap ref again that the soft locku=
p=20
> > > can be triggered that has been reported by Sebastian Herbszt.
> >=20
> > OK, I finally understand the scenario;  I'm not sure I understand h=
ow
> > we're getting concurrent scanning and removal from a simple rmmod .=
=2E. I
> > take it this is insmod rmmod in a tight loop?
>=20
> I am able to trigger the soft lockup with this test case run once:
>=20
> modprobe lpfc
> run fio for 10 seconds
> rmmod lpfc
>=20
> My test setup involves running qla2xxx in target mode (SCST) and
> lpfc as initiator on the same system with one exported volume.
>=20
> Dick, how did you trigger the lockup?
>=20
> Sebastian

Hi James, Bart, Martin

Have you already decided, which of the two patches you favour and when =
it'll
be included?

I have several customer reports that hit this lockup and I don't want t=
o include
one of the patches from the list just to find out the other one's is us=
ed in
mainline.

Thanks in advance,
	Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
