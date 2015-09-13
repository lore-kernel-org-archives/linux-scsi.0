From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SCSI: Increase REPORT_LUNS timeout
Date: Sun, 13 Sep 2015 10:43:28 +0200
Message-ID: <55F53730.6070609@suse.de>
References: <55D65082.6020504@linux.vnet.ibm.com> <55DDB8F3.3020308@suse.de>
 <55E70852.9050506@linux.vnet.ibm.com>
 <1441381013.2204.4.camel@HansenPartnership.com>
 <55E9BD01.3020002@linux.vnet.ibm.com>
 <1441383310.2204.12.camel@HansenPartnership.com>
 <55E9F53A.9090108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbbIMInd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2015 04:43:33 -0400
In-Reply-To: <55E9F53A.9090108@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>

On 09/04/2015 09:47 PM, Brian King wrote:
> On 09/04/2015 11:15 AM, James Bottomley wrote:
>> On Fri, 2015-09-04 at 10:47 -0500, Brian King wrote:
>>> On 09/04/2015 10:36 AM, James Bottomley wrote:
>>>> On Wed, 2015-09-02 at 09:31 -0500, Brian King wrote:
>>>>> This patch fixes an issue seen with an IBM 2145 (SVC) where, foll=
owing an error
>>>>> injection test which results in paths going offline, when they ca=
me
>>>>> back online, the path would timeout the REPORT_LUNS issued during=
 the
>>>>> scan. This timeout situation continued until retries were expired=
, resulting in
>>>>> falling back to a sequential LUN scan. Then, since the target res=
ponds
>>>>> with PQ=3D1, PDT=3D0 for all possible LUNs, due to the way the se=
quential
>>>>> LUN scan code works, we end up adding 512 LUNs for each target, w=
hen there
>>>>> is really only a small handful of LUNs that are actually present.
>>>>>
>>>>> This patch doubles the timeout used on the REPORT_LUNS for each r=
etry
>>>>> after a timeout is seen on a REPORT_LUNS. This patch solves the i=
ssue
>>>>> of 512 non existent LUNs showing up after this event. Running the=
 test
>>>>> with this patch still showed that we were regularly hitting two t=
imeouts,
>>>>> but the third, and final, REPORT_LUNS was always successful.
>>>>>
>>>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>>>> ---
>>>>>
>>>>>  drivers/scsi/scsi_scan.c |    5 ++++-
>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff -puN drivers/scsi/scsi_scan.c~scsi_report_luns_timeout_escal=
ate drivers/scsi/scsi_scan.c
>>>>> --- linux/drivers/scsi/scsi_scan.c~scsi_report_luns_timeout_escal=
ate	2015-09-02 08:49:07.268243497 -0500
>>>>> +++ linux-bjking1/drivers/scsi/scsi_scan.c	2015-09-02 08:49:07.27=
2243461 -0500
>>>>> @@ -1304,6 +1304,7 @@ static int scsi_report_lun_scan(struct s
>>>>>  	struct scsi_device *sdev;
>>>>>  	struct Scsi_Host *shost =3D dev_to_shost(&starget->dev);
>>>>>  	int ret =3D 0;
>>>>> +	int timeout =3D SCSI_TIMEOUT + 4 * HZ;
>>>>> =20
>>>>>  	/*
>>>>>  	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is n=
ot set.
>>>>> @@ -1383,7 +1384,7 @@ retry:
>>>>> =20
>>>>>  		result =3D scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
>>>>>  					  lun_data, length, &sshdr,
>>>>> -					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
>>>>> +					  timeout, 3, NULL);
>>>>> =20
>>>>>  		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
>>>>>  				"scsi scan: REPORT LUNS"
>>>>> @@ -1392,6 +1393,8 @@ retry:
>>>>>  				retries, result));
>>>>>  		if (result =3D=3D 0)
>>>>>  			break;
>>>>> +		else if (host_byte(result) =3D=3D DID_TIME_OUT)
>>>>> +			timeout =3D timeout * 2;
>>>>>  		else if (scsi_sense_valid(&sshdr)) {
>>>>>  			if (sshdr.sense_key !=3D UNIT_ATTENTION)
>>>>
>>>> Actually, this is a bit pointless, isn't it; why retry, why not ju=
st set
>>>> the initial timeout? ... I could understand if retrying and printi=
ng a
>>>> message gave important or useful information, but it doesn't.  How=
 long
>>>> do you actually need? ... we can just up the initial timeout to th=
at.
>>>> Currently we have a hacked 6s which looks arbitrary.  Would 15s be
>>>> better?  Nothing really times out anyway, so everything else will =
still
>>>> reply within the original 6s giving zero impact in the everyday ca=
se.
>>>
>>> 12 seconds definitely isn't long enough, but 24 seconds seems to wo=
rk, at least
>>> after we go through both a 6 and 12 second timeout. Anyone opposed =
to using 30 seconds?
>>> 15 seconds is likely to be right on the edge in this scenario.
>>
>> 30s is fine by me.  I think the initial 2s was from the sequential
>> inquiry scan so as not to wait too long.  The extra 4s was added bec=
ause
>> that was too short for report luns on some devices; I suspect some
>> larger arrays take a while just to gather all the data.
>>
>> 30s is also the traditional rq_timeout, so it may be possible to re-=
use
>> this parameter.  Currently it's set up in the ULD, so it's zero unle=
ss
>> the slave_configure requested a special value.  Traditionally, it's =
the
>> timeout for _READ and _WRITE, not special commands, but it feels lik=
e
>> REPORT_LUNS should follow this timeout as well and it would give you=
 a
>> configurable way of updating it in your driver.  If we do it this wa=
y,
>> you'd have to set it in slave_alloc, because slave_configure is too
>> late.
>=20
> I think we may just need to hard code it like the patch below. Here i=
s the current flow for
> setting this today:
>=20
> slave_alloc
> scsi scan: inquiry / report LUNs
> slave_configure
> sd attach
>=20
> Some LLDDs set a default timeout in slave_configure today, so sd.c on=
ly sets a default timeout
> if its not already set. It uses 30 seconds for disks and 75 seconds f=
or optical devices.
> If we start setting rq_timeout earlier, then the ULD will never know =
when it can set it.
>=20
> Additionally, in this particular scenario, its not so much a case of =
behavior tied to the LLDD, its more tied
> to the SCSI target. If there is concern about increasing the default =
to 30 seconds, we could
> use a blist attribute for this.
>=20
> -Brian
>=20
> 8<
>=20
> This patch fixes an issue seen with an IBM 2145 (SVC) where, followin=
g an error
> injection test which results in paths going offline, when they came
> back online, the path would timeout the REPORT_LUNS issued during the
> scan. This timeout situation continued until retries were expired, re=
sulting in
> falling back to a sequential LUN scan. Then, since the target respond=
s
> with PQ=3D1, PDT=3D0 for all possible LUNs, due to the way the sequen=
tial
> LUN scan code works, we end up adding 512 LUNs for each target, when =
there
> is really only a small handful of LUNs that are actually present.
>=20
> This patch increases the timeout used on the REPORT_LUNS to 30 second=
s.
> This patch solves the issue of 512 non existent LUNs showing up after
> this event.
>=20
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>=20
>  drivers/scsi/scsi_scan.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff -puN drivers/scsi/scsi_scan.c~scsi_report_luns_30secs drivers/sc=
si/scsi_scan.c
> --- linux/drivers/scsi/scsi_scan.c~scsi_report_luns_30secs	2015-09-04=
 14:38:47.890757391 -0500
> +++ linux-bjking1/drivers/scsi/scsi_scan.c	2015-09-04 14:39:28.891459=
147 -0500
> @@ -55,6 +55,7 @@
>   * Default timeout
>   */
>  #define SCSI_TIMEOUT (2*HZ)
> +#define SCSI_REPORT_LUNS_TIMEOUT (30*HZ)
> =20
>  /*
>   * Prefix values for the SCSI id's (stored in sysfs name field)
> @@ -1383,7 +1384,7 @@ retry:
> =20
>  		result =3D scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
>  					  lun_data, length, &sshdr,
> -					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
> +					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
> =20
>  		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
>  				"scsi scan: REPORT LUNS"
> _
>=20
>=20
That's far better.

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
