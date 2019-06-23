From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH V1] scsi: ufs-bsg: complete ufs-bsg job only if no error
Date: Sun, 23 Jun 2019 07:45:48 +0000
Message-ID: <SN6PR04MB4925EDC53B49B2E5DDD9368DFCE10@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <BN7PR08MB5684DDCA5C96794DAD71A1F9DBE60@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB5684DDCA5C96794DAD71A1F9DBE60@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bean,
Thank you for fixing this.

> From: Bean Huo <beanhuo@micron.com>
>=20
> In the case of UPIU/DME request execution failed in UFS device,
> ufs_bsg_request() will complete this failed bsg job by calling
> bsg_job_done(). Meanwhile, it returns this error status to blk-mq
> layer, then trigger blk-mq complete this request again, this will
> cause below panic.
>=20
> [   68.673050] Call trace:
> [   68.675491]  __ll_sc___cmpxchg_case_acq_32+0x4/0x20
> [   68.680369]  complete+0x28/0x70
> [   68.683510]  blk_end_sync_rq+0x24/0x30
> [   68.687255]  blk_mq_end_request+0xb8/0x118
> [   68.691350]  bsg_job_put+0x4c/0x58
> [   68.694747]  bsg_complete+0x20/0x30
> [   68.698231]  blk_done_softirq+0xb4/0xe8
> [   68.702066]  __do_softirq+0x154/0x3f0
> [   68.705726]  run_ksoftirqd+0x4c/0x68
> [   68.709298]  smpboot_thread_fn+0x22c/0x268
> [   68.713394]  kthread+0x130/0x138
> [   68.716619]  ret_from_fork+0x10/0x1c
> [   68.720193] Code: f84107fe d65f03c0 d503201f f9800011 (885ffc10)
> [   68.726298] ---[ end trace d92825bff6326e66 ]---
> [   68.730913] Kernel panic - not syncing: Fatal exception in interrupt
Please add a 'fixes:' tag

=20
> This patch is to fix this issue. The solution is we complete
> the ufs-bsg job only if no error happened.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs_bsg.c | 7 ++++---
>  drivers/scsi/ufs/ufshcd.c  | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
> index 869e71f..d5516dc 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/scsi/ufs/ufs_bsg.c
> @@ -122,7 +122,7 @@ static int ufs_bsg_request(struct bsg_job *job)
>  		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
>  		ret =3D ufshcd_send_uic_cmd(hba, &uc);
>  		if (ret)
> -			dev_dbg(hba->dev,
> +			dev_err(hba->dev,
>  				"send uic cmd: error code %d\n", ret);
Please send a different patch fixing typos (also in ufshcd_uic_change_pwr_m=
ode)
>=20
>  		memcpy(&bsg_reply->upiu_rsp.uc, &uc, UIC_CMD_SIZE);
> @@ -143,13 +143,14 @@ static int ufs_bsg_request(struct bsg_job *job)
>  			sg_copy_from_buffer(job->request_payload.sg_list,
>  					    job->request_payload.sg_cnt,
>  					    desc_buff, desc_len);
> -
Keep this one line space please

>  	kfree(desc_buff);
>=20
>  out:
>  	bsg_reply->result =3D ret;
>  	job->reply_len =3D sizeof(struct ufs_bsg_reply);
> -	bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
> +	/* complete the job here only if no error */
> +	if (ret =3D=3D 0)
> +		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
>=20
>  	return ret;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 04d3686..4718041 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3776,7 +3776,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,
> struct uic_command *cmd)
>  }
>=20
>  /**
> - * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
> + * ufshcd_uic_change_pwr_mode - Perform the UIC power mode change
Please send a different patch fixing typos

Thanks,
Avri

>   *				using DME_SET primitives.
>   * @hba: per adapter instance
>   * @mode: powr mode value
> --
> 2.7.4
