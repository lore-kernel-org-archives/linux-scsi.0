From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [v2 PATCH 2/3] scsi:stex.c Add hotplug support
Date: Thu, 03 Sep 2015 16:01:55 +0200
Message-ID: <mqdegifbnzg.fsf@c203.arch.suse.de>
References: <55E83DB3.5050209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E83DB3.5050209@gmail.com> (Charles Chiou's message of "Thu, 03
	Sep 2015 20:31:47 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Charles Chiou <ch1102chiou@gmail.com> writes:

> From 60e14c245c18cbe0300cfa244334e2850a52a381 Mon Sep 17 00:00:00 200=
1
> From: Charles <charles.chiou@tw.promise.com>
> Date: Wed, 2 Sep 2015 20:48:55 +0800
> Subject: [PATCH 2/3] scsi:stex.c Add hotplug support
>
> 1. Add hotplug support. Pegasus support surprise removal. To this end=
, I
>    use return_abnormal_state function to return DID_NO_CONNECT for al=
l
>       commands which sent to driver.
>
> 2. Remove stex_hba_stop in stex_remove because we cannot send command=
 to
>    device after hotplug.
>
> 3. Add new device status:  MU_STATE_STOP, MU_STATE_NOCONNECT,
>    MU_STATE_STOP. MU_STATE_STOP is currently not referenced.
>    MU_STATE_NOCONNECT represent that device is plugged out from the h=
ost.
>
> 4. Use return_abnormal_function() to substitute part of code in stex_=
do_reset.
>
> V2: N/A
>
> Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
> ---
>  drivers/scsi/stex.c | 53 ++++++++++++++++++++++++++++++++++---------=
----------
>  1 file changed, 34 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 0c93f1f..4ef0c80 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -83,6 +83,8 @@ enum {
>  	MU_STATE_STARTED			=3D 2,
>  	MU_STATE_RESETTING			=3D 3,
>  	MU_STATE_FAILED				=3D 4,
> +	MU_STATE_STOP				=3D 5,
> +	MU_STATE_NOCONNECT			=3D 6,
>
>  	MU_MAX_DELAY				=3D 120,
>  	MU_HANDSHAKE_SIGNATURE			=3D 0x55aaaa55,
> @@ -544,6 +546,27 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_=
msg *req,
> u16 tag)
>  	readl(hba->mmio_base + YH2I_REQ); /* flush */
>  }
>
> +static void return_abnormal_state(struct st_hba *hba, int status)
> +{
> +	struct st_ccb *ccb;
> +	unsigned long flags;
> +	u16 tag;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	for (tag =3D 0; tag < hba->host->can_queue; tag++) {
> +		ccb =3D &hba->ccb[tag];
> +		if (ccb->req =3D=3D NULL)
> +			continue;
> +		ccb->req =3D NULL;
> +		if (ccb->cmd) {
> +			scsi_dma_unmap(ccb->cmd);
> +			ccb->cmd->result =3D status << 16;
> +			ccb->cmd->scsi_done(ccb->cmd);
> +			ccb->cmd =3D NULL;
> +		}
> +	}
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +}
>  static int
>  stex_slave_config(struct scsi_device *sdev)
>  {
> @@ -567,8 +590,12 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, voi=
d
> (*done)(struct scsi_cmnd *))
>  	id =3D cmd->device->id;
>  	lun =3D cmd->device->lun;
>  	hba =3D (struct st_hba *) &host->hostdata[0];
> -
> -	if (unlikely(hba->mu_status =3D=3D MU_STATE_RESETTING))
> +	if (hba->mu_status =3D=3D MU_STATE_NOCONNECT) {
> +		cmd->result =3D DID_NO_CONNECT;
> +		done(cmd);
> +		return 0;
> +	}
> +	if (unlikely(hba->mu_status !=3D MU_STATE_STARTED))
>  		return SCSI_MLQUEUE_HOST_BUSY;
>
>  	switch (cmd->cmnd[0]) {
> @@ -1267,10 +1294,8 @@ static void stex_ss_reset(struct st_hba *hba)
>
>  static int stex_do_reset(struct st_hba *hba)
>  {
> -	struct st_ccb *ccb;
>  	unsigned long flags;
>  	unsigned int mu_status =3D MU_STATE_RESETTING;
> -	u16 tag;
>
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (hba->mu_status =3D=3D MU_STATE_STARTING) {
> @@ -1304,20 +1329,8 @@ static int stex_do_reset(struct st_hba *hba)
>  	else if (hba->cardtype =3D=3D st_yel)
>  		stex_ss_reset(hba);
>
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	for (tag =3D 0; tag < hba->host->can_queue; tag++) {
> -		ccb =3D &hba->ccb[tag];
> -		if (ccb->req =3D=3D NULL)
> -			continue;
> -		ccb->req =3D NULL;
> -		if (ccb->cmd) {
> -			scsi_dma_unmap(ccb->cmd);
> -			ccb->cmd->result =3D DID_RESET << 16;
> -			ccb->cmd->scsi_done(ccb->cmd);
> -			ccb->cmd =3D NULL;
> -		}
> -	}
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +	return_abnormal_state(hba, DID_RESET);
>
>  	if (stex_handshake(hba) =3D=3D 0)
>  		return 0;
> @@ -1786,9 +1799,11 @@ static void stex_remove(struct pci_dev *pdev)
>  {
>  	struct st_hba *hba =3D pci_get_drvdata(pdev);
>
> +	hba->mu_status =3D MU_STATE_NOCONNECT;
> +	return_abnormal_state(hba, DID_NO_CONNECT);
>  	scsi_remove_host(hba->host);
>
> -	stex_hba_stop(hba);
> +	scsi_block_requests(hba->host);
>
>  	stex_hba_free(hba);

Looks OK to me, so
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
