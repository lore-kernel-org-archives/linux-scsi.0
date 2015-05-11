From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/17] scsi_dh_alua: Use separate alua_port_group structure
Date: Mon, 11 May 2015 14:36:58 +0200
Message-ID: <5550A26A.1080902@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-11-git-send-email-hare@suse.de> <20150511123235.GC5732@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbbEKMhA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 08:37:00 -0400
In-Reply-To: <20150511123235.GC5732@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/11/2015 02:32 PM, Christoph Hellwig wrote:
> On Mon, May 04, 2015 at 02:42:16PM +0200, Hannes Reinecke wrote:
>> The port group needs to be a separate structure as several
>> LUNs might belong to the same group.
>=20
> The switch to on-stack sense data in alua_rtpg probably should be
> a separate patch.
>=20
>> -static int realloc_buffer(struct alua_dh_data *h, unsigned len)
>> +static int realloc_buffer(struct alua_port_group *pg, unsigned len)
>>  {
>=20
> Not directly related to this patch, but what's the reason to have
> a buffer hang off the dh_data or now port group?  Seems like a local
> allocation in alua_rtpg would be more sensible.
>=20
Hmm. Okay, can do this.

>> +	spin_lock(&port_group_lock);
>> +	pg =3D kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
>> +	if (!pg) {
>> +		sdev_printk(KERN_WARNING, sdev,
>> +			    "%s: kzalloc port group failed\n",
>> +			    ALUA_DH_NAME);
>> +		/* Temporary failure, bypass */
>> +		spin_unlock(&port_group_lock);
>> +		return SCSI_DH_DEV_TEMP_BUSY;
>> +	}
>=20
> As bart mentioned it should be simply enough to move the allocation
> and initialization outside the spinlock. =20
>=20
Yes, will be doing so. But I'm still waiting for a review for the
remaining bits before sending a new version.

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
