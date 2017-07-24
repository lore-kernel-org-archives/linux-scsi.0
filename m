From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/47] zfcp: open-code fc_block_scsi_eh() for host reset
Date: Mon, 24 Jul 2017 20:01:17 +0200
Message-ID: <39a4c69e-ea54-e970-a658-877c9a06f7d4@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-10-git-send-email-hare@suse.de>
 <a7950ea7-380c-bb01-7f31-5c555217ad2d@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753914AbdGXSBU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 14:01:20 -0400
In-Reply-To: <a7950ea7-380c-bb01-7f31-5c555217ad2d@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/24/2017 06:18 PM, Steffen Maier wrote:
> Hi Hannes,
> 
> unfortunately I only realized now by accident that there's stuff to
> review. Would be nice to send it also explicitly to driver maintainers
> in addition to the list.
> 
Well, the entire patchset got send as an RFC anyway, and as such I
didn't include all the individual driver maintainers.
But will be doing so for the actual patchset.

> Since you've asked for this multiple times, I happened to just now code
> a patch series of 6 patches in order to decouple zfcp from scsi_cmnd for
> device, target, and host reset.
> 
Oh, cool. That's precisely what I need.

> While I provide some review comments below, I think it might be clearer
> and easier to review if you would rebase your series on top of my
> decoupling.
> 
Sure. Get me the patches and I'll be doing it :-)

> Let me know how urgent you'd like to see my code. I planned to send it
> as RFC soon anyway. However, it hasn't seen any function testing yet. If
> you don't care, let me know and I can send it.
> 
At this stage I don't really care; the idea is to get the preliminary
patches in (preferably before the next merge window), so that the actual
patch to modify SCSI EH syntax doesn't have to modify the drivers
themselves, only the calling sequence.

> On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
>> When issuing a host reset we should be waiting for all
>> ports to become unblocked; just waiting for one might
>> be resulting in host reset to return too early.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/s390/scsi/zfcp_scsi.c | 27 +++++++++++++++++++++++----
>>   1 file changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c
>> b/drivers/s390/scsi/zfcp_scsi.c
>> index 0678cf7..3d18659 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -311,13 +311,32 @@ static int
>> zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>>
>>   static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>   {
>> -    struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>> -    struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
>> -    int ret;
>> +    struct Scsi_Host *host = scpnt->device->host;
>> +    struct zfcp_adapter *adapter = (struct zfcp_adapter
>> *)host->hostdata[0];
>> +    int ret = 0;
>> +    unsigned long flags;
>> +    struct zfcp_port *port;
>>
>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>       zfcp_erp_wait(adapter);
>> -    ret = fc_block_scsi_eh(scpnt);
>> +retry_rport_blocked:
>> +    spin_lock_irqsave(host->host_lock, flags);
> 
> missing read_lock(&adapter->port_list_lock);
> 
> Hm, well, I have to think about lock ordering, because my patch has the
> port_list as outer loop and inside it calls fc_block_scsi_eh (also
> modified with fc_rport as argument).
> If there's any other location taking both locks we better get them in
> the same order.
> 
In general I'm not terribly happy with this; after all, there is no
guarantee that the rport list after host reset is identical to the list
prior to it; in extremis we could even end up with no rports whatsoever.
In which case we wouldn't have anything to synchronize upon, leaving
host reset in a somewhat dubious state.
I'd be far happier if we could have a synchronisation point independent
on the rport states; then this problem wouldn't occur.
(And rports would be handled separately via the dev_loss_tmo mechanism
anyway, so it wouldn't matter if the rports are still recovering after
host reset returned.)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
