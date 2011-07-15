From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 15 Jul 2011 14:48:06 +0200
Message-ID: <20110715124806.GH3486@nb.net.home>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708194501.GU6418@nb.net.home> <4E1FE446.4040208@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E1FE446.4040208@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 15, 2011 at 03:55:02PM +0900, Nao Nishijima wrote:
> >  If there is not /dev/foo and /sys/block/foo then the patch introduces
> >  a REGRESSION. 
> >  
> >  The names from /proc/partitions are used in many applications
> >  (libblkid, fdisk, ...) for many many years. The applications will not
> >  work as expected.
> > 
> 
> I think that it is not a regression when users do not set an alias name.
> Of course, I am going to modify all these utils so that users can use
> alias names.
> 
> The purpose of alias names is to unify the name of device which users
> operate and see. Therefore, I think that users would like to get an
> alias name from it, because currently they get a device name form it.
> 
> However, for who wants to use alias name only for dmesg, I have an
> enhancement idea that users can choose alias names or device names in
> procfs by sysctl (default is device names).

>From my point of view

    dmesg | grep <alias>

seems a little bit problematic, because for example initial messages
for the device will be invisible. In the log will be messages with
original canonical names and another (later) messages with aliases, you
can also change the alias, etc. Seems like a mess. The log should be
consistent...

I think it would be better to use always only canonical names in the
kernel log and translate to something more user-friendly in userspace.
For example if you add some meta-information to the kernel log then we
can improve dmesg(1) to translate the canonical names to aliases.

 printk(KERN_INFO "this is info about %{device}s", device);

 <5>[105221.774534]{device=sda} this is info about sda

or whatever... (this is a nice topic with many colors for the bike
shed:-)

> I would like to hear your opinion about this.

If you want to modify all the userspace utils then you don't have to
modify /proc/partitions :-)

You can keep the standard names in /proc/partitions (so the file will
be compatible with /sys and /dev) and you can modify all the utils to
translate the canonical device names to aliases. The result will be
the same, except "cat /proc/partitions" -- but I think that instead of
"cat" you can use "lsblk".

If you add only the attribute (alias name) to the /sys then you don't
have to care if all the utils are already modified.

Anyway, I still agree with Kay and Greg -- the proper solution
is to improve printk() and dmesg(1). The aliases could be implemented 
in userspace by udev /dev/disk/by-alias/<cool_name> symlinks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
