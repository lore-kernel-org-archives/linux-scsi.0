From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 09/11] block: Expose queue nr_zones in
	sysfs
Date: Fri, 12 Oct 2018 10:28:37 +0200
Message-ID: <20181012082837.GC30248@lst.de>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-10-damien.lemoal@wdc.com>
	<c13f3820-9a69-6a74-e967-b561d7778bcf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c13f3820-9a69-6a74-e967-b561d7778bcf@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 12, 2018 at 09:41:28AM +0200, Hannes Reinecke wrote:
>> +{
>> +	return 0;
>> +}
>>   #endif /* CONFIG_BLK_DEV_ZONED */
>>     static inline bool rq_is_sync(struct request *rq)
>>
> Actually, we should be checking whether we can't blank out this attribute 
> via the is_visible mechanism; after all, not every block device is zoned, 
> and those which are not have no need of the attribute...

The answer would be 0 in this case.  I'm not sure blanking out is worth
it as it will create a lot more code for very little gain..
