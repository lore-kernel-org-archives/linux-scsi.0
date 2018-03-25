From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH v3] scsi: ufs: add trace event for ufs upiu
Date: Sun, 25 Mar 2018 13:44:37 +0000
Message-ID: <MWHPR04MB1137878F56EFB4522602228B9AAE0@MWHPR04MB1137.namprd04.prod.outlook.com>
References: <1521961684-13588-1-git-send-email-ohad.sharabi@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521961684-13588-1-git-send-email-ohad.sharabi@sandisk.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>, Ohad Sharabi <Ohad.Sharabi@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Looks fine.

Reviewed-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

> -----Original Message-----
> From: Ohad Sharabi [mailto:ohad.sharabi@sandisk.com]
> Sent: Sunday, March 25, 2018 10:08 AM
> To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>; jejb@linux.vnet.ibm.=
com; martin.petersen@oracle.com;
> gregkh@linuxfoundation.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Alex Lember=
g <Alex.Lemberg@wdc.com>; Ohad Sharabi
> <Ohad.Sharabi@wdc.com>
> Subject: [PATCH v3] scsi: ufs: add trace event for ufs upiu
>=20
> Add UFS Protocol Information Units(upiu) trace events for ufs driver,
> used to trace various ufs transaction types- command, task-management
> and device management.
> The trace-point format is generic and can be easily adapted to trace
> other upius if needed.
> Currently tracing ufs transaction of type 'device management', which
> this patch introduce, cannot be obtained from any other trace.
> Device management transactions are used for communication with the
> device such as reading and writing descriptor or attributes etc.
>=20
> v2->v3:
>     - modify args 3,4 of trace_ufshcd_upiu to be void *
>=20
> v1->v2:
>     - split to transaction specific functions (fix warnings and simplifie=
s
>       code)
>     - adding traces when sending query command
>=20
> Signed-off-by: Ohad Sharabi <ohad.sharabi@sandisk.com>
> ---
>  drivers/scsi/ufs/ufshcd.c  | 40 ++++++++++++++++++++++++++++++++++++++++
>  include/trace/events/ufs.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c7da2c1..23ffaed 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -274,6 +274,35 @@ static inline void ufshcd_remove_non_printable(char =
*val)
>  		*val =3D ' ';
>  }
>=20
> +static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
> +		const char *str)
> +{
> +	struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
> +
> +	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb);
> +}
> +
> +static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned in=
t tag,
> +		const char *str)
> +{
> +	struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
> +
> +	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
> +}
> +
> +static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int t=
ag,
> +		const char *str)
> +{
> +	struct utp_task_req_desc *descp;
> +	struct utp_upiu_task_req *task_req;
> +	int off =3D (int)tag - hba->nutrs;
> +
> +	descp =3D &hba->utmrdl_base_addr[off];
> +	task_req =3D (struct utp_upiu_task_req *)descp->task_req_upiu;
> +	trace_ufshcd_upiu(dev_name(hba->dev), str, &task_req->header,
> +			&task_req->input_param1);
> +}
> +
>  static void ufshcd_add_command_trace(struct ufs_hba *hba,
>  		unsigned int tag, const char *str)
>  {
> @@ -283,6 +312,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba,
>  	struct ufshcd_lrb *lrbp;
>  	int transfer_len =3D -1;
>=20
> +	/* trace UPIU also */
> +	ufshcd_add_cmd_upiu_trace(hba, tag, str);
> +
>  	if (!trace_ufshcd_command_enabled())
>  		return;
>=20
> @@ -2584,6 +2616,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>=20
>  	hba->dev_cmd.complete =3D &wait;
>=20
> +	ufshcd_add_query_upiu_trace(hba, tag, "query_send");
>  	/* Make sure descriptors are ready before ringing the doorbell */
>  	wmb();
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -2593,6 +2626,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>=20
>  	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>=20
> +	ufshcd_add_query_upiu_trace(hba, tag,
> +			err ? "query_complete_err" : "query_complete");
> +
>  out_put_tag:
>  	ufshcd_put_dev_cmd_tag(hba, tag);
>  	wake_up(&hba->dev_cmd.tag_wq);
> @@ -5464,11 +5500,14 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hb=
a, int lun_id, int task_id,
>=20
>  	spin_unlock_irqrestore(host->host_lock, flags);
>=20
> +	ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_send");
> +
>  	/* wait until the task management command is completed */
>  	err =3D wait_event_timeout(hba->tm_wq,
>  			test_bit(free_slot, &hba->tm_condition),
>  			msecs_to_jiffies(TM_CMD_TIMEOUT));
>  	if (!err) {
> +		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
>  		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
>  				__func__, tm_function);
>  		if (ufshcd_clear_tm_cmd(hba, free_slot))
> @@ -5477,6 +5516,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba,=
 int lun_id, int task_id,
>  		err =3D -ETIMEDOUT;
>  	} else {
>  		err =3D ufshcd_task_req_compl(hba, free_slot, tm_response);
> +		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete");
>  	}
>=20
>  	clear_bit(free_slot, &hba->tm_condition);
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index bf6f826..f8260e5 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -257,6 +257,33 @@
>  	)
>  );
>=20
> +TRACE_EVENT(ufshcd_upiu,
> +	TP_PROTO(const char *dev_name, const char *str, void *hdr, void *tsf),
> +
> +	TP_ARGS(dev_name, str, hdr, tsf),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(str, str)
> +		__array(unsigned char, hdr, 12)
> +		__array(unsigned char, tsf, 16)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(str, str);
> +		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
> +		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
> +	),
> +
> +	TP_printk(
> +		"%s: %s: HDR:%s, CDB:%s",
> +		__get_str(str), __get_str(dev_name),
> +		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
> +		__print_hex(__entry->tsf, sizeof(__entry->tsf))
> +	)
> +);
> +
>  #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) =
*/
>=20
>  /* This part must be outside protection */
> --
> 1.9.1
