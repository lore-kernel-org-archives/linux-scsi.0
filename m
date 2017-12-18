From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] virtio-scsi: Add FC transport class
Date: Mon, 18 Dec 2017 09:31:02 +0100
Message-ID: <062f16c7-ee30-aeb6-e531-f5aed285a52c@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-3-git-send-email-hare@suse.de>
 <55641493-64bf-d997-9883-62fbf59a0404@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757802AbdLRIbE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Dec 2017 03:31:04 -0500
In-Reply-To: <55641493-64bf-d997-9883-62fbf59a0404@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 12/15/2017 07:08 PM, Steffen Maier wrote:
> 
> On 12/14/2017 11:11 AM, Hannes Reinecke wrote:
>> When a device announces an 'FC' protocol we should be pulling
>> in the FC transport class to have the rports etc setup correctly.
> 
> It took some time for me to understand what this does.
> It seems to mirror the topology of rports and sdevs that exist under the
> fc_host on the kvm host side to the virtio-scsi-fc side in the guest.
> 
> I like the idea. This is also what I've been suggesting users to do if
> they back virtio-scsi with zfcp on the kvm host side. Primarily to not
> stall all virtio-scsi I/O on all paths if the guest ever gets into
> scsi_eh. But also to make it look like an HBA pass through so one can
> more easily migrate to this once we have FCP pass through.
> 
Thanks for the review.

>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/virtio_scsi.c | 323
>> ++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 277 insertions(+), 46 deletions(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index a561e90..f925fbd 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
> 
>> @@ -591,11 +616,25 @@ static int virtscsi_queuecommand_single(struct
>> Scsi_Host *sh,
>>                       struct scsi_cmnd *sc)
> 
>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>> +        struct fc_rport *rport =
>> +            starget_to_rport(scsi_target(sc->device));
>> +        if (rport && rport->dd_data) {
>> +            tgt = rport->dd_data;
>> +            target_id = tgt->target_id;
>> +        }
>> +    } else
>> +        tgt = scsi_target(sc->device)->hostdata;
>> +    if (!tgt || tgt->removed) {
> 
>> @@ -648,16 +687,30 @@ static int virtscsi_queuecommand_multi(struct
>> Scsi_Host *sh,
>>                          struct scsi_cmnd *sc)
> 
>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>> +        struct fc_rport *rport =
>> +            starget_to_rport(scsi_target(sc->device));
>> +        if (rport && rport->dd_data) {
>> +            tgt = rport->dd_data;
>> +            target_id = tgt->target_id;
>> +        }
>> +    } else
>> +        tgt = scsi_target(sc->device)->hostdata;
>> +    if (!tgt || tgt->removed) {
> 
> repeating pattern?
> 
Yeah, I could probably move that to a separate function.

>> @@ -696,12 +749,27 @@ static int virtscsi_device_reset(struct
>> scsi_cmnd *sc)
>>   {
>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>> +        struct fc_rport *rport =
>> +            starget_to_rport(scsi_target(sc->device));
>> +        if (rport && rport->dd_data ) {
>> +            tgt = rport->dd_data;
>> +            target_id = tgt->target_id;
>> +        } else
>> +            return FAST_IO_FAIL;
>> +    } else {
>> +        tgt = scsi_target(sc->device)->hostdata;
>> +        if (!tgt || tgt->removed)
> 
> The other patterns have the !tgt check outside of the if else condition.
> For consistency this might work here, too?
> 
Possibly. I'll check.

>> +            return FAST_IO_FAIL;
>> +    }
> 
> 
>> @@ -755,19 +823,34 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
> 
>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>> +        struct fc_rport *rport =
>> +            starget_to_rport(scsi_target(sc->device));
>> +        if (rport && rport->dd_data ) {
>> +            tgt = rport->dd_data;
>> +            target_id = tgt->target_id;
>> +        } else
>> +            return FAST_IO_FAIL;
>> +    } else {
>> +        tgt = scsi_target(sc->device)->hostdata;
>> +        if (!tgt || tgt->removed)
>> +            return FAST_IO_FAIL;
>> +    }
> 
> dito
> 
>> @@ -857,27 +970,67 @@ static void virtscsi_rescan_work(struct
>> work_struct *work)
>>
>>       wait_for_completion(&comp);
> 
> Waiting in work item .vs. having the response (IRQ) path trigger
> subsequent processing async ?
> Or do we need the call chain(s) getting here to be in our own process
> context via the workqueue anyway?
> 
Can't see I can parse this sentence, but I'll be looking at the code
trying to come up with a clever explanation :-)

>>       target_id = virtio32_to_cpu(vscsi->vdev, cmd->resp.rescan.id);
>> -    if (target_id != -1) {
>> -        int transport = virtio32_to_cpu(vscsi->vdev,
>> -                        cmd->resp.rescan.transport);
>> -        spin_lock_irq(&vscsi->rescan_lock);
>> -        vscsi->next_target_id = target_id + 1;
>> -        spin_unlock_irq(&vscsi->rescan_lock);
>> -        shost_printk(KERN_INFO, sh,
>> -                 "found %s target %d (WWN %*phN)\n",
>> -                 transport == SCSI_PROTOCOL_FCP ? "FC" : "SAS",
>> -                 target_id, 8,
>> -                 cmd->resp.rescan.port_wwn);
>> -        scsi_scan_target(&sh->shost_gendev, 0, target_id,
>> -                 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
>> -        queue_work(system_freezable_wq, &vscsi->rescan_work);
>> -    } else {
>> +    if (target_id == -1) {
> 
> This boolean if expression was introduced in the previous patch.
> Why negate it here?
> It causes a number of potentially unnecessary changed lines making
> review harder.
> 
True. Will be fixing it up.

> 
>> +    if (transport == SCSI_PROTOCOL_FCP) {
>> +        struct fc_rport_identifiers rport_ids;
>> +        struct fc_rport *rport;
>> +
>> +        rport_ids.node_name = wwn_to_u64(cmd->resp.rescan.node_wwn);
>> +        rport_ids.port_name = wwn_to_u64(cmd->resp.rescan.port_wwn);
>> +        rport_ids.port_id = (target_id >> 8);
> 
> Why do you shift target_id by one byte to the right?
> 
Because with the original setup virtio_scsi guest would pass in the
target_id, and the host would be selecting the device based on that
information.
With virtio-vfc we pass in the wwpn, but still require the target ID to
be compliant with things like event notification etc.
So I've shifted the target id onto the port ID (which is 24 bit anyway).
I could've used a bitfield here, but then I wasn't quite sure about the
endianness of which.

>> +        rport = fc_remote_port_add(sh, 0, &rport_ids);
>> +        if (rport) {
>> +            tgt->rport = rport;
>> +            rport->dd_data = tgt;
>> +            fc_remote_port_rolechg(rport, FC_RPORT_ROLE_FCP_TARGET);
> 
> Is the rolechg to get some event? Otherwise we could have
> rport_ids.roles = FC_RPORT_ROLE_FCP_TARGET before fc_remote_port_add().
> 
That's how the 'normal' transport classes do it; but I'll check if this
can be rolled into the call to fc_remote_port_add().

>> +        } else {
>> +            spin_lock_irq(&vscsi->rescan_lock);
>> +            list_del(&tgt->list);
>> +            spin_unlock_irq(&vscsi->rescan_lock);
>> +            kfree(tgt);
>> +            tgt = NULL;
>> +        }
>> +    } else {
>> +        scsi_scan_target(&sh->shost_gendev, 0, tgt->target_id,
>> +                 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
>> +    }
>> +    queue_work(system_freezable_wq, &vscsi->rescan_work);
>> +out:
>>       mempool_free(cmd, virtscsi_cmd_pool);
>>       return;
>>   scan_host:
> 
>> @@ -932,14 +1089,31 @@ static void virtscsi_scan_host(struct
>> virtio_scsi *vscsi)
>>   static void virtscsi_scan_start(struct Scsi_Host *sh)
>>   {
>>       struct virtio_scsi *vscsi = shost_priv(sh);
>> +    struct virtio_scsi_target_state *tgt;
>>
>> -    virtscsi_scan_host(vscsi);
>>       spin_lock_irq(&vscsi->rescan_lock);
>>       if (vscsi->next_target_id != -1) {
>>           shost_printk(KERN_INFO, sh, "rescan: already running\n");
>>           spin_unlock_irq(&vscsi->rescan_lock);
>>           return;
>>       }
>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>> +        fc_host_node_name(sh) = vscsi->wwnn;
>> +        fc_host_port_name(sh) = vscsi->wwpn;
>> +        fc_host_port_id(sh) = 0x00ff00;
>> +        fc_host_port_type(sh) = FC_PORTTYPE_NPIV;
> 
> Why is this hardcoded?
> 
> At least with zfcp, we can have kvm host *v*HBAs without NPIV.
> 
For the simple fact that I don't have fields to transfer this
information; plus it's not _actually_ used anywhere.
Unless you have a strict need why this information is required?

>> +        fc_host_port_state(sh) = FC_PORTSTATE_BLOCKED;
>> +        list_for_each_entry(tgt, &vscsi->target_list, list) {
>> +            if (tgt->rport) {
>> +                fc_remote_port_delete(tgt->rport);
> 
> I'm not familiar with the scan callbacks, maybe that's why I wonder why
> you block all rports when scanning the host. Is it so that the
> subsequent port scans can call the properly paired fc_remote_port_add to
> potentially update a previously existing rport with new properties we
> got from the qemu/host side.
> 
The 'scan' code here is the equivalent of an RSCN for FC-AL,
ie we will be updating the rport state (and existence) during scanning.
As we cannot guess the rport state during this operation (in fact, we
can't even tell if the rport is still alive) we set all ports to BLOCKED
here, and let the FC transport class handle the state transition of the
rports via fc_remove_port_add() or dev_loss_tmo firing.

>> +                tgt->rport = NULL;
>> +            }
>> +            tgt->removed = true;
>> +        }
>> +    } else {
>> +        list_for_each_entry(tgt, &vscsi->target_list, list)
>> +            tgt->removed = true;
>> +    }
>>       vscsi->next_target_id = 0;
>>       shost_printk(KERN_INFO, sh, "rescan: start\n");
>>       spin_unlock_irq(&vscsi->rescan_lock);
>> @@ -954,12 +1128,14 @@ int virtscsi_scan_finished(struct Scsi_Host
>> *sh, unsigned long time)
>>       spin_lock_irq(&vscsi->rescan_lock);
>>       if (vscsi->next_target_id != -1)
>>           ret = 0;
>> +    else if (vscsi->protocol == SCSI_PROTOCOL_FCP)
>> +        fc_host_port_state(sh) = FC_PORTSTATE_ONLINE;
>>       spin_unlock_irq(&vscsi->rescan_lock);
>>       if (!ret)
>>           flush_work(&vscsi->rescan_work);
>>
>> -    shost_printk(KERN_INFO, sh, "rescan: %s finished\n",
>> -             ret ? "" : "not");
>> +    shost_printk(KERN_INFO, sh, "rescan: %sfinished\n",
>> +             ret ? "" : "not ");
> 
> You introduced it in the previous patch, so do the fixup there in the
> first place?
> 
Yeah, will be cleaning it up.

>>       return ret;
>>   }
>>
>> @@ -978,6 +1154,34 @@ static ssize_t virtscsi_host_store_rescan(struct
>> device *dev,
>>       NULL,
>>   };
>>
>> +static int virtscsi_issue_lip(struct Scsi_Host *shost)
>> +{
>> +    struct virtio_scsi *vscsi = shost_priv(shost);
>> +    unsigned long start = jiffies;
>> +    struct virtio_scsi_target_state *tgt;
>> +
>> +    spin_lock_irq(&vscsi->rescan_lock);
>> +    if (vscsi->next_target_id != -1) {
>> +        spin_unlock_irq(&vscsi->rescan_lock);
>> +        return 0;
>> +    }
> 
>> +    fc_host_port_state(shost) = FC_PORTSTATE_BLOCKED;
>> +    list_for_each_entry(tgt, &vscsi->target_list, list) {
>> +        if (tgt->rport) {
>> +            fc_remote_port_delete(tgt->rport);
>> +            tgt->rport = NULL;
>> +        }
>> +    }
>> +    vscsi->next_target_id = 0;
> 
> I see some code duplication with what's in virtscsi_scan_host().
> Not sure if reduction is worth it.
> 
Possibly not :-)

>> +    spin_unlock_irq(&vscsi->rescan_lock);
>> +    queue_work(system_freezable_wq, &vscsi->rescan_work);
>> +
>> +    while (!virtscsi_scan_finished(shost, jiffies - start))
>> +        msleep(10);
>> +
>> +    return 0;
>> +}
>> +
>>   static struct scsi_host_template virtscsi_host_template_single = {
>>       .module = THIS_MODULE,
>>       .name = "Virtio SCSI HBA",
>> @@ -1066,6 +1270,20 @@ static ssize_t
>> virtscsi_host_store_rescan(struct device *dev,
>>       .track_queue_depth = 1,
>>   };
>>
>> +static struct fc_function_template virtscsi_transport_functions = {
>> +    .dd_fcrport_size = sizeof(struct virtio_scsi_target_state *),
>> +    .show_host_node_name = 1,
>> +    .show_host_port_name = 1,
>> +    .show_host_port_id = 1,
>> +    .show_host_port_state = 1,
>> +    .show_host_port_type = 1,
>> +    .show_starget_node_name = 1,
>> +    .show_starget_port_name = 1,
>> +    .show_starget_port_id = 1,
>> +    .show_rport_dev_loss_tmo = 1,
>> +    .issue_fc_host_lip = virtscsi_issue_lip,
>> +};
>> +
>>   #define virtscsi_config_get(vdev, fld) \
>>       ({ \
>>           typeof(((struct virtio_scsi_config *)0)->fld) __val; \
>> @@ -1193,7 +1411,9 @@ static int virtscsi_probe(struct virtio_device
>> *vdev)
>>       vscsi->num_queues = num_queues;
>>       vdev->priv = shost;
>>       vscsi->next_target_id = -1;
>> +    vscsi->protocol = SCSI_PROTOCOL_SAS;
> 
> Why is the old/legacy/non-fcp hardcoded SAS?
> Doesn't the non-fcp virtio-scsi have any real transport at all, i.e.
> "none"?
> Maybe I just don't understand semantics of vscsi->protocol well enough.
> 

The original virtio-scsi code _claimed_ to the a SAS HBA (look for the
VPD page 83 emulation).
So to get the compatible output there we need to set the protocol to 'SAS'.
Using 'none' would just add another layer of complexity (as I would need
to differentiate between 'none' and 'real' SAS), which gives not benefit
ATM as there _is_ not real SAS implementation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
