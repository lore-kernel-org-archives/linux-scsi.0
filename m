From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 0/4] New SCSI command timeout handler
Date: Fri, 07 Jun 2013 14:54:16 +0800
Message-ID: <51B18398.6000508@cn.fujitsu.com>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3FGHQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jun 2013 03:16:03 -0400
In-Reply-To: <1370511835-50072-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

Hi, Hannes:

On 06/06/2013 05:43 PM, Hannes Reinecke wrote:
> this is the first step towards a new non-blocking
> error handler. This patch implements a new command
> timeout handler which will be sending command aborts
> inline without engaging SCSI EH.
>
> In addition the commands will be returned directly
> if the command abort succeeded, cutting down recovery
> times dramatically.
>
> With the original scsi error recovery I got:
> # time dd if=/dev/zero of=/mnt/test.blk bs=512 count=2048 oflag=sync
> 2048+0 records in
> 2048+0 records out
> 1048576 bytes (1.0 MB) copied, 3.72732 s, 281 kB/s
>
> real	2m14.475s
> user	0m0.000s
> sys	0m0.104s
>
> with this patchset I got:
> # time dd if=/dev/zero of=/mnt/test.blk bs=512 count=2048 oflag=sync
> 2048+0 records in
> 2048+0 records out
> 1048576 bytes (1.0 MB) copied, 31.5151 s, 33.3 kB/s
>
> real	0m31.519s
> user	0m0.000s
> sys	0m0.088s
>
> Test was to disable RSCN on the target port, disable the
> target port, and then start the 'dd' command as indicated.
>
> As a proof-of-concept I've also enabled the new timeout
> handler for virtio, so that things can be tested out
> more easily.

So this 31.5s is tested on virtio disks, right? Much faster than your
former test via fc.

This approach may not work for some LLDDs as you said, but I wonder
whether SAS is applicable(whether there will be later patches for
SAS).

Thanks,
Ren

