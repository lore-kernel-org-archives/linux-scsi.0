From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Fri, 11 Apr 2014 07:52:01 +0200
Message-ID: <53478301.6@suse.de>
References: <Pine.LNX.4.44L0.1404101128020.32351-100000@netrider.rowland.org>	 <5346DA43.4010603@suse.de> <1397162171.9391.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaDKFwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 01:52:04 -0400
In-Reply-To: <1397162171.9391.22.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andreas Reis <andreas.reis@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 04/10/2014 10:36 PM, James Bottomley wrote:
> On Thu, 2014-04-10 at 19:52 +0200, Hannes Reinecke wrote:
>> On 04/10/2014 05:31 PM, Alan Stern wrote:
>>> On Thu, 10 Apr 2014, Hannes Reinecke wrote:
>>>
>>>> On 04/10/2014 12:58 PM, Andreas Reis wrote:
>>>>> That patch appears to work in preventing the crashes, judged on o=
ne
>>>>> repeated appearance of the bug.
>>>>>
>>>>> dmesg had the usual
>>>>> [  215.229903] usb 4-2: usb_disable_lpm called, do nothing
>>>>> [  215.336941] usb 4-2: reset SuperSpeed USB device number 3 usin=
g
>>>>> xhci_hcd
>>>>> [  215.350296] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint cal=
led
>>>>> with disabled ep ffff880427b829c0
>>>>> [  215.350305] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint cal=
led
>>>>> with disabled ep ffff880427b82a08
>>>>> [  215.350621] usb 4-2: usb_enable_lpm called, do nothing
>>>>>
>>>>> repeated five times, followed by one
>>>>> [  282.795801] sd 8:0:0:0: Device offlined - not ready after erro=
r
>>>>> recovery
>>>>>
>>>>> and then as often as something tried to read from it:
>>>>> [  295.585472] sd 8:0:0:0: rejecting I/O to offline device
>>>>>
>>>>> The stick could then be properly un- and remounted (the latter if=
 it
>>>>> had been physically replugged) without issue =EF=BF=BD for the bu=
g to
>>>>> reoccur after one to three minutes. I tried this three times, no
>>>>> dmesg difference except the ep addresses varied on two of that.
>>>>>
>>>> Was this just that patch you've tested with or the entire patch se=
ries?
>>>>
>>>> If the latter, Alan, is this the expected outcome?
>>>
>>> Yes, it is.  The same thing should happen with the entire patch ser=
ies.
>>>
>>>> I would've thought the error recover should _not_ run into
>>>> offlining devices here, but rather the device should be recovered
>>>> eventually.
>>>
>>> The command times out, it is aborted, and the command is retried.  =
The
>>> same thing happens, and we repeat five times.  Eventually the SCSI =
core
>>> gives up and declares the device to be offline.
>>>
>> Hmm. Ok. If you are fine with it who am I to argue here.
>> James, shall I resent the patch series?
>=20
> You mean the one patch?  No, it's OK, I have it.
>=20
> It's still not complete, though, as I've said a couple of times.  The
> problem is that we have abort memory on any eh command as well, which
> this doesn't fix.
>=20
> The scenario is abort command, set flag, abort completes, send TUR, T=
UR
> doesn't return, so we now try to abort the TUR, but scsi_abort_eh_cmn=
d()
> will skip the abort because the flag is set and move straight to rese=
t.
>=20
> The fix is this, I can just add it as well.
>=20
> James
>=20
> ---
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..7516e2c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -920,6 +920,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, st=
ruct scsi_eh_save *ses,
>  	ses->prot_op =3D scmd->prot_op;
> =20
>  	scmd->prot_op =3D SCSI_PROT_NORMAL;
> +	scmd->eh_eflags =3D 0;
>  	scmd->cmnd =3D ses->eh_cmnd;
>  	memset(scmd->cmnd, 0, BLK_MAX_CDB);
>  	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
>=20
>=20
Oh yes, that is correct.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
