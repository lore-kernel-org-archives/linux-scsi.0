From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
 queue pointer to blk_rq_init()
Date: Mon, 22 May 2017 14:56:18 +0200
Message-ID: <95b0aba4-9463-eb8e-5c27-4a6951c3112a@suse.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
 <20170519183016.12646-7-bart.vanassche@sandisk.com>
 <20170521065003.GE12891@lst.de> <1495384897.3192.3.camel@sandisk.com>
 <1a2b631a-8b12-f167-b3b8-3a74bd179daa@suse.com>
 <20170522075443.GC2081@lst.de>
 <78097a2b-73c6-3206-803a-c108fe464c45@suse.com>
 <20170522124809.GB11869@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:58898 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756582AbdEVM4U (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 22 May 2017 08:56:20 -0400
In-Reply-To: <20170522124809.GB11869@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 05/22/2017 02:48 PM, hch@lst.de wrote:
> On Mon, May 22, 2017 at 10:46:10AM +0200, Hannes Reinecke wrote:
>>> That seems to be overkill to me for the few drivers.  And I suspect
>>> most of them would be better off now even using blk-mq private tags
>>> (which we'd have to implement for the legacy path first or just
>>> kill it off) but just not expose a tag per host to the scsi and block
>>> layers and set that aside.
>>>
>> IE not using blk-mq private tags for EH? Hmm.
>> But then we'd need a SCSI-internal mechanism to get one of them. I
>> really would want to avoid having each driver to implement it's own
>> mechanism on how to get a TMF tag; that sort of thing only leads to
>> copy-and-paste errors.
>> Ok; will be looking into it.
> 
> No, we don't.  The driver simply sets a tag aside and doesn't expose
> it to the block layer.  Similar to what smartpqi already does for LUN
> resets and AENs, mpt3sas does for the ioctl tags and NVMe does for AERs.
> Personally I feel a bit uncomfortable by setting aside just one tag for
TMFs; this assumes we'll never be sending LUN resets to devices in parallel.

But maybe this is a discussion for another time, if and when we finally
move to that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
