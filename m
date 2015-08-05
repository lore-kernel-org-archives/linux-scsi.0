From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/4] cxlflash: Base error recovery support
Date: Wed, 5 Aug 2015 17:30:42 -0500
Message-ID: <4194F460-16AC-46A2-9ECF-63C4F100060A@linux.vnet.ibm.com>
References: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com> <55C23420.50905@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:37611 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbbHEWat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2015 18:30:49 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 5 Aug 2015 18:30:48 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 83EF66E8045
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2015 18:22:30 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t75MUiEL61276168
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 22:30:44 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t75MUhB3023055
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 18:30:44 -0400
In-Reply-To: <55C23420.50905@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Brian,

Thanks for reviewing. Comments inline below.


-matt

> On Aug 5, 2015, at 11:04 AM, Brian King <brking@linux.vnet.ibm.com> w=
rote:
>=20
> On 08/02/2015 11:33 PM, Matthew R. Ochs wrote:
>=20
>> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/=
common.h
>> index ba070a5..3d6217a 100644
>> --- a/drivers/scsi/cxlflash/common.h
>> +++ b/drivers/scsi/cxlflash/common.h
>> @@ -76,6 +76,12 @@ enum cxlflash_init_state {
>> 	INIT_STATE_SCSI
>> };
>>=20
>> +enum eeh_state {
>> +	EEH_STATE_NONE,
>> +	EEH_STATE_ACTIVE,
>> +	EEH_STATE_FAILED
>> +};
>=20
> Can you use pdev->error_state and pci_channel_offline instead of dupl=
icating this
> state information in a private driver definition?

Makes sense, I=92ll look into this.

>>=20
>> +#ifdef CONFIG_CXL_EEH
>> +	cxl_perst_reloads_same_image(afu, val)=20
>> +#endif
>=20
> I'd suggest moving this to a .h and defining the function as a noop t=
here if appropriate, something
> like:
>=20
> #ifndef CONFIG_CXL_EEH
> #define cxl_perst_reloads_same_image(cfg->cxl_afu, true) do { } while=
(0)
> #endif

Done.

>>=20
>> -	rcr =3D afu_reset(cfg);
>> -	if (rcr =3D=3D 0)
>> -		rc =3D SUCCESS;
>> -	else
>> -		rc =3D FAILED;
>> +	switch (cfg->eeh_active) {
>> +	case EEH_STATE_NONE:
>> +		cfg->eeh_active =3D EEH_STATE_FAILED;
>=20
> Seems a little strange to be messing with the EEH state machine here =
when EEH isn't even at play.
> If you can't switch to use the existing EEH state machine in the pdev=
 struct, suggest renaming
> this internal state machine to something more accurate and using the =
pdev EEH state machine where you can.
> Same goes for the eeh_waitq=85

I do agree that this is a bit strange. What we=92re doing here is borro=
wing the framework we
put in place to quiesce user contexts and hold off new threads coming i=
n during an EEH
event. I=92ll look into how we can refactor this given that we=92re goi=
ng to move to using the
existing EEH state machine (pdev->error_state) and will no longer be ab=
le to toggle state.

>> +	pr_debug("%s: pdev=3D%p state=3D%u\n", __func__, pdev, state);
>> +
>> +	switch (state) {
>> +	case pci_channel_io_frozen:
>> +		cfg->eeh_active =3D EEH_STATE_ACTIVE;
>> +		udelay(100);
>> +
>=20
> I think this udelay needs a comment=85

This may end up going away. I=92ll add a comment if we keep it.

> I'd suggest calling scsi_block_requests here to stop your queuecomman=
d function from being called.
> Note that this won't stop EH commands from being sent, so you will st=
ill need to check this
> in queuecommand, although the right thing to do may be to fix scsi_se=
nd_eh_cmnd to not call
> queuecommand if the host is blocked.
>=20
> You=92d then need to call scsi_unblock_requests when EEH in the perm =
failure and resume cases.

Good suggestion, we=92ll look at adding this in.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
