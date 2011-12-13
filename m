From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Tue, 13 Dec 2011 11:50:27 -0500
Message-ID: <20111213165024.GA9391@redhat.com>
References: <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EBA49C2.1000704@suse.de>
 <20111110161008.GA15659@osiris.boeblingen.de.ibm.com>
 <20111117162919.GA3812@redhat.com>
 <20111129120047.GA2456@osiris.boeblingen.de.ibm.com>
 <20111129201803.GB6827@redhat.com>
 <20111212123946.GA2307@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1LMQvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2011 11:51:14 -0500
Content-Disposition: inline
In-Reply-To: <20111212123946.GA2307@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com, dm-devel@redhat.com

On Mon, Dec 12 2011 at  7:39am -0500,
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Tue, Nov 29, 2011 at 03:18:03PM -0500, Mike Snitzer wrote:
> > On Tue, Nov 29 2011 at  7:00am -0500,
> > Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > [ 4906.683654] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
> > 
> > ...
> > 
> > > Gonzalo also tried 2.6.38.8 as suggested and ran into this one:
> > > 
> > > [  292.877936] ------------[ cut here ]------------
> > > [  292.877939] Kernel BUG at 6b6b6b6b6b6b6b6d [verbose debug info unavailable]
> > 
> > Again, more poison.
> > 
> > Seems this test is causing us to fall on our face no matter what.
> > Likely, best to leave this 2.6.38 blk_unplug crash to one side and
> > continue focusing on latest upstream.
> 
> Sorry again, for taking so long to come back. This time however with good news:
> 
> With 3.2.0-rc4.00255.g77a7300 we were unable to reproduce any I/O stall or
> user-after-free bugs even after nearly 3000 test iterations.

Great news, so with an eye towards getting these fixes upstream:

> The only patches on top we have are:
> 
> two patches from Hannes:
> http://www.spinics.net/lists/linux-scsi/msg55112.html

Has that scsi_lib.c patch been posted with a formal patch header?

James, I'm not clear on where I should be looking to see what you have
staged but not yet sent to Linus.  Does such a branch exist in your
scsi-misc-2.6 tree?

> http://www.spinics.net/lists/linux-scsi/msg55413.html

Jun'ichi and Hannes said that additional NULL pointer check is needed:
http://www.redhat.com/archives/dm-devel/2011-December/msg00022.html

Hannes said he'd re-post an updated patch (but hasn't yet).

Mike
