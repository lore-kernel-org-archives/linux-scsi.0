From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Mon, 7 Nov 2011 16:44:51 -0500
Message-ID: <20111107214451.GA14339@redhat.com>
References: <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EB7C159.8020009@ce.jp.nec.com>
 <20111107153649.GA9935@redhat.com>
 <20111107171044.GA10801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1KGVpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2011 16:45:15 -0500
Content-Disposition: inline
In-Reply-To: <20111107171044.GA10801@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com, dm-devel@redhat.com

On Mon, Nov 07 2011 at 12:10pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Nov 07 2011 at 10:36am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> > Could be the block layer's onstack plugging changes are at the heart of
> > this.
> > 
> > I voiced onstack plugging concerns relative to DM some time ago
> > (https://lkml.org/lkml/2011/3/9/450) but somehow convinced myself DM was
> > fine to no longer need dm_table_unplug_all() etc.  Unfortunately I
> > cannot recall _why_ I felt that was the case.
> > 
> > So DM needs further review relative to block's onstack plugging changes
> > and DM IO completion.
> 
> dm_suspend is performed as part of the DM table reload that is being
> done my multipathd during path failure.  Seems DM no longer insures
> inflight requests have finished during dm_suspend().
> 
> Before onstack plugging (< 2.6.39):
> dm_suspend() -> dm_wait_for_completion() -> dm_unplug_all() -> dm_table_unplug_all()
> 
> After onstack plugging (>= 2.6.39, commit 7eaceaccab5f40bb):
> dm_suspend's call to dm_wait_for_completion() no longer unplugs IO
> (dm_unplug_all and dm_table_unplug_all were removed without introducing
> a clear equivalent).

If a missing unplug were a concern then dm_wait_for_completion()'s check
for inflight IO would cause dm_suspend() to hang.

So the onstack plugging changes are unlikely to be the reason for this.

Mike
