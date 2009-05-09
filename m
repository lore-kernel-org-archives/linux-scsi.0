From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Sat, 09 May 2009 03:36:29 -0400
Message-ID: <4A05327D.3060101@garzik.org>
References: <4A0307F4.50205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33831 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZEIHgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 May 2009 03:36:49 -0400
In-Reply-To: <4A0307F4.50205@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Boaz Harrosh wrote:
> Osd library needs to submit pre-allocated bios, form several sources.
> osdblk exofs and pNFS-layout driver all have prepared bios for IO submission.
> On top of that the osd library needs to append additional segments to the
> IO memory, for get/set attributes and more.
> 
> All these are done today by use of a temporary hack - blk_rq_append_bio.
> This is bad on few accounts.
> 1. blk_rq_append_bio was not meant to be exported and is very specific to its users.
> 2. blk_rq_append_bio does not support chained bios.
> 3. blk_rq_append_bio does not bounce the bio and therefore current osd implementation
>    has a bug.
> 
> The proposed solution adds two new fixtures to the block layer, and a corresponding
> fixing patch to osd. These are:

Just wanted to say... thanks for working on this.  I'll test osdblk anew 
once this stuff goes in, and then send you another osdblk patch.

	Jeff




