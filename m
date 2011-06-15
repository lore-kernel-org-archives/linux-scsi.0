From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/3] [RFC] Persistent device name using preferred name
Date: Wed, 15 Jun 2011 08:37:11 -0700
Message-ID: <20110615153711.GB10160@kroah.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 15, 2011 at 05:16:10PM +0900, Nao Nishijima wrote:
> Hi,
> 
> This patch series provides preferred name into kernel and procfs
> messages. Preferred name is user's preferred name for a device.
> 
> The purpose of this feature is to solve the persistent device
> naming issues which was discussed here:
> 
>  http://marc.info/?l=linux-scsi&m=130200794615884&w=2
> 
> There are four issues.
> 1. kernel messages doesn't show persistent device names

That is because a persistent device name could be anything, there are
multiple ways of defining a device, and the kernel will not know them
all as multiple ones could be in use for the same device.

> 2. procfs messages doesn't show persistent device names

See above.

> 3. Some commands didn't support persistent device name in arguments

Then fix the commands!

Seriously, this could be done by now, it's been over a year since this
was first discussed.  All distros could have the updated packages by now
and this would not be an issue.

I still think this is the correct way to solve the problem as it is a
userspace issue, not a kernel one.

> 4. Some commands message didn't show persistent device names

Same as #3.

> Then I suggested the intermediate device naming which changes
> the naming scheme, but it was rejected. I realized that we should
> use udev to provide persistent device names instead of change the
> naming scheme.

Yes.

> In LKML discussion, a new idea was suggested by James Bottomley.
> This idea allows kernel messages show preferred names by adding a
> new attribute to a device, kernel messages show this new attribute.
> This idea's advantage is not to change the current naming scheme.
> 
> I tried implementation of preferred name, and then there are two
> discussion points.
> 
> (a) Which devices need support?
> Preferred name is stored in struct device. Therefore it is available
> for all devices if we make preferred name support with other device
> types.
> 
> This patch series only support scsi block device. Is there the device
> which needs support? (e.g. Ntwork devices, generic SCSI devices, etc.)
> 
> (b) What kind of procfs form is good?
> I implemented preferred name something like this,
> 
> (preferred name assigned foo to sda)
> #cat /proc/partitions
> major minor  #blocks  name
> 
>    8        0  488386584 foo
>    8        1     194560 foo1
> ...
> 
> Do you needs device name filed?
> Something like this,
> 
> (preferred name assigned foo to sda)
> #cat /proc/partitions
> major minor  #blocks  name preferred
> 
>    8        0  488386584 sda foo
>    8        1     194560 sda1 foo1
> ...

Sorry, but you can not change the format of procfs files without
breaking a lot of tools, that's no longer allowed.

> Issue 3 and 4 is command releated issue. Commands have to be
> modified to use preferred name. We need to create library for
> preferred name.

Again, this is quite simple and could have been finished by now :(

> Our goal is to solve those issues, and users can use and see
> preferred name anywhere.

I don't see how your proposed solution would solve the issue of
userspace using different persistant names for the same device.  How
would it know which one is correct?

Again, this is a userspace thing, not a kernel thing, please solve it in
userspace.

greg k-h
