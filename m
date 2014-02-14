From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Fri, 14 Feb 2014 13:21:58 +0100
Message-ID: <52FE0A66.6050200@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de> <52FE0793.9040505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaBNMV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 07:21:59 -0500
In-Reply-To: <52FE0793.9040505@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/2014 01:09 PM, Bart Van Assche wrote:
> On 01/31/14 10:29, Hannes Reinecke wrote:
>> +	if (!target_id_size) {
>> +		/* Check for EMC Clariion extended inquiry */
>> +		if (!strncmp(sdev->vendor, "DGC     ", 8) &&
>> +		    sdev->inquiry_len > 160) {
>> +			target_id_size =3D sdev->inquiry[160];
>> +			target_id =3D sdev->inquiry + 161;
>> +			strcpy(target_id_str, "emc.");
>> +			memcpy(target_id_str + 4, target_id, target_id_size);
>> +		}
>> +		/* Check for HP EVA extended inquiry */
>> +		if (!strncmp(sdev->vendor, "HP      ", 8) &&
>> +		    !strncmp(sdev->model, "HSV", 3) &&
>> +		    sdev->inquiry_len > 170) {
>> +			target_id_size =3D 16;
>> +			target_id =3D sdev->inquiry + 154;
>> +			strcpy(target_id_str, "naa.");
>> +			memcpy(target_id_str + 4, target_id, target_id_size);
>> +		}
>> +	}
>=20
> Being able to identify a storage array unambiguously is essential for
> the new ALUA device handler algorithm introduced by this patch series=
=2E
> What if a new storage array is introduced that is not covered by one =
of
> the heuristics in this patch ? Has it been considered to let storage
> array identification occur in user space instead of in the kernel ?
>=20
As noted in the other mail, if we cannot decipher the array
identifier the whole thing degrades into one pg per sdev.
IE we cannot bunch RTPG / STPG for those.
The idea here is that those arrays do not have any limitations,
so that no special treatment is required.

Adding identifiers from userspace are a bit tricky; there is no
actual sysfs structure for the device handler.
Which we would need if we were to use these tricks.

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
