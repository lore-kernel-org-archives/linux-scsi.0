From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [hch@infradead.org: Re: [PATCH] fix 2.5 scsi queue depth setting]
Date: Thu, 7 Nov 2002 02:13:20 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107021320.A9844@infradead.org>
References: <20021106210542.A32241@infradead.org> <20021106212040.GI22177@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 189cAa-0002Yz-00
	for linux-scsi@vger.kernel.org; Thu, 07 Nov 2002 02:13:20 +0000
Content-Disposition: inline
In-Reply-To: <20021106212040.GI22177@redhat.com>; from dledford@redhat.com on Wed, Nov 06, 2002 at 04:20:40PM -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 04:20:40PM -0500, Doug Ledford wrote:
> > I'm all for the second option, but I don't think we should specify the
> > NULLing out, the device will go away anyway.
> 
> Hmmm...I thought this was being done on upper level de-attachment, which 
> doesn't always imply device removal.  I'm not sure the device is going 
> away in all cases....

In this context it implies that the last upperlayer user of the device
goes away and thus the device can't be access from the upperlayer
anymore.  If a new driver attaches we'll call slave_attach again
after Patrick's changes.

