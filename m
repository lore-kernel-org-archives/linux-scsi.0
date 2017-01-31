From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] mpt3sas: lockless command submission for scsi-mq
Date: Tue, 31 Jan 2017 14:46:19 +0100
Message-ID: <8b403430-3fe8-2008-2748-4a3095648746@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <1485854760-122683-9-git-send-email-hare@suse.de>
 <20170131132206.GA5686@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbdAaNqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 08:46:48 -0500
In-Reply-To: <20170131132206.GA5686@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

On 01/31/2017 02:22 PM, Christoph Hellwig wrote:
> On Tue, Jan 31, 2017 at 10:25:58AM +0100, Hannes Reinecke wrote:
>> Enable lockless command submission for scsi-mq by moving the
>> command structure into the payload for struct request.
> 
> We support cmd_size for both the mq and !mq code path, so this
> could be simplified by always taking your new block-mq path.
> 
Yes, they are with your latest patchset.
But that sort of overlapped with my patches and is hasn't been merged
yet. So I haven't integrated that.

So what is the status?
Should I rebase my patch on top of those patches?

>>  4 files changed, 427 insertions(+), 57 deletions(-)
> 
> The amount of new code scare me.  Especially compared to the very
> short changelog.
> 
Well, these are mainly duplicated code paths as I left the original code
in place.
Simply because the infrastructure is very much in flux and converting it
all in one go might be giving negative results :-)

>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 942fb7e..29e139f 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -867,6 +867,20 @@ struct scsiio_tracker *
>>  {
>>  	WARN_ON(!smid);
>>  	WARN_ON(smid >= ioc->hi_priority_smid);
>> +	if (shost_use_blk_mq(ioc->shost)) {
>> +		u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
>> +		u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
>> +		struct blk_mq_tag_set *tagset = &ioc->shost->tag_set;
>> +		struct request *req;
>> +
>> +		req = blk_mq_tag_to_rq(tagset->tags[hwq], tag);
>> +		if (req) {
>> +			struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>> +
>> +			return scsi_cmd_priv(cmd);
>> +		} else
>> +			return NULL;
>> +	}
> 
> This looks like it basically duplicates scsi_host_find_tag().
> 
Yes, but scsi_host_find_tag() still relies on req->special, which it
really shouldn't after your patches; scsi_cmd_priv() should be used there.
I got a patch series to remove the last vestigies from using ->special
in the SCSI midlayer; probably time to post it.

>> +	if (shost_use_blk_mq(ioc->shost)) {
>> +		unsigned int unique_tag = blk_mq_unique_tag(scmd->request);
>> +		u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
>> +		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
>> +		u16 smid = (tag * ioc->shost->nr_hw_queues) + hwq + 1;
>> +
>> +		request = scsi_cmd_priv(scmd);
>> +		request->scmd = scmd;
> 
> no need for a backpointer, blk_mq_rq_from_pdu gets your
> back to the request, and scsi_cmd_priv back to driver private data.
> 
I know. Compability with original code only.

>> +		request->cb_idx = cb_idx;
>> +		request->msix_io = hwq;
>> +		request->smid = smid;
> 
> why do we need to store the smid?
> 
Sanity checking.
Far too many instances where I got the tag <-> smid mapping wrong during
development.
But yeah, if we move the entire driver over and rip out the original
code path this can go.

>> @@ -562,12 +642,7 @@ enum block_state {
>>  _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
> 
> I think this function just needs to go away instantly.
> Trying to send task management requests from userspace for any
> active smid is plain dangerous.
> 
Hey, I didn't to it. I just did the conversion.

But indeed, it's of questionable value.

I can remove it with the next iteration.

So, I'm happy to rebase it on top of your BLOCK_PC changes. Just tell me
which tree to use.
Then indeed most of the duplicate code-paths could go away.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
