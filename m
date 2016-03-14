From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_sas: add 'scsi_target_id' sysfs attribute
Date: Mon, 14 Mar 2016 07:46:55 +0100
Message-ID: <56E65E5F.8080507@suse.de>
References: <1457710401-37716-1-git-send-email-hare@suse.de>
 <56E31433.3070009@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbcCNGq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 02:46:58 -0400
In-Reply-To: <56E31433.3070009@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: manoj@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 03/11/2016 07:53 PM, Manoj Kumar wrote:
> On 3/11/2016 9:33 AM, Hannes Reinecke wrote:
>> There is no way to detect the scsi_target_id for any given SAS
>> remote port, so add a new sysfs attribute 'scsi_target_id'.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/scsi_sas_internal.h  | 2 +-
>>   drivers/scsi/scsi_transport_sas.c | 2 ++
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_sas_internal.h
>> b/drivers/scsi/scsi_sas_internal.h
>> index 6266a5d..e659912 100644
>> --- a/drivers/scsi/scsi_sas_internal.h
>> +++ b/drivers/scsi/scsi_sas_internal.h
>> @@ -4,7 +4,7 @@
>>   #define SAS_HOST_ATTRS        0
>>   #define SAS_PHY_ATTRS        17
>>   #define SAS_PORT_ATTRS        1
>> -#define SAS_RPORT_ATTRS        7
>> +#define SAS_RPORT_ATTRS        8
>>   #define SAS_END_DEV_ATTRS    5
>>   #define SAS_EXPANDER_ATTRS    7
>>
>> diff --git a/drivers/scsi/scsi_transport_sas.c
>> b/drivers/scsi/scsi_transport_sas.c
>> index 80520e2..deb3fde 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -1286,6 +1286,7 @@
>> sas_rphy_protocol_attr(identify.target_port_protocols,
>> target_port_protocols);
>>   sas_rphy_simple_attr(identify.sas_address, sas_address,
>> "0x%016llx\n",
>>           unsigned long long);
>>   sas_rphy_simple_attr(identify.phy_identifier, phy_identifier,
>> "%d\n", u8);
>> +sas_rphy_simple_attr(scsi_target_id, scsi_target_id, "%d\n", u8);
>=20
> Hannes:
>=20
> Shouldn't the last argument be u32?
>=20
Errm. Yes. indeed. Thank you for spotting this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
