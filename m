From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 12/23] sd: handle REQ_UNMAP
Date: Wed, 29 Mar 2017 16:57:39 +0200
Message-ID: <dab09af5-521a-99da-9852-2d18cc28ca4f@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-13-hch@lst.de>
	<1490719722.2573.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1490719722.2573.8.camel@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Alasdair G Kergon <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, Jens Axboe <axboe@fb.com>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm <dm-devel@redhat.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
List-Id: linux-scsi@vger.kernel.org



On 28/03/2017 18:48, Bart Van Assche wrote:
>> +	if (rq->cmd_flags & REQ_UNMAP) {
>> +		switch (sdkp->provisioning_mode) {
>> +		case SD_LBP_WS16:
>> +			return sd_setup_write_same16_cmnd(cmd, true);
>> +		case SD_LBP_WS10:
>> +			return sd_setup_write_same10_cmnd(cmd, true);
>> +		}
>> +	}
>> +
>>  	if (sdp->no_write_same)
>>  		return BLKPREP_INVALID;
>>  	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
> Users can change the provisioning mode from user space from SD_LBP_WS16 into
> SD_LBP_WS10 so I'm not sure it's safe to skip the (sdkp->ws16 || sector >
> 0xffffffff || nr_sectors > 0xffff) check if REQ_UNMAP is set.

Yeah, if REQ_UNMAP is set you should probably check sdkp->provisioning_mode
instead of sdkp->ws16, but apart from this it should still go through the
checks below.

Plus, if the provisioning mode is not ws10 or ws16, should
sd_setup_write_zeroes_cmnd:

1) do a WRITE SAME without UNMAP (what Christoph's code does)

2) return BLKPREP_INVALID

3) ignore provisioning mode and do a WRITE SAME with UNMAP

4) do a WRITE SAME without UNMAP for SD_LBP_{ZERO,FULL,DISABLE},
do a WRITE SAME with UNMAP for SD_LBP_{WS10,WS16,UNMAP}.

I'm in favor of (4).  The distinction between SD_LBP_UNMAP, SD_LBP_WS10
and SD_LBP_WS16 is as problematic as discard_zeroes_data in my opinion.

Thanks,

Paolo
