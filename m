From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 1/3] cxlflash: Base error recovery support
Date: Mon, 17 Aug 2015 19:30:15 -0500
Message-ID: <864F3A3B-94AF-4E56-9FCA-BBD36E58FA60@linux.vnet.ibm.com>
References: <1439520454-56759-1-git-send-email-mrochs@linux.vnet.ibm.com> <55D1F1CE.1030900@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:36301 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbHRAaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2015 20:30:21 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 17 Aug 2015 20:30:20 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 4C00D6E8040
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2015 20:22:01 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7I0UGD431719540
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 00:30:16 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7I0UECi006411
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2015 20:30:16 -0400
In-Reply-To: <55D1F1CE.1030900@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Brian,

Thanks for reviewing.

All good suggestions that I am fine with implementing. As these are fai=
rly minor,
would you be okay with these being made in a separate =91fix' patch ser=
ies?

-matt

> On Aug 17, 2015, at 9:38 AM, Brian King <brking@linux.vnet.ibm.com> w=
rote:
>=20
> On 08/13/2015 09:47 PM, Matthew R. Ochs wrote:
>> --- a/drivers/scsi/cxlflash/common.h
>> +++ b/drivers/scsi/cxlflash/common.h
>> @@ -76,6 +76,12 @@ enum cxlflash_init_state {
>> 	INIT_STATE_SCSI
>> };
>>=20
>> +enum cxlflash_state {
>> +	STATE_NORMAL,	/* Normal running state, everything good */
>> +	STATE_LIMBO,	/* Limbo running state, trying to reset/recover */
>=20
> Might be more clear to call this STATE_RESETTING or STATE_RECOVERY
>=20
>> +	STATE_FAILTERM	/* Failed/terminating state, error out users/thread=
s */
>> +};
>> +
>> /*
>>  * Each context has its own set of resource handles that is visible
>>  * only from that context.
>=20
>> @@ -105,7 +109,8 @@ struct cxlflash_cfg {
>>=20
>> 	wait_queue_head_t tmf_waitq;
>> 	bool tmf_active;
>> -	u8 err_recovery_active:1;
>> +	wait_queue_head_t limbo_waitq;
>=20
> How about reset_waitq instead?
>=20
>> +	enum cxlflash_state state;
>> };
>>=20
>> struct afu_cmd {
>=20
>> @@ -455,9 +471,21 @@ static int cxlflash_eh_device_reset_handler(str=
uct scsi_cmnd *scp)
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>=20
>> -	rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
>> -	if (unlikely(rcr))
>> +	switch (cfg->state) {
>> +	case STATE_NORMAL:
>> +		rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
>> +		if (unlikely(rcr))
>> +			rc =3D FAILED;
>> +		break;
>> +	case STATE_LIMBO:
>> +		wait_event(cfg->limbo_waitq, cfg->state !=3D STATE_LIMBO);
>> +		if (cfg->state =3D=3D STATE_NORMAL)
>> +			break;
>=20
> In this case you've been asked to do a LUN reset but didn't actually =
reset the LUN. I'd suggest
> restructuring this switch statement to send the LUN reset TMF in the =
case where you had
> to wait for an AFU reset to complete.
>=20
>> +		/* fall through */
>> +	default:
>> 		rc =3D FAILED;
>> +		break;
>> +	}
>>=20
>> 	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>> 	return rc;
>> @@ -487,11 +515,29 @@ static int cxlflash_eh_host_reset_handler(stru=
ct scsi_cmnd *scp)
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>=20
>> -	rcr =3D cxlflash_afu_reset(cfg);
>> -	if (rcr =3D=3D 0)
>> -		rc =3D SUCCESS;
>> -	else
>> +	switch (cfg->state) {
>> +	case STATE_NORMAL:
>> +		cfg->state =3D STATE_LIMBO;
>> +		scsi_block_requests(cfg->host);
>> +
>> +		rcr =3D cxlflash_afu_reset(cfg);
>> +		if (rcr) {
>> +			rc =3D FAILED;
>> +			cfg->state =3D STATE_FAILTERM;
>> +		} else
>> +			cfg->state =3D STATE_NORMAL;
>> +		wake_up_all(&cfg->limbo_waitq);
>> +		scsi_unblock_requests(cfg->host);
>=20
> The scsi_block_requests / scsi_unblock_requests is not necessary in t=
his path, since SCSI EH
> will already be preventing any new commands being issued via queuecom=
mand.
>=20
>> +		break;
>> +	case STATE_LIMBO:
>> +		wait_event(cfg->limbo_waitq, cfg->state !=3D STATE_LIMBO);
>> +		if (cfg->state =3D=3D STATE_NORMAL)
>> +			break;
>> +		/* fall through */
>> +	default:
>> 		rc =3D FAILED;
>> +		break;
>> +	}
>>=20
>> 	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>> 	return rc;
>> @@ -642,7 +688,7 @@ static void cxlflash_wait_for_pci_err_recovery(s=
truct cxlflash_cfg *cfg)
>> 	struct pci_dev *pdev =3D cfg->dev;
>>=20
>> 	if (pci_channel_offline(pdev))
>> -		wait_event_timeout(cfg->eeh_waitq,
>> +		wait_event_timeout(cfg->limbo_waitq,
>> 				   !pci_channel_offline(pdev),
>> 				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
>> }
>> @@ -825,6 +871,8 @@ static void cxlflash_remove(struct pci_dev *pdev=
)
>> 						    !cfg->tmf_active);
>> 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>>=20
>> +	cfg->state =3D STATE_FAILTERM;
>=20
> I don't see any locking around the setting or reading of this flag. W=
hat are the
> implications if the processor reorders the store to change this state=
 either here
> or elsewhere. Same goes for the load associated with checking the sta=
te.
>=20
>> +
>> 	switch (cfg->init_state) {
>> 	case INIT_STATE_SCSI:
>> 		scsi_remove_host(cfg->host);
>> @@ -1879,6 +1927,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
>> 	struct afu *afu =3D cfg->afu;
>> 	struct device *dev =3D &cfg->dev->dev;
>>=20
>> +	cxl_perst_reloads_same_image(cfg->cxl_afu, true);
>> +
>> 	rc =3D init_mc(cfg);
>> 	if (rc) {
>> 		dev_err(dev, "%s: call to init_mc failed, rc=3D%d!\n",
>=20
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
>=20
> --=20
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
