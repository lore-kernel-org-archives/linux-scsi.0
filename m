From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] sd: Implement new RESET_WP provisioning mode
Date: Wed, 20 Jul 2016 16:52:31 +0200
Message-ID: <62ea4016-dc5d-3df6-8764-e62291f7adc3@suse.de>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
 <1468934710-93876-3-git-send-email-hare@suse.de>
 <6c0e2de2-fbed-1fc1-3d2c-4063d034cb58@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbcGTOwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 10:52:34 -0400
In-Reply-To: <6c0e2de2-fbed-1fc1-3d2c-4063d034cb58@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 07/20/2016 02:49 AM, Damien Le Moal wrote:
> Hi Hannes,
>=20
> On 7/19/16 22:25, Hannes Reinecke wrote:
>> We can map the RESET WRITE POINTER command onto a 'discard'
>> request.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/sd.c | 65
>> ++++++++++++++++++++++++++++++++++++++++++++-----------
>>  drivers/scsi/sd.h |  1 +
>>  2 files changed, 53 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 249ea81..52dda83 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -369,6 +369,7 @@ static const char *lbp_mode[] =3D {
>>      [SD_LBP_WS16]        =3D "writesame_16",
>>      [SD_LBP_WS10]        =3D "writesame_10",
>>      [SD_LBP_ZERO]        =3D "writesame_zero",
>> +    [SD_ZBC_RESET_WP]    =3D "reset_wp",
>>      [SD_LBP_DISABLE]    =3D "disabled",
>>  };
>>
>> @@ -391,6 +392,13 @@ provisioning_mode_store(struct device *dev,
>> struct device_attribute *attr,
>>      if (!capable(CAP_SYS_ADMIN))
>>          return -EACCES;
>>
>> +    if (sdkp->zoned =3D=3D 1) {
>> +        if (!strncmp(buf, lbp_mode[SD_ZBC_RESET_WP], 20)) {
>> +            sd_config_discard(sdkp, SD_ZBC_RESET_WP);
>> +            return count;
>> +        }
>> +        return -EINVAL;
>> +    }
>>      if (sdp->type !=3D TYPE_DISK)
>>          return -EINVAL;
>>
>> @@ -683,6 +691,11 @@ static void sd_config_discard(struct scsi_disk
>> *sdkp, unsigned int mode)
>>          q->limits.discard_zeroes_data =3D sdkp->lbprz;
>>          break;
>>
>> +    case SD_ZBC_RESET_WP:
>> +        max_blocks =3D sdkp->unmap_granularity;
>> +        q->limits.discard_zeroes_data =3D 1;
>> +        break;
>> +
>>      case SD_LBP_ZERO:
>>          max_blocks =3D min_not_zero(sdkp->max_ws_blocks,
>>                        (u32)SD_MAX_WS10_BLOCKS);
>=20
> I am still wondering if setting discard_zeroes_data to 1 is the right
> choice here since nothing will happen for conventional zones (no
> zeroing, no reset, nothing). discard_zeroes_data=3D0 may be a safer
> choice, even though I have not hit any issue with it set to 1.
>=20
This setting needs to be reviewed once hchs zero-out patches are in.
Thing is, we need to properly differentiate between 'discard' and
'zero-out'. Unfortunately ATM the libata stack only implements a
translation for 'write_same', which is then mapped onto DSM TRIM.
So the 'write_discard_zeroes' is even incorrect for current libata usag=
e.

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
