From: scameron@beardog.cce.hp.com
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 1 Sep 2011 13:01:38 -0500
Message-ID: <20110901180138.GV8422@beardog.cce.hp.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com> <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110901160724.GN9189@beardog.cce.hp.com> <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:41414 "EHLO
	g1u1820.austin.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755404Ab1IASJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2011 14:09:34 -0400
Content-Disposition: inline
In-Reply-To: <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Thu, Sep 01, 2011 at 07:40:15PM +0200, Eric Dumazet wrote:
> Le jeudi 01 septembre 2011 =E0 11:07 -0500, scameron@beardog.cce.hp.c=
om a
> =E9crit :
> > On Thu, Sep 01, 2011 at 05:24:02PM +0200, Eric Dumazet wrote:
> > > Stephen,
> > >=20
> > > Current linux-3.1-rc4+ is a total disaster on my BL460c G6
> >=20
> > What kernel were you running successfully previously?
> >=20
> > I saw similar on BL460cG7 on Friday with 3.1-rc4,
> > but I'm not sure the problem is in the driver. =20
> > I installed rhel6.1, then put 3.1-rc4 on.  Turning off
> > "Virtualization" in the kernel config seemed to help
> > (allowed it to boot) and so I thought that must have
> > been the source of the issue.  So, you might try that.
> >=20
> > However, I rebooted that machine just now, and
> > now I am getting the similar "hpsa 0000:0c:00.0: resetting device 0=
:0:0:0"
> > message, so that's pretty weird.
> >=20
> > The cmd_alloc failure, I didn't see, but I may have missed it
> > (didn't have console directed to serial output.)
> >=20
> > cmd_alloc failing is not generally expected, as we reserve enough
> > commands that the upper layers should never exhaust them all (shoul=
d
> > honor hpsa's max request limit), so that's pretty weird that
> > you're seeing that.
> >=20
> > I am able to run 3.1-rc3 on rhel6 just fine on other systems (DL380=
g7,
> > for example) and I don't think there are any hpsa changes between r=
c3
> > and rc4.  (haven't tried rc4 on the dl380g7 yet).
> >=20
> > So, I'm not sure what's going on with the BL460c yet, but I am
> > aware of the problem and have already seen it.  I can't think of
> > any driver changes lately which should be causing such
> > changes in behavior.
> >=20
> > -- steve
> >=20
> >=20
>=20
> OK I found the bad commit,I got lucky... I lost some files but my
> machine was able to complete the bisection. CC involved people
>=20

Thanks.  I will run this information by the hardware guys here
and see if they have any bright ideas.

Would be interesting to see if the "pcie_bus_safe" option=20
makes a difference.

-- steve

> git bisect start
> # bad: [9e79e3e9dd9672b37ac9412e9a926714306551fe] Merge git://git.ker=
nel.org/pub/scm/linux/kernel/git/davem/sparc
> git bisect bad 9e79e3e9dd9672b37ac9412e9a926714306551fe
> # good: [322a8b034003c0d46d39af85bf24fee27b902f48] Linux 3.1-rc1
> git bisect good 322a8b034003c0d46d39af85bf24fee27b902f48
> # bad: [0c3bef612881ee6216a36952ffaabfc35b83545c] Merge branch 'for-l=
inus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> git bisect bad 0c3bef612881ee6216a36952ffaabfc35b83545c
> # good: [8c70aac04e01a08b7eca204312946206d1c1baac] Merge branch 'stag=
ing-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/stag=
ing-2.6
> git bisect good 8c70aac04e01a08b7eca204312946206d1c1baac
> # good: [291b63c86aea8a571ddf913d41ab5156b8314dad] Merge branch 'drm-=
intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/keithp/li=
nux-2.6
> git bisect good 291b63c86aea8a571ddf913d41ab5156b8314dad
> # good: [aa462abe8aaf2198d6aef97da20c874ac694a39f] mm: fix __page_to_=
pfn for a const struct page argument
> git bisect good aa462abe8aaf2198d6aef97da20c874ac694a39f
> # good: [5c80c71b9a0ec518b4b58d2a61de01a04f4a4453] Merge branch 'for-=
linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-uns=
table
> git bisect good 5c80c71b9a0ec518b4b58d2a61de01a04f4a4453
> # good: [2c4ac99f983f1341b5962a16b5e8de6049bf10b5] Merge branch 'upst=
ream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/li=
bata-dev
> git bisect good 2c4ac99f983f1341b5962a16b5e8de6049bf10b5
> # bad: [0a2daa1cf35004f5adbf4138555cc5669abf3a3e] PCI: make cardbus-b=
ridge resources optional
> git bisect bad 0a2daa1cf35004f5adbf4138555cc5669abf3a3e
> # bad: [be768912a49b10b68e96fbd8fa3cab0adfbd3091] PCI: honor child bu=
ses add_size in hot plug configuration
> git bisect bad be768912a49b10b68e96fbd8fa3cab0adfbd3091
> # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max =
Payload Size on fabric
> git bisect bad b03e7495a862b028294f59fc87286d6d78ee7fa1
> commit b03e7495a862b028294f59fc87286d6d78ee7fa1
> Author: Jon Mason <mason@myri.com>
> Date:   Wed Jul 20 15:20:54 2011 -0500
>=20
>     PCI: Set PCI-E Max Payload Size on fabric
>    =20
>     On a given PCI-E fabric, each device, bridge, and root port can h=
ave a
>     different PCI-E maximum payload size.  There is a sizable perform=
ance
>     boost for having the largest possible maximum payload size on eac=
h PCI-E
>     device.  However, if improperly configured, fatal bus errors can =
occur.
>     Thus, it is important to ensure that PCI-E payloads sends by a de=
vice
>     are never larger than the MPS setting of all devices on the way t=
o the
>     destination.
>    =20
>     This can be achieved two ways:
>    =20
>     - A conservative approach is to use the smallest common denominat=
or of
>       the entire tree below a root complex for every device on that f=
abric.
>    =20
>     This means for example that having a 128 bytes MPS USB controller=
 on one
>     leg of a switch will dramatically reduce performances of a video =
card or
>     10GE adapter on another leg of that same switch.
>    =20
>     It also means that any hierarchy supporting hotplug slots (includ=
ing
>     expresscard or thunderbolt I suppose, dbl check that) will have t=
o be
>     entirely clamped to 128 bytes since we cannot predict what will b=
e
>     plugged into those slots, and we cannot change the MPS on a "live=
"
>     system.
>    =20
>     - A more optimal way is possible, if it falls within a couple of
>       constraints:
>     * The top-level host bridge will never generate packets larger th=
an the
>       smallest TLP (or if it can be controlled independently from its=
 MPS at
>       least)
>     * The device will never generate packets larger than MPS (which c=
an be
>       configured via MRRS)
>     * No support of direct PCI-E <-> PCI-E transfers between devices =
without
>       some additional code to specifically deal with that case
>    =20
>     Then we can use an approach that basically ignores downstream req=
uests
>     and focuses exclusively on upstream requests. In that case, all w=
e need
>     to care about is that a device MPS is no larger than its parent M=
PS,
>     which allows us to keep all switches/bridges to the max MPS suppo=
rted by
>     their parent and eventually the PHB.
>    =20
>     In this case, your USB controller would no longer "starve" your 1=
0GE
>     Ethernet and your hotplug slots won't affect your global MPS.
>     Additionally, the hotplugged devices themselves can be configured=
 to a
>     larger MPS up to the value configured in the hotplug bridge.
>    =20
>     To choose between the two available options, two PCI kernel boot =
args
>     have been added to the PCI calls.  "pcie_bus_safe" will provide t=
he
>     former behavior, while "pcie_bus_perf" will perform the latter be=
havior.
>     By default, the latter behavior is used.
>    =20
>     NOTE: due to the location of the enablement, each arch will need =
to add
>     calls to this function.  This patch only enables x86.
>    =20
>     This patch includes a number of changes recommended by Benjamin
>     Herrenschmidt.
>    =20
>     Tested-by: Jordan_Hargrave@dell.com
>     Signed-off-by: Jon Mason <mason@myri.com>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>=20
>=20
>=20
> > >=20
> > >=20
> > > Few seconds after boot, I get "cmd_alloc returned NULL" messages
> > > or "hpsa 0000:0c:00.0: resetting device 0:0:0:0"
> > >=20
> > > Usually lot of files are corrupted, fsck needed, and full distro
> > > reinstall as well.
> > >=20
> > > I tested on two different machines, same result.
> > >=20
> > > Relevant hardware information :
> > >=20
> > > 	Manufacturer: HP
> > > 	Product Name: ProLiant BL460c G6
> > > 	Version: I24
> > > 	Release Date: 05/05/2011
> > > 	Intel(R) Xeon(R) CPU E5540 @ 2.53GHz  (two sockets)
> > >=20
> > > 0c:00.0 RAID bus controller: Hewlett-Packard Company Smart Array =
G6
> > > controllers (rev 01)
> > > 	Subsystem: Hewlett-Packard Company Smart Array P410i
> > > 	Flags: bus master, fast devsel, latency 0, IRQ 16
> > > 	Memory at fbc00000 (64-bit, non-prefetchable) [size=3D4M]
> > > 	Memory at fbbf0000 (64-bit, non-prefetchable) [size=3D4K]
> > > 	I/O ports at 4000 [size=3D256]
> > > 	[virtual] Expansion ROM at e7200000 [disabled] [size=3D512K]
> > > 	Capabilities: [40] Power Management version 3
> > > 	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
> > > 	Capabilities: [70] Express Endpoint, MSI 00
> > > 	Capabilities: [ac] MSI-X: Enable+ Count=3D16 Masked-
> > > 	Capabilities: [100] Advanced Error Reporting
> > > 	Kernel driver in use: hpsa
> > >=20
> > > # hpacucli ctrl all show config detail
> > >=20
> > > Smart Array P410i in Slot 0 (Embedded)
> > >    Bus Interface: PCI
> > >    Slot: 0
> > >    Serial Number: 5001438006F44240
> > >    RAID 6 (ADG) Status: Disabled
> > >    Controller Status: OK
> > >    Chassis Slot:=20
> > >    Hardware Revision: Rev C
> > >    Firmware Version: 2.50
> > >    Rebuild Priority: Medium
> > >    Expand Priority: Medium
> > >    Surface Scan Delay: 15 secs
> > >    Surface Scan Mode: Idle
> > >    Wait for Cache Room: Disabled
> > >    Surface Analysis Inconsistency Notification: Disabled
> > >    Post Prompt Timeout: 0 secs
> > >    Cache Board Present: False
> > >    Drive Write Cache: Disabled
> > >    SATA NCQ Supported: True
> > >=20
> > >    Array: A
> > >       Interface Type: SATA
> > >       Unused Space: 0 MB
> > >       Status: OK
> > >=20
> > >=20
> > >=20
> > >       Logical Drive: 1
> > >          Size: 232.9 GB
> > >          Fault Tolerance: RAID 1
> > >          Heads: 255
> > >          Sectors Per Track: 32
> > >          Cylinders: 59844
> > >          Strip Size: 128 KB
> > >          Status: OK
> > >          Unique Identifier: 600508B1001030364634343234300F00
> > >          Disk Name: /dev/cciss/c0d0
> > >          Mount Points: / 9.3 GB, /home 216.0 GB
> > >          OS Status: LOCKED
> > >          Logical Drive Label: A0124E845001438006F442403033
> > >          Mirror Group 0:
> > >             physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SATA, 250 =
GB, OK)
> > >          Mirror Group 1:
> > >             physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SATA, 250 =
GB, OK)
> > >=20
> > >       physicaldrive 1I:1:1
> > >          Port: 1I
> > >          Box: 1
> > >          Bay: 1
> > >          Status: OK
> > >          Drive Type: Data Drive
> > >          Interface Type: SATA
> > >          Size: 250 GB
> > >          Firmware Revision: HPG2   =20
> > >          Serial Number: K648T9C27M8E       =20
> > >          Model: ATA     GJ0250EAGSQ    =20
> > >          SATA NCQ Capable: True
> > >          SATA NCQ Enabled: True
> > >          PHY Count: 1
> > >          PHY Transfer Rate: 3.0GBPS
> > >=20
> > >       physicaldrive 1I:1:2
> > >          Port: 1I
> > >          Box: 1
> > >          Bay: 2
> > >          Status: OK
> > >          Drive Type: Data Drive
> > >          Interface Type: SATA
> > >          Size: 250 GB
> > >          Firmware Revision: HPG2   =20
> > >          Serial Number: K648T9C27M49       =20
> > >          Model: ATA     GJ0250EAGSQ    =20
> > >          SATA NCQ Capable: True
> > >          SATA NCQ Enabled: True
> > >          PHY Count: 1
> > >          PHY Transfer Rate: 3.0GBPS
> > >=20
> > >=20
> > >=20
> > > 64 bit kernel, 4GB of memory
> > >=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
