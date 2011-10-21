From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st: fix race in st_scsi_execute_end
Date: Fri, 21 Oct 2011 20:00:54 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1110212000010.5184@kai.makisara.local>
References: <20111021113108.GA26181@foxbat.suse.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-168531485-1319216466=:5184"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111021113108.GA26181@foxbat.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Uzel <petr.uzel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>, jack@suse.cz, linux-scsi@vger.kernel.org, juergen.gross@ts.fujitsu.com
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-168531485-1319216466=:5184
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011, Petr Uzel wrote:

> The call to complete() in st_scsi_execute_end() wakes up sleeping threa=
d
> in write_behind_check(), which frees the st_request, thus invalidating
> the pointer to the associated bio structure, which is then passed to th=
e
> blk_rq_unmap_user(). Fix by storing pointer to bio structure into
> temporary local variable.
>=20
> This bug is present since at least linux-2.6.32.
>=20
> CC: stable@kernel.org
> Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
> Reported-by: Juergen Gro=C3=9F <juergen.gross@ts.fujitsu.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

> ---
>  drivers/scsi/st.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 1871b8a..9b28f39 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -462,14 +462,16 @@ static void st_scsi_execute_end(struct request *r=
eq, int uptodate)
>  {
>  	struct st_request *SRpnt =3D req->end_io_data;
>  	struct scsi_tape *STp =3D SRpnt->stp;
> +	struct bio *tmp;
> =20
>  	STp->buffer->cmdstat.midlevel_result =3D SRpnt->result =3D req->error=
s;
>  	STp->buffer->cmdstat.residual =3D req->resid_len;
> =20
> +	tmp =3D SRpnt->bio;
>  	if (SRpnt->waiting)
>  		complete(SRpnt->waiting);
> =20
> -	blk_rq_unmap_user(SRpnt->bio);
> +	blk_rq_unmap_user(tmp);
>  	__blk_put_request(req->q, req);
>  }
> =20
>=20

Thanks for the fix.

Kai

---1463811327-168531485-1319216466=:5184--
