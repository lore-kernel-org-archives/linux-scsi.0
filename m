From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Tue, 17 Aug 2010 18:41:47 +0200
Message-ID: <4C6ABBCB.9030306@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0HQQpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2010 12:45:22 -0400
In-Reply-To: <20100817131915.GB2963@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

Hi,

On 08/17/2010 03:19 PM, Christoph Hellwig wrote:
> On Tue, Aug 17, 2010 at 11:59:38AM +0200, Tejun Heo wrote:
>> I'm not against restructuring the patchset if it makes more sense but
>> it just feels like it would be a bit pointless effort (and one which
>> would require much tighter coordination among different trees) at this
>> point.  Am I missing something?
> 
> What other trees do you mean?

I was mostly thinking about dm/md, drdb and stuff, but you're talking
about filesystem conversion patches being routed through block tree,
right?

> The conversions of the 8 filesystems that actually support barriers
> need to go through this tree anyway if we want to be able to test
> it.  Also the changes in the filesystem are absolutely minimal -
> it's basically just s/WRITE_BARRIER/WRITE_FUA_FLUSH/ after my
> initial patch kill BH_Orderd, and removing about 10 lines of code in
> reiserfs.

I might just resequence it to finish this part of discussion but what
does that really buy us?  It's not really gonna help bisection.
Bisection won't be able to tell anything in higher resolution than
"the new implementation doesn't work".  If you show me how it would
actually help, I'll happily reshuffle the patches.

>> I wasn't sure about that part.  You removed store_flush_error(), but
>> DM_ENDIO_REQUEUE should still have higher priority than other
>> failures, no?
> 
> Which priority?

IIUC, when any of flushes get DM_ENDIO_REQUEUE (which tells the dm
core layer to retry the whole bio later), it trumps all other failures
and the bio is retried later.  That was why DM_ENDIO_REQUEUE was
prioritized over other error codes, which actually is sort of
incorrect in that once a FLUSH fails, it _MUST_ be reported to upper
layers as FLUSH failure implies data already lost.  So,
DM_ENDIO_REQUEUE actually should have lower priority than other
failures.  But, then again, the error codes still need to be
prioritized.

>> But how do you make sure REQ_FLUSHes for preflush finish before
>> starting the write?
> 
> Hmm, okay.  I see how the special flush_bio makes the waiting easier,
> let's see if Mike or other in the DM team have a better idea.

Yeah, it would be better if it can be sequenced w/o using a work but
let's leave it for later.

Thanks.

-- 
tejun
