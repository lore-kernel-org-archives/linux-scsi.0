From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Tue, 27 Dec 2011 14:40:39 +0100
Message-ID: <20111227144039.1b5c5c20@stein>
References: <4EE8E419.8010000@pre-sense.de>
	<CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com>
	<20111225215804.03ef9402@stein>
	<4EF99C3C.8030602@pre-sense.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EF99C3C.8030602@pre-sense.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Axel Theilmann <theilmann@pre-sense.de>
Cc: linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, jbottomley@parallels.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Dec 27 Axel Theilmann wrote:
> On 12/25/2011 09:58 PM, Stefan Richter wrote:
[...
>>> =E5=9C=A8 2011=E5=B9=B412=E6=9C=8815=E6=97=A5 =E4=B8=8A=E5=8D=881:5=
9=EF=BC=8CAxel Theilmann <theilmann@pre-sense.de> =EF=BC=9A
>>>> two weeks ago Huajun Li posted a patch for a kernel oops, subject
>>>> [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk".
>>>>=20
>>>> The patch was discussed but considered "clearly wrong". The bug sh=
ows
>>>> up for us in kernel 3.1.4 quite often when unplugging usb sticks a=
nd
>>>> it seems a few other people have the same problem:
>>>>=20
>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/859199
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D754518
>>>> https://bugzilla.novell.com/show_bug.cgi?id=3D722350
>>>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D649735
>>>>=20
>>>> Can anyone of you maybe give me any status update on that bug?
=2E..]
> > as far as I remember, all Linux releases in 2011 have been broken W=
RT hot
> > removal of block devices; some more severely, some less.  Various p=
atches
> > for this went in over the year, but if they fixed anything, they al=
ways
> > uncovered the next lingering unplug related bug.  The presumed firs=
t Linux
>=20
> so now there are 2 known NULL-pointer problems in the cd-rom code and=
 one in
> the scsi-disk code.

The two CD-ROM related traces which I posted seem to indicate a bug
between block layer's and SCSI core lifetime managements, rather than i=
n
the cd-rom code particularly.  When I get the time, I will try the
"1. open(), 2. remove device, 3. ioctl()" sequence on an sd_mod device
instead of an sr_mod one and see where this goes.

> Would a complete fix for this issue be a question of locating all the
> possible NULL-pointers and fixing them or do you think that the hotpl=
ug
> problem has to be fixed on a more "fundamental" level?

I don't know what my two traces tell us what particularly is broken and
where to attack the problem.

In case of the sd_revalidate_disk oops from the thread which I highjack=
ed
(which refers to "[PATCH] SCSI/sd: Fix NULL dereference in
sd_revalidate_disk", http://thread.gmane.org/gmane.linux.scsi/71174), t=
he
trouble is that nobody came up with an answer to James' question on how=
 it
could happen in the first place that sd_revalidate_disk(disk) could be
called on a disk that leads to a NULL scsi_disk.  In turn, this presuma=
bly
means among else that the answer to my earlier question --- what preven=
ts
the scsi_disk to go invalid slightly after that newly added NULL pointe=
r
check --- cannot be answered yet either.

However, I do think that the pitiful state of block device unplugging
throughout circa a whole year indicates a fundamental problem indeed.  =
But
I am only familiar with one of the SCSI transport layer drivers, not wi=
th
the kernel layers above, so what do I know.

> Even if there is a more fundamental problem below that has to be fixe=
d, it
> would still be nice to get in fixes for the dereferences that are cur=
rently
> known to keep peoples systems from crashing.
>=20
> We built a kernel with Huajun's patch included and will do some tests=
 to see
> if the problem goes away (and no others show up).

AFAIU it is not clear whether this patch actually prevents dereference =
of
an invalid sdkp or only makes it considerably more unlikely.

In either case, since there is apparently an underlying issue that this
patch does not address, it is a judgment call whether such a patch is
allowed into a kernel --- distributor kernel or mainline kernel.  If
somebody takes it, then at least a FIXME comment should be put there th=
at
sd_revalidate_disk is supposed to rely on an always valid sdkp.

> > With a little bit of bad luck, udisks-daemon or in older distros ha=
ld
> > should hit the bug too.  Under kernel 3.1 I typically just got proc=
esses
> > hanging in unkillable sleep.  With kernel 3.2-rc7 I get an instant =
kernel
> > panic.
>=20
> Yes, udisks is what probably triggers the bug for us. People removing=
 USB
> media before udisks is finished initializing the medium. With kernel =
3.1.4
> we get instant kernel panics as well.
>=20
> tty, axel

Sounds like both "your" and "my" bug occur at the end of the sequence

    1. open(), 2. remove device, 3. ioctl() or whatever

though perhaps with the extra twist in your case that this has to happe=
n
before the device bring-up was entirely finished...?  In my CD-ROM rela=
ted
case the bug is not timing-sensitive at all; it always happens with abo=
ve
sequence.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D=3D =3D=3D-- =3D=3D-=3D=3D
http://arcgraph.de/sr/
