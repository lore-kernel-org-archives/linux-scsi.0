From: EXT / DEVOTEAM VAROQUI Christophe
	 <ext.devoteam.varoqui@sncf.fr>
Subject: [DOC] Linux multipath implementation
Date: Mon, 16 Feb 2004 13:49:45 +0100
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <A979D299E02AD31188EA0000834A03D20875831F@S64P17BIA40>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C3F48B.5A52B6AC"
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "'linux-lvm@redhat.com'" <linux-lvm@redhat.com>, "'linux-hotplug-devel@lists.sourceforge.net'" <linux-hotplug-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C3F48B.5A52B6AC
Content-Type: text/plain;
	charset="iso-8859-1"

Hello,

I would like to submit this doc to your criticism.
Beware, the english will certainly be awful, as I'm not anglozone native.
I will take any guidance about what to do to make it useful for the widest
audiance.

 <<multipath.html>> 
regards,
cvaroqui

------_=_NextPart_000_01C3F48B.5A52B6AC
Content-Type: text/html;
	name="multipath.html"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="multipath.html"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">=0A=
<HTML>=0A=
<HEAD>=0A=
	<META HTTP-EQUIV=3D"CONTENT-TYPE" CONTENT=3D"text/html; =
charset=3Dutf-8">=0A=
	<TITLE></TITLE>=0A=
	<META NAME=3D"GENERATOR" CONTENT=3D"OpenOffice.org 1.1.0  (Linux)">=0A=
	<META NAME=3D"CREATED" CONTENT=3D"20040215;13342400">=0A=
	<META NAME=3D"CHANGED" CONTENT=3D"20040216;13450400">=0A=
	<STYLE>=0A=
	<!--=0A=
		@page { size: 21.59cm 27.94cm }=0A=
	-->=0A=
	</STYLE>=0A=
</HEAD>=0A=
<BODY LANG=3D"en-US" DIR=3D"LTR">=0A=
<H1>The Linux multipath implementation</H1>=0A=
<P>Original author : Christophe Varoqui, Feb 2004</P>=0A=
<P>This document is shared under the OpenContent Licence=0A=
(<A =
HREF=3D"http://www.opencontent.org/opl.shtml">http://www.opencontent.org=
/opl.shtml</A>)</P>=0A=
<P STYLE=3D"margin-top: 0.42cm; page-break-after: avoid"><FONT =
FACE=3D"Albany, sans-serif"><FONT =
SIZE=3D4>Introduction</FONT></FONT></P>=0A=
<P>The most common multipathed environment today is a Fibre Channel=0A=
(FC) Storage Area Network (SAN). This beasts can be found in most=0A=
Datacenters. The lego blocks forming a SAN are :</P>=0A=
<UL>=0A=
	<LI><P>FC switchs : core switchs (multiprotocols chassis and FC=0A=
	boards), or stacked switchs linked by Inter Switch Links (ISL). =
This=0A=
	layer, the Fabric layer, can be subdived in two major fabric types =
:</P>=0A=
	<UL>=0A=
		<LI><P>Simple fabrics : all storage ports can be routed to all=0A=
		hosts ports. Hosts an storage controlers can have a single=0A=
		attachement to the the fabric.</P>=0A=
		<LI><P>Dual independent Fabrics : two sets of switchs are=0A=
		completely segregated (no ISL). They form two independent naming=0A=
		domains. The hosts and storage controlers must be attached the the=0A=
		two fabrics to assure redondancy. This technology is used to=0A=
		provide the maximum availability as one fabric can be shut, for=0A=
		planned or unplanned reasons, without pertubation seen on the =
other=0A=
		one.</P>=0A=
	</UL>=0A=
	<LI><P>FC storage controlers : most of them provide multiple ports=0A=
	to attach to the switchs layer. The physical storage they drive is=0A=
	arranged in virtual drives we will refer to as Logical Units (LU).=0A=
	Each LU is provided by its host controler a unique identifier as =
per=0A=
	the SCSI standard. We will refer to this identifier as the World=0A=
	Wide Identifier (WWID) or World Wide Name (WWN).</P>=0A=
	<LI><P>Host Bus Controlers (HBA) : the PCI / FC coupling adapters. =
A=0A=
	server can embed multiple HBA.</P>=0A=
</UL>=0A=
<P>The multipath term simply means that a host can acess a LU by=0A=
muliple paths, the path being a route from one host HBA port to one=0A=
storage controler port.</P>=0A=
<TABLE WIDTH=3D100% BORDER=3D1 CELLPADDING=3D4 CELLSPACING=3D3 =
STYLE=3D"page-break-inside: avoid">=0A=
	<COL WIDTH=3D256*>=0A=
	<THEAD>=0A=
		<TR>=0A=
			<TD WIDTH=3D100% VALIGN=3DTOP BGCOLOR=3D"#cccccc">=0A=
				<P>Examples :</P>=0A=
				<UL>=0A=
					<LI><P>A host with 2 HBA attached to a single fabric is=0A=
					presented a LU by a 4 ports storage controler. The host then =
see=0A=
					8 paths to the LU</P>=0A=
					<LI><P>A host with 2 HBA attached to a dual independent fabric=0A=
					(1 HBA on eache fabric) is presented a LU by a 4 ports storage=0A=
					controler (2 ports on each fabric). The host then see 4 paths =
to=0A=
					the LU : 2 paths through fabric A, plus 2 through the fabric =
B.</P>=0A=
				</UL>=0A=
			</TD>=0A=
		</TR>=0A=
	</THEAD>=0A=
</TABLE>=0A=
<P><BR><BR>=0A=
</P>=0A=
<P>The Linux kernel choose not the mask the individual paths, that=0A=
appears as normal SCSI Disks (SD).</P>=0A=
<P>Multipath awareness and support for an operating system can be=0A=
described as :</P>=0A=
<UL>=0A=
	<LI><P>Provide a single block device node for a multipathed LU</P>=0A=
	<LI><P>Ensure that IO are re-routed to available paths when a loss=0A=
	of path occurs, with no userspace process disruption other than an=0A=
	short pause.</P>=0A=
	<LI><P>Ensure that failed paths get revalidated as soon as =
possible</P>=0A=
	<LI><P>Ensure stability of the naming of that node</P>=0A=
	<LI><P>Configure the multipaths to maximize performance : spread IO=0A=
	when possible path switching is free, and not spread when it's=0A=
	costly. =0A=
	</P>=0A=
	<LI><P>Configure the multipaths automatically early at boot to=0A=
	permit OS install on a multipathed LU</P>=0A=
	<LI><P>Reconfigure the multipaths automatically when events =
occur</P>=0A=
	<LI><P>The multipath must be partitionable</P>=0A=
	<LI><P>In the Linux way : simple and hardware vendor agnostic</P>=0A=
</UL>=0A=
<P>All these goals are met by leveraging a set of userspace tools =
ans=0A=
kernel subsystems :</P>=0A=
<UL>=0A=
	<LI><P>the kernel device mapper</P>=0A=
	<LI><P>the hotplug kernel subsystem</P>=0A=
	<LI><P>the udev device naming tool</P>=0A=
	<LI><P>the multipath userspace configuration tool</P>=0A=
	<LI><P>the kpartx userspace configuration tool</P>=0A=
	<LI><P>the early userspace Linux kernel boot environment</P>=0A=
</UL>=0A=
<P>The rest of this document describes these individual tools and=0A=
subsystems and their interactions.</P>=0A=
<P><FONT FACE=3D"Albany, sans-serif"><FONT SIZE=3D4>Device =
Mapper</FONT></FONT></P>=0A=
<P>Starting with Linux kernel 2.6, a new lightweight block subsystem=0A=
named Device Mapper enables advanced storage management with style.=0A=
This component features a plugable design. At the time of this=0A=
writing available plugins are :</P>=0A=
<UL>=0A=
	<LI><P>segments concatenation</P>=0A=
	<LI><P>segment striping</P>=0A=
	<LI><P>segment snapshoting</P>=0A=
	<LI><P>segment mirroring, with and without persistance</P>=0A=
	<LI><P>segment on-the-fly encryption</P>=0A=
	<LI><P>segment multipathing</P>=0A=
</UL>=0A=
<P>This last policy is the core component of the multipath tool=0A=
chain. It is not included in the main kernel tree as of linux-2.6.3.=0A=
It is part of a patchset maintained by Joe Thornber (thornber at=0A=
redhat dot com) that can be downloaded at=0A=
<A =
HREF=3D"http://people.sistina.com/~thornber/dm/">http://people.sistina.c=
om/~thornber/dm/</A></P>=0A=
<P>This component fills the following requirements :</P>=0A=
<UL>=0A=
	<LI><P>Provide a single block device node for a multipathed LU</P>=0A=
	<LI><P>Ensure that IO are re-routed to available paths when a loss=0A=
	of path occurs, with no userspace process disruption other than an=0A=
	short pause.</P>=0A=
	<LI><P>Ensure that failed paths get revalidated as soon as =
possible</P>=0A=
</UL>=0A=
<P>So, let's see how it works.</P>=0A=
<P>The Device Mapper is configured one map at a time. A device map,=0A=
also referred to as a table, is a list of segments in the form of =
:</P>=0A=
<TABLE WIDTH=3D100% BORDER=3D1 CELLPADDING=3D4 CELLSPACING=3D3 =
STYLE=3D"page-break-inside: avoid">=0A=
	<COL WIDTH=3D256*>=0A=
	<THEAD>=0A=
		<TR>=0A=
			<TD WIDTH=3D100% VALIGN=3DTOP BGCOLOR=3D"#cccccc">=0A=
				<P STYLE=3D"margin-bottom: 0cm"><FONT FACE=3D"Courier, =
monospace">0=0A=
				35258368 linear 8:48 65920</FONT></P>=0A=
				<P STYLE=3D"margin-bottom: 0cm"><FONT FACE=3D"Courier, =
monospace">35258368=0A=
				35258368 linear 8:32 65920</FONT></P>=0A=
				<P STYLE=3D"margin-bottom: 0cm"><FONT FACE=3D"Courier, =
monospace">70516736=0A=
				17694720 linear 8:16 17694976</FONT></P>=0A=
				<P><FONT FACE=3D"Courier, monospace">88211456 17694720 linear =
8:16=0A=
				256</FONT></P>=0A=
			</TD>=0A=
		</TR>=0A=
	</THEAD>=0A=
</TABLE>=0A=
<P><BR><BR>=0A=
</P>=0A=
<P>The first 2 parameters of each line are the segment starting =
block=0A=
in the virtual device and the lengh of the segment. The next keyword=0A=
ist the target policy (linear). The rest of the line is the target=0A=
parameters.</P>=0A=
<P>The Device Mapper can be fed its tables through the use of a=0A=
library : libdevmapper. Dmsetup, LVM2, the multipath configuration=0A=
tool and kpartx all link this lib. A table setup boils down to=0A=
sprintf'ing the right segment definitions in a char *. Should the DM=0A=
user-kernel interface change from being ioctl based to a pseudo=0A=
filesystem, the libdevmapper API should remain stable.</P>=0A=
<TABLE WIDTH=3D100% BORDER=3D1 CELLPADDING=3D4 CELLSPACING=3D3 =
STYLE=3D"page-break-inside: avoid">=0A=
	<COL WIDTH=3D256*>=0A=
	<THEAD>=0A=
		<TR>=0A=
			<TD WIDTH=3D100% VALIGN=3DTOP BGCOLOR=3D"#cccccc">=0A=
				<P>Here is an example of a multipath target :</P>=0A=
				<P><FONT FACE=3D"Courier, monospace">0 27262976 multipath 10 2 1=0A=
				round-robin 2 0 /dev/sda /dev/sdk 1 round-robin 2 0 /dev/sdc=0A=
				/dev/sdm</FONT></P>=0A=
			</TD>=0A=
		</TR>=0A=
	</THEAD>=0A=
</TABLE>=0A=
<P><BR><BR>=0A=
</P>=0A=
<P>The multipath target parameters are :</P>=0A=
<UL>=0A=
	<LI><P>$0 : the =E2=80=9Cmultipath=E2=80=9D keyword</P>=0A=
	<LI><P>$1 : the test IO posting interval, used to revalidate failed=0A=
	paths, in seconds</P>=0A=
	<LI><P>$2 : the number of priority groups for the segment</P>=0A=
	<LI><P>$3 : the first priority group parameters :</P>=0A=
	<UL>=0A=
		<LI><P>$3.1 : the priority of this PG</P>=0A=
		<LI><P>$3.2 : the scheduler to be used to spread IO inside the =
PG</P>=0A=
		<LI><P>$3.3 : the number of paths in the PG</P>=0A=
		<LI><P>$3.4 : the number of paths parameters (usualy 0)</P>=0A=
		<LI><P>$3.5 : the paths list for this PG</P>=0A=
	</UL>=0A=
	<LI><P>$4 : next priority group</P>=0A=
</UL>=0A=
<TABLE WIDTH=3D100% BORDER=3D1 CELLPADDING=3D4 CELLSPACING=3D3 =
STYLE=3D"page-break-inside: avoid">=0A=
	<COL WIDTH=3D256*>=0A=
	<THEAD>=0A=
		<TR>=0A=
			<TD WIDTH=3D100% VALIGN=3DTOP BGCOLOR=3D"#cccccc">=0A=
				<P>For completion, here is an example of a pure failover target=0A=
				definition for the same LU :</P>=0A=
				<P><FONT FACE=3D"Courier, monospace">0 27262976 multipath 10 4 1=0A=
				round-robin 1 0 /dev/sda 1 round-robin 1 0 /dev/sdc 1 =
round-robin=0A=
				1 0 /dev/sdk 1 round-robin 1 0 /dev/sdm</FONT></P>=0A=
				<P><FONT FACE=3D"Nimbus Roman No9 L">And a full spread =
(multibus)=0A=
				target one :</FONT></P>=0A=
				<P><FONT FACE=3D"Courier, monospace">0 27262976 multipath 10 1 1=0A=
				round-robin 4 0 /dev/sda /dev/sdc /dev/sdk /dev/sdm</FONT></P>=0A=
			</TD>=0A=
		</TR>=0A=
	</THEAD>=0A=
</TABLE>=0A=
<P><BR><BR>=0A=
</P>=0A=
<P>Upon device map creating, a new block kernel object named=0A=
dm-[0-9]* is instantiated, and a hotplug call is triggered. Each=0A=
device map can be assigned a symbolic name when created through=0A=
libdevmapper, but this name won't be available anywhere but through =
a=0A=
libdevmapper request.</P>=0A=
<P STYLE=3D"margin-top: 0.42cm; page-break-after: avoid"><FONT =
FACE=3D"Albany, sans-serif"><FONT SIZE=3D4>hotplug=0A=
subsystem and udev</FONT></FONT></P>=0A=
<P>Starting with Linux kernel 2.6, the hotplug callbacks are=0A=
commonized through the presence of a new pseudo filesystem : sysfs.=0A=
This filesystem presents to userspace kernel objects like bus, =
driver=0A=
instances or block devices in a hierarchicaly and homogenous manner.=0A=
The hotplug subsystem is leveraged by triggering a /sbin/hotplug =
call=0A=
upon file creation and deletion in the sysfs filesystem.</P>=0A=
<P>For our needs this facility provides :</P>=0A=
<UL>=0A=
	<LI><P>userspace callbacks upon paths additions and =
suppressions</P>=0A=
	<LI><P>userspace callbacks upon device maps additions and=0A=
	suppressions</P>=0A=
</UL>=0A=
<P>It may also provide in the future callbacks upon FC transport=0A=
events like a =E2=80=9CPort Database Rescan=E2=80=9D. This callbacks =
could then=0A=
be used to trigger SCSI Bus Rescan to bring a fully dynamic storage=0A=
layer.</P>=0A=
<P>Here is how we use this callbacks for the multipath =
implementation=0A=
:</P>=0A=
<UL>=0A=
	<LI><P>The paths additions and suppressions callbacks are routed to=0A=
	the multipath userspace configuration tool described later. This=0A=
	tool ensure the multipath maps are always up-to-date with the =
fabric=0A=
	topology, and this ensure optimal performance by adding new paths =
to=0A=
	the existing maps as soon as they become available.</P>=0A=
	<LI><P>The udev userspace tool is triggered upon every block sysfs=0A=
	entry creation and suppression, and assume the responsibility of =
the=0A=
	associated device node creation and naming. Udev default naming=0A=
	policies can be complemented by add-on scripts or binaries. As it=0A=
	does not currently have a default policy for device maps naming, we=0A=
	plug a little tool named devmap_name that resolve the sysfs=0A=
	dm-[0-9]* names in map names as set at map creation time. Provided=0A=
	the map naming is rightly done, this plugin provides the naming=0A=
	stability and meaningfullness required for a proper multipath=0A=
	implementation.</P>=0A=
	<LI><P>The userspace callbacks upon device maps additions and=0A=
	suppressions also triggers the kpartx tool to create the device =
maps=0A=
	over eventual partitions</P>=0A=
</UL>=0A=
<P>Udev is a reimplementation in userspace of the devfs kernel=0A=
facility. It provides a dynamic /dev space, with an agnostic naming=0A=
policy. Greg Kroah-Hartman is the main developer and maintainer of=0A=
this package. It can be found at=0A=
<A =
HREF=3D"http://ftp.kernel.org/pub/linux/utils/kernel/hotplug/">http://ft=
p.kernel.org/pub/linux/utils/kernel/hotplug/</A></P>=0A=
<P>To synthetize what implementation details these subsystems fill =
:</P>=0A=
<UL>=0A=
	<LI><P>Ensure stability of the naming of that node</P>=0A=
	<LI><P>Reconfigure the multipaths automatically when events =
occur</P>=0A=
	<LI><P>The multipath must be partitionable</P>=0A=
</UL>=0A=
<P STYLE=3D"margin-top: 0.42cm; page-break-after: avoid"><FONT =
FACE=3D"Albany, sans-serif"><FONT SIZE=3D4>multipath=0A=
userspace config tool</FONT></FONT></P>=0A=
<P>This tool is responsible for the paths coalescing and device maps=0A=
creation. As seen earlier, it is triggered by the hotplug calls on=0A=
new paths additions and suppressions. It must deal with hardware=0A=
specifics and abstract them for the others subsystems.</P>=0A=
<P>Here is how it works :</P>=0A=
<UL>=0A=
	<LI><P>draw a list of all available devices in the system through a=0A=
	sysfs scan. For each device, get a bunch of information :</P>=0A=
	<UL>=0A=
		<LI><P>Host / Bus / Target / Lun tuple</P>=0A=
		<LI><P>SCSI Device Strings : Vendor / Model / Revision</P>=0A=
		<LI><P>SCSI Serial String</P>=0A=
	</UL>=0A=
	<LI><P>Considering the informations fetched, elect a LU WWID method=0A=
	and an IO spreading policy. Ie deal with hardware specifics.</P>=0A=
	<LI><P>Get the LU WWID with the elected method. This method =
defaults=0A=
	to the standard 128 bit EUID found in the EVPD 0x83 inquiry page of=0A=
	the device.</P>=0A=
	<LI><P>Coalesce the paths to form the multipath structs</P>=0A=
	<LI><P>Create and name the device maps associated with the =
multipath=0A=
	structs with the selected IO spreading policy</P>=0A=
</UL>=0A=
<P>There are currently 3 spreading policy implemented :</P>=0A=
<UL>=0A=
	<LI><P>failover : 1 path per priority group. IO thus get routed to=0A=
	one path only.</P>=0A=
	<LI><P>multibus : 1 priority group containing all paths to the LU.=0A=
	Brings the maximum spreading, but assumes that all paths are=0A=
	sollicitable without penalty.</P>=0A=
	<LI><P>group_by_serial : 1 priority group per storage controler=0A=
	(serial), paths through one controler are assigned to the =
associated=0A=
	PG. This policy applies to controlers that impose a latency penalty=0A=
	on LU management hand-over between a pair of redondant =
controlers.</P>=0A=
</UL>=0A=
<P>The device maps naming policy is =E2=80=9Cname by LU =
WWID=E2=80=9D.</P>=0A=
<TABLE WIDTH=3D100% BORDER=3D1 CELLPADDING=3D4 CELLSPACING=3D3 =
STYLE=3D"page-break-inside: avoid">=0A=
	<COL WIDTH=3D256*>=0A=
	<THEAD>=0A=
		<TR>=0A=
			<TD WIDTH=3D100% VALIGN=3DTOP BGCOLOR=3D"#cccccc">=0A=
				<P>To illustrate this synopsis, here is an example verbose =
output=0A=
				:</P>=0A=
				<DL>=0A=
					<DD><FONT FACE=3D"Courier, monospace">xa-s03:~/udev-016/extras#=0A=
					multipath -v</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156d700012000000b0000=0A=
					(0 0 1 1) /dev/sda [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156c30001200000210000=0A=
					(0 0 1 2) /dev/sdb [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156d700012000000b0000=0A=
					(0 0 2 1) /dev/sdc [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156c30001200000210000=0A=
					(0 0 2 2) /dev/sdd [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad0000903507109004b=0A=
					(0 0 3 1) /dev/sde [HSG80 ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad000090371312100bf=0A=
					(0 0 3 2) /dev/sdf [HSG80 ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad000090371312100c2=0A=
					(0 0 3 3) /dev/sdg [HSG80 ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad00009037131210067=0A=
					(0 0 4 1) /dev/sdh [HSG80 ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad000090371312100b3=0A=
					(0 0 4 2) /dev/sdi [HSG80 ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad00009035071090024=0A=
					(0 0 4 3) /dev/sdj [HSG80 ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156d700012000000b0000=0A=
					(1 0 1 1) /dev/sdk [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156c30001200000210000=0A=
					(1 0 1 2) /dev/sdl [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156d700012000000b0000=0A=
					(1 0 2 1) /dev/sdm [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156c30001200000210000=0A=
					(1 0 2 2) /dev/sdn [HSV110 (C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">600508b4000156d700012000000b0000<=
/FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 1 1) /dev/sda [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 2 1) /dev/sdc [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(1 0 1 1) /dev/sdk [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(1 0 2 1) /dev/sdm [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">600508b4000156c30001200000210000</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 1 2) /dev/sdb [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 2 2) /dev/sdd [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(1 0 1 2) /dev/sdl [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(1 0 2 2) /dev/sdn [HSV110=0A=
					(C)COMPAQ]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad0000903507109004b</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 3 1) /dev/sde [HSG80 =
]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad000090371312100bf</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 3 2) /dev/sdf [HSG80 =
]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad000090371312100c2</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 3 3) /dev/sdg [HSG80 =
]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad00009037131210067</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 4 1) /dev/sdh [HSG80 =
]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad000090371312100b3</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 4 2) /dev/sdi [HSG80 =
]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">60001fe1000bdad00009035071090024</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, monospace">\_(0 0 4 3) /dev/sdj [HSG80 =
]</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:600508b4000156d700012000000b0000:0=0A=
					27262976 multipath 10 2 1 round-robin 2 0 /dev/sda /dev/sdk 1=0A=
					round-robin 2 0 /dev/sdc /dev/sdm</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:600508b4000156c30001200000210000:0=0A=
					31457280 multipath 10 2 1 round-robin 2 0 /dev/sdb /dev/sdl 1=0A=
					round-robin 2 0 /dev/sdd /dev/sdn</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:60001fe1000bdad0000903507109004b:0=0A=
					106669167 multipath 10 1 1 round-robin 1 0 =
/dev/sde</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:60001fe1000bdad000090371312100bf:0=0A=
					142229246 multipath 10 1 1 round-robin 1 0 =
/dev/sdf</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:60001fe1000bdad000090371312100c2:0=0A=
					142229246 multipath 10 1 1 round-robin 1 0 =
/dev/sdg</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:60001fe1000bdad00009037131210067:0=0A=
					213338334 multipath 10 1 1 round-robin 1 0 =
/dev/sdh</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:60001fe1000bdad000090371312100b3:0=0A=
					213338334 multipath 10 1 1 round-robin 1 0 =
/dev/sdi</FONT></DD><DD>=0A=
					<FONT FACE=3D"Courier, =
monospace">U:60001fe1000bdad00009035071090024:0=0A=
					71114623 multipath 10 1 1 round-robin 1 0 =
/dev/sdj</FONT></DD></DL>=0A=
			</TD>=0A=
		</TR>=0A=
	</THEAD>=0A=
</TABLE>=0A=
<P><BR><BR>=0A=
</P>=0A=
<P>The first section shows the list of all paths detected on the=0A=
host. The second shows the multipath structs produced by the=0A=
coalescing logic. The third shows the device maps submited to the=0A=
Device Mapper.</P>=0A=
<P>Of interest is the creation of device maps for single path LU :=0A=
this enable to system to operate normaly when booted in a degraded=0A=
SAN context. The missing paths will be added to the maps when they=0A=
become available.</P>=0A=
<P>This tool is packaged with udev, in the extras/ section. The=0A=
devmap_name tool is distributed in the same tree.</P>=0A=
<P>The implementation requirements filled by this tool are :</P>=0A=
<UL>=0A=
	<LI><P>Ensure stability of the naming of that node (in complement =
of=0A=
	udev)</P>=0A=
	<LI><P>Configure the multipaths to maximize performance : spread IO=0A=
	when possible path switching is free, and not spread when it's=0A=
	costly. =0A=
	</P>=0A=
	<LI><P>Configure the multipaths automatically at boot</P>=0A=
	<LI><P>Reconfigure the multipaths automatically when events occur (=0A=
	in complement of hotplug)</P>=0A=
</UL>=0A=
<P STYLE=3D"margin-top: 0.42cm; page-break-after: avoid"><FONT =
FACE=3D"Albany, sans-serif"><FONT SIZE=3D4>kpartx=0A=
userspace config tool</FONT></FONT></P>=0A=
<P>This tool, derived from util-linux' partx, reads partition tables=0A=
on specified device and create device maps over partitions segments=0A=
detected. It is called from hotplug upon device maps creation and=0A=
deletion.</P>=0A=
<P>For now kpartx can be found at <A =
HREF=3D"http://dsit.free.fr/">http://dsit.free.fr/</A></P>=0A=
<P STYLE=3D"margin-top: 0.42cm; page-break-after: avoid"><FONT =
FACE=3D"Albany, sans-serif"><FONT SIZE=3D4>Early=0A=
userspace</FONT></FONT></P>=0A=
<P>Starting with Linux kernel 2.6, an early userspace execution=0A=
environment is available in the name of initramfs. The grand plan is=0A=
to package a set of tools in a cpio archive concatanated to the=0A=
kernel. This archive is expanded in an in-memory filesystem early at=0A=
boot and the tools are called to assume logics that previously=0A=
belonged in the kernel : dhcp requests and setups, nfsroot stuffing=0A=
...</P>=0A=
<P>Being concatenated to the kernel, the size of this archive =
matters=0A=
a lot. A slim libc implementation is required and provided in the=0A=
name of klibc, maintained by Hans Peter Anvin.</P>=0A=
<P>The multipath implementation toolchain fits in this early=0A=
userspace definition. Udev, multipath and kpartx are linked against=0A=
klibc and can be packaged with the cpio archive to bring up the=0A=
multipathed device early enough to boot on.</P>=0A=
<P>So is met the last multipath implementation requirement.</P>=0A=
<P STYLE=3D"margin-top: 0.42cm; page-break-after: avoid"><FONT =
FACE=3D"Albany, sans-serif"><FONT SIZE=3D4>Quick=0A=
installation guide</FONT></FONT></P>=0A=
<UL>=0A=
	<LI><P>Download and unarchive a recent 2.6 kernel</P>=0A=
	<LI><P>Download, unarchive and apply the associated udm patchset=0A=
	from <A =
HREF=3D"http://people.sistina.com/~thornber/dm/">http://people.sistina.c=
om/~thornber/dm/</A></P>=0A=
	<LI><P>Configure, compile and install the kernel, reconfigure the=0A=
	bootloader if needed</P>=0A=
	<LI><P>Download udev, at least 017, from=0A=
	<A =
HREF=3D"http://ftp.kernel.org/pub/linux/utils/kernel/hotplug/">http://ft=
p.kernel.org/pub/linux/utils/kernel/hotplug/</A></P>=0A=
	<LI><P>Compile udev with klibc linking (edit the Makefile to=0A=
	uncomment KLIBC=3Dtrue). Make install.</P>=0A=
	<LI><P>In udev/extras/multipath, make and make install</P>=0A=
	<LI><P>Reboot under the new kernel and see the magic operate</P>=0A=
</UL>=0A=
</BODY>=0A=
</HTML>
------_=_NextPart_000_01C3F48B.5A52B6AC--


-------------------------------------------------------
SF.Net is sponsored by: Speed Start Your Linux Apps Now.
Build and deploy apps & Web services for Linux with
a free DVD software kit from IBM. Click Now!
http://ads.osdn.com/?ad_id=1356&alloc_id=3438&op=click
