From: Martin Dalecki <dalecki@evision-ventures.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Fri, 21 Jun 2002 00:29:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D125735.7000805@evision-ventures.com>
References: <Pine.LNX.4.33.0206201230190.654-100000@geena.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: Linus Torvalds <torvalds@transmeta.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

U=BFytkownik Patrick Mochel napisa=B3:
>>But:
>>
>>1. There was the mistake of using different major numbers
>>for SCSI and IDE/ATAPI devices. (disk and CD-ROM are the most strikin=
g).
>>
>>2. Then came devfs along and promised to slove this problem.
>>    But people still complained about not beeing ablve to boot, after
>>    I changed the registration name for IDE devices from "ide" to "at=
a".
>>    This showed nicely that devfs doesn't cut it. It's useless for
>>    the purpose of unification of access methods apparently.
>>
>>3. Now comes driverfs, which is basically a Solaris driver tree clone=
 and
>>    *repeats* the same errors as 1. and 2.:
>=20
>=20
> driverfs is not a Solaris driver tree clone. Sure, it's similar, but =
I=20
> assure no inspiaration was derived from Solaris. The same is true for=
 the=20
> Windows Driver Model (though bits of inspiration may have filtered in=
to=20
> the initial driver tree from WDM via the ACPI people).

Yes that's the pitty :-).

> driverfs does not care about major and minor numbers (yet).=20
>=20
> driverfs does not attempt to replace the /dev hierarchy.
>=20
> That said, driverfs will use major/minor numbers in the future, but i=
t
> will not care about what they are or who owns them. It will also offe=
r a
> solution to the device naming problem (like devfs), and provide a=20
> mechanism for maintaining /dev compatability. But, I'm foreshadowing.=
=20

Irony by someone remembering the days devfs wasn't in the main
kernel tree and who was against it:
I tought devfs already solves those problems...


> You mean e.g. ./bus/pci/drivers/ ? I don't think it's useless at all.=
 It=20
> provides a mechanism for drivers to export attributes specific to the=
=20
> drivers themselves (and not specific to a particular device). For exa=
mple,=20
> if you want to turn on debugging on the fly in the e100 driver, it co=
uld=20
> export a 'debug' file, which the user could toggle. It would turn on=20
> debugging for the entire driver on the fly.=20

Interface on the heap phenomena. If someone writing a driver wished to =
have
this he could have registered some sysctl already. Becouse
this is precisely the interface fitting the purpose you describe.

> It likely has a module parameter to do the same thing. But, that para=
meter=20
> is not available if you statically compile it into the kernel. And, m=
odule=20
> parameters are not tweakable on the fly.=20

See above - sysctl.

> Rusty and I are talking at the kernel workshop on Monday about parame=
ters. =20
> One of the topics is where module parameters leave off and driverfs s=
tarts
> up. It would be really really nice to unify the representation of the=
se
> types of parameters.=20

Indeed yes but it doesn't have to be done under the umbrella of
driverfs.

> Plus, something that is easy to do is create symlinks in the drivers'=
=20
> directory to the devices in the physical hierarchy for the devices it=
's=20
> driving.=20

??


>>The bus suffix. is useless for any purpose I can imagine.
>>Which kind of view is the above supposed to present?
>=20
>=20
> It's the 'bus' view. Each bus should have a struct bus_type object th=
at it=20
> registers on startup. (See the documentation I sent out a couple of w=
eeks=20
> ago). It's then inserted into a flat list of bus types.=20
>=20
> Each bus keeps a list of devices and drivers. These lists are moved t=
o the=20
> struct bus_type for centralized management.=20
>=20
> Everything is exported via driverfs because it's easy to do so, and=20
> because it can potentially be very useful.=20
>=20
>=20
>>./root
>>
>>2. What is this root prefix good for?!
>=20
>=20
> Every system has the concept of a 'root' device. It's a virtual devic=
e=20
> that doresn't physically exist. It's the start of the device tree.=20

That's called /. BTW. If anything I'm missing there is the
representation of the very first BUS out there: CPU!!!

>>./root/pci0
>>
>>3. Solaris is separating the name and enumeration part by @ for
>>good reaons.
>=20
>=20
> 'pci0' is the bus ID of the first PCI bridge. Devices that exist on t=
he=20
> board itself and not on a peripheral bus don't have a standard for bu=
s=20
> IDs. So, I went with <canonical name><instance number>. I thought it =
was=20
> pretty clear what it meant...

Yes and the *@* should be there to separate naming from enumeration par=
t.
However I see in the above hierarchy no clear mandate for
where enumeration does happen - dir name subdirs named 0, 1, 2, 3,

>>./root/pci0/00:0c.1
>>./root/pci0/00:0c.1/resources

> I don't want driverfs to end up like procfs with the random formattin=
g
> problem. I want driverfs files to be ASCII-only files with one value =
per
> file. This cannot be programmatically enforced, so we must rely on so=
cial
> engineering to enforce it.=20

=46orget it. I have warned against those problems even before /proc
became mandatory. You see now where we are. You are just moving
the arbitrary part away from the content to the fs name level.

> [ Also, the resources file also violates the second rule, since it's =
an=20
> array of information, but I don't know any better way to represent th=
is. ]

You see: ascii files are *evil* not just due to buffer overrun attacks.

> driverfs files are named attribute pairs, where the name of the attri=
bute=20
> is the name of the file, and the value is the contents. I've talked w=
ith=20
> people before about making them even easier to create, read, and writ=
e, in=20
> ways that enforce one value of a specific type to be exported. (I.e.=20
> making them very restrictive). Someday...
>=20
>=20
>>./root/pci0/00:0c.1/irq
>>
>>5. This is showing that the resources file above is useless, becouse
>>I would rather love to consider irq as a resource.
>=20
>=20
> Sure, but it's a separate field.=20
>=20
>=20
>>./root/pci0/00:0c.1/power
>>./root/pci0/00:0c.1/name
>>
>>6. The /name is entierly redundant logically to the fact that we
>>have already a unique path to the device. For "pretty" printing
>>we have userspace. For PCI it's for example repeating the
>>ID info found already by lspci.
>=20
>=20
> Sure. But, we already have the information in struct device. Instead =
of=20
> using lspci, lsusb, lsfoo to ascertain the name, you can just cat the=
 name=20
> file for any device on the system. (Though, I basically agree with th=
e=20
> premise that that information doesn't need to be in the kernel in the=
=20
> first place)

Argument frequently enough repeated by the advertisers of
the /proc mess... The kernel should be what it's name says -
just the kernel of the things and not the all for everything.

>>./root/pci0/00:07.2/usb_bus
>>
>>7. What is the _bus? suffix good for? How does this releate
>>to the /bus hierarchy?
>=20
>=20
> It says that it's a USB hub. I believe the information is redundant, =
and=20
> there should be a patch to remove it. Greg? :)
>=20
>=20
>>./root/pci0/00:07.2/usb_bus/00
>>
>>9. Contrary to PCI we enumerate the busses apparently
>>by one dir level and not a suffix on the usb prefix.

You see I understood that pci0 is for the first bridge.
And you see that in comparision to /proc you are moving
the "arbitrary" part just from the file level to the directory
level.

Once reason I advertize for short names is the fact
that they will prevent people psychologicall from inventing
names like:

/devices/pci0/..../my_beloved_toy_device_which_....


> Yes, the directory names are bus-specific identifiers for the device.=
 It's=20
> up to the bus enumerator to determine what they are, and really don't=
 make=20
> any sense outside of the bus context.=20
>=20
>=20
>>./root/pci0/00:07.1/ata@00
>>./root/pci0/00:07.1/ata@00/sd@0,0
>>./root/pci0/00:07.1/ata@00/sd@0,0/power
>>./root/pci0/00:07.1/ata@00/sd@0,0/name
>>./root/pci0/00:07.1/ata@00/power
>>./root/pci0/00:07.1/ata@00/name
>>
>>Here I'm trying to fit the whole in some kind of
>>physical view. I did sneak in the sd instead of
>>hd in the futile hope that SCSI will pick up the same
>>name. And I buy in to the idea of separating
>>the enumeratin for the naming by a @.
>>This way one has only to enumerate the
>>dir only and no room for possible ambiguity is present.
>=20
>=20
> ata@00 is the controller, right? And sd@0,0 is the first disk on the =
first
> channel?? You don't need the former. It's already present as PCI devi=
ce
> 00:07.1, and you shouldn't have a duplicate entry.=20
>=20
> sd@0,0 can simply be 0,0 (though I don't personally like commas). You=
=20
> don't really _need_ any more context in there, since it's implied by =
your=20
> location in the tree.

I would love to distingish between device types sd - disk
sr - -CD-ROM DVD or whatever.
Please note that you have only one single PCI device but from
the physical perspecitve two buses hanging down from it called
channels (The ribbon between the disk and controller).
So a ATA host chip controller is basically even in reality
a PCI to ISA bus bridge. For example it's quite common
in notebooks to use the second ATA channel precisely as a bridge
between the host PCI and ISA on the expander....
Just forget that there is usually only a master and slave
on this bus please.

> Partitions are purely logical entities on a physical disk. They have =
no=20
> presence in the physical device tree.=20

Device drivers are purely logical entities of the kernel. They have
no presence in the physical device tree.

But they have a presence in /dev/ and are the entity we act on.

>>However we can see that the driver filesystem is
>>inconsistant on the kind of enumeration it should
>>provide. See the colon in sd@0,0 and the whole subdir
>>crazyness... So do we distingish different devices by a subdir?
>>Or do we do it by an unique enumeration suffix?

> I imagine we'll have a lot to discuss in Ottawa...

Yeep. I'm looking forward to it. Let's count the ARM CPUs attached
to my notebook after some real beer :-).

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
