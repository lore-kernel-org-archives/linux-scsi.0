From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/9] snic:Add interrupt, resource firmware interfaces
Date: Tue, 07 Apr 2015 08:27:50 +0200
Message-ID: <552378E6.3070800@suse.de>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com> <1426093299-4511-3-git-send-email-nmusini@cisco.com> <55128B6C.60706@suse.de> <D142F0C4.1D3A8%nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbbDGG1w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 02:27:52 -0400
In-Reply-To: <D142F0C4.1D3A8%nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Narsimhulu,

On 04/02/2015 09:48 AM, Narsimhulu Musini (nmusini) wrote:
> Hi Hannes,
>=20
>   Thank you for reviewing patches. Please find responses inline.
> I will incorporate the comments and suggestions in next patch submitt=
al.
>=20
>=20
>=20
> On 25/03/15 3:48 pm, "Hannes Reinecke" <hare@suse.de> wrote:
>=20
>> On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
[ .. ]
>>> +void
>>> +snic_free_intr(struct snic *snic)
>>> +{
>>> +	int i;
>>> +
>>> +	/* ONLY interrupt mode MSIX is supported */
>>> +	for (i =3D 0; i < ARRAY_SIZE(snic->msix); i++) {
>>> +		if (snic->msix[i].requested) {
>>> +			free_irq(snic->msix_entry[i].vector,
>>> +				 snic->msix[i].devid);
>>> +		}
>>> +	}
>>> +} /* end of snic_free_intr */
>>> +
>>> +int
>>> +snic_request_intr(struct snic *snic)
>>> +{
>>> +	int ret =3D 0, i;
>>> +
>>> +#ifdef SNIC_DEBUG
>>> +	enum vnic_dev_intr_mode intr_mode;
>>> +
>>> +	intr_mode =3D vnic_dev_get_intr_mode(snic->vdev);
>>> +	SNIC_BUG_ON(intr_mode !=3D VNIC_DEV_INTR_MODE_MSIX);
>>> +#endif
>>> +
>>> +	/* FIXME: Pass devid as work queue or completion queue pointers
>>> +	 * except for err_notify
>>> +	 */
>>> +	sprintf(snic->msix[SNIC_MSIX_WQ].devname,
>>> +		"%.11s-scsi-wq",
>>> +		snic->name);
>> Any reason why you didn't fix it now?
>> This is a new submission, so I would have expected
>> _you_ are fine with the code ...
> The comment is a place holder for future changes when hardware suppor=
ts
> multiple queues. one idea is to pass queue pointer and retrieve snic =
from
> queue pointer. At this moment, hardware provides single queue. So dir=
ectly
> passing snic.
>=20
>=20
>>
>>> +	snic->msix[SNIC_MSIX_WQ].isr =3D snic_isr_msix_wq;
>>> +	snic->msix[SNIC_MSIX_WQ].devid =3D snic;
>>> +
>>> +	/* FIXME: name can be scsi_cq or iocmpl */
>>> +	sprintf(snic->msix[SNIC_MSIX_IO_CMPL].devname,
>>> +		"%.11s-io-cmpl",
>>> +		snic->name);
>> Same here.
>> I would accept FIXMEs is if they require an infrastructure
>> change or if it refers to future / planned
>> hardware updates. This doesn't strike me as either ...
> The comment is a place holder for future changes when hardware suppor=
ts
> multiple queues. one idea is to pass queue pointer and retrieve snic =
from
> queue pointer. At this moment, hardware provides single queue. So dir=
ectly
> passing snic.
>=20
Okay, can you then please update the comment indicating this?
It's not directly a 'FIXME', as the current hardware/firmware
doesn't support this.
At the same time I see the value of having this comment in there.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
