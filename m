From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Thu, 05 Aug 2010 11:16:37 +0900
Message-ID: <4C5A1F05.40308@ce.jp.nec.com>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <20100803185148.GA12258@lst.de> <4C58F341.9060605@ct.jp.nec.com> <20100804085423.GA15687@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34060 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532Ab0HECXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 22:23:55 -0400
In-Reply-To: <20100804085423.GA15687@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org

Hi Christoph,

(08/04/10 17:54), Christoph Hellwig wrote:
> On Wed, Aug 04, 2010 at 01:57:37PM +0900, Kiyoshi Ueda wrote:
>>> -		if (unlikely(dm_rq_is_flush_request(rq))) {
>>> +		if (rq->cmd_flags & REQ_FLUSH) {
>>>  			BUG_ON(md->flush_request);
>>>  			md->flush_request = rq;
>>>  			blk_start_request(rq);
>>
>> Current request-based device-mapper's flush code depends on
>> the block-layer's barrier behavior which dispatches only one request
>> at a time when flush is needed.
>> In other words, current request-based device-mapper can't handle
>> other requests while a flush request is in progress.
>>
>> I'll take a look how I can fix the request-based device-mapper to
>> cope with it.  I think it'll take time for carefull investigation.
> 
> Given that request based device mapper doesn't even look at the
> block numbers from what I can see just removing any special casing
> for REQ_FLUSH should probably do it.

Special casing is necessary because device-mapper may have to
send multiple copies of REQ_FLUSH request to multiple
targets, while normal request is just sent to single target.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
