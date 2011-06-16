From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Thu, 16 Jun 2011 11:50:54 -0400
Message-ID: <1308239454.2436.34.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44432 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab1FPPu6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 11:50:58 -0400
In-Reply-To: <20110616154129.GA31498@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Thu, 2011-06-16 at 08:41 -0700, Greg KH wrote:
> On Thu, Jun 16, 2011 at 09:03:43PM +0900, Nao Nishijima wrote:
> > Hi Greg,
> > 
> > (2011/06/16 0:33), Greg KH wrote:
> > > On Wed, Jun 15, 2011 at 05:16:28PM +0900, Nao Nishijima wrote:
> > >> Allow users to set the preferred name of device via sysfs interface.
> > >>
> > >> (Exsample) sda -> foo
> > >> # echo foo > /sys/block/sda/preferred_name
> > >>
> > >> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > >> Suggested-by: Jon Masters <jcm@redhat.com>
> > >> Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
> > > 
> > > You don't document this new sysfs file (which is required), nor do you
> > > explain what it is for and how to use it.
> > > 
> > > Please do that in this patch, and in a Documentation/ABI/ file for any
> > > new sysfs file you create.
> > >
> > 
> > I'm afraid that my explanation was not enough.
> > I will add explanation to this patch and Documentation/ABI file.
> > 
> > > I still fail to understand how a "preferred" file will help anyone out
> > > here at all...
> > >
> > 
> > Let me explain, users cannot identify a device from a device name
> > because device names may change at each boot up time. If kernel show
> > preferred names in kernel messages, users can easily identify a device
> > from kernel messages.
> 
> I understand your request for the kernel to print out these types of
> names, but I'm still not sold on this being an issue that is the
> kernel's to deal with at all.
> 
> Again, how would you handle multiple persistant names for the same
> device being used at the same time?
> 
> And again, why not just fix the userspace tools?  That is trivial to do
> so and again, could have been done by now in the years this has been
> discussed.

So I can summarise where I think we are in these discussions:

We provide the ability to give all kernel devices a "preferred name".
By default this will be the device name the kernel would have originally
assigned.  the dev_printk's will use the preferred name, and it will be
modifiable from user space.  All the kernel will do is print out
whatever it is ... no guarantees of uniqueness or specific format will
be made.  Since we're only providing one preferred_name file, the kernel
can only have one preferred name for a device at any given time
(although it is modifiable on the fly as many times as the user
chooses).

The design is to use this preferred name to implement what Hitachi wants
in terms of persistent name, but we don't really care.

All userspace naming will be taken care of by the usual udev rules, so
for disks, something like /dev/disk/by-preferred/<fred> which would be
the usual symbolic link.

This will ensure that kernel output and udev input are consistent.  It
will still require that user space utilities which derive a name for a
device will need modifying to print out the preferred name.

James


