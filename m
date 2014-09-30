From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Tue, 30 Sep 2014 11:08:17 +0200
Message-ID: <542A7301.1060400@suse.de>
References: <1411991272-129962-1-git-send-email-hare@suse.de> <20140930074329.GA10290@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaI3JIU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 05:08:20 -0400
In-Reply-To: <20140930074329.GA10290@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@avagotech.com>

On 09/30/2014 09:43 AM, Christoph Hellwig wrote:
> On Mon, Sep 29, 2014 at 01:47:52PM +0200, Hannes Reinecke wrote:
>> Megaraid_sas uses a shared pool of commands per HBA, so we
>> should be enabling a shared tag map.
>> This will allow the I/O scheduler to make better scheduling
>> decisions and will avoid BUSY states in the driver.
>=20
> What exact problem did you see?  Do you have a link to a bugzilla ent=
ry
> or similar?  Was this observed on real hardware or your qemu emulatio=
n?
>=20
Well, _actually_ I just did it so that I could get the tag number
for my printk patchset :-)

But there is an underlying reason:
megaraid_sas uses an internal frame pool of a fixed size.
Once that's exhausted it cannot queue any more commands, and need to
return busy.
But as this is a per-host command pool all LUNs have to shared the
same frame pool, and the driver uses heuristics (ie 1/4 of the pool
size) to set cmd_per_lun. So if you have more than 4 LUNs you'll run
into issues as the pool can become exhausted.
Hence I thought it would be good to expose this to the block layer
so that we can avoid BUSY states in the driver.


>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c | 34 ++++++++++++++++++++=
++++++++++-
>>  1 file changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scs=
i/megaraid/megaraid_sas_base.c
>> index f6a69a3..996fa9a 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -1659,7 +1659,7 @@ static int megasas_slave_configure(struct scsi=
_device *sdev)
>>  	*/
>>  	blk_queue_rq_timeout(sdev->request_queue,
>>  		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
>> -
>> +	sdev->tagged_supported =3D 1;
>=20
>> +	/* We have a shared tag map, so TCQ is always supported */
>> +	sdev->tagged_supported =3D 1;
>> +
>=20
> Why doesn't the device return the proper data in the INQUIRY response=
?
>=20
> And more importantly why do you want to do this twice?
>=20
Bah, Typo.

>>  	instance =3D megasas_lookup_instance(sdev->host->host_no);
>>  	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
>>  		/*
>> @@ -1677,13 +1681,20 @@ static int megasas_slave_alloc(struct scsi_d=
evice *sdev)
>>  			sdev->id;
>>  		if (instance->pd_list[pd_index].driveState =3D=3D
>>  					MR_PD_STATE_SYSTEM) {
>> +			scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
>>  			return 0;
>>  		}
>>  		return -ENXIO;
>>  	}
>> +	scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
>>  	return 0;
>=20
> Please refactor the code so that the first case falls through to the
> second, something like:
>=20
>=20
> 		if (instance->pd_list[pd_index].driveState !=3D
> 					MR_PD_STATE_SYSTEM)
> 			return -ENXIO;
> 	}
>=20
> 	scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
> 	return 0;
>=20
Okay, will be doing it.

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
