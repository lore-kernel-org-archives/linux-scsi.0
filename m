From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Mon, 17 Feb 2014 15:09:30 +0100
Message-ID: <5302181A.9080308@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de> <52FE0793.9040505@acm.org> <52FE0A66.6050200@suse.de> <5302171A.9070507@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaBQOJb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Feb 2014 09:09:31 -0500
In-Reply-To: <5302171A.9070507@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/17/2014 03:05 PM, Bart Van Assche wrote:
> On 02/14/14 13:21, Hannes Reinecke wrote:
>> On 02/14/2014 01:09 PM, Bart Van Assche wrote:
>>> On 01/31/14 10:29, Hannes Reinecke wrote:
>>>> +	if (!target_id_size) {
>>>> +		/* Check for EMC Clariion extended inquiry */
>>>> +		if (!strncmp(sdev->vendor, "DGC     ", 8) &&
>>>> +		    sdev->inquiry_len > 160) {
>>>> +			target_id_size =3D sdev->inquiry[160];
>>>> +			target_id =3D sdev->inquiry + 161;
>>>> +			strcpy(target_id_str, "emc.");
>>>> +			memcpy(target_id_str + 4, target_id, target_id_size);
>>>> +		}
>>>> +		/* Check for HP EVA extended inquiry */
>>>> +		if (!strncmp(sdev->vendor, "HP      ", 8) &&
>>>> +		    !strncmp(sdev->model, "HSV", 3) &&
>>>> +		    sdev->inquiry_len > 170) {
>>>> +			target_id_size =3D 16;
>>>> +			target_id =3D sdev->inquiry + 154;
>>>> +			strcpy(target_id_str, "naa.");
>>>> +			memcpy(target_id_str + 4, target_id, target_id_size);
>>>> +		}
>>>> +	}
>>>
>>> Being able to identify a storage array unambiguously is essential f=
or
>>> the new ALUA device handler algorithm introduced by this patch seri=
es.
>>> What if a new storage array is introduced that is not covered by on=
e of
>>> the heuristics in this patch ? Has it been considered to let storag=
e
>>> array identification occur in user space instead of in the kernel ?
>>
>> As noted in the other mail, if we cannot decipher the array
>> identifier the whole thing degrades into one pg per sdev.
>> IE we cannot bunch RTPG / STPG for those.
>> The idea here is that those arrays do not have any limitations,
>> so that no special treatment is required.
>>
>> Adding identifiers from userspace are a bit tricky; there is no
>> actual sysfs structure for the device handler.
>> Which we would need if we were to use these tricks.
>=20
> The reason I started asking about the target device ID is because for
> Fusion-io ION devices we also encode the device ID in the INQUIRY
> response (bytes 36..55; left aligned; padded with '\0'). The vendor n=
ame
> is "FUSIONIO" and the first three characters of the product name are
> "ION". Can you add  the necessary support in the device identificatio=
n
> code ? Seems like it's time we get you a pair of those devices for
> testing :-) An example:
>=20
> # sg_inq -rl256 /dev/sdb | dd bs=3D1 count=3D20 skip=3D36 2>/dev/null=
 | od -c
> 0000000   U   S   E   2   4   0   F   W   6   5  \0  \0  \0  \0  \0  =
\0
> 0000020  \0  \0  \0  \0
> 0000024
>=20
If the product ID is actually the array identification and not a
generic name, sure.
But if all ION arrays with the same FW level identify itself with
the same identifier it's kinda pointless :-)
Otherwise, yeah, that's easily done.

But you might want to talk to your FW folks; if they were to update
VPD page 0x83 to include an target-specific identifier we'd be all
set ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
