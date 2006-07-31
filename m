From: Jens Axboe <axboe@suse.de>
Subject: Re: cd burning with plextor drives.
Date: Mon, 31 Jul 2006 11:32:26 +0200
Message-ID: <20060731093225.GN14748@suse.de>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47203 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932068AbWGaJcX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 05:32:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

On Sat, Jul 29 2006, Linus Torvalds wrote:
>=20
>=20
> On Sat, 29 Jul 2006, Jens Axboe wrote:
> >=20
> > I'd greatly prefer just ripping the entire command access table out=
, it
> > was a mistake to begin with and still just a horrible solution.
>=20
> Well, I don't think the _notion_ of a command access table is the pro=
blem=20
> per se.=20
>=20
> I just think that "sg.c" is badly done.
>=20
> We do it _correctly_ in the sane paths (ie we really have the "same t=
able"=20
> in "verify_command()" in block/scsi_ioctl.c), and the thing is, when =
done=20
> correctly, the command access table is a perfectly fine idea.
>=20
> And the thing is, that "verify_command()" is absolutely _required_. A=
s=20
> root, you can send any command you want, but we really _do_ want norm=
al=20
> users to be able to send a sane subset, without allowing them to do o=
ther=20
> things just because they have write access to the medium.

If you feel that the command screening is required, then I'd suggest we
start adding some flexibility to it. As Doug pointed out, it's very MMC
centric right now. And you have have the problem of wanting to allow
some commands for certain devices, some for others, but not have perfec=
t
overlap. Vendor specific commands is another problem, some of them are
required for functionality on newer Plextor (not making this up or got
it from Joerg, it's a fact) drives. We can never add vendor specific
commands right now though, as they are device specific.

One possible approach is this:

http://git.kernel.dk/?p=3Dlinux-2.6-block.git;a=3Dcommitdiff;h=3D63bfd0=
060d0feb5f3ba161c2c1e6e8082fe2f68d

exposing the command table to user space through a filter in the queue
directory of that request queue.

What do you think of that approach?

> > In fact, I think we should decide soon what to do about it. At the
> > storage summit, there was general consensus on just killing it as w=
ell.
>=20
> I don't think there's any point to killing it.
>=20
> The fact is, anybody who works with a known storage device simply SHO=
ULD=20
> NOT USE THE sg.c INTERFACES. Only totally insane people (ie J=F6rg=20
> Schilling) think that it's even remotely sane. If you know it's a sto=
rage=20
> device, you should use the proper block interfaces, and instad of doi=
ng
>=20
> 	cdrecord -dev=3DATA:1,0,0
>=20
> the person should really have done
>=20
> 	cdrecord -dev=3D/dev/hdc
>=20
> or something sane, and gone through the proper channels, instead of g=
oing=20
> through the nightmare that is Schillings "brain").
>=20
> In fact, I would seriously suggest that distributions should disallow=
 the=20
> insane interfaces to cdrecord.
>=20
> "sg.c" makes sense for SCSI laser range fingers and other strange stu=
ff.=20
> It does _not_ make sense for CD-ROM access.
>=20
> Btw, it's entirely possible that you might hit the same problem with=20
> /dev/hdc too. But at that point it should be 100% obvious that
>=20
>  - only root can ever be allowed to generate commands that the kernel=
 has=20
>    no clue what they are doing. NO WAY can we allow a user to generat=
e=20
>    postentially hardware-changing special commands just because he ca=
n=20
>    access the CD-ROM (ie how would the kernel know that it's not a co=
mmand=20
>    that says "rewrite the firmware with something that always reads g=
oatse=20
>    off the disk"?)
>=20
>  - if cdrecord tries to do some device-specific setup, and is upset t=
hat=20
>    it can't do it because the user isn't root, then it's obviously a=20
>    cdrecord bug. Which wouldn't surprise me at all - can we _please_ =
not=20
>    rely on code that has been written by a certified nut-case?
>=20
> And in either case, I don't think this is a kernel bug, unless it als=
o=20
> happens as root, of course.

=46orget sg.c vs scsi_ioctl.c, that is a separate issue that bsg should
unify in the future. The command table affects them all though, and the
fact that we have differing access limitation in scsi_ioctl vs sg right
now is a little sad. But a separate issue.

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
