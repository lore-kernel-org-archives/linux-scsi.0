From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] scsi:stex.c Add S3/S4 support
Date: Thu, 03 Sep 2015 16:03:54 +0200
Message-ID: <mqd8u8nbnw5.fsf@c203.arch.suse.de>
References: <55E83F66.2060300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E83F66.2060300@gmail.com> (Charles Chiou's message of "Thu, 03
	Sep 2015 20:39:02 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Charles Chiou <ch1102chiou@gmail.com> writes:

> From f442518879f8f41d103b684046d912eca13844e7 Mon Sep 17 00:00:00 200=
1
> From: Charles <charles.chiou@tw.promise.com>
> Date: Wed, 2 Sep 2015 20:54:45 +0800
> Subject: [PATCH 3/3] scsi:stex.c Add S3/S4 support
>
> Add S3/S4 support, add .suspend and .resume function in pci_driver.
> In .suspend handler, driver send S3/S4 signal to the device.
>
> V2: Remove blank lines
>
> Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
> ---
>  drivers/scsi/stex.c | 59 +++++++++++++++++++++++++++++++++++++++++++=
+++++++---
>  1 file changed, 56 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 4ef0c80..c96a86d 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -166,6 +166,13 @@ enum {
>
>  	ST_ADDITIONAL_MEM			=3D 0x200000,
>  	ST_ADDITIONAL_MEM_MIN			=3D 0x80000,
> +	PMIC_SHUTDOWN				=3D 0x0D,
> +	PMIC_REUMSE					=3D 0x10,
> +	ST_IGNORED					=3D -1,
> +	ST_S3						=3D 3,
> +	ST_S4						=3D 4,
> +	ST_S5						=3D 5,
> +	ST_S6						=3D 6,
>  };
>
>  struct st_sgitem {
> @@ -1733,7 +1740,7 @@ out_disable:
>  	return err;
>  }
>
> -static void stex_hba_stop(struct st_hba *hba)
> +static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
>  {
>  	struct req_msg *req;
>  	struct st_msg_header *msg_h;
> @@ -1749,11 +1756,18 @@ static void stex_hba_stop(struct st_hba *hba)
>  	} else
>  		memset(req, 0, hba->rq_size);
>
> -	if (hba->cardtype =3D=3D st_yosemite || hba->cardtype =3D=3D st_yel=
) {
> +	if ((hba->cardtype =3D=3D st_yosemite || hba->cardtype =3D=3D st_ye=
l)
> +		&& st_sleep_mic =3D=3D ST_IGNORED) {
>  		req->cdb[0] =3D MGT_CMD;
>  		req->cdb[1] =3D MGT_CMD_SIGNATURE;
>  		req->cdb[2] =3D CTLR_CONFIG_CMD;
>  		req->cdb[3] =3D CTLR_SHUTDOWN;
> +	} else if (hba->cardtype =3D=3D st_yel && st_sleep_mic !=3D ST_IGNO=
RED) {
> +		req->cdb[0] =3D MGT_CMD;
> +		req->cdb[1] =3D MGT_CMD_SIGNATURE;
> +		req->cdb[2] =3D CTLR_CONFIG_CMD;
> +		req->cdb[3] =3D PMIC_SHUTDOWN;
> +		req->cdb[4] =3D st_sleep_mic;
>  	} else {
>  		req->cdb[0] =3D CONTROLLER_CMD;
>  		req->cdb[1] =3D CTLR_POWER_STATE_CHANGE;
> @@ -1773,10 +1787,12 @@ static void stex_hba_stop(struct st_hba *hba)
>  	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
>  		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
>  			hba->ccb[tag].req_type =3D 0;
> +			hba->mu_status =3D MU_STATE_STOP;
>  			return;
>  		}
>  		msleep(1);
>  	}
> +	hba->mu_status =3D MU_STATE_STOP;
>  }
>
>  static void stex_hba_free(struct st_hba *hba)
> @@ -1816,9 +1832,44 @@ static void stex_shutdown(struct pci_dev *pdev=
)
>  {
>  	struct st_hba *hba =3D pci_get_drvdata(pdev);
>
> -	stex_hba_stop(hba);
> +	if (hba->supports_pm =3D=3D 0)
> +		stex_hba_stop(hba, ST_IGNORED);
> +	else
> +		stex_hba_stop(hba, ST_S5);
> +}
> +
> +static int stex_choice_sleep_mic(pm_message_t state)
> +{
> +	switch (state.event) {
> +	case PM_EVENT_SUSPEND:
> +		return ST_S3;
> +	case PM_EVENT_FREEZE:
> +	case PM_EVENT_HIBERNATE:
> +		return ST_S4;
> +	default:
> +		return ST_S4;
> +	}
> +}
> +
> +static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct st_hba *hba =3D pci_get_drvdata(pdev);
> +
> +	if (hba->cardtype =3D=3D st_yel && hba->supports_pm =3D=3D 1)
> +		stex_hba_stop(hba, stex_choice_sleep_mic(state));
> +	else
> +		stex_hba_stop(hba, ST_IGNORED);
> +	return 0;
>  }
>
> +static int stex_resume(struct pci_dev *pdev)
> +{
> +	struct st_hba *hba =3D pci_get_drvdata(pdev);
> +
> +	hba->mu_status =3D MU_STATE_STARTING;
> +	stex_handshake(hba);
> +	return 0;
> +}
>  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
>
>  static struct pci_driver stex_pci_driver =3D {
> @@ -1827,6 +1878,8 @@ static struct pci_driver stex_pci_driver =3D {
>  	.probe		=3D stex_probe,
>  	.remove		=3D stex_remove,
>  	.shutdown	=3D stex_shutdown,
> +	.suspend	=3D stex_suspend,
> +	.resume		=3D stex_resume,
>  };
>
>  static int __init stex_init(void)

Looks OK from my side
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
