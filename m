From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/17] scsi_dh_alua: Improve error handling
Date: Thu, 07 May 2015 13:52:05 +0200
Message-ID: <554B51E5.3030305@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-5-git-send-email-hare@suse.de> <554B5113.7050800@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbEGLwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:52:07 -0400
In-Reply-To: <554B5113.7050800@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/07/2015 01:48 PM, Bart Van Assche wrote:
> On 05/04/15 14:42, Hannes Reinecke wrote:
>> @@ -161,12 +164,12 @@ static unsigned submit_rtpg(struct
>> scsi_device *sdev, struct alua_dh_data *h,
>>       rq->sense_len =3D h->senselen =3D 0;
>>
>>       err =3D blk_execute_rq(rq->q, NULL, rq, 1);
>> -    if (err =3D=3D -EIO) {
>> -        sdev_printk(KERN_INFO, sdev,
>> -                "%s: rtpg failed with %x\n",
>> -                ALUA_DH_NAME, rq->errors);
>> +    if (err < 0) {
>> +        if (!rq->errors)
>> +            err =3D DID_ERROR << 16;
>> +        else
>> +            err =3D rq->errors;
>>           h->senselen =3D rq->sense_len;
>> -        err =3D SCSI_DH_IO;
>>       }
>>       blk_put_request(rq);
>>   done:
>=20
> Running the grep query "->errors =3D " over the Linux kernel source
> tree shows that sometimes a SCSI error code is written into that
> field and sometimes a negative error code. Does this mean that the
> test !rq->errors should be modified into !rq->errors &&
> !IS_ERR_VALUE(rq->errors) ?
>=20
Hmm. I'm going to review this. 'rq->errors' should be used consistently=
=2E

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
