From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: Fix extraneous ref on sp's after adapter break
Date: Wed, 31 May 2017 21:08:37 +0000
Message-ID: <0CD3926A-A7BA-409F-8E43-A179D3B05CBE@cavium.com>
References: <1495740391-33124-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0059.outbound.protection.outlook.com ([104.47.33.59]:26016
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750898AbdEaVIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 17:08:40 -0400
In-Reply-To: <1495740391-33124-1-git-send-email-William.Kuzeja@stratus.com>
Content-Language: en-US
Content-ID: <59B124F9A7329E42AE0225A99936C340@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Kuzeja <william.kuzeja@stratus.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>


> On May 25, 2017, at 12:26 PM, Bill Kuzeja <william.kuzeja@stratus.com> wr=
ote:
>=20
> Hung task timeouts can result if a qlogic board breaks unexpectedly while
> running I/O. These tasks become hung because command srb reference counts
> are not going to zero, hence the affected srbs and commands do not get=20
> freed. This fix accounts for this extra reference in the srbs in the case=
=20
> of a board failure.=20
>=20
> Fixes: a465537ad1a4 ("qla2xxx: Disable the adapter and skip error recover=
y in case of register disconnect")
> Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
> ---
>=20
> I encountered this hang during by adapter break testing (on Stratus
> hardware, we need to survive adapter breaks). I noticed that we wait
> indefinitely for several commands which all have outstanding
> references to them, but which have all followed this code path:
>=20
> qla2x00_abort_all_cmds
>   qla2xxx_eh_abort
>       Exit early because qla2x00_isp_reg_stat is non-zero.
>=20
> Note that before calling qla2xxx_eh_abort from this path, we do an extra
> sp_get(sp), which takes out another reference on the current sp. If we
> do not early exit immediately from qla2xxx_eh_abort, we'll get rid of thi=
s
> extra reference through the abort - which is the normal case.
>=20
> However, if we exit immediately, this extra sp_get is never dereferenced.
> Each one of the commands flowing through this code will be stuck forever,
> resulting in hung tasks.
>=20
> This early exit in qla2xxx_eh_abort was introduced by this commit:
>=20
> commit a465537ad1a4 ("qla2xxx: Disable the adapter and skip error recover=
y in case of register disconnect.")
>=20
> The solution for this is somewhat tricky because qla2xxx_eh_abort can be
> invoked from the scsi error handler as well as qla2x00_abort_all_cmds.
> I originally thought of having qla2xxx_eh_abort remove the extra referenc=
e
> before early exiting, but not knowing the context of its invocation,
> this seemed dangerous.
>=20
> Alternatively we could also just remove the early exit case from
> qla2xxx_eh_abort, but the aforementioned commit was put in for a reason, =
so=20
> that doesn't seem correct either.
>=20
> The right thing to do seems to be putting the fix in qla2x00_abort_all_cm=
ds,
> checking the conditions we where we have exited early from qla2xxx_eh_abo=
rt
> before removing the extra reference.
>=20
> ---
> drivers/scsi/qla2xxx/qla_os.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 1c79579..1a93365 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1632,7 +1632,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *h=
a)
> void
> qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
> {
> -	int que, cnt;
> +	int que, cnt, status;
> 	unsigned long flags;
> 	srb_t *sp;
> 	struct qla_hw_data *ha =3D vha->hw;
> @@ -1662,8 +1662,12 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *=
ha)
> 					 */
> 					sp_get(sp);
> 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -					qla2xxx_eh_abort(GET_CMD_SP(sp));
> +					status =3D qla2xxx_eh_abort(GET_CMD_SP(sp));
> 					spin_lock_irqsave(&ha->hardware_lock, flags);
> +					/* Get rid of extra reference if immediate exit
> +					 * from ql2xxx_eh_abort */
> +					if (status =3D=3D FAILED && (qla2x00_isp_reg_stat(ha)))
> +						atomic_dec(&sp->ref_count);
> 				}
> 				req->outstanding_cmds[cnt] =3D NULL;
> 				sp->done(sp, res);
> --=20
> 1.8.3.1
>=20

Looks Good.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
