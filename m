From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Date: Wed, 04 Feb 2015 07:26:03 -0800
Message-ID: <1423063563.2090.2.camel@HansenPartnership.com>
References: <20150204172925.728016bf@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150204172925.728016bf@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Joe Perches <joe@perches.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-02-04 at 17:29 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/scsi_logging.c: In function 'sdev_prefix_printk':
> drivers/scsi/scsi_logging.c:119:6: error: void value not ignored as it ought to be
>   ret = dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
>       ^
> drivers/scsi/scsi_logging.c: In function 'scmd_printk':
> drivers/scsi/scsi_logging.c:146:6: error: void value not ignored as it ought to be
>   ret = dev_printk(level, &scmd->device->sdev_gendev, "%s", logbuf);
>       ^
> 
> Caused by commit ded85c193a39 ("scsi: Implement per-cpu logging
> buffer") interacting with commit d1f1052c5204 ("device: Change
> dev_<level> logging functions to return void") from the driver-core
> tree.
> 
> I added the following merge resolution patch.  Someone will have to
> remember to tell Linus.  Also, the void return may be able to be
> propagated further up the chain since these two new affected functions
> now always return 0.

Hannes posted a more correct fix for it today to the scsi list.
However, sorting this out isn't just about the short term fix:  We can't
afford the bisection failure of SCSI not building over a wide range of
commits, so our tree will need to be pulled ahead of the driver-core
tree.

I've got to say, while it's great that linux-next spotted this ahead of
time (saves us all a massive beating from Linus, thanks Stephen) it's
unfortunate to have this type of thing turn up on the edge of a merge
window, especially caused by a trivial commit which perhaps shouldn't
have gone in so late.

James
