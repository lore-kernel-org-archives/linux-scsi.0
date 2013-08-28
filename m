From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 1/4] [SCSI] sg: use rwsem to solve race during
 exclusive open
Date: Wed, 28 Aug 2013 08:00:19 +0400
Message-ID: <1377662419.2005.12.camel@dabdike>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
	 <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
	 <1374468033-8947-2-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374468033-8947-2-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: joern@logfs.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-07-22 at 12:40 +0800, Vaughan Cao wrote:
> A race condition may happen if two threads are both trying to open th=
e same sg
> with O_EXCL simultaneously. It's possible that they both find fsds li=
st is
> empty and get_exclude(sdp) returns 0, then they both call set_exclude=
() and
> break out from wait_event_interruptible and resume open.
>=20
> Now use rwsem to protect this process. Exclusive open gets write lock=
 and
> others get read lock. The lock will be held until file descriptor is =
closed.
> This also leads 'exclude' only a status rather than a check mark.
>=20
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>

This produces a couple of unused variable warnings which will excite th=
e
static checkers, so I've removed them:

drivers/scsi/sg.c: In function =E2=80=98sg_open=E2=80=99:
drivers/scsi/sg.c:268:6: warning: unused variable =E2=80=98res=E2=80=99=
 [-Wunused-variable]
drivers/scsi/sg.c: In function =E2=80=98sg_remove_sfp=E2=80=99:
drivers/scsi/sg.c:2138:20: warning: unused variable =E2=80=98sdp=E2=80=99=
 [-Wunused-variable]

Plus this:

> @@ -331,16 +331,19 @@ sg_open(struct inode *inode, struct file *filp)
>         if ((sfp =3D sg_add_sfp(sdp, dev)))
>                 filp->private_data =3D sfp;
>         else {
> -               if (flags & O_EXCL) {
> -                       set_exclude(sdp, 0);    /* undo if error */
> -                       wake_up_interruptible(&sdp->o_excl_wait);
> -               }
>                 retval =3D -ENOMEM;
> -               goto error_out;
> +               goto sem_out;
>         }
>         retval =3D 0;
> -error_out:
> +
>         if (retval) {
> +sem_out:
> +               if (flags & O_EXCL) {

Is insane code. You're adding a label to jump around setting retval=3D0
(which is completely superfluous: retval is already provably zero at
this point because of the check after retval =3D
scsi_autopm_get_device(sdp->device))

The sane way to write this is

	if ((sfp =3D sg_add_sfp(sdp, dev)))
		filp->private_data =3D sfp;
	else {
		retval =3D -ENOMEM;

		if (flags & O_EXCL) {
=2E..

James
