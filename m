From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] libata: implement ZBC IN translation
Date: Wed, 6 Apr 2016 09:51:26 +0200
Message-ID: <5704BFFE.4050200@suse.de>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
 <1459763271-125856-2-git-send-email-hare@suse.de>
 <20160404154924.GU7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbcDFHva (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2016 03:51:30 -0400
In-Reply-To: <20160404154924.GU7822@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 05:49 PM, Tejun Heo wrote:
> On Mon, Apr 04, 2016 at 11:47:48AM +0200, Hannes Reinecke wrote:
>> +/*
>=20
> /**
>=20
>> + * ata_scsi_report_zones_complete
>> + *
>> + * Convert T-13 little-endian field representation into
>> + * T-10 big-endian field representation.
>> + */
>> +static void ata_scsi_report_zones_complete(struct ata_queued_cmd *q=
c)
>> +{
>> +	struct scsi_cmnd *scmd =3D qc->scsicmd;
>> +	struct sg_mapping_iter miter;
>> +	unsigned long flags;
>> +	unsigned int bytes =3D 0;
>> +
>> +	sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
>> +		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
>> +
>> +	local_irq_save(flags);
>> +	while (sg_miter_next(&miter)) {
>> +		unsigned int offset =3D 0;
>=20
> Not this patch's fault but ugh........  :(
>=20
I know. I've been asking the very same questions to T-13.
But apparently it's by design ... gnaa.

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
