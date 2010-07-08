From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error
  path
Date: Thu, 08 Jul 2010 14:10:46 +0200
Message-ID: <4C35C046.6000701@fusionio.com>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp> <20100705134529.GA18645@redhat.com> <20100706135958.GA10772@redhat.com> <20100708131726C.fujita.tomonori@lab.ntt.co.jp> <20100708120602.GA28083@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46199 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab0GHMKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 08:10:50 -0400
In-Reply-To: <20100708120602.GA28083@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On 2010-07-08 14:06, Mike Snitzer wrote:
> On Thu, Jul 08 2010 at 12:17am -0400,
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> On Tue, 6 Jul 2010 09:59:58 -0400
>> Mike Snitzer <snitzer@redhat.com> wrote:
>>
>>> Here is a minimalist patch that 1) removes the discard request's page
>>> leak 2) preserves the prep cleanup rules covered above.  Fixing the leak
>>> is a priority, introducing additional error path code sharing/cleanup is
>>> secondary and can come later.
>>
>> This patch doesn't work. I hit kernel oops since now this patch frees
>> a discard page twice.
> 
> I load tested my v2 patch quite a bit but didn't hit the oops.  Guess
> you're just lucky ;)
> 
>> If scsi_init_io hits BLKPREP_DEFER (e.g. due to scsi_init_sgtable),
>> scsi_setup_blk_pc_cmnd calls scsi_unprep_request. So sd_unprep_fn
>> frees a page. Then, scsi_setup_discard_cmnd frees the same page again.
> 
> OK, thanks for catching this.
> 
>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Subject: [PATCH] scsi: fix discard page leak
>>
>> We leak a page allocated for discard on some error conditions
>> (e.g. scsi_prep_state_check returns BLKPREP_DEFER in
>> scsi_setup_blk_pc_cmnd).
>>
>> We unprep on requests that weren't prepped in the error path of
>> scsi_init_io. It makes the error path to clean up scsi commands messy.
>>
>> Let's strictly apply the rule that we can't unprep on a request that
>> wasn't prepped.
>>
>> Calling just scsi_put_command() in the error path of scsi_init_io() is
>> enough. We don't set REQ_DONTPREP yet.
>>
>> scsi_setup_discard_cmnd can safely free a page on the error case with
>> the above rule.
>>
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> Jens, it'd be great if we could get this fix in now.

I picked up Tomo's patch this morning.


-- 
Jens Axboe

