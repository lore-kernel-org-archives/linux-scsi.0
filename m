From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/7] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date: Fri, 27 Jun 2014 16:41:20 +0200
Message-ID: <53AD8290.7020809@linux.vnet.ibm.com>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-7-git-send-email-hare@suse.de> <53AD4BDB.2040707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:54441 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0Olf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 10:41:35 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 27 Jun 2014 15:41:33 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id BABED2190042
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 15:41:18 +0100 (BST)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5REfVes34472002
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 14:41:31 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5REfQij002015
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 08:41:29 -0600
In-Reply-To: <53AD4BDB.2040707@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

What base does this patch set apply to?
I failed with scsi:misc / scsi:fixes / vanilla.

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
> This needs the assignment from the added line below since zfcp_sdev n=
o
> longer exists.
> Alternatively, drop the assignment here, only have the auto variable
> definition, and do the assignment below with the added line.
>
>>       struct fc_rport *rport =3D zfcp_sdev->port->rport;

Oh crap, this also no longer works now. And as a consequence we cannot=20
get a reasonable rport any more now to call fc_block_scsi_eh().

I think it's us as LLDD calling fc_remote_port_add() anyway as part of=20
adapter/port recovery, so we trigger the change to an unblocked rport.
So, now we "only" need to make sure to block long enough for all=20
fc_remote_port_add's to have happened?
zfcp_erp_wait() might not be sufficient which is probably why Christof=20
introduced fc_block_scsi_eh() in that commit Martin referred to.

Where's a design document which explains how to correctly use=20
scsi_transport_fc?

>>       int ret;

If adapter recovery fails, e.g. because there is no local light on the=20
fibre, I would suppose that our recovery ended with a blocked Scsi_Host=
=20
(at the latest after zfcp_erp_wait()).
Is that sufficient or do we need to actually return the success of the=20
host reset from this handler function?
If not, we drop the "ret" variable as well.
If yes, how is host reset success defined?
Is it success, e.g. if adapter recovery succeeded but there is no light=
=20
on the fibre?

>>
>> +    adapter =3D (struct zfcp_adapter *)host->hostdata[0];
>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>       zfcp_erp_wait(adapter);
>>       ret =3D fc_block_scsi_eh(rport);
>
> A question just for my understanding: Calling fc_block_scsi_eh at the
> end *after* our adapter recovery is OK to wait for rports to become
> unblocked (or fast_io_failed)?
> I would guess so.

Maybe we could replace the call to fc_block_scsi_eh() with something=20
like the following which would wait until zfcp called=20
fc_remote_port_add() [synchronously via work item in=20
zfcp_scsi_schedule_rport_register() during port recovery or if link tes=
t=20
with ADISC succeeded] for all ports of the adapter as part of the=20
adapter recovery:

flush_workqueue(adapter->work_queue);

That's as coarse granular as the zfcp_erp_wait() just waiting for the=20
queue to run empty, no matter which items were queued.
Strictly speaking we would only wait for all rport work items of this=20
adapter, but that's more complicated to code. It would be safer to=20
actually return in time, and not prolong arbitrarily if new work items=20
were queued meanwhile and the work queue does not become empty, but the=
n=20
again flush_workqueue might already be safe compared to drain_workqueue=
=2E

Can I assume, that fc_remote_port_add() is synchronous and does the=20
rport state change to unblocked before returning?
If so, I would think this would semantically replace our previous call=20
to fc_block_scsi_eh().

Does any of this make sense?

To make a long story short: I'm still kinda clueless how to get this ri=
ght.

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
