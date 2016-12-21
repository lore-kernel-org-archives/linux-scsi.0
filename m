From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] set a base index for libsas based ata devices
Date: Wed, 21 Dec 2016 00:03:42 -0800
Message-ID: <20161221080342.GA21557@infradead.org>
References: <CAF2xp_F3ea-n4R8jG8UpHEE3YmvKN7UWBAn36_QXMg-e34tY_w@mail.gmail.com>
 <1482258634.2475.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482258634.2475.20.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Chang <dpf@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 20, 2016 at 10:30:34AM -0800, James Bottomley wrote:
> I'd actually disagree with this assertion; it's why tagging (what you
> mean by ncq) and queue depth are separate.  Queue depth represents the
> number of outstanding commands we sent on the wire; however, it often
> excludes things like sense probes and error handling commands, so
> tagged depth==1 is a different operating environment from untagged. 
>  Some transports actually have no untagged variant nowadays, so it's
> physically impossible to disable tagging.

Yes.  We have the queue_type sysfs file that also used to be writeable
and allow changing the queue type, but it's never been used for
anything.

For debugging you can clear the tagged_supported flag in the driver,
but there should be no reason for doing that during normal operation
for a SAS HBA driver.
