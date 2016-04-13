From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf] LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 09:57:19 -0700
Message-ID: <570E7A6F.5040206@sandisk.com>
References: <57067F19.3030404@sandisk.com>
 <1460044289.2311.5.camel@linux.vnet.ibm.com> <570E6C55.1060003@sandisk.com>
 <yq11t69wkcl.fsf@sermon.lab.mkp.net> <570E73D5.3010502@sandisk.com>
 <yq1twj5v4qs.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:7680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751746AbcDMQ5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2016 12:57:25 -0400
In-Reply-To: <yq1twj5v4qs.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@fb.com>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>

On 04/13/2016 09:43 AM, Martin K. Petersen wrote:
>>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:
>
> Bart> Today if a BLKDISCARD ioctl passes a non-aligned start and/or end
> Bart> sector to the kernel then the block layer will submit invalid
> Bart> (non-aligned) REQ_DISCARD requests to the block driver the ioctl
> Bart> applies to.
>
> I do not know what you mean by "invalid".
>
> A device that implements UNMAP can freely ignore any parts of a request
> block range that are not aligned to its internal allocation units.
>
>  From SBC: "An unmap request with a number of logical blocks that is not
> a multiple of this value (OPTIMAL UNMAP GRANULARITY) may result in unmap
> operations on fewer LBAs than requested." and "An unmap request with a
> starting LBA that is not optimal may result in unmap operations on fewer
> LBAs than requested."
>
> The same is true for SATA which has no way report granularity and
> alignment at all.
>
> Nowhere does it say that a request that is not an aligned multiple of
> any reported granularity should be considered "invalid" or rejected by
> the storage.

Hello Martin,

Sorry if I wasn't clear enough. Regarding the SCSI UNMAP command, 
consider e.g. the following code from drivers/scsi/sd.c:

static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
{
	[ ... ]
	sector >>= ilog2(sdp->sector_size) - 9;
	nr_sectors >>= ilog2(sdp->sector_size) - 9;
	[ ... ]
	case SD_LBP_UNMAP:
		[ ... ]
		cmd->cmd_len = 10;
		cmd->cmnd[0] = UNMAP;
		cmd->cmnd[8] = 24;
		put_unaligned_be16(6 + 16, &buf[0]);
		put_unaligned_be16(16, &buf[2]);
		put_unaligned_be64(sector, &buf[8]);
		put_unaligned_be32(nr_sectors, &buf[16]);
		[ ... ]
}

For sdp->sector_size > 512, should we allow the block layer to pass 
sector and nr_sector values to this function that are not a multiple of 
sdp->sector_size? And if so, how should this code behave and if sector 
and/or nr_sectors is not a multiple of sdp->sector_size? As one can see 
the above code rounds down sector and nr_sectors while converting from 
sectors to logical blocks. This means that if a non-aligned BLKDISCARD 
is submitted from user space that one or more sectors *before* the start 
of the range specified in the ioctl will be discarded. Isn't that a bug?

Bart.


