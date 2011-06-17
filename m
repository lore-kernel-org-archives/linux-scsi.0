From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Fri, 17 Jun 2011 10:49:53 -0400
Message-ID: <1308322193.2586.30.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave>
	 <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave>
	 <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
	 <1308264321.2436.161.camel@mulgrave>
	 <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
	 <1308320844.2586.14.camel@mulgrave>
	 <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-06-17 at 16:40 +0200, Kay Sievers wrote:
> On Fri, Jun 17, 2011 at 16:27, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2011-06-17 at 01:04 +0200, Kay Sievers wrote:
> >> >> We need many names, and we need all of them from the very
> >> beginning,
> >> >> and they should not change during device lifetime unless the device
> >> >> state changes.
> >> >
> >> > So that's actually an argument for leaving the links, surely?  We
> >> can
> >> > have many inbound links, but the kernel can only print one name in
> >> > messages, which would be the preferred name that was currently set.
> >>
> >> I really question any concept of _the_ name. My take on it: It will
> >> never work in reality.
> >
> > OK, so lets take the common example: a desktop with three disks and an
> > enclosure with three slots and labels "fred", "jim", and "betty".
> >
> > The desired outcome is that whenever the user manipulates those devices
> > he uses a name related to the label, so whenever dmesg flags a problem,
> > it says sd betty:  device offline or something.  Whenever he mounts, he
> > mounts by /dev/disk/by-preferred/betty (or whatever the current udev
> > vernacular is).  Whenever smartmon says there's an over temp problem. it
> > says that fred has it;  cat /proc/partitions shows how fred, jim and
> > betty are partitioned and so on.
> >
> > To do this, we set the preferred name at start of day via a machine
> > specific customisation.  For an enclosure, there's a standard way of
> > mapping the name to the device, so we'd just use that, but it's not
> > impossible to imagine systems with stranger entities that require per
> > motherboard customisations.
> >
> > Once the name is set in boot up, we, in fact, never alter it.
> >
> > With the kernel patch proposed and a corresponding update to udev
> > actually makes all the above happen.  There have to be tweaks to the
> > startup scripts, like smartd needs a file configuration that lists the
> > disk by preferred path so that the output is correct.
> >
> > Obviously, I chose the commands above so there is no need to modify any
> > of them.  There will be utilities (like overly smart san managers) that
> > do derive the name and will need updating, but they're not among the
> > standard workstation admin tools.
> 
> Ok, the still remaining questions:
> 
> Why isn't logging all symlink names during device discovery solving
> all the problems we discuss without any change to the kernel? It's
> just a single udev rule that can be added to ages old systems today. I
> think that solves exactly the same problem and works with many names
> at the same time.

It could ... but that doesn't solve the prink problem or
the /proc/partitions one.  The idea is to allow naive users to identify
their device physically when the system logs something about it.  Having
to describe a manual mapping procedure is very complex for them.

> Where is "fred", "jim", and "betty" stored on bootup?

So this is subsystem specific.  For the case of a SCSI enclosure, I can
answer that it's actually burned into the enclosure firmware.  When you
build an enclosure with labels, the label names are stored in a
diagnostic page.  We can actually interrogate the enclosure directly or
use the ses driver to get these names mapped to current devices.

> What are the keys to match the pretty names to the disks?
> 
> The pretty name is a one-shot setting only? If not how is a change
> handled for already used devices?

obviously, one device will be root, and it will already be used
as /dev/root, but the proposal isn't to change any name, it's merely to
set "fred" as the preferred name for /dev/root, which is also /dev/sdc
and /dev/disk/by-id/naa-566dce3ddf etc ...

> How will this information be available in the initramfs, where
> mutltiple disks might need to be mounted already? Initramfs images are
> generic and not created per host.

That's initramfs specific.  However, if, in deference to your new
location, we look at dracut, it has a modules directory for plugin
extensions.  The scripts which do the mapping can be inserted there as
an additional rpm.

> How are multipath setups handled where the exact same disk is behind
> multiple kernel devices? What to put into these names in this case?

I'm not sure I understand the question.  a md setup of RAID-1 on fred
and betty would assemble using /dev/disk/by-preferred/fred
and /dev/disk/by-preferred/betty.  Whether the user want's to
call /dev/md0 something pretty is up to them ... it's not a physically
labelled entity, so I'd tend just to leave it with its default name as
the preferred name.

James
