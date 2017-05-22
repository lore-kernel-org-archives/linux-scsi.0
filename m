From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
 queue pointer to blk_rq_init()
Date: Mon, 22 May 2017 08:06:46 +0200
Message-ID: <1a2b631a-8b12-f167-b3b8-3a74bd179daa@suse.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
 <20170519183016.12646-7-bart.vanassche@sandisk.com>
 <20170521065003.GE12891@lst.de> <1495384897.3192.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:49454 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdEVGGt (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 22 May 2017 02:06:49 -0400
In-Reply-To: <1495384897.3192.3.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 05/21/2017 06:41 PM, Bart Van Assche wrote:
> On Sun, 2017-05-21 at 08:50 +0200, Christoph Hellwig wrote:
>> Although we really need to stop abusing requests/cmds for EH..
>> (Hannes, time to dust off your old patches!)
> 
> Hello Christoph and Hannes,
> 
> How about passing a struct scsi_device pointer to the eh_*_reset_handler
> callbacks instead of a struct scsi_cmnd pointer? Most SCSI LLD
> eh_*_reset_handler implementations don't do anything with the information
> passed through the struct scsi_cmnd pointer except reading the SCSI device
> pointer and logging the SCSI command CDB. Hannes, is this the same as your
> proposal? Do you want to work on this or do you perhaps expect me to prepare
> patches to implement that change?
> 
If it were so easy.

Problem is that quite some LLDDs require a hardware tag for sending
TMFs, and currently the re-use the tag from the passed in scmd for that.
So first we need to move those to a sane interface, and having them
requesting a new tag for TMFs.
Should be made easier with Christophs rework, but we still don't have
any defined way how TMFs should request their tag; should they use
private tags? Should they use 'normal' tags? Should the driver implement
their own tag pool, seeing that these commands will never ever making
use of the associated request?

Hence I'm looking into implementing a REQ_RESET block request operation,
which then could be used to facilitate all of this (the request would be
allocated from the private tag pool if present).
It would also neatly solve the scsi_ioctl_reset() problem, as we then
could just issue a REQ_RESET and would avoid having to call into the
eh_* function directly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
