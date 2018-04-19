From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 20/39] afs: simplify procfs code
Date: Thu, 19 Apr 2018 14:00:23 +0100
Message-ID: <22411.1524142823@warthog.procyon.org.uk>
References: <20180419124140.9309-21-hch@lst.de> <20180419124140.9309-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180419124140.9309-21-hch@lst.de>
Content-ID: <22410.1524142823.1@warthog.procyon.org.uk>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Use remove_proc_subtree to remove the whole subtree on cleanup, and
> unwind the registration loop into individual calls.  Switch to use
> proc_create_seq where applicable.

Note that this is likely going to clash with my patch to net-namespace all of
the afs proc files:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=mount-context&id=f60c26c827c073583107ebf19d87bc5c0e71c3d2

If it helps, I should be able to disentangle this from the mount-api changes
since the subsequent patch connects the dots to propagate the network
namespace over automount using the new fs_context to do it.

David
