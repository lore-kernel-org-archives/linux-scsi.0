From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] scsi: Remove scmd->tag
Date: Thu, 02 Oct 2014 13:36:44 +0200
Message-ID: <542D38CC.7000706@suse.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de> <1412246593-107001-6-git-send-email-hare@suse.de> <20141002112230.GB31346@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJBLgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 07:36:47 -0400
In-Reply-To: <20141002112230.GB31346@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Finn Thain <fthain@telegraphics.com.au>, James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org

On 10/02/2014 01:22 PM, Christoph Hellwig wrote:
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index a0c8c5d..cb68089 100644
>> --- a/drivers/scsi/NCR5380.c
>> +++ b/drivers/scsi/NCR5380.c
>> @@ -1527,7 +1527,6 @@ part2:
>>  	tmp[0] =3D IDENTIFY(((instance->irq =3D=3D SCSI_IRQ_NONE) ? 0 : 1)=
, cmd->device->lun);
>> =20
>>  	len =3D 1;
>> -	cmd->tag =3D 0;
>=20
> The driver was explicitly setting the tag to zero here, so this needs
> a good explanation instead of a blind removal.
>=20
> But given how nice the code that Finn delivered in the past is I have=
 high
> hopes that his NCR5380 overhaul will get rid of a lot of this cruft :=
)
>=20
Yep. (Removing the above line shouldn't actually doing any harm, as
the tagged queueing support in NCR5380 is currently disabled anyway).
(Famous last words).

But this was just a test for the feasibility of scmd->tag removal.
Once Finn's patchset is posted we definitely should be revisiting
it.

And arguably the tcm_loop and vmw_pvscsi patches are real bugfixes,
so maybe they should be applied anyway.

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
