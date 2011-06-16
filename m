From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 00:05:38 +0200
Message-ID: <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1308256290.2436.143.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2011 at 22:31, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2011-06-16 at 11:19 -0700, Greg KH wrote:
>> On Thu, Jun 16, 2011 at 12:25:06PM -0400, James Bottomley wrote:
>> > On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:

>> > > No, udev can not create such a link after the preferred name is =
set, as
>> > > it has no way of knowing that the name was set.
>> >
>> > It can if we trigger a uevent. =C2=A0Note: I'm not advocating this=
 ... I'd be
>> > equally happy having whatever sets the kernel name create the link=
 (or
>> > tickle udev to create it). =C2=A0We definitely require device link=
s, though,
>> > to get this to work.
>>
>> And no, I don't want to trigger a uevent, Kay pointed out where this
>> will go very wrong very quickly if this is done.
>
> As I said: we just need a by-preferred type of link.

And if the user changes the name, the link and all earlier uses will
be dangling, even /proc/mounts might show non-existing device names.

I honestly don't think there will ever be _the_ name for a device.
We've been there, stuff seems not to work that way in the real world.

I really like to hear how stuff is supposed to compose _the_ name in a
real world use-case like a multipath setup, in initramfs, in a heavy
hotplug setup, and so on ... And with more details than "udev will set
_the_ name", I really fail to see how that is supposed to happen to be
useful.

I think any solution that assumes the name can change later after it
is possibly already used, is just wishful thinking.

We need many names, and we need all of them from the very beginning,
and they should not change during device lifetime unless the device
state changes.

>> > > So as userspace tools will still need to be fixed, I don't see h=
ow
>> > > adding a kernel file for this is going to help any. =C2=A0Well, =
a bit in that
>> > > the kernel log files will look "different", but again, that real=
ly isn't
>> > > a problem that userspace couldn't also solve with no kernel chan=
ges
>> > > needed.
>> >
>> > This is true, but I think for the small effort it takes to impleme=
nt the
>> > feature in-kernel compared with what we'd have to do to the
>> > distributions to get it implemented in userspace (we'd need klogd =
to do
>> > the conversion for dmesg ... I'm entirely unclear what we need to =
modify
>> > for /proc/partitions, etc.) the benefit outweighs the cost.
>> >
>> > Additionally, since renaming is something users seem to want (just=
 look
>> > at net interfaces), if we can make this work, we now have a defini=
tive
>> > answer to point people at.
>>
>> Renaming is something that we do NOT want to do, as we have learned =
our
>> lesson of the network device renaming mess. =C2=A0And as Kay pointed=
 out, we
>> already have an "alias" name there, which no one uses.
>
> Look at this as an opportunity to get it right. =C2=A0The original pr=
oposal
> was for renaming. =C2=A0By iterating over the actual requirements, we=
 have it
> reduced to simply having the kernel print a preferred name. =C2=A0I t=
hink
> that's a nice achievement which we can point other proponents of
> renaming to as they arise.

Sure, we absolutely don't want renaming, and we can provide countless
solid technical reasons why we should not allow it to happen. But I'm
also pretty sure, we also don't want just-another-single-name to put
somewhere in the kernel.

>> So again, I really don't like this, just fix the userspace tools to =
map
>> the proper device name that the kernel is using to the userspace nam=
e
>> the tool used, and all is fine. =C2=A0This has been done already tod=
ay,
>> succesfully, by many of the big "enterprise" monitoring systems that
>> work quite well on Linux, proving that this is not something that th=
e
>> kernel needs to provide to implement properly.
>
> Well, it's expediency. =C2=A0Sure we could try to patch the world, bu=
t I
> think the simple patch of getting the kernel to print a preferred nam=
e
> solves 90% of the problem. =C2=A0Sure there is a long tail of userspa=
ce
> components that needs fixing, but that can be done gradually if we ta=
ke
> the kernel route. =C2=A0If we go the userspace route, it will be a lo=
ng while
> before we even get to 50% coverage.

I need to ask again ask for an explanation why logging all symlinks at
device discovery from udev, does not solve exactly this problem. With
that tag in the syslog message stream, all later kernel names can be
safely associated with _all_ the current device names in question,
until the next tag from udev is found.

Kay
