From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/8] SCSI: implement sd_unlock_native_capacity()
Date: Mon, 17 May 2010 07:30:57 +0200
Message-ID: <4BF0D491.7090802@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>	 <1273946974-29131-7-git-send-email-tj@kernel.org>	 <1274017175.14187.9.camel@mulgrave.site>	 <1274022457.2564.105.camel@localhost>	 <1274025636.14187.24.camel@mulgrave.site>  <4BF024A2.4090804@kernel.org> <1274037797.14187.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1274037797.14187.50.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On 05/16/2010 09:23 PM, James Bottomley wrote:
>> request_queue is (or at least supposed to be) oblivious about genhd
>> and its attributes including capacity.  After all, request_queue can
>> exist w/o genhd associated, so it would be quite odd to have capacity
>> related method living in request_queue.
> 
> Yes, I'll sort of buy this ... although it's not quite that clean:
> barrier methods, which are only used for filesystem above block devices
> also live in the queue.

You mean prepare_flush_fn()?  Hmmm...

>> Another thing is that there is no generic way to reach the associated
>> genhd from request_queue and I can't think of a clean way to map
>> request_queue to the associated ata device w/o in-flight requests (can
>> you even do that from SCSI?).
> 
> No ... that's by design ... but you don't need it if all you're doing is
> unlocking the native capacity (whether on behalf of block dev ops or
> queue ops).

libata defers all those managements stuff to EH and the ata device
needs to be accessible to invoke EH.  It can be worked around by
issuing a pseudo command which is trapped and deferred to EH during
command processing but it's much better to be able to access the
device directly.

>> Unfortunately, libata is still properly layered below SCSI, so I'm
>> afraid threading through sd is clumsy yet the cleanest way to do it.
> 
> s/properly/im\&/

Heh, yeah.  :-)

> but yes,
> 
> Reluctantly-Acked-by: James Bottomley <James.Bottomley@suse.de>

Thanks.  Much appreciated.

-- 
tejun
