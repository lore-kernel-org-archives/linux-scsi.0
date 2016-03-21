From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] uas: Limit qdepth at the scsi-host level
Date: Mon, 21 Mar 2016 15:36:03 +0100
Message-ID: <20160321143603.GB12654@lst.de>
References: <1458377952-12567-1-git-send-email-hdegoede@redhat.com> <1458407176.2288.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458407176.2288.5.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 19, 2016 at 10:06:16AM -0700, James Bottomley wrote:
> Help me understand this bug a bit more.  Are you saying that the commit
> you identify is causing the block layer to queue more commands than
> you've set the per-lun limit to?  In which case we have a serious
> problem for more than just UAS.  Or are you saying that UAS always had
> a global command limit, but it just didn't get set correctly; however,
> it mostly worked until the above commit exposed the problem?

I did mishandle uas in my patch to make the host wide tags the default
and didn't notice that uas set a different limit for the host wide
tag limit and ->can_queue.  With the old code we'd apply the lower
of the two limits, which was the host wide tag limit, but my patch
removed that one and now purely relies on can_queue.

Now most uas devices only have a single lun, and the per-lun limit
was set to what the global limit should be as well, so most users
didn't really notice this.
