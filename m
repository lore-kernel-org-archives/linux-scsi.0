From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/4] cxlflash: Base error recovery support
Date: Fri, 7 Aug 2015 15:53:13 -0500
Message-ID: <A00B50AE-A153-42A4-8636-E163AD7C8D5C@linux.vnet.ibm.com>
References: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com> <1438924347.6796.22.camel@axtens.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:59707 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbHGUxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 16:53:25 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 7 Aug 2015 16:53:20 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 0C3F7C90045
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2015 16:44:22 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t77KrGcj65273896
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2015 20:53:16 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t77KrElQ011154
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2015 16:53:16 -0400
In-Reply-To: <1438924347.6796.22.camel@axtens.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Daniel,

Thanks for reviewing. Comments inline below.


-matt

> On Aug 7, 2015, at 12:12 AM, Daniel Axtens <dja@axtens.net> wrote:
>=20
> Hi,=20
>=20
>> @@ -1857,9 +1884,18 @@ static int cxlflash_eh_device_reset_handler(s=
truct scsi_cmnd *scp)
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>=20
>> -	rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
>> -	if (unlikely(rcr))
>> -		rc =3D FAILED;
>> +	switch (cfg->eeh_active) {
>> +	case EEH_STATE_NONE:
>> +		rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
>> +		if (unlikely(rcr))
>> +			rc =3D FAILED;
>> +		break;
>> +	case EEH_STATE_ACTIVE:
>> +		wait_event(cfg->eeh_waitq, cfg->eeh_active !=3D EEH_STATE_ACTIVE)=
;
>> +		break;
>> +	case EEH_STATE_FAILED:
>> +		break;
>> +	}
>>=20
>=20
> Looking at the context here, it looks like rc gets initalised to
> SUCCESS. In that case, in the EEH failed case, you'll return SUCCESS.
> I'm not particularly clear on the semantics here: does that make sens=
e?
>=20
> Likewise, in the EEH active state, when you finish the wait_event,
> should you check if the EEH state went to NONE or FAILED before you
> break?
>=20
> There=E2=80=99s a similar case below in host_reset.

Good catch, this is a bug we had previously identified. Look for a fix =
in v4.

>=20
>> 	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>> 	return rc;
>> @@ -1889,11 +1925,23 @@ static int cxlflash_eh_host_reset_handler(st=
ruct scsi_cmnd *scp)
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>=20
>> -	rcr =3D afu_reset(cfg);
>> -	if (rcr =3D=3D 0)
>> -		rc =3D SUCCESS;
>> -	else
>> -		rc =3D FAILED;
>> +	switch (cfg->eeh_active) {
>> +	case EEH_STATE_NONE:
>> +		cfg->eeh_active =3D EEH_STATE_FAILED;
>> +		rcr =3D afu_reset(cfg);
>> +		if (rcr =3D=3D 0)
>> +			rc =3D SUCCESS;
>> +		else
>> +			rc =3D FAILED;
>> +		cfg->eeh_active =3D EEH_STATE_NONE;
>> +		wake_up_all(&cfg->eeh_waitq);
>> +		break;
>> +	case EEH_STATE_ACTIVE:
>> +		wait_event(cfg->eeh_waitq, cfg->eeh_active !=3D EEH_STATE_ACTIVE)=
;
>> +		break;
>> +	case EEH_STATE_FAILED:
>> +		break;
>> +	}
>>=20
>> 	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>> 	return rc;
>> @@ -2145,6 +2193,11 @@ static void cxlflash_worker_thread(struct wor=
k_struct *work)
>> 	int port;
>> 	ulong lock_flags;
>>=20
>> +	/* Avoid MMIO if the device has failed */
>> +
>> +	if (cfg->eeh_active =3D=3D EEH_STATE_FAILED)
>> +		return;
>> +
> Should this check be !=3D EEH_STATE_NONE? Or is this called within th=
e
> error recovery process?

Yes, we have already swapped the logic around as you pointed out. You=E2=
=80=99ll see it in v4.

>=20
>> 	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
>>=20
>> 	if (cfg->lr_state =3D=3D LINK_RESET_REQUIRED) {
>> @@ -2226,6 +2279,8 @@ static int cxlflash_probe(struct pci_dev *pdev=
,
>>=20
>> 	cfg->init_state =3D INIT_STATE_NONE;
>> 	cfg->dev =3D pdev;
>> +
>> +	cfg->eeh_active =3D EEH_STATE_NONE;
>> 	cfg->dev_id =3D (struct pci_device_id *)dev_id;
>>=20
>>=20
>> @@ -2286,6 +2341,85 @@ out_remove:
>> 	goto out;
>> }
>>=20
>> +/**
>> + * cxlflash_pci_error_detected() - called when a PCI error is detec=
ted
>> + * @pdev:	PCI device struct.
>> + * @state:	PCI channel state.
>> + *
>> + * Return: PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
>> + */
>> +static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev =
*pdev,
>> +						    pci_channel_state_t state)
>> +{
>> +	struct cxlflash_cfg *cfg =3D pci_get_drvdata(pdev);
>> +
>> +	pr_debug("%s: pdev=3D%p state=3D%u\n", __func__, pdev, state);
>> +
>> +	switch (state) {
>> +	case pci_channel_io_frozen:
>> +		cfg->eeh_active =3D EEH_STATE_ACTIVE;
>> +		udelay(100);
>> +
>> +		term_mc(cfg, UNDO_START);
>> +		stop_afu(cfg);
>> +
>> +		return PCI_ERS_RESULT_CAN_RECOVER;
>=20
> I think that should PCI_ERS_RESULT_NEED_RESET.

Agreed. Will change for v4.

>=20
> Apart from that, it=E2=80=99s looking pretty good from an EEH perspec=
tive.

Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
