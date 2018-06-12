From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: RE: [PATCH] scsi: qla4xxx: add error handling for try_module_get
Date: Tue, 12 Jun 2018 07:52:26 +0000
Message-ID: <MW2PR07MB4042EC187A6945E4F39D97FAE37F0@MW2PR07MB4042.namprd07.prod.outlook.com>
References: <1528778910-42113-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528778910-42113-1-git-send-email-jiazhouyang09@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Zhouyang Jia <jiazhouyang09@gmail.com>
> Sent: Tuesday, June 12, 2018 10:18 AM
> Cc: Zhouyang Jia <jiazhouyang09@gmail.com>; Dept-Eng QLogic Storage
> Upstream <QLogic-Storage-Upstream@cavium.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com=
>;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: qla4xxx: add error handling for try_module_get
>=20
> When try_module_get fails, the lack of error-handling code may cause
> unexpected results.
>=20
> This patch adds error-handling code after calling try_module_get.
>=20
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c index
> 0e13349..6b677ab 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -7687,7 +7687,10 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct
> iscsi_cls_session *cls_sess)
>  	 * to be seamless without actually destroying the
>  	 * session
>  	 **/
> -	try_module_get(qla4xxx_iscsi_transport.owner);
> +	if (!try_module_get(qla4xxx_iscsi_transport.owner))
> +		ql4_printk(KERN_WARNING, ha,
> +			"%s: cannot get module.\n", __func__);
> +
>  	iscsi_destroy_endpoint(ddb_entry->conn->ep);
>=20
>  	spin_lock_irqsave(&ha->hardware_lock, flags); @@ -8970,7 +8973,9
> @@ static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
>  			 * to be seamless without actually destroying the
>  			 * session
>  			 **/
> -			try_module_get(qla4xxx_iscsi_transport.owner);
> +			if (!try_module_get(qla4xxx_iscsi_transport.owner))
> +				ql4_printk(KERN_WARNING, ha,
> +					"%s: cannot get module.\n",
> __func__);
>  			iscsi_destroy_endpoint(ddb_entry->conn->ep);
>  			qla4xxx_free_ddb(ha, ddb_entry);
>  			iscsi_session_teardown(ddb_entry->sess);
> --
> 2.7.4

Thanks,

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
