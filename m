From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/12] advansys: use host_reset
Date: Thu, 04 Dec 2014 10:23:52 +0100
Message-ID: <54802828.2060806@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-2-git-send-email-hare@suse.de> <20141204091741.GC23891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaLDJXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:23:55 -0500
In-Reply-To: <20141204091741.GC23891@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 12/04/2014 10:17 AM, Christoph Hellwig wrote:
>> -#define AdvAbortQueue(asc_dvc, scsiq) \
>> +#define AdvAbortQueue(asc_dvc, srb_tag) \
>>          AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_ABORT, \
>> -                       (ADV_DCNT) (scsiq))
>> +                       (ADV_DCNT) (srb_tag))
>=20
> This change looks unrelated.
>=20
Yes, correct. This needs to be moved to the next patch.

>> @@ -11250,7 +11250,7 @@ static struct scsi_host_template advansys_te=
mplate =3D {
>>  	.name =3D DRV_NAME,
>>  	.info =3D advansys_info,
>>  	.queuecommand =3D advansys_queuecommand,
>> -	.eh_bus_reset_handler =3D advansys_reset,
>> +	.eh_host_reset_handler =3D advansys_reset,
>=20
> Please also update the comments in advansys_reset that talk about bus
> resets and in one case event about a device reset.
>=20
Okay.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
