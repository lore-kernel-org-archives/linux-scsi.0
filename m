From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date: Fri, 27 Jun 2014 13:04:01 +0200
Message-ID: <53AD4FA1.8090502@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-7-git-send-email-hare@suse.de> <53AD4BDB.2040707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaF0LEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 07:04:04 -0400
In-Reply-To: <53AD4BDB.2040707@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/27/2014 12:47 PM, Steffen Maier wrote:
> On 06/27/2014 08:27 AM, Hannes Reinecke wrote:
>> Issuing a host reset should not rely on any commands.
>> So use Scsi_Host as argument for eh_host_reset_handler.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>
>>   drivers/s390/scsi/zfcp_scsi.c             |  3 +-
>
>>   69 files changed, 289 insertions(+), 379 deletions(-)
>
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c
>> b/drivers/s390/scsi/zfcp_scsi.c
>> index dc42c93..fe50f69 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -281,13 +281,14 @@ static int
>> zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>>       return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
>>   }
>>
>> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>>   {
>>       struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->device=
);
>
> Scpnt argument no longer exists, so this line must likely go away to
> compile.
>
>>       struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;
>
> This needs the assignment from the added line below since zfcp_sdev
> no longer exists.
> Alternatively, drop the assignment here, only have the auto variable
> definition, and do the assignment below with the added line.
>
>>       struct fc_rport *rport =3D zfcp_sdev->port->rport;
>>       int ret;
>>
>> +    adapter =3D (struct zfcp_adapter *)host->hostdata[0];
>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>       zfcp_erp_wait(adapter);
>>       ret =3D fc_block_scsi_eh(rport);
>
> A question just for my understanding: Calling fc_block_scsi_eh at
> the end *after* our adapter recovery is OK to wait for rports to
> become unblocked (or fast_io_failed)?
> I would guess so.
>
Hehe. That's actually a question for _you_ :-)

Thing is, 'fc_block_scsi-eh' only waits for the rport to become=20
unblocked; the unblocking itself would need to be done from the LLDD.
So I would like to ask the maintainer of the LLDD why this code is=20
there; normally I would have expected the 'zfcp_erp_wait' to only
return after the HBA is fully online again.

And in general waiting for an rport during host reset is _really_ a=20
bad idea. The rport might not be present after host reset at all,
making the check pretty much pointless.

Can't you check whether the HBA is in a working state after=20
zfcp_erp_wait() and return a status based on that?

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
