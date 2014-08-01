From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Xen-devel] [PATCH V2 2/4] Introduce xen-scsifront module
Date: Fri, 1 Aug 2014 05:08:47 -0700
Message-ID: <20140801120847.GB17864@infradead.org>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
 <1406288253-13293-3-git-send-email-jgross@suse.com>
 <20140729135300.GA20415@infradead.org>
 <53D7B65C.8030701@suse.com>
 <53D87A67.8050005@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53D87A67.8050005@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 30, 2014 at 06:53:59AM +0200, Juergen Gross wrote:
> Hmm, I looked into scsi_add_device(). It seems as if the caller can't
> distinguish between a new created and an already existing device. Am I
> missing something?

That's right.  If you need that I still think it's better to add a
variant of scsi_add_device helping you with that.

> The race is not existing: scsi_add_device() (and scsi_remove_device()
> as well) for this scsi_host is called in scsifront_do_lun_hotplug()
> only, and this function is always called in the same thread (xenbus
> watch). A comment seems to be a good idea.

Do you disable scanning through procfs and sysfs as well?
