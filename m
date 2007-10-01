From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 13/16] gdth: Make one abuse of scsi_cmnd less obvious
Date: Mon, 01 Oct 2007 15:56:29 +0200
Message-ID: <4700FC8D.1050209@panasas.com>
References: <46FFFC8C.6080804@panasas.com> <47000367.6090402@panasas.com> <20070930212813.GD13343@infradead.org> <20070930232135.GF12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30427 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842AbXJAOAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 10:00:04 -0400
In-Reply-To: <20070930232135.GF12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Oct 01 2007 at 1:21 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sun, Sep 30, 2007 at 10:28:13PM +0100, Christoph Hellwig wrote:
>> I think it would be better if your whole patch series goes ontop of
>> willy's ->done removal series instead.  I really hope we can get that
>> one into scsi-misc ASAP.
> 
> Actually, I think if Boaz simply flips this patch to be after his next
> one (or merges them ...), there's no real dependency on the ->done
> removal.
> 
But this is exactly it, 14th patch is dependent on this one. Because now
I have a central place to deallocate the private per-cmnd-info.

I have looked at it and in it's original form it mainly conflicts
with Jeff's "[PATCH 4/16] gdth: Remove 2.4.x support". (And minor
other places) What I could do right away is put it at 7-th
place. So the first 6 patches can go in now as you said, followed
by Matthew's patchset. But on the other hand Matthew's second
patch just dropped once a proper per-cmnd-info was setup, so
the all thing is entangled in this way.

But I totally understand Christoph's motivation with regard to
Matthew's patchset. 

OK My suggestion is as follows:
- Accept the first 6 patches right away, I think we have a consensus
  on that. Except from Achim, I got an "out-of-the-office" notice from
  his mailer, so it might take some time. Can we push them in anyway,
  as these should be pretty safe.

- I will advance this patch to 7th place.
- I will revive Matthew's second patch to follow these 7 patches.

- Mathew can now submit the rest of his patchset minus the gdth
  patches, as these are taken care of.

Following will be a second part. But these will wait
Achim's ACKs:
- I will unite my 7th & 8th patch to now be 9th.
  ("gdth: Remove virt hosts")
- Redo 10th patch as per Christoph comments.
- I will rebase the rest of the patches to the new conditions.
  Mainly redoing 14th patch 
  ("[PATCH 14/16] gdth: Setup proper per-command private data"
   This is because of conflicts with Matthew's second part)

- Christoph or Jeff will work on the finish up of the BUS hotplug API.
  I have looked at code examples elsewhere in the kernel, and Jeff's
  master plan sounds very good. But I would hope not to do it myself 
  as it will take me much longer.
  Jeff it sounds like you have it clearer in your head?

James?
 We need a decision here, about if we can push the first
6 patches ASAP. and than Matthew's 2 patches that I will send
soon, after we decide.
That is, if Matthew's patchset is to go in NOW. Other wise,
there is no rush and it can stay in the order they are now, which 
is easiest for me.

Thanks everyone, I'm awaiting all your comments to proceed.
Boaz

