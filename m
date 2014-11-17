From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] zfcp: remove access control tables interface (port
 leftovers)
Date: Mon, 17 Nov 2014 14:33:34 +0100
Message-ID: <5469F92E.90806@suse.de>
References: <1415887188-40233-1-git-send-email-maier@linux.vnet.ibm.com> <1415887188-40233-2-git-send-email-maier@linux.vnet.ibm.com> <5469F857.10402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaKQNdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 08:33:36 -0500
In-Reply-To: <5469F857.10402@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

On 11/17/2014 02:29 PM, Hannes Reinecke wrote:
> On 11/13/2014 02:59 PM, Steffen Maier wrote:
>> From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
>>
>> This patch removes some leftovers for commit
>> 663e0890e31cb85f0cca5ac1faaee0d2d52880b5
>> "[SCSI] zfcp: remove access control tables interface".
>>
>> The "access denied" case for ports is gone, as well.
>> The corresponding flag was cleared, but never set.
>> So clean it up.
>>
>> Sysfs flag is kept, though, for backward-compatibility.
>> Now it returns always 0.
>>
>> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
>> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
>> ---
>>  drivers/s390/scsi/zfcp_erp.c   | 7 -------
>>  drivers/s390/scsi/zfcp_fsf.c   | 3 +--
>>  drivers/s390/scsi/zfcp_sysfs.c | 4 +---
>>  3 files changed, 2 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_e=
rp.c
>> index c82fe65..2c5d456 100644
>> --- a/drivers/s390/scsi/zfcp_erp.c
>> +++ b/drivers/s390/scsi/zfcp_erp.c
>> @@ -821,11 +821,6 @@ static int zfcp_erp_port_forced_strategy_close(=
struct zfcp_erp_action *act)
>>  	return ZFCP_ERP_CONTINUES;
>>  }
>> =20
>> -static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *por=
t)
>> -{
>> -	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status)=
;
>> -}
>> -
>>  static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *er=
p_action)
>>  {
>>  	struct zfcp_port *port =3D erp_action->port;
>> @@ -833,7 +828,6 @@ static int zfcp_erp_port_forced_strategy(struct =
zfcp_erp_action *erp_action)
>> =20
>>  	switch (erp_action->step) {
>>  	case ZFCP_ERP_STEP_UNINITIALIZED:
>> -		zfcp_erp_port_strategy_clearstati(port);
>>  		if ((status & ZFCP_STATUS_PORT_PHYS_OPEN) &&
>>  		    (status & ZFCP_STATUS_COMMON_OPEN))
>>  			return zfcp_erp_port_forced_strategy_close(erp_action);
>> @@ -933,7 +927,6 @@ static int zfcp_erp_port_strategy(struct zfcp_er=
p_action *erp_action)
>> =20
>>  	switch (erp_action->step) {
>>  	case ZFCP_ERP_STEP_UNINITIALIZED:
>> -		zfcp_erp_port_strategy_clearstati(port);
>>  		if (p_status & ZFCP_STATUS_COMMON_OPEN)
>>  			return zfcp_erp_port_strategy_close(erp_action);
>>  		break;
>> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_f=
sf.c
>> index 0fe8d5d..21ec5e2 100644
>> --- a/drivers/s390/scsi/zfcp_fsf.c
>> +++ b/drivers/s390/scsi/zfcp_fsf.c
>> @@ -1396,8 +1396,7 @@ static void zfcp_fsf_open_port_handler(struct =
zfcp_fsf_req *req)
>>  		port->handle =3D header->port_handle;
>>  		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN |
>>  				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
>> -		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
>> -		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
>> +		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
>>  		                  &port->status);
>>  		/* check whether D_ID has changed during open */
>>  		/*
>> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp=
_sysfs.c
>> index 672b572..6b66412 100644
>> --- a/drivers/s390/scsi/zfcp_sysfs.c
>> +++ b/drivers/s390/scsi/zfcp_sysfs.c
>> @@ -73,9 +73,7 @@ ZFCP_DEFINE_ATTR(zfcp_port, port, status, "0x%08x\=
n",
>>  ZFCP_DEFINE_ATTR(zfcp_port, port, in_recovery, "%d\n",
>>  		 (atomic_read(&port->status) &
>>  		  ZFCP_STATUS_COMMON_ERP_INUSE) !=3D 0);
>> -ZFCP_DEFINE_ATTR(zfcp_port, port, access_denied, "%d\n",
>> -		 (atomic_read(&port->status) &
>> -		  ZFCP_STATUS_COMMON_ACCESS_DENIED) !=3D 0);
>> +ZFCP_DEFINE_ATTR_CONST(port, access_denied, "%d\n", 0);
>> =20
>>  ZFCP_DEFINE_ATTR(zfcp_unit, unit, status, "0x%08x\n",
>>  		 zfcp_unit_sdev_status(unit));
>>
> Is the ZFCP_STATUS_COMMON_ACCESS_DENIED bit still in use somewhere?
> If not, shouldn't it be removed altogether?
>=20
Ah. Reading the entire patch series helps.
Ignore this objection.

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
