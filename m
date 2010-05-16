From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 6/8] SCSI: implement sd_unlock_native_capacity()
Date: Sun, 16 May 2010 11:00:36 -0500
Message-ID: <1274025636.14187.24.camel@mulgrave.site>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	 <1273946974-29131-7-git-send-email-tj@kernel.org>
	 <1274017175.14187.9.camel@mulgrave.site>
	 <1274022457.2564.105.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1274022457.2564.105.camel@localhost>
Sender: linux-ide-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-05-16 at 16:07 +0100, Ben Hutchings wrote:
> On Sun, 2010-05-16 at 08:39 -0500, James Bottomley wrote:
> [...]
> > Then there's no need for anything at all in SCSI ... and it becomes a
> > whole lot more obvious how to do legacy ide (if we ever get problems
> > there).
> 
> The block device set_capacity() interface is already defined and was
> implemented for the IDE disk driver some time ago.  The purpose of
> Tejun's work on sd and libata is to implement this existing interface
> and so avoid a regression when users switch from IDE to libata-based
> drivers.  I don't see why he should have to replace the interface as
> well.

I thought we already reached the conclusion that set_capacity wasn't the
right interface, hence the redo as a binary lock/unlock of native
capacity ... which is revoking the set_capacity interface in this patch.

The point I was making is that bdops just works for ide because it's
completely monolithic.  It gives us a layering problem in SCSI because
you have to hook it into the lower layers which don't have access to
bdops (since they're an upper layer thing in SCSI).

This layering problem is partly the fault of libata ... if we had an ATA
native disk driver, it would be able to unlock the capacity on its own.
It's just we're using SCSI which has no SAT command it can issue for
this, so the functional request has to be pushed down to libata ...
leading to the need to thread it through the host template.

I was just pointing out that the whole thing is simplified if we use a
block queue function approach instead.  ide_disk_t has access to the
queue, as does gendisk, so it would all "just work" with a simple call
site change if we used queue ops instead of block dev ops.  The plus
side of doing it this way is that the SCSI threading becomes
unnecessary: libata gets directly hooked into the unlock function
instead of having to do it via an intermediary.

James


