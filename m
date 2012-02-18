From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer dereference
Date: Fri, 17 Feb 2012 17:36:07 -0800
Message-ID: <CAL1RGDXdVjZsOa=-guuBxXGWG1m9Ff9Q7S=+CLa66AkXY0arqQ@mail.gmail.com>
References: <20120217203939.GA955@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120217203939.GA955@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, target-devel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 17, 2012 at 12:39 PM, J=F6rn Engel <joern@logfs.org> wrote:
> Afaics the assignment does not need to be protected by ha->tgt_mutex =
and
> we definitely should check for NULL before dereferencing sess.
>
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
> =A0drivers/scsi/qla2xxx/qla_target.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx=
/qla_target.c
> index ac203ef..4bbfa88 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2586,12 +2586,12 @@ static void qla_tgt_do_work(struct work_struc=
t *work)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_lock(&ha->tgt_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cmd->sess =3D sess =3D qla_tgt_make_lo=
cal_sess(vha, s_id, loop_id);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->loop_id =3D sess->loop_id;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* sess has got an extra creation ref =
*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ha->tgt_mutex);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!sess)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_term;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->loop_id =3D sess->loop_id;

Good catch... maybe it's cleaner if we just use the loop_id local varia=
ble we
already have anyway?  (Not that it really matters either way)
