From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Wed, 13 May 2009 18:01:53 +0300
Message-ID: <4A0AE0E1.1080804@panasas.com>
References: <4A0307F4.50205@panasas.com>	<20090512112539.GH4140@kernel.dk>	<4A0AD8FA.6030903@panasas.com> <20090514005231.506907f0.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:11082 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756120AbZEMPC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2009 11:02:29 -0400
In-Reply-To: <20090514005231.506907f0.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 05/13/2009 05:52 PM, Stephen Rothwell wrote:
> Hi Boaz,
> 
> On Wed, 13 May 2009 17:28:10 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have done the rebase and ran some tests, however I was unable to test these patches
>> as is, because there are some inter tree fallouts.
>>
>> Jens, James, Stephan, I please need your help
>>
>> The situation is like that.
>> - Both block/for-next and scsi/master are based on an old osd upstream-point (v2.6.30-rc3--ce8a7424)
>> - Linus tip has important OSD patches that went in via scsi-rc-fixes which changed Wire format
>> - If I try and merge block/for-next ontop of plain linus/master I get a merge conflict
>> - If I try merge scsi/master block/for-next I get build errors / conflicts
>>
>> So there is no sane tree point that I can test on.
> 
> We could ask Jens and James to both merge either Linus' tree or just the
> scsi-rc-fixes tree into their trees.  Currently when I merge the scsi
> tree I get only one very minor conflict.  The block tree, on the other
> hand, had quite big problems today - but that was due to interactions
> with the scsi tree.
> 
> If the above merges were done, then I suspect that the scsi tree with
> commit 1bfe9caaff367601134c14fc428017419f628f7d ("[SCSI] FC Pass Thru
> support") reverted would merge ok with the block tree and give you a base
> for testing.
> 

That sounds good, I'll wait a couple of days and see what they decide to do.

Mean while I've collected all relevant patches from Linus and cherry-picked them
above block, and below my patches. And am testing this way. That should give me
99% coverage as scsi-misc does not have anything interacting with me, only
Linus and block do.

Once I figure it out I will push a osd/linux-next also

Thanks
Boaz
