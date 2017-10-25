From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/1] qla2xxx: Fix oops in qla2x00_probe_one error path
Date: Wed, 25 Oct 2017 15:58:40 +0000
Message-ID: <7FB24E4E-6F6C-480A-8127-529EFFBB2600@cavium.com>
References: <1508505442-30352-1-git-send-email-dougmill@linux.vnet.ibm.com>
 <1508505442-30352-2-git-send-email-dougmill@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0068.outbound.protection.outlook.com ([104.47.42.68]:48959
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751887AbdJYP6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 11:58:43 -0400
In-Reply-To: <1508505442-30352-2-git-send-email-dougmill@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <47B5817FE482F64F97FA1AC9B180B7FD@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>


> On Oct 20, 2017, at 6:17 AM, Douglas Miller <dougmill@linux.vnet.ibm.com>=
 wrote:
>=20
> On error, kthread_create() returns an errno-encoded pointer, not NULL.
> The routine qla2x00_probe_one() detects the error case and jumps
> to probe_failed, but has already assigned the return value from
> kthread_create() to ha->dpc_thread.  Then probe_failed checks to see
> if ha->dpc_thread is not NULL before doing cleanup on it. Since in the
> error case this is also not NULL, it ends up trying to access an invalid
> task pointer.
>=20
> Solution is to assign NULL to ha->dpc_thread in the error path to avoid
> kthread cleanup in that case.
>=20
> Signed-off-by: Douglas Miller <dougmill@linux.vnet.ibm.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 9372098..bd39bf2 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3212,6 +3212,7 @@ static void qla2x00_iocb_work_fn(struct work_struct=
 *work)
> 		ql_log(ql_log_fatal, base_vha, 0x00ed,
> 		    "Failed to start DPC thread.\n");
> 		ret =3D PTR_ERR(ha->dpc_thread);
> +		ha->dpc_thread =3D NULL;
> 		goto probe_failed;
> 	}
> 	ql_dbg(ql_dbg_init, base_vha, 0x00ee,
> --=20
> 1.7.1
>=20

Looks good.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
