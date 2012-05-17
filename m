From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 12:46:35 -0700
Message-ID: <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
References: <20120511143341.GA18753@logfs.org>
	 <20120517162600.GA18067@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120517162600.GA18067@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-05-17 at 12:26 -0400, J=C3=B6rn Engel wrote:
> As the comment explains, we have a race between dropping the refcount=
 to
> zero and actually removing the session from lookup tables.  Plug this=
 by
> checking the refcount on lookup.
>=20
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   28 ++++++++++++++++++++++++++=
++
>  1 file changed, 28 insertions(+)
>=20

Hi Joern!

> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xx=
x/tcm_qla2xxx.c
> index 09a70aa..b1bfa08 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1300,6 +1300,20 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_s=
ess_by_s_id(
>  		return NULL;
>  	}
> =20
> +	/*
> +	 * We drop the hardware_lock between dropping the reference count t=
o
> +	 * zero and removing the session from the btree.  Therefore it
> +	 * is possible to successfully lookup a session after it has been
> +	 * scheduled for removal, but before actual removal.  Result is pre=
tty
> +	 * good chance of dereferencing freed memory in qlt_issue_task_mgmt=
=2E
> +	 *
> +	 * Proper fix would be to atomically drop the refcount and remove t=
he
> +	 * session from all data structures that would allow lookup.  Until
> +	 * then this tasteless hack shall suffice.
> +	 */
> +	if (atomic_read(&nacl->qla_tgt_sess->se_sess->sess_kref.refcount) =3D=
=3D 0)
> +		return NULL;
> +
>  	return nacl->qla_tgt_sess;
>  }
> =20

Mmmmm, I'd still like to try to avoid (another) atomic op in the fast
path w/ hardware_lock held if at all possible..

Also thinking more about the case in your comment, I'm starting to
wonder if tcm_qla2xxx_free_session() should be obtaining hardware_lock =
+
clearing the s_id and loop_id lookup entries earlier than currently
done..

That is, target_wait_for_sess_cmds() is called before clearing the
nodeacl pointers from s_id + loop_id in tcm_qla2xxx_free_session(),
which means that we still perform se_node_acl lookups in the case where
the individual tcm_qla2xxx endpoint was not also being shutdown as
well..

So that said, I think your work-around is OK to address the current BUG=
,
but the s_id + loop_id clearing order in tcm_qla2xxx_free_session()
would be having an effect here as well..

--nab
