From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/
	interrupts disabled internally
Date: Sun, 19 Dec 2010 19:07:59 -0700
Message-ID: <20101220020758.GK1263@parisc-linux.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-2-git-send-email-nab@linux-iscsi.org> <20101219233835.GJ1263@parisc-linux.org> <1292807703.20840.29.camel@haakon2.linux-iscsi.org> <1292808126.20840.33.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1292808126.20840.33.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 19, 2010 at 05:22:06PM -0800, Nicholas A. Bellinger wrote:
> Actually sorry, Mike Christie did already make a clarification on this
> subject here:
> 
> http://marc.info/?l=linux-scsi&m=129010439421506&w=2
> 
> I had originally thought the same that session->lock should be using
> some flavour of spin_lock_irq*() as well, but apparently this is not the
> case for libiscsi.

Right, so it seems.  "the session lock is just locked in softirqs/timers"
means that it does need to be the _bh() version of spin_lock though.

I'm actually not sure ... is it safe to use the _bh versions in BH
context?  I think it is because the preempt count is nested, unlike the
_irq variants of spinlocks.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
