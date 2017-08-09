From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] mylex: Replace DAC960 block driver
Date: Wed, 9 Aug 2017 17:09:41 +0200
Message-ID: <39e5035d-fd5b-f5b6-23fb-150b1c8d5252@suse.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de>
 <20170809142308.GA28945@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43113 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751560AbdHIPJp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 11:09:45 -0400
In-Reply-To: <20170809142308.GA28945@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 08/09/2017 04:23 PM, Christoph Hellwig wrote:
> On Wed, Aug 02, 2017 at 04:13:24PM +0200, Hannes Reinecke wrote:
>> Hi all,
>>
>> as we're trying to get rid of the remaining request_fn drivers here's
>> a patchset to move the DAC960 driver to the SCSI stack.
>> The new driver is called 'mylex'.
>>
>> The Mylex/DAC960 HBA comes in two flavours; the later one (V2) already
>> has a pretty complete SCSI emulation layer, so we just have to reformat
>> the command.
>> For for earlier ones (V1) we don't have a SCSI emulation layer for the
>> logical drives, so I've added a (pretty rudimentary, admittedly) SCSI
>> translation for them.
>> And the weird proc interface has been converted to sysfs attributes.
> 
> It seems like V1 and V2 basically don't share any code at all, so it seems
> like they should be separate drivers.  And for V1 it seems like it might
> even be better off as a blk-mq driver - which could then reuse the DAC960
> name and device nodes?
> 
> For the V2 firmware your approach looks great, though.
> 
Guess what, I've started doing the separation already :-)
For V1 I'm indeed unsure; thing is, it _does_ have a SCSI passthrough
for the physical devices, so that definitely simplifies things.
And for the logical drives; doing a SCSI emulation is not hard to do
(especially so if one sticks with SCSI-3 :-), so I'd rather move it to
become a SCSI driver.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
