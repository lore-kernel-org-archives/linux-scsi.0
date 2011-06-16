From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 01:04:55 +0200
Message-ID: <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
 <1308264321.2436.161.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1308264321.2436.161.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 17, 2011 at 00:45, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-06-17 at 00:05 +0200, Kay Sievers wrote:
>> On Thu, Jun 16, 2011 at 22:31, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Thu, 2011-06-16 at 11:19 -0700, Greg KH wrote:
>> >> On Thu, Jun 16, 2011 at 12:25:06PM -0400, James Bottomley wrote:
>> >> > On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>>
>> >> > > No, udev can not create such a link after the preferred name =
is set, as
>> >> > > it has no way of knowing that the name was set.
>> >> >
>> >> > It can if we trigger a uevent. =C2=A0Note: I'm not advocating t=
his ... I'd be
>> >> > equally happy having whatever sets the kernel name create the l=
ink (or
>> >> > tickle udev to create it). =C2=A0We definitely require device l=
inks, though,
>> >> > to get this to work.
>> >>
>> >> And no, I don't want to trigger a uevent, Kay pointed out where t=
his
>> >> will go very wrong very quickly if this is done.
>> >
>> > As I said: we just need a by-preferred type of link.
>>
>> And if the user changes the name, the link and all earlier uses will
>> be dangling, even /proc/mounts might show non-existing device names.
>
> I don't understand this. =C2=A0If a user decides to call sda "fred" b=
y doing
> an echo to the preferred named file, then there should be a link
>
> /dev/disk/by-preferred/fred -> ../../sda
>
> Even if the name later changes to "angela", /dev/disk/by-preferred/fr=
ed
> will be valid if we don't clean it up.

Not currently, udev needs to keep track of all symlinks, and removes
the ones not specified in rules. There is not way for udev to track no
longer valid names.

We can not just add stuff to /dev without a udev database entry, it
would never get removed on device unplug and leave a real mess behind.

>> I honestly don't think there will ever be _the_ name for a device.
>> We've been there, stuff seems not to work that way in the real world=
=2E
>
> So that's not really the point ... all we do with it in-kernel is use=
 it
> as the device name for log prints and some basic /proc files (again,
> mainly as prints); nothing more.
>
>> I really like to hear how stuff is supposed to compose _the_ name in=
 a
>> real world use-case like a multipath setup, in initramfs, in a heavy
>> hotplug setup, and so on ... And with more details than "udev will s=
et
>> _the_ name", I really fail to see how that is supposed to happen to =
be
>> useful.
>
> All that really has to happen is that we get a database of 1:1
> correspondence between preferred name and actual name (with device
> links).
>
>> I think any solution that assumes the name can change later after it
>> is possibly already used, is just wishful thinking.
>
> The ability to change on the fly isn't part of the original hitachi
> proposal, but I don't really see why it can't ... it just alters the =
way
> the kernel prints out the name, nothing more.

And creates a huge problem for everything that uses that name.

>> We need many names, and we need all of them from the very beginning,
>> and they should not change during device lifetime unless the device
>> state changes.
>
> So that's actually an argument for leaving the links, surely? =C2=A0W=
e can
> have many inbound links, but the kernel can only print one name in
> messages, which would be the preferred name that was currently set.

I really question any concept of _the_ name. My take on it: It will
never work in reality.

>> >> > > So as userspace tools will still need to be fixed, I don't se=
e how
>> >> > > adding a kernel file for this is going to help any. =C2=A0Wel=
l, a bit in that
>> >> > > the kernel log files will look "different", but again, that r=
eally isn't
>> >> > > a problem that userspace couldn't also solve with no kernel c=
hanges
>> >> > > needed.
>> >> >
>> >> > This is true, but I think for the small effort it takes to impl=
ement the
>> >> > feature in-kernel compared with what we'd have to do to the
>> >> > distributions to get it implemented in userspace (we'd need klo=
gd to do
>> >> > the conversion for dmesg ... I'm entirely unclear what we need =
to modify
>> >> > for /proc/partitions, etc.) the benefit outweighs the cost.
>> >> >
>> >> > Additionally, since renaming is something users seem to want (j=
ust look
>> >> > at net interfaces), if we can make this work, we now have a def=
initive
>> >> > answer to point people at.
>> >>
>> >> Renaming is something that we do NOT want to do, as we have learn=
ed our
>> >> lesson of the network device renaming mess. =C2=A0And as Kay poin=
ted out, we
>> >> already have an "alias" name there, which no one uses.
>> >
>> > Look at this as an opportunity to get it right. =C2=A0The original=
 proposal
>> > was for renaming. =C2=A0By iterating over the actual requirements,=
 we have it
>> > reduced to simply having the kernel print a preferred name. =C2=A0=
I think
>> > that's a nice achievement which we can point other proponents of
>> > renaming to as they arise.
>>
>> Sure, we absolutely don't want renaming, and we can provide countles=
s
>> solid technical reasons why we should not allow it to happen. But I'=
m
>> also pretty sure, we also don't want just-another-single-name to put
>> somewhere in the kernel.
>
> I understand why we don't want renaming. =C2=A0However, the technical=
 reason
> why we want a preferred name is that it's often associated with a nam=
e
> printed somewhere on the box (say a label on the disk enclosure, or
> ethernet port). =C2=A0Not being able to use this name to address the =
device
> is a usability issue which annoys the enterprise enormously.
>
> So if we stop there, regardless of solution (in-kernel or fix all
> userspace), does everyone see what the actual problem is?

I don't think that solves the problem, no. We need _smart_ userspace
with a debug/error message channel from the kernel to userspace that
pops out _structured_ data. Userspace needs to index the data, and
merge a lot of userspace information into it.

Adding just another single-name to the kernel just makes the
much-too-dumb free-text printk() a bit more readable, but still sounds
not like a solution. Pimping up syslog is not the solution to this
problem, and it can't be solved in the kernel alone.

>> >> So again, I really don't like this, just fix the userspace tools =
to map
>> >> the proper device name that the kernel is using to the userspace =
name
>> >> the tool used, and all is fine. =C2=A0This has been done already =
today,
>> >> succesfully, by many of the big "enterprise" monitoring systems t=
hat
>> >> work quite well on Linux, proving that this is not something that=
 the
>> >> kernel needs to provide to implement properly.
>> >
>> > Well, it's expediency. =C2=A0Sure we could try to patch the world,=
 but I
>> > think the simple patch of getting the kernel to print a preferred =
name
>> > solves 90% of the problem. =C2=A0Sure there is a long tail of user=
space
>> > components that needs fixing, but that can be done gradually if we=
 take
>> > the kernel route. =C2=A0If we go the userspace route, it will be a=
 long while
>> > before we even get to 50% coverage.
>>
>> I need to ask again ask for an explanation why logging all symlinks =
at
>> device discovery from udev, does not solve exactly this problem. Wit=
h
>> that tag in the syslog message stream, all later kernel names can be
>> safely associated with _all_ the current device names in question,
>> until the next tag from udev is found.
>
> So if the user has one preferred name, us logging all the names (and =
we
> have quite a few for disks) doesn't really help because the user migh=
t
> want to choose a different name. =C2=A0However, even if we assume the=
y choose
> one of the current names, they still have to do the mapping manually;
> even if they have all the information, they can't just cut and paste
> from dmesg say, they have to cut, edit the buffer to put in the
> preferred name and then paste ... that's just one annoying step too f=
ar
> for most users. =C2=A0I agree that all the output tools within reason=
 can be
> fixed to do this automatically, but fixing cat say, just so
> cat /proc/partitions works would never be acceptable upstream.
>
> The reason for storing this in the kernel is just that it's easier th=
an
> trying to update all the tools, and it solves 90% of the problem, whi=
ch
> makes the solution usable, even if we have to update tools to get to
> 100%.

I don't think we can even solve 10% of the problems that way. It's
just a hack that makes stuff a bit more pretty, but doesn't provide
any reasonable solution to the problem. I doubt we can even make a
simple use case out of it, what name to put into that field for a
multipath setup.

Kay
