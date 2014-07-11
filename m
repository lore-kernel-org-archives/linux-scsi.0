From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/10] sd: don't use scsi_setup_blk_pc_cmnd for write
	same requests
Date: Fri, 11 Jul 2014 17:15:15 +0200
Message-ID: <20140711151515.GA23254@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-6-git-send-email-hch@lst.de> <53BFD7A1.7040205@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60364 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaGKPPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 11:15:18 -0400
Content-Disposition: inline
In-Reply-To: <53BFD7A1.7040205@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>> -	rq->__data_len = sdp->sector_size;

>> +	rq->__data_len = sdp->sector_size;
>> +	ret = scsi_init_io(cmd, GFP_ATOMIC);
>> +	rq->__data_len = nr_bytes;
>>   	return ret;
>>   }
>>
> Hmm? __data_len is the amount of data written _on the target_.
> Do we actually care about it?
> And if so, why didn't it break with the original version?
> In either case a short description in the patch would be nice.

The drivers care about it, and scsi_init_io uses it as transfer size,
thus we have to set it to the tranfer length before the scsi_init_io
call, and to the full number of bytes to be written after it.

We already do this before the patch, I just moved the first assginment
next to the call to scsi_init_io so that it's more obvious.

