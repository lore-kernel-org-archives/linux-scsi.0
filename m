From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17] scsi_dh_alua: Make stpg synchronous
Date: Thu, 07 May 2015 15:36:38 +0200
Message-ID: <554B6A66.9070603@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-9-git-send-email-hare@suse.de> <554B57F8.1060209@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbbEGNgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 09:36:40 -0400
In-Reply-To: <554B57F8.1060209@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/07/2015 02:18 PM, Bart Van Assche wrote:
> On 05/04/15 14:42, Hannes Reinecke wrote:
>> +static unsigned alua_stpg(struct scsi_device *sdev, struct
>> alua_dh_data *h)
>> +{
>> +    int retval, err =3D SCSI_DH_RETRY;
>> +    unsigned char sense[SCSI_SENSE_BUFFERSIZE];
>> +    struct scsi_sense_hdr sense_hdr;
>> +
>> +    if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
>> +        /* Only implicit ALUA supported, retry */
>> +        return SCSI_DH_RETRY;
>> +    }
>> +    switch (h->state) {
>> +    case TPGS_STATE_OPTIMIZED:
>> +        return SCSI_DH_OK;
>> +    case TPGS_STATE_NONOPTIMIZED:
>> +        if ((h->flags & ALUA_OPTIMIZE_STPG) &&
>> +            (!h->pref) &&
>> +            (h->tpgs & TPGS_MODE_IMPLICIT))
>> +            return SCSI_DH_OK;
>> +        break;
>> +    case TPGS_STATE_STANDBY:
>> +    case TPGS_STATE_UNAVAILABLE:
>> +        break;
>> +    case TPGS_STATE_OFFLINE:
>> +        return SCSI_DH_IO;
>> +        break;
>> +    case TPGS_STATE_TRANSITIONING:
>> +        break;
>> +    default:
>> +        sdev_printk(KERN_INFO, sdev,
>> +                "%s: stpg failed, unhandled TPGS state %d",
>> +                ALUA_DH_NAME, pg->state);
>> +        return SCSI_DH_NOSYS;
>> +        break;
>> +    }
>> +    /* Set state to transitioning */
>> +    h->state =3D TPGS_STATE_TRANSITIONING;
>> +    retval =3D submit_stpg(sdev, h->group_id, sense);
>> +
>> +    if (retval) {
>> +        if (!(driver_byte(retval) & DRIVER_SENSE) ||
>> +            !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
>> +                      &sense_hdr)) {
>> +            sdev_printk(KERN_INFO, sdev,
>> +                    "%s: stpg failed, result %d",
>> +                    ALUA_DH_NAME, retval);
>> +            /* Retry RTPG */
>> +            return err;
>> +        }
>> +        err =3D alua_check_sense(h->sdev, &sense_hdr);
>> +        sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
>> +                ALUA_DH_NAME);
>> +        scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>> +        err =3D SCSI_DH_RETRY;
>> +    }
>> +    return err;
>> +}
>=20
> The value returned by alua_check_sense() is assigned to the variable
> 'err' but that value is not used. Otherwise in this function the
> variable 'err' always has the value SCSI_DH_RETRY. Does that mean
> that that variable can be removed ?=20
Hmm. Yes, we could.

> Additionally, why is 'retval'
> only printed if normalizing the sense data succeeds and not if
> normalizing the sense data fails ? Has it been considered to print
> the ASC and ASCQ values upon STPG failure ? Having these values
> available can be a big help during debugging.
>=20
We do print the ASC / ASCQ values; that's what scsi_print_sense_hdr
does. And the above line works on the assumption that iff
DRIVER_SENSE is set in the retval we'll have a sense code, and
this sense code will give more information than any other
(internally generated) error status. So 'retval' isn't printed
in that case, only if no sense code is provided or if we fail
to decode it.

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
