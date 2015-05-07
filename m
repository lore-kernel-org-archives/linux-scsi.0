From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/17] scsi_dh_alua: Use vpd_pg83 information
Date: Thu, 07 May 2015 13:50:25 +0200
Message-ID: <554B5181.1050108@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-4-git-send-email-hare@suse.de> <554B4F83.8020308@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbEGLu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:50:27 -0400
In-Reply-To: <554B4F83.8020308@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/07/2015 01:41 PM, Bart Van Assche wrote:
> On 05/04/15 14:42, Hannes Reinecke wrote:
>> -/*
>>    * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>>    * @sdev: sdev the command should be sent to
>>    */
>> @@ -352,55 +315,42 @@ static int alua_check_tpgs(struct
>> scsi_device *sdev, struct alua_dh_data *h)
>>           sdev_printk(KERN_INFO, sdev, "%s: supports implicit
>> TPGS\n",
>>                   ALUA_DH_NAME);
>>           break;
>> -    default:
>> -        h->tpgs =3D TPGS_MODE_NONE;
>> +    case TPGS_MODE_NONE:
>>           sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
>>                   ALUA_DH_NAME);
>>           err =3D SCSI_DH_DEV_UNSUPP;
>>           break;
>> +    default:
>> +        sdev_printk(KERN_INFO, sdev,
>> +                "%s: unsupported TPGS setting %d\n",
>> +                ALUA_DH_NAME, h->tpgs);
>> +        h->tpgs =3D TPGS_MODE_NONE;
>> +        err =3D SCSI_DH_DEV_UNSUPP;
>> +        break;
>>       }
>>
>>       return err;
>>   }
>=20
> The function scsi_device_tpgs() returns a value between 0 and 3. So
> why to add a fifth case in this switch statement ?
>=20
Because I'm paranoid?

'h->tpgs' is an integer, so _in principle_ it could take any value.
We can only safely restrict this by turning 'h->tpgs' into
an enum.
_And_ 'h->tpgs' is being set to '-1' initially, so this is to catch
any logic / initialisation issues.

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
