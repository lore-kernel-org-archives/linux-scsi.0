From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Thu, 3 Nov 2016 14:07:11 +0100
Message-ID: <4f0d87c9-3fc2-9d7b-770c-df5d11a9593e@suse.de>
References: <1478036978-30583-1-git-send-email-hare@suse.de>
 <1478036978-30583-2-git-send-email-hare@suse.de>
 <20161102150655.GA14320@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756642AbcKCNHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Nov 2016 09:07:19 -0400
In-Reply-To: <20161102150655.GA14320@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 11/02/2016 04:06 PM, Christoph Hellwig wrote:
> On Tue, Nov 01, 2016 at 10:49:36PM +0100, Hannes Reinecke wrote:
>> Switch to scsi_execute_req_flags() instead of
>> using the block interface directly. This will set
>> REQ_QUIET and REQ_PREEMPT, but this is okay as
>> we're evaluating the errors anyway and should be
>> able to send the command even if the device is
>> quiesced.
>
> Actually most users are switched to scsi_get_vpd_page if I read the patch
> right, which is even better.  And it seems like the remaining user of
> scsi_execute_req_flags could be switch to use scsi_mode_select() as well,
> but maybe we should leave that out for now.
>
I'd rather not do that now, as switching to scsi_mode_select() would 
cause the failfast flags to be lost, and I'll have to think about the 
implications of doing so.

>> +	if (scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
>> +				   &h->ctlr->mode_select, data_size, &sshdr,
>> +				   RDAC_TIMEOUT * HZ,
>> +				   RDAC_RETRIES, NULL, REQ_FAILFAST_MASK)) {
>
> Pleae use the individual failfast flags - REQ_FAILFAST_MASK is just
> for block layer use.
>
Okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
