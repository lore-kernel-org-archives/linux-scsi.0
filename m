From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 20/23] scsi: Add 'access_state' attribute
Date: Fri, 19 Feb 2016 07:50:28 +0100
Message-ID: <56C6BB34.8070000@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-21-git-send-email-hare@suse.de>
 <56C64059.8060604@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbcBSGua (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 01:50:30 -0500
In-Reply-To: <56C64059.8060604@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/18/2016 11:06 PM, Bart Van Assche wrote:
> On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
>> --- a/include/scsi/scsi_proto.h
>> +++ b/include/scsi/scsi_proto.h
>> @@ -277,5 +277,17 @@ struct scsi_lun {
>>       __u8 scsi_lun[8];
>>   };
>>
>> +/* SPC asymmetric access states */
>> +#define SCSI_ACCESS_STATE_OPTIMAL     0x00
>> +#define SCSI_ACCESS_STATE_ACTIVE      0x01
>> +#define SCSI_ACCESS_STATE_STANDBY     0x02
>> +#define SCSI_ACCESS_STATE_UNAVAILABLE 0x03
>> +#define SCSI_ACCESS_STATE_LBA         0x04
>> +#define SCSI_ACCESS_STATE_OFFLINE     0x0e
>> +#define SCSI_ACCESS_STATE_TRANSITIONING 0x0f
>> +
>> +#define SCSI_ACCESS_STATE_MASK        0x0f
>> +#define SCSI_ACCESS_STATE_PREFERRED   0x80
>> +#define SCSI_ACCESS_STATE_UNKNOWN     0x70
>=20
> Please mention in the comment above these constants that the ALUA
> state values apply to both the RTPG and STPG commands but that the
> PREFERRED bit only applies to the RTPG command.
>=20
> All constants in scsi_proto.h come from a SCSI standard. However,
> this patch adds a constant that does not come from a SCSI standard
> (SCSI_ACCESS_STATE_UNKNOWN). Please remove this constant entirely
> because it causes confusion. sdev_show_access_state() only
> interprets the PREFERRED bit and the lower 4 bits of the
> access_state member variable. This means that the
> SCSI_ACCESS_STATE_UNKNOWN entry in sdev_access_states[] is never
> used and hence should be left out. This also means that the
> "sdev->access_state =3D SCSI_ACCESS_STATE_UNKNOWN" assignment in
> scsi_scan.c is equivalent to "sdev->access_state =3D
> SCSI_ACCESS_STATE_OPTIMAL".
>=20
Correct. Will be fixing it up.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
