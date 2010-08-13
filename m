From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/11] fs, block: propagate REQ_FLUSH/FUA interface to
 upper layers
Date: Fri, 13 Aug 2010 09:19:57 +0200
Message-ID: <4C64F21D.7010409@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-11-git-send-email-tj@kernel.org> <20100812212404.GB3665@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100812212404.GB3665@quack.suse.cz>
Sender: linux-ide-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hello, Jan.

On 08/12/2010 11:24 PM, Jan Kara wrote:
> On Thu 12-08-10 14:41:30, Tejun Heo wrote:
>> Propagate deprecation of REQ_HARDBARRIER and new REQ_FLUSH/FUA
>> interface to upper layers.
>>
>> * WRITE_BARRIER is marked deprecated and WRITE_FLUSH, WRITE_FUA and
>>   WRITE_FLUSH_FUA are added.
>>
>> * REQ_COMMON_MASK now includes REQ_FLUSH | REQ_FUA so that they are
>>   copied from bio to request.
>>
>> * BH_Ordered is marked deprecated and BH_Flush and BH_FUA are added.
>
>   Deprecating BH_Ordered is fine but I wouldn't introduce new BH flags for
> this. BH flags should be used for buffer state, not for encoding how the
> buffer should be written (there were actually bugs in the past because of
> this). Being able to set proper flags when calling submit_bh() in the rw
> parameter is enough.

Ah, okay, I was just trying to match the BH_Ordered usage but you're
saying just requiring submit_bh() users to specify appropriate REQ_*
(or WRITE_*) in @rw is okay, right?  I'll drop the bh part then.

Thanks.

-- 
tejun
