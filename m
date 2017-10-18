From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Always retry internal target error
Date: Wed, 18 Oct 2017 08:15:46 +0200
Message-ID: <51f905cd-6907-438e-396f-a6efe610370f@suse.de>
References: <1508224263-130302-1-git-send-email-hare@suse.de>
 <yq18tg9upqf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48051 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755484AbdJRGPs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Oct 2017 02:15:48 -0400
In-Reply-To: <yq18tg9upqf.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 10/18/2017 04:58 AM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> +		if (!strncmp(scmd->device->vendor, "EMC", 3) &&
>> +		    !strncmp(scmd->device->model, "SYMMETRIX", 9) &&
>> +		    (sshdr.asc == 0x44) && (sshdr.ascq == 0x0)) {
>> +			/*
>> +			 * EMC Symmetrix returns 'Internal target failure'
>> +			 * for a variety of internal issues, all of which
>> +			 * can be recovered by retry.
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>> +		}
> 
> It's decidedly awful to have vendor/model-specific triggers in
> scsi_error.
> 
> What are the drawbacks of just always refiring on AC/0x44/ITF?
> 
Hmm. 'Internal target failure' is not very descriptive, so it could mean
anything. Hence the rather awkward approach.
But I just checked with the qemu code, and that returns 0x44/0x00 only
if some (internal) call returned with -ENOMEM.
So I guess we're safe to always retry here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
