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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB09CC71156
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D9ED206ED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oyEuP4Wk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgK3TPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 14:15:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55158 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729665AbgK3TPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 14:15:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ9AYe003707;
        Mon, 30 Nov 2020 19:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=beudE14zcXr8+Wjd8IruOkrNoIvvL+m5FPyj6/lImGA=;
 b=oyEuP4WklbnwjVKeqzcCB0NmtqgAAO908H/E16qMOutwwGPDAqNSz3hjwLduAvUtuzPm
 hIynsvaa/wYStGBxJYOM3L9WQpvbkpS8D+ZS5Q0yCoKEcwjTiFFAvtv6qlJuTK1Ei+X0
 9IFAHLk5dWkRl4llg36ruJRidyXNVIH5tetZ7FZ1jD0zq4Qn7aj/TdMnejfiM7qdnSV2
 LFd94zUGVkvbmUzzemefScYTqF0UqxWFYFgjsLE0YwudpyFHR6LYU1Qhd3t+k0eBa8YH
 2os4nIP+KevdjMuPyU8VyYfuSeoL2NljLRdRc5JTUfflIv5ZW+sohV3pSht6MBqKzF49 MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqev0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 19:13:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ6EZt075817;
        Mon, 30 Nov 2020 19:11:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540ar18dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:11:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUJBSGW020683;
        Mon, 30 Nov 2020 19:11:28 GMT
Received: from dhcp-10-154-168-92.vpn.oracle.com (/10.154.168.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 11:11:27 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 04/14] scsi: qla2xxx: qla82xx: Remove in_interrupt().
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201126132952.2287996-5-bigeasy@linutronix.de>
Date:   Mon, 30 Nov 2020 13:11:25 -0600
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
Message-Id: <B8EAE100-5178-41D8-97B4-104CEB3500FF@oracle.com>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-5-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=3
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=3 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 26, 2020, at 7:29 AM, Sebastian Andrzej Siewior =
<bigeasy@linutronix.de> wrote:
>=20
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>=20
> qla82xx_idc_lock() spins on a certain hardware state until it's =
updated. At
> the end of each spin, if in_interrupt() is true, it does 20 loops of
> cpu_relax(). Otherwise, it yields the CPU.
>=20
> While in_interrupt() is ill-defined and does not provide what the name
> suggests, it is not needed here: qla82xx_idc_lock() is always called
> from process context. Below is an analysis of its callers, in order of
> appearance:
>=20
>  - qla_nx.c: qla82xx_device_bootstrap(), only called by
>    qla82xx_device_state_handler(), has multiple msleep()s.
>=20
>  - qla_nx.c: qla82xx_need_qsnt_handler(), has one second msleep()
>=20
>  - qla_nx.c: qla82xx_wait_for_state_change(), one second msleep()
>=20
>  - qla_nx.c: qla82xx_need_reset_handler(), can sleep up to 10 seconds
>=20
>  - qla_nx.c: qla82xx_device_state_handler(), has multiple msleep()s
>=20
>  - qla_nx.c: qla82xx_abort_isp(), if it's a qla82xx controller, calls
>    qla82xx_device_state_handler(), which sleeps. It's also bound to
>    isp_operations ->abort_isp() hook, where all the callers are in
>    process context.
>=20
>  - qla_nx.c: qla82xx_beacon_on(), bound to isp_operations =
->beacon_on()
>    hook.  That hook is only called once, in a mutex locked context,
>    from qla2x00_beacon_store().
>=20
>  - qla_nx.c: qla82xx_beacon_off(), bound to isp_operations
>    ->beacon_off() hook.  Like ->beacon_on(), it's only called once, in
>    a mutex locked context, from qla2x00_beacon_store().
>=20
>  - qla_nx.c: qla82xx_fw_dump(), calls qla2x00_wait_for_chip_reset(),
>    which has msleep() in a loop. It is bound to isp_operations
>    ->fw_dump() hook. That hook *is* called from atomic context at
>    qla_isr.c by multiple interrupt handlers. Nonetheless, it's other
>    controllers interrupt handlers, and not the qla82xx.
>=20
>  - qla_attr.c: qla2x00_sysfs_write_fw_dump(), and
>    qla2x00_sysfs_write_reset(), process-context sysfs ->write() hooks.
>=20
>  - qla_os.c: qla2x00_probe_one(). PCI ->probe(), process context.
>=20
>  - qla_os.c: qla2x00_clear_drv_active(), called solely from
>    qla2x00_remove_one(), which is PCI ->remove() hook, process =
context.
>=20
>  - qla_os.c: qla2x00_do_dpc(), kthread function, process context.
>=20
> Remove the in_interrupt() check. Change qla82xx_idc_lock() =
specification
> to a purely process-context function. Mark it with "Context: task, =
might
> sleep".
>=20
> Change qla82xx_idc_lock() implementation to sleep 100ms, instead of a
> schedule(), for each spin. This is more deterministic, and it matches
> the other qla models idc_lock() functions.
>=20
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: <GR-QLogic-Storage-Upstream@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h |  5 +++++
> drivers/scsi/qla2xxx/qla_nx.c  | 25 +++++++++++--------------
> 2 files changed, 16 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index ed9b10f8537d6..fe3c0e2f1ce88 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3296,8 +3296,10 @@ struct isp_operations {
> 	void (*fw_dump)(struct scsi_qla_host *vha);
> 	void (*mpi_fw_dump)(struct scsi_qla_host *, int);
>=20
> +	/* Context: task, might sleep */
> 	int (*beacon_on) (struct scsi_qla_host *);
> 	int (*beacon_off) (struct scsi_qla_host *);
> +
> 	void (*beacon_blink) (struct scsi_qla_host *);
>=20
> 	void *(*read_optrom)(struct scsi_qla_host *, void *,
> @@ -3308,7 +3310,10 @@ struct isp_operations {
> 	int (*get_flash_version) (struct scsi_qla_host *, void *);
> 	int (*start_scsi) (srb_t *);
> 	int (*start_scsi_mq) (srb_t *);
> +
> +	/* Context: task, might sleep */
> 	int (*abort_isp) (struct scsi_qla_host *);
> +
> 	int (*iospace_config)(struct qla_hw_data *);
> 	int (*initialize_adapter)(struct scsi_qla_host *);
> };
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c =
b/drivers/scsi/qla2xxx/qla_nx.c
> index b3ba0de5d4fb8..b2017f1c35044 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -489,29 +489,26 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong =
off_in)
> 	return data;
> }
>=20
> -#define IDC_LOCK_TIMEOUT 100000000
> +/*
> + * Context: task, might sleep
> + */
> int qla82xx_idc_lock(struct qla_hw_data *ha)
> {
> -	int i;
> -	int done =3D 0, timeout =3D 0;
> +	const int delay_ms =3D 100, timeout_ms =3D 2000;
> +	int done, total =3D 0;
>=20
> -	while (!done) {
> +	might_sleep();
> +
> +	while (true) {
> 		/* acquire semaphore5 from PCI HW block */
> 		done =3D qla82xx_rd_32(ha, =
QLA82XX_PCIE_REG(PCIE_SEM5_LOCK));
> 		if (done =3D=3D 1)
> 			break;
> -		if (timeout >=3D IDC_LOCK_TIMEOUT)
> +		if (WARN_ON_ONCE(total >=3D timeout_ms))
> 			return -1;
>=20
> -		timeout++;
> -
> -		/* Yield CPU */
> -		if (!in_interrupt())
> -			schedule();
> -		else {
> -			for (i =3D 0; i < 20; i++)
> -				cpu_relax();
> -		}
> +		total +=3D delay_ms;
> +		msleep(delay_ms);
> 	}
>=20
> 	return 0;
> --=20
> 2.29.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

