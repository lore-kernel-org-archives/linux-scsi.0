From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/23] scsi: Add scsi_vpd_lun_id()
Date: Tue, 1 Sep 2015 14:43:26 +0200
Message-ID: <55E59D6E.7050007@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-17-git-send-email-hare@suse.de>
 <20150901102238.GD9838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbbIAMn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 08:43:29 -0400
In-Reply-To: <20150901102238.GD9838@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/01/2015 12:22 PM, Christoph Hellwig wrote:
> On Thu, Aug 27, 2015 at 02:41:14PM +0200, Hannes Reinecke wrote:
>> Add a function scsi_vpd_lun_id() to return a unique device
>> identifcation based on the designation descriptors of
>> VPD page 0x83.
>>
>> As devices might implement several descriptors the order
>> of preference is:
>> - NAA IEE Registered Extended
>> - EUI-64 based 16-byte
>> - EUI-64 based 12-byte
>> - NAA IEEE Registered
>> - NAA IEEE Extended
>> A SCSI name string descriptor is preferred to all of them
>> if the identification is longer than 16 bytes.
>>
>> The returned unique device identification will be formatted
>> as a SCSI Name string to avoid clashes between different
>> designator types.
>=20
> Looks good in general, but I wonder if it might make sense to switch
> to kasprintf and let the caller free the buffer?
>=20
I really am no friend of caller-needs-to-free-up-buffer thingies.
Allocations and deallocations should be done in the same context for
better tracking (and debugging), IMO.

> Otherwise:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
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
