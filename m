From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 12:32:32 +0200
Message-ID: <9b06e8d20710150332u53092454x13219e28fcfb4244@mail.gmail.com>
References: <200710112011.22000.rob@landley.net>
	 <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org>
	 <200710150304.00901.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:61133 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbXJOKcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 06:32:35 -0400
Received: by ug-out-1314.google.com with SMTP id z38so846307ugc
        for <linux-scsi@vger.kernel.org>; Mon, 15 Oct 2007 03:32:33 -0700 (PDT)
In-Reply-To: <200710150304.00901.rob@landley.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

2007/10/15, Rob Landley <rob@landley.net>:
> On Sunday 14 October 2007 8:45:03 pm Theodore Tso wrote:
>> On Sun, Oct 14, 2007 at 06:45:44PM -0500, Rob Landley wrote:
>>> I admit a certain amount of personal annoyance that once the SCSI
>>> layer consumes a category of device (USB, SATA, PATA), they can
>>> often _only_ be used by going through the SCSI midlayer.  (This
>>> strikes me as analogous to TCP/IP claiming ethernet and PPP devices
>>> so thoroughly that you can no longer address them as eth1 or
>>> /dev/ttyS0.)
>>
>> That's because modern USB, ATAPI (what was once known as IDE), SATA
>> really *all* using the SCSI command protocols at the low level,
>
> Ok, I'll bite.  If it's all "real" scsi, why does ioctl(SG_EMULATED_H=
OST)
> exist? exist if it's all "real" scsi?

     How do you define real SCSI ? The definition of SCSI in the kernel=
 is
  "a device that accept the SCSI command set" (more precisely "a
  suitably large subset a the SCSI command set". It looks as if you
  definition of SCSI is "a device that is sold with written SCSI on the
  box and that attaches to a card with SCSI written on the box"; is it
  correct ?

    The host is the expansion card that connects the device to the
  motherboard. If it is emulated this means that it is not a native
  SCSI host. In case of USB drives/keys this is probably the case.

>> just as Ethernet and PPP interfaces really are fundamentally the
>> same thing.
>
> They're the same thing?
>
> Do you mean that on a system with both, going:
>   ifconfig eth1 66.92.53.140
>   ifconfig ppp 192.168.0.42
>
> Would be functionally equivalent to:
>   ifconfig eth1 192.168.0.42
>   ifconfig ppp 66.92.53.140
>
> So if on one boot the addresses are assigned the first way, and upon =
reboot
> they're assigned in the second way by exact the same set of commands.=
=2E.  well
> that's not IMPORTANT, is it?  (Or is it that everyone everywhere shou=
ld use
> dhcp for everything, and static addressing is obsolete and no longer
> supported?

     You are really looking like you are out for a fight.

> Apparently dhcp addresses should be delivered by machines with
> only one network interface of any type...)

     I don't understand this one.

> This is my objection.  Even when enumerating multiple devices of the =
same type
> is tricky, enumerating multiple devices of _different_ types should n=
ot be.
> There's a great big type indicator that is being _deliberately_ ignor=
ed, and
> large classes of devices (millions of laptops) where you know there's=
 only
> going to be _one_ instance of a given type.

      Your objection is interesting. It is lost in the middle of e-mail=
s which,
  to the untrained eye, look like you are trying to fight everyone and
  everybody.

> By the way, ethernet cards contain a unique MAC address.  Hard drives=
 do not
> seem to, or if they do it's not being consistently exposed in a way I=
 can
> find.  This is sad.  (No, reading data from the device to determine t=
his gets
> us back to the "spinning up the external USB drive to find my root pa=
rtition"
> gripe mentioned earlier.)

     As far as I can tell the hard drives do not have serial numbers ea=
sily
  readable by the kernel (I think it's only printed on the label). Howe=
ver
  (feverishly plugging his USB key in the laptop), you can tell how a d=
rive
  is attached to the motherboard:

Laptop's SATA drive:
cognac $ readlink /sys/block/sda/device
=2E./../devices/pci0000:00/0000:00:12.0/host0/target0:0:0/0:0:0:0

USB key:
coghac $ readlink /sys/block/sdb/device
=2E./../devices/pci0000:00/0000:00:13.5/usb6/6-3/6-3:1.0/host4/target4:=
0:0/4:0:0:0

    By the way, did you look in /dev/disk/by-id (udev magic) ? It's pro=
bably
  not very difficult to reconfigure udevd to not read the UUIDs of the
  partitions and not spin up your holy external disk at each reboot. I =
think
  the one that is spinning up your holy external hard drive is udevd. B=
y
  the way, how many time do you reboot instead of resuming from
  suspend-to-disk ? Have you given a try to TuxOnIce ?

    If you had asked your first question in a way similar to this one:

    "I have my laptop hard drive that shows as different devices depend=
ing
  whether there are USB drives plugged in or not, what should I do ?
  Shouldn't SATA/USB drives/PATA/iSCSI drives be enumerated in differen=
t
  queues ?"

    You would probably have received more interesting answers and less
  insults.

>> You can rail against it, but that's the mark of someone who
>> refuses to accept reality.
>
> Let me clarify: I'm talking about device enumeration.
>
> I've never had trouble enumerating a device that was _not_ routed thr=
ough the
> scsi layer, largely because the systems I work with don't usually hav=
e more
> than one device of the same type.  (There are millions of laptop and =
desktop
> devices out there where this is the common case.  As I said, I may ha=
ve four
> USB ports and the ability to plug hubs into them, but you can't add a=
nother
> SATA hard drive to my laptop without a soldering iron.)
>
> However, as soon as a device _is_ routed through the scsi layer (as P=
ATA was a
> few versions back), it gets conflated with numerous other devices.  T=
his
> creates problems.  SATA isn't hard to enmerate in my laptop, USB pote=
ntially
> is.  Dumping all the SATA devices into the same bucket with the USB d=
evices
> makes both harder to enumerate.

    Indeed. Propose a solution. Remember that it is indispensable that =
all
  goes through the SCSI layer(s) because all those devices respond to t=
he
  same command set thus you do not want several implementations of
  the routines.

>>> This has the annoying effect of bundling together different types o=
f
>>> devices and making device enumeration unnecessarily difficult: my
>>> laptop only has one SATA hard drive and can't gain another without =
a
>>> soldering iron, but that drive could move from /dev/sda to /dev/sdb
>>> if I reboot the system with a USB key plugged in.  This seems like =
a
>>> regrettable loss of orthogonality to me.  I remember back when
>>> /dev/usb0 and /dev/hda were separate devices that showed up in /dev=
,
>>> but these days "it's SCSI" seems to trump "it's USB", "it's ATA", o=
r
>>> "it's SATA".  (Even though none of those are actually SCSI hardware=
,
>>> they just send a similar packet protocol across the wire.)
>>
>> You're showing your ignorance here.
>
> I have buckets of ignorance.  It's why I ask questions.

     Once again. You are so aggressive in your asking that it does not
  lead to an interesting discussion.

>> In fact in the past few years,
>> ATA and SCSI has been converging significantly,
>
> And down far enough all these devices are powered by electricity.  Ar=
e we
> going to wind up with /dev/electric[1-999]?

     Out for a fight ?

> SATA !=3D PATA !=3D USB.  But /dev/sda can be PATA, /dev/sdb SATA, an=
d /dev/sdc
> USB.  And they can move relative to each other.  This didn't used to =
be the
> case.  Why is it considered an improvement?

     Each device is different from each other (they do not share their =
atoms).
  Where do you want to put the line between using a single driver for t=
hem
  or not ?

     In that case the sd driver registers all disk-like devices that re=
spond to
  (a suitably large subset of) the SCSI command set. It is an improvmen=
t
  to have all devices share a driver because if you improve it, you imp=
rove
  it for all the devices; if you debug it, you debug it for all your
devices; you
  use less memory.

   The enumeration of the devices is not the nightmare you are trying t=
o
  imply. If it is hard in your particular case, many people are likely =
to want
  to help you. Just try to ask politely, without shouting, without sayi=
ng that
  block layer is useless, without saying that device enumeration in the
  SCSI layer (or sd device driver) is braindead. If you want to propose=
 a
  change, propose it: "we could also do it that other way". "The way th=
e
  SCSI disk is attached should show in the name of the device". I suspe=
ct
  this will be refused anyway because that would mean that you need
  a (series of) major block number(s) for each type of SCSI attachment
  (if the device has not a different major block number, there is nothi=
ng
  short of udev that can give it a different name).

>> with the ATAPI
>> specification has essentially incorporating the SCSI protocol by
>> reference and by value --- with the point that SAS was developed by
>> the SCSI Trade Association, and SAS is effectively a superset of SAT=
A,
>> to the point where with care, you can actually mix SAS and SATA driv=
es
>> on the same in enclosure (SAS and SATA are physically compatible on
>> the connector level).
>
> I'm aware of this, and under the impression they're both modified gig=
abit
> ethernet at the PHY level.  Should the hard drive become eth2?

     Out for a fight ?

>> More to the point, with SATA, hot plugging has been designed in, so
>> probing order is not going to be well defined,
>
> The spec may define the capability to hotplug, but your average
> laptop doesn't not offer the capability to hotplug anything into its
> SATA controllers.

    How long before eSATA enabled laptops (with eSATA enumerated
  before SATA obviously) ?

> The hard drive is screwed in (due to the portability part of laptopne=
ss),
> all the controllers wired onto the motherboard are accounted for, non=
e
> are exposed externally.  What _is_ exposed externally is USB, and if =
you
> want to add an extra hard drive you can buy a cheap USB one at Fry's.
>
> In such a case, which is common, the first SATA hard drive is reliabl=
y the
> disk containing the root partition, and there's no need to stick a UU=
ID
> in /etc/fstab.
>
> The problem is, "the first SATA hard drive" is not a stable identifie=
r in a
> system where SATA and USB devices are dumped in the same bucket
> and given big stir.  Dumping SATA and USB devices into the same
> bucket (because they smell a bit like SCSI) is what I am objecting to=
=2E

     You should have told it in the first place -- with cooler tone.

>> just as with USB
>> devices.  And there are already relatively common situations where t=
he
>> same disk can show up via multiple different interfaces.
>
> It was also possible to buy a hotplug PATA ide enclosure.  So what?  =
The vast
> majority of traditional IDE users happily ignored this, and went on w=
ith
> their lives.
>
> > For example, if you have a modern Thinkpad with an secondary SATA h=
ard
> > drive in an Ultrabay, and you plug it into the Ultrabay in your T60=
,
> > it will show up as a SATA drive.
>
> I remember the config option about enumerating onboard IDE controller=
s first.
> It didn't really matter what order they were enumerated in as long as=
 it was
> controllable.
>
> Presumably if the primary SATA hard drive was /dev/sata and the slot
> with "secondary" in its name got /dev/satb, life would be good.  And =
the
> presence or absence of /dev/satb wouldn't affect USB devices and such=
 if they
> weren't in the same namespace.
>
>> However, if you plug it into the
>> Advanced dock, it shows up as a USB device.
>
> You plug it in somewhere else, it shows up somewhere else.  This soun=
ds
> familiar to old IDE users. :)
>
> How is it harder for udev to make a stable symlink for this drive tha=
t
> sometimes points to /dev/satb and sometimes to /dev/usb1?  (Harder th=
an a
> symlink that sometimes points to /dev/sdb and sometimes to /dev/sdd? =
 You
> don't have persistent naming _now_, so the objection seems to be that
> maintaining the distinction between device types would not be a perfe=
ct
> solution in all cases.  I agree.  So?)
>
> > And with iSCSI not only
> > can you encapsulate a SCSI command stream over USB, you can do so o=
ver
> > IP as well.
>
> Yup.  And you've been able to make a network block device for years. =
 They
> showed up as /dev/nd0, a distinct type of block device which you (and=
 your
> scripts) could find.  Now yet another way of doing the same thing is =
mixed
> into the same scsi bucket and given a stir...
>
> > In any case, regardless of how the physical SATA drive is
> > attached to the system, you want it to show up as the same device a=
nd
> > be mounted in the same location.
>
> If my laptop's hard drive reliably showed up as /dev/sda every time, =
and I
> could count on that, I wouldn't be complaining about it.  The entire =
problem
> is that it isn't guaranteed to do that, and thus /etc/fstab is a nigh=
tmare I
> can't edit.
>
> You could meet this definition of "the same" by having every block de=
vice in
> the system show up as /dev/block[a-z] no matter what type it was, and=
 all the
> char devices show up as /dev/char[aa-zz], shuffle them all each reboo=
t, and
> then have all the programs iterate through all of them any time they =
wanted
> something specific.
>
> I'm rather glad that /dev/ttyS0 and /dev/zero aren't easy to mix up.
>
> > That's why identifying filesystem by UUID's or Labels is so critica=
l.
> > This is not a new concept; we've had the capability to do this for
> > over a decade, and I always knew it would be necessary for us to do
> > this sooner or later --- which is why I added the UUID support to e=
xt2
> > back in 1996.
>
> It's necessary for IBM big iron to do this.  It's generally not neces=
sary for
> laptops or embedded systems to do this if they distinguish between _t=
ypes_ of
> devices, which is something they until recently did for the types of =
devices
> I was interested in, and something they _stopped_ doing when everythi=
ng got
> merged into the scsi layer, and I consider this a regression.
>
> No, distinguishing between types of devices is not a perfect solution=
 to
> device enumeration, but it was sufficient for all my use cases for ma=
ny
> years, and would still be if the kernel still did it, and I'm not alo=
ne here.
>
> > > The fact that udev can theoretically unwind this hairball is not =
an
> > > excuse for conflating different categories of devices in the firs=
t
> > > place.
> >
> > See the thinkpad Ultrabay drive example above.
>
> Last week I drove my laptop so deep into swap (with a "make -j" on qe=
mu) that
> after half an hour trying to repaint my kmail window, it locked solid=
=2E
> Again.  You'd think the oom killer would come to the rescue, but it d=
idn't.
> Maybe Ubuntu disabled it.  I have _2_gigs_ of ram in this sucker, on =
a stock
> Ubuntu 7.04 install (with the "upgrade all" tab pressed a few times),=
 and yet
> I managed to make it swap itself to death one more time.
>
> Virtual memory isn't perfect.  I've _always_ been able to come up wit=
h
> examples where it just doesn't work for me.  This doesn't mean VM ove=
rcommit
> should be abolished, because it's useful more often than not.
>
> So you have a counterexample.  Ok.  I can't actually see how your
> counterexample would be worse off than it is now; just differently wo=
rse off.
>
> > You address hosts by
> > IP address; it doesn't matter whether you access them via a PPP
> > interface, or a wireless interface, or a ethernet interface.
>
> It does when I'm configuring the interfaces.
>
> > Similarly, a disk could in theory be accessible over USB, SATA, or
> > iSCSI, and the Thinkpad example is only one such where the same
> > filesystem might be accessible over multiple interfaces.  And with
> > multipath fiber channel SAN's (and I hate to break it to you, but F=
C
> > also uses SCSI protocols) storage is very much looking more and mor=
e
> > like networking.
>
> And in the networking world I'm able to say that this local machine h=
as a
> static IP that is not world-routable.  It is separate, manually confi=
gured, I
> put it _right_here_, and I personally know that it's not going to mov=
e
> because I'm the one who put it there and I'm the only one who would m=
ove it.
>
> Over on the networking side of things I can "ifconfig lo 127.0.0.1" w=
ithout
> first probing all the interfaces to figure out which one's loopback a=
nd which
> one's the wireless card.
>
> I note that the eth0 and eth1 names are dynamically assigned on a fir=
st come
> first serve basis (like scsi).  This never causes me a problem becaus=
e the
> driver loading order is constant, and once you figure out that eth0 i=
s
> gigabit and eth1 is the 80211g it _stays_ that way across reboots, re=
liably.
> Yeah, it's a heuristic.  Hands up everybody relying on such a heurist=
ic in
> the real world.

     It' also easier because you have the MAC address to help.

> Possibly one solution here is to document that the SATA drivers load
> before any other scsi device, and the driver subsystem _waits_ for
> that to finish enumerating before trying any other kind of scsi devic=
e,
> with a barrier of some kind), and then any SATA devices present at
> boot time will reliably get those names in that order (no races, no
> variation) and anything after that is a separate problem.  (Of course
> this would involve making it true if it currently isn't.  It's still =
a mess to
> dump all sorts of different devices in the same namespace, but at
> least for the common case of a laptop with a SATA root partition this
> would let us get the UUID out of /etc/fstab).

     There is also the need to ensure that each distribution loads the =
ahci
  driver before any other SCSI or emulated SCSI host. It looks as if Ub=
untu
  does not do it that way (I've tried to understand the module probing =
logic
  in the initramfs but have miserably failed; too much magic probably).

    Remember that udevd starts your holy external hard disk, not the
  UUID in /etc/fstab (obiously if you have an UUID in fstab, you need u=
dev
  to probe for it, but it'll do it regardless of whether or not UUSID i=
s present
  in fstab.

    Regards,

          Lo=EFc
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
