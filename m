From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date: Fri, 27 Jun 2014 19:52:15 +0200
Message-ID: <53ADAF4F.3060900@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <1403850425-89297-7-git-send-email-hare@suse.de> <53AD4BDB.2040707@linux.vnet.ibm.com> <53AD8290.7020809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaF0RwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 13:52:18 -0400
In-Reply-To: <53AD8290.7020809@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

On 06/27/2014 04:41 PM, Steffen Maier wrote:
> What base does this patch set apply to?
> I failed with scsi:misc / scsi:fixes / vanilla.
>
> On 06/27/2014 12:47 PM, Steffen Maier wrote:
>> On 06/27/2014 08:27 AM, Hannes Reinecke wrote:
>>> Issuing a host reset should not rely on any commands.
>>> So use Scsi_Host as argument for eh_host_reset_handler.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>
>>>   drivers/s390/scsi/zfcp_scsi.c             |  3 +-
>>
>>>   69 files changed, 289 insertions(+), 379 deletions(-)
>>
>>> diff --git a/drivers/s390/scsi/zfcp_scsi.c
>>> b/drivers/s390/scsi/zfcp_scsi.c
>>> index dc42c93..fe50f69 100644
>>> --- a/drivers/s390/scsi/zfcp_scsi.c
>>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>>> @@ -281,13 +281,14 @@ static int
>>> zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>>>       return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
>>>   }
>>>
>>> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt=
)
>>> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>>>   {
>>>       struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->devic=
e);
>>
>> Scpnt argument no longer exists, so this line must likely go away to
>> compile.
>>
>>>       struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;
>>
>> This needs the assignment from the added line below since zfcp_sdev =
no
>> longer exists.
>> Alternatively, drop the assignment here, only have the auto variable
>> definition, and do the assignment below with the added line.
>>
>>>       struct fc_rport *rport =3D zfcp_sdev->port->rport;
>
> Oh crap, this also no longer works now. And as a consequence we canno=
t
> get a reasonable rport any more now to call fc_block_scsi_eh().
>
> I think it's us as LLDD calling fc_remote_port_add() anyway as part o=
f
> adapter/port recovery, so we trigger the change to an unblocked rport=
=2E
> So, now we "only" need to make sure to block long enough for all
> fc_remote_port_add's to have happened?
Either that, or have some hook in queuecommand which will return any=20
command with BUSY until the HBA reset is finished.

> zfcp_erp_wait() might not be sufficient which is probably why Christo=
f
> introduced fc_block_scsi_eh() in that commit Martin referred to.
>
> Where's a design document which explains how to correctly use
> scsi_transport_fc?
>
Typically the LLDD sets all ports to 'BLOCKED' if it's still doing=20
discovery (ie during LIP for FC-AL) and then updates the port states
accordingly once discovery is finished via=20
fc_remote_port_add()/fc_remote_port_delete().

>>>       int ret;
>
> If adapter recovery fails, e.g. because there is no local light on th=
e
> fibre, I would suppose that our recovery ended with a blocked Scsi_Ho=
st
> (at the latest after zfcp_erp_wait()).
No. It's perfectly okay for host_reset to end up with no local light on=
=20
the fibre; that is not a failure.
(Of course, the driver would have to call fc_remote_port_delete() here=20
first).
Adapter recovery should only be considered 'failed' if for some reason=20
the HBA itself doesn't react to the host reset procedure.

> Is that sufficient or do we need to actually return the success of th=
e
> host reset from this handler function?

Not necessarily. If the communication with the HBA is always assumed to=
=20
be working (and, judging from DASD details, this is a safe assumption)
host reset cannot really fail for zfcp.

> If not, we drop the "ret" variable as well.
> If yes, how is host reset success defined?
> Is it success, e.g. if adapter recovery succeeded but there is no lig=
ht
> on the fibre?
>
As mentioned above: Yes, that's perfectly okay.
It still means that you can communicate with the HBA, otherwise you
wouldn't even know the current light status :-)

>>>
>>> +    adapter =3D (struct zfcp_adapter *)host->hostdata[0];
>>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>>       zfcp_erp_wait(adapter);
>>>       ret =3D fc_block_scsi_eh(rport);
>>
>> A question just for my understanding: Calling fc_block_scsi_eh at th=
e
>> end *after* our adapter recovery is OK to wait for rports to become
>> unblocked (or fast_io_failed)?
>> I would guess so.
>
> Maybe we could replace the call to fc_block_scsi_eh() with something
> like the following which would wait until zfcp called
> fc_remote_port_add() [synchronously via work item in
> zfcp_scsi_schedule_rport_register() during port recovery or if link t=
est
> with ADISC succeeded] for all ports of the adapter as part of the
> adapter recovery:
>
> flush_workqueue(adapter->work_queue);
>
> That's as coarse granular as the zfcp_erp_wait() just waiting for the
> queue to run empty, no matter which items were queued.
> Strictly speaking we would only wait for all rport work items of this
> adapter, but that's more complicated to code. It would be safer to
> actually return in time, and not prolong arbitrarily if new work item=
s
> were queued meanwhile and the work queue does not become empty, but t=
hen
> again flush_workqueue might already be safe compared to drain_workque=
ue.
>
Actually, it would be safe to call 'fc_remote_port_delete()' for all=20
remote ports as the first part of the host_reset() function.
(Always assuming you're not doing that already; I haven't checked here)=
=2E
The you could call zfcp_erp_adapter_reopen() and zfcp_erp_wait() as you=
=20
do nowadays.
But now it wouldn't matter if there are any work items queued or not;
the ports will be reset if and when the workqueue items are called.
And the SCSI midlayer wouldn't be sending any commands as the ports are=
=20
still in BLOCKED during that time.

Of course, it might be that the ports does in fact vanish during host=20
reset (dev_loss_tmo might trigger before host reset finished), but the=20
SCSI layer is well equipped to handle that.

> Can I assume, that fc_remote_port_add() is synchronous and does the
> rport state change to unblocked before returning?
Yes.

> If so, I would think this would semantically replace our previous cal=
l
> to fc_block_scsi_eh().
>
No. You cannot assume that the rport is still present after host_reset.
So I would really not try to call anything rport related in host_reset =
=2E..

> Does any of this make sense?
>
Sorta. Hope the same holds for my answers :-)

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
