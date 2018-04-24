From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 26/39] rtc/proc: switch to proc_create_single_data
Date: Tue, 24 Apr 2018 16:15:24 +0200
Message-ID: <20180424141524.GB26136@lst.de>
References: <20180419124140.9309-1-hch@lst.de> <20180419124140.9309-27-hch@lst.de> <20180419131027.GC7369@piout.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419131027.GC7369@piout.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 19, 2018 at 03:10:27PM +0200, Alexandre Belloni wrote:
> On 19/04/2018 14:41:27+0200, Christoph Hellwig wrote:
> > And stop trying to get a reference on the submodule, procfs code deals
> > with release after and unloaded module and thus removed proc entry.
> > 
> 
> Are you sure about that? The rtc module is not the one adding the procfs
> file so I'm not sure how the procfs code can handle it.

The proc file is removed from this call chain:

  <driver>_exit (module_exit handler)
    -> rtc_device_unregister
      -> rtc_proc_del_device
        -> remove_proc_entry

remove_proc_entry takes care of waiting for currently active file
operation instances and makes sure every new operation never calls
into the actual proc file ops.  Same behavior as in RTC exists all
over the kernel.
