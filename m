From: Daniel Axtens <dja@ozlabs.au.ibm.com>
Subject: Re: [PATCH v3 2/4] cxlflash: Base error recovery support
Date: Thu, 06 Aug 2015 08:38:39 +1000
Message-ID: <1438814319.6796.0.camel@ozlabs.au.ibm.com>
References: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <55C23420.50905@linux.vnet.ibm.com>
	 <4194F460-16AC-46A2-9ECF-63C4F100060A@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43036 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbbHEWlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2015 18:41:55 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <dja@ozlabs.au.ibm.com>;
	Thu, 6 Aug 2015 08:41:52 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 5A7FF3578056
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2015 08:41:50 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t75MfgHo52166692
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2015 08:41:50 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t75MfHMI008494
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2015 08:41:18 +1000
In-Reply-To: <4194F460-16AC-46A2-9ECF-63C4F100060A@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Wed, 2015-08-05 at 17:30 -0500, Matthew R. Ochs wrote:
> Hi Brian,
>=20
> Thanks for reviewing. Comments inline below.
>=20
>=20
> -matt
>=20
> > On Aug 5, 2015, at 11:04 AM, Brian King <brking@linux.vnet.ibm.com>=
 wrote:
> >=20
> > On 08/02/2015 11:33 PM, Matthew R. Ochs wrote:
> >=20
> >> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflas=
h/common.h
> >> index ba070a5..3d6217a 100644
> >> --- a/drivers/scsi/cxlflash/common.h
> >> +++ b/drivers/scsi/cxlflash/common.h
> >> @@ -76,6 +76,12 @@ enum cxlflash_init_state {
> >> 	INIT_STATE_SCSI
> >> };
> >>=20
> >> +enum eeh_state {
> >> +	EEH_STATE_NONE,
> >> +	EEH_STATE_ACTIVE,
> >> +	EEH_STATE_FAILED
> >> +};
> >=20
> > Can you use pdev->error_state and pci_channel_offline instead of du=
plicating this
> > state information in a private driver definition?
>=20
> Makes sense, I=E2=80=99ll look into this.
>=20
I don't think my vPHB code propagates error_state yet. I'll check, and
if necessary, push a patch and fold it into my v3.

Regards
Daniel

> >>=20
> >> +#ifdef CONFIG_CXL_EEH
> >> +	cxl_perst_reloads_same_image(afu, val)=20
> >> +#endif
> >=20
> > I'd suggest moving this to a .h and defining the function as a noop=
 there if appropriate, something
> > like:
> >=20
> > #ifndef CONFIG_CXL_EEH
> > #define cxl_perst_reloads_same_image(cfg->cxl_afu, true) do { } whi=
le(0)
> > #endif
>=20
> Done.
>=20
> >>=20
> >> -	rcr =3D afu_reset(cfg);
> >> -	if (rcr =3D=3D 0)
> >> -		rc =3D SUCCESS;
> >> -	else
> >> -		rc =3D FAILED;
> >> +	switch (cfg->eeh_active) {
> >> +	case EEH_STATE_NONE:
> >> +		cfg->eeh_active =3D EEH_STATE_FAILED;
> >=20
> > Seems a little strange to be messing with the EEH state machine her=
e when EEH isn't even at play.
> > If you can't switch to use the existing EEH state machine in the pd=
ev struct, suggest renaming
> > this internal state machine to something more accurate and using th=
e pdev EEH state machine where you can.
> > Same goes for the eeh_waitq=E2=80=A6
>=20
> I do agree that this is a bit strange. What we=E2=80=99re doing here =
is borrowing the framework we
> put in place to quiesce user contexts and hold off new threads coming=
 in during an EEH
> event. I=E2=80=99ll look into how we can refactor this given that we=E2=
=80=99re going to move to using the
> existing EEH state machine (pdev->error_state) and will no longer be =
able to toggle state.
>=20
> >> +	pr_debug("%s: pdev=3D%p state=3D%u\n", __func__, pdev, state);
> >> +
> >> +	switch (state) {
> >> +	case pci_channel_io_frozen:
> >> +		cfg->eeh_active =3D EEH_STATE_ACTIVE;
> >> +		udelay(100);
> >> +
> >=20
> > I think this udelay needs a comment=E2=80=A6
>=20
> This may end up going away. I=E2=80=99ll add a comment if we keep it.
>=20
> > I'd suggest calling scsi_block_requests here to stop your queuecomm=
and function from being called.
> > Note that this won't stop EH commands from being sent, so you will =
still need to check this
> > in queuecommand, although the right thing to do may be to fix scsi_=
send_eh_cmnd to not call
> > queuecommand if the host is blocked.
> >=20
> > You=E2=80=99d then need to call scsi_unblock_requests when EEH in t=
he perm failure and resume cases.
>=20
> Good suggestion, we=E2=80=99ll look at adding this in.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
