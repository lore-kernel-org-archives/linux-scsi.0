From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 20/25] qla2xxx: Remove redundant code
Date: Fri, 19 May 2017 23:43:00 +0000
Message-ID: <1495237379.2581.19.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-21-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:3285 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751818AbdESXnD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 19:43:03 -0400
In-Reply-To: <20170519215344.2168-21-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <C65C32A83FD86E4C9E6DA266BF9106DE@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> During ABTS or Abort task, qla2xxx does a pre-search for
> the se_cmd, based on command's tag. The same search is
> performed by TCM. Remove the extra search from qla2xxx.
>=20
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 21e8993baf4b..b8e609ae6cff 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1836,34 +1836,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla=
_host *vha,
>  	struct abts_recv_from_24xx *abts, struct fc_port *sess)
>  {
>  	struct qla_hw_data *ha =3D vha->hw;
> -	struct se_session *se_sess =3D sess->se_sess;
>  	struct qla_tgt_mgmt_cmd *mcmd;
> -	struct se_cmd *se_cmd;
>  	int rc;
> -	bool found_lun =3D false;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> -		if (se_cmd->tag =3D=3D abts->exchange_addr_to_abort) {
> -			found_lun =3D true;
> -			break;
> -		}
> -	}
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> =20
> -	/* cmd not in LIO lists, look in qla list */
> -	if (!found_lun) {
> -		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
> -			/* send TASK_ABORT response immediately */
> -			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
> -			return 0;
> -		} else {
> -			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
> -			    "unable to find cmd in driver or LIO for tag 0x%x\n",
> -			    abts->exchange_addr_to_abort);
> -			return -ENOENT;
> -		}
> +	if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
> +		/* send TASK_ABORT response immediately */
> +		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
> +		return 0;
>  	}
> =20
>  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,

Hello Himanshu and Quinn,

Please drop this patch. If a command has already been submitted to the LIO
core and an ABTS is received then the LIO core should be requested to perfo=
rm
the abort. This patch changes the behavior of the qla2xxx target driver suc=
h
that the LIO core is not informed at all if abort_cmd_for_tag() finds the
command that has to be aborted in one of the command lists maintained by th=
e
qla2xxx driver.=A0That can lead to the presence of overlapping writes in th=
e
command set on the target system and hence to data corruption. Please note
that I had proposed a better approach on the target-devel mailing list and
that I'm still waiting for someone from Cavium to review these patches:
* [PATCH v6 09/33] target: Make it possible to specify I_T nexus for SCSI
  abort (http://www.spinics.net/lists/target-devel/msg14534.html).
* [PATCH v6 10/33] tcm_qla2xxx: Let the target core look up the LUN of the
  aborted cmd (http://www.spinics.net/lists/target-devel/msg14563.html).

Bart.=
