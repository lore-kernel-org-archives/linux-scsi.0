From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 31 Jan 2017 12:16:52 +0100
Message-ID: <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36193 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbdAaLRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 06:17:13 -0500
In-Reply-To: <20170131100243.GA1811@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On 01/31/2017 11:02 AM, Christoph Hellwig wrote:
> On Tue, Jan 31, 2017 at 10:25:50AM +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> this is a patchset to enable full multiqueue support for the mpt3sas driver.
>> While the HBA only has a single mailbox register for submitting commands,
>> it does have individual receive queues per MSI-X interrupt and as such
>> does benefit from converting it to full multiqueue support.
> 
> Explanation and numbers on why this would be beneficial, please.
> We should not need multiple submissions queues for a single register
> to benefit from multiple completion queues.
> 
Well, the actual throughput very strongly depends on the blk-mq-sched
patches from Jens.
As this is barely finished I didn't post any numbers yet.

However:
With multiqueue support:
4k seq read : io=60573MB, bw=1009.2MB/s, iops=258353, runt= 60021msec
With scsi-mq on 1 queue:
4k seq read : io=17369MB, bw=296291KB/s, iops=74072, runt= 60028msec
So yes, there _is_ a benefit.

(Which is actually quite cool, as these tests were done on a SAS3 HBA,
so we're getting close to the theoretical maximum of 1.2GB/s).
(Unlike the single-queue case :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
