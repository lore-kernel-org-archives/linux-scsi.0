From: Jeff Garzik <jeff@garzik.org>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 15:20:04 -0400
Message-ID: <49FDEE64.5090302@garzik.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>	 <20090503071619.GP8822@parisc-linux.org>	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org> <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2009-05-03 at 14:40 -0400, Jeff Garzik wrote:
>> Jeff Garzik wrote:
>>> (2) determine at init if queue (a) supports explicit DISCARD and/or (b) 
>>> supports DISCARD flag passed with READ or WRITE
>>
>> As an aside -- does any existing command set support case #b, above?
> 
> Not to my knowledge.
> 
> I think discard was modelled on barrier (which can be associated with
> data or stand on its own).

Yeah -- I am thinking we can reduce complexity if no real hardware 
supports "associated with data."


>> AFAICT, ATA, SCSI and NVMHCI all have a single, explicit hardware 
>> command to discard/deallocate unused sectors.
>>
>> Therefore, creating REQ_TYPE_DISCARD seems to eliminate any need for new 
>> hook ->prepare_discard().
> 
> Well, yes and no ... in the SCSI implementation of either UNMAP or WRITE
> SAME, we still need a data buffer to store either the extents or the
> actual same data.

Sure, UNMAP's extents would quite naturally travel with the 
REQ_TYPE_DISCARD struct request, and can be set up at struct request 
allocation time.  In all of ATA, SCSI and NVMHCI, they appear to want 
the extents.

Is WRITE SAME associated with this current DISCARD work, or is that just 
a similar example?  I'm unfamiliar with its issues...


>> This provides a 1:1 correspondence between hardware and struct request, 
>> most closely matching the setup of known hardware.
> 
> Agreed ... but we still have to allocate the adjunct buffer
> somewhere ....

Agreed.  I merely argue ->prep_rq_fn() would be a better place -- it can 
at least return a useful return value -- than ->prepare_discard(), which 
would be the natural disposition for a REQ_TYPE_DISCARD -- or 
->request_fn() itself, if a block driver so chooses.

The extents would be an argument to REQ_TYPE_DISCARD, and should be 
associated with struct request somehow, by struct request's creator. 
The extent info needs to be in some generic form, because all of 
ATA|SCSI|NVMHCI seem to want it.


[tangent...]

Does make you wonder if a ->init_rq_fn() would be helpful, one that 
could perform gfp_t allocations rather than GFP_ATOMIC?  The idea being 
to call ->init_rq_fn() almost immediately after creation of struct 
request, by the struct request creator.

I obviously have not thought in depth about this, but it does seem that 
init_rq_fn(), called earlier in struct request lifetime, could eliminate 
the need for ->prepare_flush, ->prepare_discard, and perhaps could be a 
better place for some of the ->prep_rq_fn logic.

The creator of struct request generally has more freedom to sleep, and 
it seems logical to give low-level drivers a "fill in LLD-specific info" 
hook BEFORE the request is ever added to a request_queue.

Who knows...

	Jeff




