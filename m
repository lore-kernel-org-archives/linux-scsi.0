From: Greg KH <greg@kroah.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 8 Jul 2011 08:47:36 -0700
Message-ID: <20110708154736.GA7320@kroah.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
 <20110708145408.GA2283@kroah.com>
 <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jcm@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 08, 2011 at 05:41:36PM +0200, Kay Sievers wrote:
> On Fri, Jul 8, 2011 at 16:54, Greg KH <greg@kroah.com> wrote:
> > On Fri, Jul 08, 2011 at 05:45:47PM +0900, Nao Nishijima wrote:
> >> This patch series provides an "alias name" of the disk into kernel and procfs
> >> messages. The user can assign a preferred name to an alias name of the device.
> >>
> >> Based on previous discussion (*), I changed patches as follows
> >> - This is "alias name"
> >> - An "alias name" is stored in gendisk struct
> >> - Add document to Documentation/ABI/testing/sysfs-block
> >> - When the user changes an "alias name", kernel notifies udev
> >>
> >> (*) http://marc.info/?l=linux-scsi&m=130812625531219&w=2
> >
> > I don't like it and I don't think it will really solve the root problem
> > you are trying to address, but as the patches don't touch any code I
> > maintain, there's not much I can do to object to it.
> 
> I can only repeat what I already wrote in detail earlier:
> 
> This approach seems to papers over the problem which emitting and
> parsing free-text printk() messages with much-too-dumb tools cause. It
> seems to fix the symptoms not the cause.
> 
> You can already write a udev rule today that logs _all_ symlinks of a
> device at discovery time, and any later kernel message can safely be
> associated with all possible names of the blockdev. No kernel changes
> needed, all possible names are covered. That also works good enough
> with our current stone-age tools for anybody who is able to scroll
> back to the last log udev message in that same log file.
> 
> There can be by-definition no default udev rules assigning a proper
> single name to a block device. There is never a valid single name for
> a disks, so udev can not ship anything like that in the default setup,
> so this stays as a custom hack.
> 
> We absolutely need _structured_ data for logging and error reporting,
> not only to solve this problem. Along with the current free-text
> printk(), we would be able to attach classifications, device
> error/sense data, firmware register dumps and anything
> interesting-for-debug to the messages.
> 
> We can't solve that problem in the kernel alone. Structured data from
> the kernel will need to feed a smarter userspace logger that can index
> and classify messages, merge current userspace data into it, and
> provides hooks for the system management to act on critical failures
> and raise notifications.
> 
> Structured logging seems like the solution for this and also to many
> other problems in this area. Single custom names pushed into the
> kernel might cover some rather exotic use cases, but I think, is not
> what we are looking for.

I totally agree, but hey, no one listens to us :)

greg k-h
