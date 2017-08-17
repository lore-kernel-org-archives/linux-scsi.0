From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a
 request"
Date: Thu, 17 Aug 2017 09:45:44 +0900
Message-ID: <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
 <yq1fucrqchu.fsf@oracle.com> <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@linux.vnet.ibm.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin,

On 8/17/17 09:41, Damien Le Moal wrote:
> Martin,
> 
> On 8/17/17 09:11, Martin K. Petersen wrote:
>>
>> Bart,
>>
>>> For an unknown reason this patch causes the boot process to hang on
>>> PowerPC systems:
>>
>> OK, dropped it from fixes for now.
>>
>> Thanks!
> 
> It means that commit 70e42fd02c46e2aa9ab07b766d418637e3a51de7 "scsi:
> sd_zbc: Write unlock zone from sd_uninit_cmnd()" will need to be
> reverted too as it will not solve the potential deadlock anymore. Bart's
> patch was needed for it to work.
> 
> So we are back to the initial patch I sent that Chirstoph nacked, that
> is, not write locking zones with scsi-mq to avoid deadlocking (blk-mq
> does not dispatch write requests in order anyway, so SMR does not work
> with mq for now).
> 
> Other solutions would be:
> 1) Do not change the zone locking and add a big fat warning for scanned
> zoned block devices that things can get nasty
> 2) Fail initialization of zoned block devices with scsi-mq (do not
> create the block devices)
> 
> (2) may actually be the better solution for now until I get a fix for
> blk-mq.
> 
> Thoughts ?
> 
> Best regards.

Actually, we can keep that commit as it makes the sq case cleaner
anyway. But we need something else to prevent deadlock in the mq case...

-- 
Damien Le Moal,
Western Digital
