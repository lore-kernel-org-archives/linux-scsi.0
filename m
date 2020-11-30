Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E309BC63777
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D548206ED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NZBJwQyJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgK3TPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 14:15:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39972 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729807AbgK3TPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 14:15:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ8s9s174184;
        Mon, 30 Nov 2020 19:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=tU9nLjqDNXK+M2JY2PVv2wtQvPYCdueyaELjIcVunZc=;
 b=NZBJwQyJfwDl7zr4u2wZXrpkAMzvM++PAr43ObpesRnQas59JaaUDCy3KP+9qYY1bpw5
 Xwu5kKvHGPn6CjqM+fm9xOP+dqnSRdkooxWQLrc/r6hqvUJ+aPRgP2FgaLV1BAQRUTi/
 VSynVpKIpOst0T5nbaQwFtBQzOwYE5LWilTwhDdN+K7M/togr9c3dTzCRLtldDy6mgOg
 7hr7c9wgIpiL9xqpaAffp97FMeSbQWHxa1NdtdnmnJeKm2/sCScCB6SA12pkWCADh3IG
 zgBaU5VcGmPeSfZ9SInVnOnlgChiLtFebnUqzzGq9DYJUJ1C/q4E3FizCR5HOGo/Hv8M KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2aq034-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 19:14:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ5Mof137178;
        Mon, 30 Nov 2020 19:14:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fvkfyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:14:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUJEV34016270;
        Mon, 30 Nov 2020 19:14:31 GMT
Received: from dhcp-10-154-168-92.vpn.oracle.com (/10.154.168.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 11:14:31 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 06/14] scsi: qla2xxx: init/os: Remove in_interrupt().
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201126132952.2287996-7-bigeasy@linutronix.de>
Date:   Mon, 30 Nov 2020 13:14:30 -0600
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>, linux-m68k@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <49C65644-69D7-45FB-AD9E-D6E15EB86618@oracle.com>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-7-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 26, 2020, at 7:29 AM, Sebastian Andrzej Siewior =
<bigeasy@linutronix.de> wrote:
>=20
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>=20
> qla83xx_wait_logic() is used to control the frequency of device IDC =
lock
> retries. If in_interrupt() is true, it does 20 loops of cpu_relax().
> Otherwise, it sleeps for 100ms and yields the CPU.
>=20
> While in_interrupt() is ill-defined and does not provide what the name
> suggests, it is not needed here: that qla83xx_wait_logic() is =
exclusively
> called by qla83xx_idc_lock() / unlock(), and they always run from
> process context. Below is an analysis of all the idc lock/unlock =
callers,
> in order of appearance:
>=20
>  - qla_os.c:
>      qla83xx_nic_core_unrecoverable_work(),
>      qla83xx_idc_state_handler_work(),
>      qla83xx_nic_core_reset_work(),
>      qla83xx_service_idc_aen(), all workqueue context
>=20
>  - qla_os.c: qla83xx_check_nic_core_fw_alive(), has msleep()
>=20
>  - qla_os.c: qla83xx_set_drv_presence(), called once from
>    qla2x00_abort_isp(), which is bound to process-context =
->abort_isp()
>    hook. It also invokes wait_for_completion_timeout() through the
>    chain qla2x00_configure_hba() =3D> qla24xx_link_initialize() =3D>
>    qla2x00_mailbox_command().
>=20
>  - qla_os.c: qla83xx_clear_drv_presence(), which is called from
>    qla2x00_abort_isp() discussed above, and from qla2x00_remove_one()
>    which is PCI process-context ->remove() hook.
>=20
>  - qla_os.c: qla83xx_need_reset_handler(), has a one second msleep() =
in
>    a loop.
>=20
>  - qla_os.c: qla83xx_device_bootstrap(), called only by
>    qla83xx_idc_state_handler(), which has multiple msleep()
>    invocations.
>=20
>  - qla_os.c: qla83xx_idc_state_handler(), multiple msleep()
>    invocations.
>=20
>  - qla_attr.c: qla2x00_sysfs_write_reset(), sysfs bin_attribute
>    ->write() hook, process context
>=20
>  - qla_init.c: qla83xx_nic_core_fw_load()
>      =3D> qla_init.c: qla2x00_initialize_adapter()
>        =3D> bound to isp_operations ->initialize_adapter() hook
>        ** =3D> qla_os.c: qla2x00_probe_one(), PCI ->probe() process =
ctx
>=20
>  - qla_init.c: qla83xx_initiating_reset(), msleep() in a loop.
>=20
>  - qla_init.c: qla83xx_nic_core_reset(), called by
>    qla83xx_nic_core_reset_work(), workqueue context.
>=20
> Remove the in_interrupt() check, and thus replace the entirety of
> qla83xx_wait_logic() with an msleep(QLA83XX_WAIT_LOGIC_MS).
>=20
> Mark qla83xx_idc_lock() / unlock() with "Context: task, can sleep".
>=20
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> ---
> drivers/scsi/qla2xxx/qla_os.c | 43 ++++++++++++++++-------------------
> 1 file changed, 19 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index f9c8ae9d669ef..2a8e065b192c3 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5619,25 +5619,10 @@ qla83xx_service_idc_aen(struct work_struct =
*work)
> 	}
> }
>=20
> -static void
> -qla83xx_wait_logic(void)
> -{
> -	int i;
> -
> -	/* Yield CPU */
> -	if (!in_interrupt()) {
> -		/*
> -		 * Wait about 200ms before retrying again.
> -		 * This controls the number of retries for single
> -		 * lock operation.
> -		 */
> -		msleep(100);
> -		schedule();
> -	} else {
> -		for (i =3D 0; i < 20; i++)
> -			cpu_relax(); /* This a nop instr on i386 */
> -	}
> -}
> +/*
> + * Control the frequency of IDC lock retries
> + */
> +#define QLA83XX_WAIT_LOGIC_MS	100
>=20
> static int
> qla83xx_force_lock_recovery(scsi_qla_host_t *base_vha)
> @@ -5727,7 +5712,7 @@ qla83xx_idc_lock_recovery(scsi_qla_host_t =
*base_vha)
> 		goto exit;
>=20
> 	if (o_drv_lockid =3D=3D n_drv_lockid) {
> -		qla83xx_wait_logic();
> +		msleep(QLA83XX_WAIT_LOGIC_MS);
> 		goto retry_lockid;
> 	} else
> 		return QLA_SUCCESS;
> @@ -5736,6 +5721,9 @@ qla83xx_idc_lock_recovery(scsi_qla_host_t =
*base_vha)
> 	return rval;
> }
>=20
> +/*
> + * Context: task, can sleep
> + */
> void
> qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
> {
> @@ -5743,6 +5731,8 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, =
uint16_t requester_id)
> 	uint32_t lock_owner;
> 	struct qla_hw_data *ha =3D base_vha->hw;
>=20
> +	might_sleep();
> +
> 	/* IDC-lock implementation using driver-lock/lock-id remote =
registers */
> retry_lock:
> 	if (qla83xx_rd_reg(base_vha, QLA83XX_DRIVER_LOCK, &data)
> @@ -5761,7 +5751,7 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, =
uint16_t requester_id)
> 			/* Retry/Perform IDC-Lock recovery */
> 			if (qla83xx_idc_lock_recovery(base_vha)
> 			    =3D=3D QLA_SUCCESS) {
> -				qla83xx_wait_logic();
> +				msleep(QLA83XX_WAIT_LOGIC_MS);
> 				goto retry_lock;
> 			} else
> 				ql_log(ql_log_warn, base_vha, 0xb075,
> @@ -6259,6 +6249,9 @@ void qla24xx_process_purex_list(struct =
purex_list *list)
> 	}
> }
>=20
> +/*
> + * Context: task, can sleep
> + */
> void
> qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_t requester_id)
> {
> @@ -6269,6 +6262,8 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, =
uint16_t requester_id)
> 	uint32_t data;
> 	struct qla_hw_data *ha =3D base_vha->hw;
>=20
> +	might_sleep();
> +
> 	/* IDC-unlock implementation using driver-unlock/lock-id
> 	 * remote registers
> 	 */
> @@ -6284,7 +6279,7 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, =
uint16_t requester_id)
> 			/* SV: XXX: IDC unlock retrying needed here? */
>=20
> 			/* Retry for IDC-unlock */
> -			qla83xx_wait_logic();
> +			msleep(QLA83XX_WAIT_LOGIC_MS);
> 			retry++;
> 			ql_dbg(ql_dbg_p3p, base_vha, 0xb064,
> 			    "Failed to release IDC lock, retrying=3D%d\n",=
 retry);
> @@ -6292,7 +6287,7 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, =
uint16_t requester_id)
> 		}
> 	} else if (retry < 10) {
> 		/* Retry for IDC-unlock */
> -		qla83xx_wait_logic();
> +		msleep(QLA83XX_WAIT_LOGIC_MS);
> 		retry++;
> 		ql_dbg(ql_dbg_p3p, base_vha, 0xb065,
> 		    "Failed to read drv-lockid, retrying=3D%d\n", =
retry);
> @@ -6308,7 +6303,7 @@ qla83xx_idc_unlock(scsi_qla_host_t *base_vha, =
uint16_t requester_id)
> 	if (qla83xx_access_control(base_vha, options, 0, 0, NULL)) {
> 		if (retry < 10) {
> 			/* Retry for IDC-unlock */
> -			qla83xx_wait_logic();
> +			msleep(QLA83XX_WAIT_LOGIC_MS);
> 			retry++;
> 			ql_dbg(ql_dbg_p3p, base_vha, 0xb066,
> 			    "Failed to release IDC lock, retrying=3D%d\n",=
 retry);
>=20
> 2.29.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

