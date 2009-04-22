From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] dm mpath: Try recover from I/O failure by
	re-initializing the PG if device is running on one path
Date: Wed, 22 Apr 2009 10:41:44 -0700
Message-ID: <da824cf30904221041h40b87096yb4cb2784f31c5270@mail.gmail.com>
References: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 20, 2009 at 11:05 AM, Moger, Babu <Babu.Moger@lsi.com> wrote:
> This patch introduces the mechanism to recover from I/O failures by re-=
initializing the path if the device is running on only one path.
>
> Problem: Device mapper fails the path for every I/O error.
> It does not care about the type of error.

This is the fundamental problem.  Different layers of the block IO
path have to agree on how to handle each possible type of error that
can be returned. I don't know where to find such an agreement and
think an implementation that does discriminate is needed.

> There are certain errors which can be recovered by re-initializing the =
path again. I have seen this problem during my testing on rdac device han=
dler. I have observed I/O errors when there is a change in Lun ownership.=
 When Lun ownership changes device will return back with check condition =
with sense 0x05/0x94/0x01(SK/ASC/ASCQ -meaning Lun ownership changed). Cu=
rrently, device mapper fails the path for this error and eventually this =
will lead to I/O error. We don't want to see I/O error for this reason.

1) This patch isn't discriminating between transport, media, or other
device errors. Wouldn't it make sense to discriminate?
"LUN ownership changed" sounds like some of the events possible in
multi-inititiator enviroment would want to be notified about and
perhaps even take some action (renegotiate access to

2) Will this result in resetting a SATA device?
I ask because device reset may result in data loss due to WCE enabled.
I just don't know the higher parts of the block SW stack and how
errors flow up the stack.

thanks,
grant

>
> The patch will set the flag pg_init_required if the device is running o=
n single path. The process_queued_ios will re-initialize path if required=
. I have tested this patch on LSI rdac handler.
>
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> ---
>
> --- linux-2.6.30-rc2/drivers/md/dm-mpath.c.orig 2009-04-17 16:49:33.000=
000000 -0500
> +++ linux-2.6.30-rc2/drivers/md/dm-mpath.c =C2=A0 =C2=A0 =C2=A02009-04-=
17 17:09:51.000000000 -0500
> @@ -1152,6 +1152,15 @@ static int do_end_io(struct multipath *m
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(&m->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* If this is the only path left, then lets=
 try to
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* re-initialize the PG one last time..
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (m->nr_valid_paths =3D=3D 1 && m->hw_handler_=
name) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 m->pg_init_required =
=3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqresto=
re(&m->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto requeue;
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!m->nr_valid_paths) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (__must_push_=
back(m)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0spin_unlock_irqrestore(&m->lock, flags);
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>
