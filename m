From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of staging
Date: Mon, 17 Oct 2011 10:26:42 -0500
Message-ID: <1318865202.4794.21.camel@dabdike.int.hansenpartnership.com>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
	 <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
	 <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA15174@TK5EX14MBXC124.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA15174@TK5EX14MBXC124.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-17 at 15:15 +0000, KY Srinivasan wrote:
> This patch is against Greg's staging tree where recently I merged all
> of the storage
> drivers into a single driver. This change may not have percolated up
> yet - Greg has
> checked this into his staging tree though.

OK, that explains the difference.

> As I deal with the review comments now, do you want me to get these
> changes
> applied first to Greg's tree before you would consider moving this
> driver to drivers/scsi
> directory, or could you move the driver as it is in Greg's tree under
> staging and I could give
> you patches against the moved driver.

Either way is fine by me.  The best route for this is to get the staging
update into Linus head, then work on the actual SCSI problems.  I'd like
other SCSI people besides me to review it.

> > OK, so as I read the code, what it can't handle is fragments except at
> > the ends.  As long as everything always transfers in multiples of 4k,
> > the problem will never occur.  This means that all devices you present
> > need to tell the OS they have 4k sectors.  I *think* you can do this by
> > setting  blk_limits_io_min() in the driver ... but you'll have to test
> > this.  The minimum sector size gets set also in sd.c when we probe the
> > disk.  I think that won't override blk_limits_io_min(), but please test
> > (we don't have any SCSI drivers which have ever used this setting).
> > 
> > The way to test, is to read back the /sys/block/<dev>/queue/ settings
> > when presenting a 512 byte sector disk.  (And the way to activate your
> > bounce code would be to create a filesystem with a < PAGE_SIZE block
> > size).
> 
> Given that the bounce buffer handling code would typically
> never be triggered, I not sure how useful it will be to try to get rid
> of the bounce buffer
> code using a feature that is not well tested.

As opposed to bounce buffer code which hasn't been well tested either if
it can't be triggered.

>  In any event, I will try your suggestion though. 

Just to be clear: Setting the minimum I/O size is completely well
tested: it's how we handle 4k sector drives.  What hasn't been tested is
the ability of the *driver* to enforce the minimum using
blk_limits_io_min().  As long at that doesn't get overridden by sd when
it sees a 512b drive, the rest of the block paths (those which actually
enforce the minimum) have all been well tested.

James
