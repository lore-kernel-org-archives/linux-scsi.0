From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with	blk_rq_map_kern_sgl()
Date: Thu, 16 Apr 2009 15:07:09 +0900
Message-ID: <49E6CB0D.3060307@kernel.org>
References: <49E6A0B5.2090704@kernel.org> <20090416054457.GA13226@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZDPGHX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2009 02:07:23 -0400
In-Reply-To: <20090416054457.GA13226@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Hello, Borislav.

Borislav Petkov wrote:
> Hi,
> 
> On Thu, Apr 16, 2009 at 12:06:29PM +0900, Tejun Heo wrote:
>> I updated the patch a bit and folded it into the series after patch
>> 10.  I hope I didn't butcher the patch too bad.  Can I add your
>> Signed-off-by: on the modified patch?  Also, I just started working on
>> the atapi version.  Do you already have something?
> 
> Ok here's what I got: I went and converted all ide-cd and ide-atapi to
> using a common routine ide_prep_sense, see following patches for that.
> Preliminary testing is promising but you never know :).

Cool.  I'll take a look.

> I put the request_sense buffer as defined in <linux/cdrom.h> into the
> drive struct so that each device can have its own buffer. IMHO, request
> sense standard data should be pretty identical across most ATAPI devices
> (yeah, I'm sure there are exceptions :)). We might move the struct
> request_sense to a more generic location instead of <linux/cdrom.h> if
> we decide to go with that.

Okay.

>>     * Both user and kernel PC requests expect sense data to be stored
>>       in separate storage other than info->sense_data.  Copy sense
>>       data to rq->sense on completion if rq->sense is not NULL.  This
>>       fixes bogus sense data on PC requests.
> 
> I took that into my version of the patch.
> 
> Anyway, please do have a closer look in case I've missed something. Of
> course you can split them the way you see fit, there's more to be done
> there anyways but should suffice for your block layer stuff, I hope.

There was another problem.  If we use blk_rq_map_kern() the failed rq
must be finished after the sense rq is finished because that's when
the bio is copied back if it was copied.  Before sense_rq completion,
the sense buffer doesn't contain any valid data.

Anyways, I'll review your patchset and integrate it with mine.  Please
standby a bit.

Thanks.

-- 
tejun
