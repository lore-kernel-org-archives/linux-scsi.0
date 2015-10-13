From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] scsi: report 'INQUIRY result too short' once per host
Date: Tue, 13 Oct 2015 08:16:38 +0200
Message-ID: <561CA1C6.2010207@suse.de>
References: <1444323291-16447-1-git-send-email-vkuznets@redhat.com>	<561BA89B.2040504@suse.de> <87egh0yv5s.fsf@vitty.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87egh0yv5s.fsf@vitty.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2015 05:16 PM, Vitaly Kuznetsov wrote:
> Hannes Reinecke <hare@suse.de> writes:
>=20
>> On 10/08/2015 06:54 PM, Vitaly Kuznetsov wrote:
>>> Some host adapters (e.g. Hyper-V storvsc) are known for not respect=
ing the
>>> SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall conta=
in at
>>> least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi sca=
n:
>>> INQUIRY result too short (5), using 36' messages on console. This c=
an be
>>> problematic for slow consoles. Introduce short_inquiry flag in stru=
ct
>>> Scsi_Host to print the message once per host.
>>>
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>> Changes since v2:
>>> - This is a successor of previously sent (and still not merged) "sc=
si:
>>>   introduce short_inquiry flag for broken host adapters" patch. I'm=
 not
>>>   particularly sure which solution is better but I'm leaning toward=
s this
>>>   one as it doesn't require changes to adapter drivers.
>>> ---
>>>  drivers/scsi/scsi_scan.c | 9 ++++++---
>>>  include/scsi/scsi_host.h | 3 +++
>>>  2 files changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index f9f3f82..cd347e4 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -701,9 +701,12 @@ static int scsi_probe_lun(struct scsi_device *=
sdev, unsigned char *inq_result,
>>>  	 * strings.
>>>  	 */
>>>  	if (sdev->inquiry_len < 36) {
>>> -		sdev_printk(KERN_INFO, sdev,
>>> -			    "scsi scan: INQUIRY result too short (%d),"
>>> -			    " using 36\n", sdev->inquiry_len);
>>> +		if (!sdev->host->short_inquiry) {
>>> +			shost_printk(KERN_INFO, sdev->host,
>>> +				    "scsi scan: INQUIRY result too short (%d),"
>>> +				    " using 36\n", sdev->inquiry_len);
>>> +			sdev->host->short_inquiry =3D 1;
>>> +		}
>>>  		sdev->inquiry_len =3D 36;
>>>  	}
>>> =20
>> At least you need to check if you've received any valid data here;
>> 'INQUIRY result too short' is also a common error if the interrupt
>> is hosed when trying to access the device.
>> So please check for 'inquiry_len > 4' before setting 'short_inquiry'=
=2E
>=20
> Currently we proceed even with a shorter reply... Should we abort the
> scan (and return -EOI?) in case we got inquiry_len <=3D 4?
>=20
Yes please. We need to ensure that we actually received some data,
and not running into an error scenario here.
So we need to read at least five bytes of data, as byte 4 carries
the response length. If we read less than that we have no way of
figuring out if the response data is even remotely sane.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
