From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 16:42:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107164206.C9189@lst.de>
References: <200211071532.HAA21625@freya.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211071532.HAA21625@freya.yggdrasil.com>; from adam@freya.yggdrasil.com on Thu, Nov 07, 2002 at 07:32:08AM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@freya.yggdrasil.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 07:32:08AM -0800, Adam J. Richter wrote:
> Michael Anderson wrote:
> >The removal of detect should eventually result in other reductions /
> >cleaner code (If the sg binding issue can be resolved cleanly).
> 
> 	What makes you think that?  You need a way to ask "is this
> driver interested in this device" and that's all that the code
> remaining in scsi_device_template.detect() does after you remove the
> side effects (i.e., the counter incrementing), and it does so about as
> simply as possible.

"Is this driver interested" is a fundamentally racy concept.  We want to
only support "attach if you're interested".  That's like the other
driver infrastructure works, too.

> 	I haven't looked at it closely, but there seems to be
> workaround in the generic device code for its inability to bind more
> than one driver to a device: struct device_interface, which seems to
> duplicate much of the generic driver interface but lacks
> device->driver_data, which we could compensate for by adding
> a field in struct scsi_device:
> 
> struct scsi_device {
>        ...
> 	struct sg_device *sg_dev;	/* For use by SCSI generic only. */
> };

Yupp, that's the way I'd prefer.  In addition get rid of the whole
driver template for sg.

