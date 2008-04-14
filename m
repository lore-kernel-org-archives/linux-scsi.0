From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] add large command support to the block layer
Date: Mon, 14 Apr 2008 14:38:46 +0300
Message-ID: <48034246.7040702@panasas.com>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:43111 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbYDNLj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 07:39:58 -0400
In-Reply-To: <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alasdair G Kergon <agk@redhat.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

On Mon, Apr 14 2008 at 13:50 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> This patchset adds large command support to the block layer.
> 
> We rarely handle large commands. So for optimization, a struct request
> still has a static array for a command. rq_init sets rq->cmd pointer
> to the static array. In short, rq_init() does
> 
> rq->cmd = rq->__cmd;
> 
> So we can access to rq->cmd and rq->cmd_len as before.
> 
> Boaz argues that having single cmd_len is dangerous:
> 
>> Because this way it is dangerous if large commands are issued to legacy
>> drivers. In scsi-land we have .cmd_len at host template that will govern if
>> we are allow to issue larger commands to the driver. In block devices we do
>> not have such a facility, and the danger is if such commands are issued through
>> bsg or other means, even by malicious code. What you say is the ideal and it
> 
> I don't see how it is dangerous. We don't send large commands to block
> devices via bsg. We can send large commands to block devices via only
> SG_IO. SG_IO (block/scsi_ioctl.c) forbids us sending commands large
> than 16 bytes, BLK_MAX_CDB. So how can we send large commands to block
> devices?
> 
> The first, second, and third patches are safe cleanups (a preparation
> for changing rq->cmd from the static array to a pointer). They don't
> conflict with Boaz's patchset. Even if we choose Boaz's approach now,
> we'll move to the approach to have one command length in struct
> request in the long term. So they can be applied now.
> 
> The forth patch adds large command support. It's a substitute for
> Boaz's second patch. It's pretty simple except for one hack for
> ide-io. It's necessary since the ide subsystem allocates struct
> request without using blk_get_request. In the long term, it would
> better to convert it to use blk_get_request properly.
> 
>

I still think that my last patch with one cmd_len and the Union is
nicer and more simple. And does not waist the extra pointer that is 
never ever used but by me. (And does not need 3 preparation patches)

Boaz
