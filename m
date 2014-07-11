From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
	requests
Date: Fri, 11 Jul 2014 17:15:57 +0200
Message-ID: <20140711151557.GB23254@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-7-git-send-email-hch@lst.de> <53BFD7F0.5080703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60371 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaGKPP7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 11:15:59 -0400
Content-Disposition: inline
In-Reply-To: <53BFD7F0.5080703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, Jul 11, 2014 at 02:26:24PM +0200, Hannes Reinecke wrote:
>>   	blk_add_request_payload(rq, page, len);
>> -	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
>> +
>> +	cmd->transfersize = len;
>> +	cmd->allowed = rq->retries;
>> +
>> +	ret = scsi_init_io(cmd, GFP_ATOMIC);
>>   	rq->__data_len = nr_bytes;
>>
>>   out:
> Ah. Here it's done properly.

blk_add_request_payload also sets up rq->__data_len..

