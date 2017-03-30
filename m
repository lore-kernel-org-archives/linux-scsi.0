From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] iscsi-target: Fix TMR reference leak during session
 shutdown
Date: Thu, 30 Mar 2017 17:08:10 +0000
Message-ID: <1490893673.2753.8.camel@sandisk.com>
References: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
         <1490862594-2712-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490862594-2712-2-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Content-ID: <AB1B9C4A9F262640875441870FD55222@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cyl@datera.io" <cyl@datera.io>, "jcs@datera.io" <jcs@datera.io>, "rlm@daterainc.com" <rlm@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-03-30 at 08:29 +0000, Nicholas A. Bellinger wrote:
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/is=
csi/iscsi_target_util.c
> index 5041a9c..b464033 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -737,21 +737,23 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool sh=
utdown)
>  {
>  	struct se_cmd *se_cmd =3D NULL;
>  	int rc;
> +	bool op_scsi =3D false;
>  	/*
>  	 * Determine if a struct se_cmd is associated with
>  	 * this struct iscsi_cmd.
>  	 */
>  	switch (cmd->iscsi_opcode) {
>  	case ISCSI_OP_SCSI_CMD:
> -		se_cmd =3D &cmd->se_cmd;
> -		__iscsit_free_cmd(cmd, true, shutdown);
> +		op_scsi =3D true;
>  		/*
>  		 * Fallthrough
>  		 */
>  	case ISCSI_OP_SCSI_TMFUNC:
> -		rc =3D transport_generic_free_cmd(&cmd->se_cmd, shutdown);
> -		if (!rc && shutdown && se_cmd && se_cmd->se_sess) {
> -			__iscsit_free_cmd(cmd, true, shutdown);
> +		se_cmd =3D &cmd->se_cmd;
> +		__iscsit_free_cmd(cmd, op_scsi, shutdown);
> +		rc =3D transport_generic_free_cmd(se_cmd, shutdown);
> +		if (!rc && shutdown && se_cmd->se_sess) {
> +			__iscsit_free_cmd(cmd, op_scsi, shutdown);
>  			target_put_sess_cmd(se_cmd);
>  		}
>  		break;

Hello Nic,

I agree that this patch fixes a leak. However, an existing bug in
iscsit_free_cmd() is not addressed by this patch. Before the TMF code start=
ed
using kref_get() / kref_put() it was possible for transport_generic_free_cm=
d()
to determine whether or not iscsit_free_cmd() should call __iscsit_free_cmd=
()
by checking the command reference count. I think that since the TMF code
manipulates the command reference count it is no longer possible for
transport_generic_free_cmd() to determine this. If iscsit_free_cmd() is cal=
led
while a LUN RESET is in progress then the return value of
transport_generic_free_cmd() will be wrong. I will post a few patches that =
not
only address what I just described but also the leak fixed by this patch.

Bart.=
