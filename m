Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C847618CC13
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764198499; cv=none; b=M0Vi8apy5VFmSNcyKYoHziBb/46RZ8ZRKjTFzs/Li3FRlc1HLhnrD0nOIujEY4ou6STYZJhkbrW/vXOpjxFOP1Kcgg7lNThMX0GlSfJ+3tp9r6HcxuIt2Zo2Ybl7fnv2vnMvBvwck124MgqeH23mzkFkDyjoax9mIdICwiKq2jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764198499; c=relaxed/simple;
	bh=edCjHgsfOB3Tvm0SEOsZNOcLzAqRAaMBFmtlB8LuPAw=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=j1Mrf3DmmJ6sYNBXmO+HqmTiQn1nj7xpDPUQwd3W9QAcoF4xDOqXVMrtzUcjVNPX+iSMXwlF68e4ULV7JShkjol417j05jYmZCis/EDqmDPyr2rI7Je1JMJSJbqNWVcSw745TX3vc/+zH5KW7dIbzxTD/fzCC6OCk1B5Mmjmu3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIFlhieh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIFlhieh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F086C116C6
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 23:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764198499;
	bh=edCjHgsfOB3Tvm0SEOsZNOcLzAqRAaMBFmtlB8LuPAw=;
	h=From:To:Subject:Date:From;
	b=XIFlhiehaktrMG4uKuxj8EwSirO7ijUWo5Kyl4T97JeMG+fP/5bFAHvk9fliuHKRs
	 p6py09dSmcveGCdougu+Jo9S4gnrlgDwMoA5uJqAn4eyZ3mnN2fe1l36TLV/3VAinC
	 RD+nuzsicN+0E7UK7TjpQxuXRPPdyKoQu0iU5saqnfhx+RJz+pNBkLFTRwXU7GU/Y2
	 y9MyV0GauXDVTzw8wh/kACqciaScRKrAT+THH8hWhldNJopXi39YHhu8VBdYeqIono
	 Gqkvi1bC6XDytBihYNNtVPSf31aGWiTbFI6MvJeeM6/dYzC7ZxOLMHBDEv1lwGErq/
	 /KscZu90aKtiw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 33BE2C41613; Wed, 26 Nov 2025 23:08:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220810] New: RTL9210: "unmap" in provisioning_mode keeps
 getting overwritten to "full"
Date: Wed, 26 Nov 2025 23:08:18 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: frank.shimizu@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220810-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220810

            Bug ID: 220810
           Summary: RTL9210: "unmap" in provisioning_mode keeps getting
                    overwritten to "full"
           Product: IO/Storage
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: frank.shimizu@mailbox.org
        Regression: No

I have a Ugreen NVMe M.2 to USB enclosure. lsusb reports it as (long version
follows later):
Bus 001 Device 012: ID 0bda:9210 Realtek Semiconductor Corp. RTL9210 M.2 NV=
ME
Adapter

The device supports unmap/TRIM/discard but doesn't seem to report this to t=
he
OS correctly. sg_vpd -a on the device reports: LBPU=3D1. This suggests trim
should work. But the system sets the provisioning_mode to "full":
# cat
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/host8/target8:0:0/8:0=
:0:0/scsi_disk/8:0:0:0/provisioning_mode
full

And therefore when I try to run blkdiscard on the device I get: Operation n=
ot
supported.

Windows is able to trim the device, which seems to support that the device =
is
capable of trim, but possibly Windows doesn't care about the chip's inaccur=
ate
report.

When I manually write "unmap" to provisioning_mode, I can successfully run
blkdiscard. So I created the following udev rule:
ACTION=3D=3D"add|change", ATTRS{idVendor}=3D=3D"0bda", ATTRS{idProduct}=3D=
=3D"9210",
SUBSYSTEM=3D=3D"scsi_disk", ATTR{provisioning_mode}=3D"unmap"

After a reboot the device indeed has "unmap" set and trim works:
# cat
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/host8/target8:0:0/8:0=
:0:0/scsi_disk/8:0:0:0/provisioning_mode
unmap

So far, so good, but this is where the real problem starts: After a short t=
ime
it always gets set back to "full" automatically. Unfortunately I see no rel=
ated
messages in dmesg when this happens. The change might sometimes be triggere=
d by
my actions, such as opening a LUKS volume, but it also seems to happen by
itself even when I don't do anything with the device. I tried disabling and
masking the udisks2 service to make sure it doesn't interfere, but that did=
n't
help. I also tried watching the provisioning_mode file with inotify to see =
what
changes it but didn't get any messages when it changed.

Please let me know if I can provide any more information.

Steps to reproduce:
 * Create udev rule
 * Plug in device -> provisioning_mode initially set by udev to "unmap"
 * blkdiscard works
 * Perform action on device, or wait
 * provisioning_mode reverts to "full"
 * blkdiscard now fails with "Operation not supported"

=3D=3D=3D=3D=3D

Additional info:

Kernel is current Debian Trixie stock kernel, no patches

# uname -a
Linux homura 6.12.57+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.57-1
(2025-11-05) x86_64 GNU/Linux

-----

# cat /proc/version
Linux version 6.12.57+deb13-amd64 (debian-kernel@lists.debian.org)
(x86_64-linux-gnu-gcc-14 (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for
Debian) 2.44) #1 SMP PREEMPT_DYNAMIC Debian 6.12.57-1 (2025-11-05)

-----

# sg_vpd -a /dev/sde
Supported VPD pages VPD page:
  Supported VPD pages [sv]
  Unit serial number [sn]
  Device identification [di]
  Block limits (SBC) [bl]
  Block device characteristics (SBC) [bdc]
  Logical block provisioning (SBC) [lbpv]

Unit serial number VPD page:
  Product serial number: 0000000000000000

Device Identification VPD page:
  Addressed logical unit:
    designator type: T10 vendor identification,  code set: ASCII
      vendor id: Realtek=20
      vendor specific: RTL9210         1.000000000000000000
    designator type: NAA,  code set: Binary
      0x3001237923792379

Block limits VPD page (SBC)
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks [command not implemented]
  Optimal transfer length granularity: 0x1
  Maximum transfer length: 0xffff
  Optimal transfer length: 0xffff
  Maximum prefetch length: 0 blocks [not reported]
  Maximum unmap LBA count: 0x1400000
  Maximum unmap block descriptor count: 0x1
  Optimal unmap granularity: 0x1
  Unmap granularity alignment valid: false
  Maximum write same length: 0 blocks [not reported]
  Maximum atomic transfer length: 0 blocks [not reported]
  Atomic alignment: 0 blocks [unaligned atomic writes permitted]
  Atomic transfer length granularity: 0 blocks [no granularity requirement]
  Maximum atomic transfer length with atomic boundary: 0 blocks [not report=
ed]
  Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]

Block device characteristics VPD page (SBC)
  Non-rotating medium (e.g. solid state)
  Product type: Not specified
  WABEREQ=3D0
  WACEREQ=3D0
  Nominal form factor: not reported
  MACT=3D0
  ZONED=3D0 [not reported]
  RBWZ=3D0
  FUAB=3D0
  VBULS=3D0
  DEPOPULATION TIME: 0x0

Logical block provisioning VPD page (SBC)
  LBPU=3D1
  LBPWS=3D0
  LBPWS10=3D0
  LBPRZ=3D0x0
  ANC_SUP=3D0
  DP=3D0
  Minimum percentage: 0 [not reported]
  Provisioning type: not known or fully provisioned
  Threshold percentage: 0 [percentages not supported]

-----

# lsusb -vvv -d 0bda:9210

Bus 001 Device 012: ID 0bda:9210 Realtek Semiconductor Corp. RTL9210 M.2 NV=
ME
Adapter
Negotiated speed: High Speed (480Mbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.10
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x9210 RTL9210 M.2 NVME Adapter
  bcdDevice           f0.01
  iManufacturer           1 Ugreen
  iProduct                2 Ugreen Storage Device
  iSerial                 3 01293805A6A5
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x002a
  bNumDeviceCaps          3
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000006
      BESL Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat        2047 micro seconds
  SuperSpeedPlus USB Device Capability:
    bLength                20
    bDescriptorType        16
    bDevCapabilityType     10
    bmAttributes         0x00000001
      Sublink Speed Attribute count 2
      Sublink Speed ID count 1
    wFunctionalitySupport   0x1100
      Min functional Speed Attribute ID: 0
      Min functional RX lanes: 1
      Min functional TX lanes: 1
    bmSublinkSpeedAttr[0]   0x000a4030
      Speed Attribute ID: 0 10Gb/s Symmetric RX SuperSpeedPlus
    bmSublinkSpeedAttr[1]   0x000a40b0
      Speed Attribute ID: 0 10Gb/s Symmetric TX SuperSpeedPlus
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
  (Bus Powered)

-----

dmesg at boot when the device is initialized:
[  176.009742] usb 1-3: new high-speed USB device number 12 using xhci_hcd
[  176.155752] usb 1-3: New USB device found, idVendor=3D0bda, idProduct=3D=
9210,
bcdDevice=3Df0.01
[  176.155765] usb 1-3: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[  176.155770] usb 1-3: Product: Ugreen Storage Device
[  176.155774] usb 1-3: Manufacturer: Ugreen
[  176.155778] usb 1-3: SerialNumber: 01293805A6A5
[  176.214591] usb-storage 1-3:1.0: USB Mass Storage device detected
[  176.214909] scsi host8: usb-storage 1-3:1.0
[  176.214959] usbcore: registered new interface driver usb-storage
[  176.220056] usbcore: registered new interface driver uas
[  179.875749] scsi 8:0:0:0: Direct-Access     WD_BLACK  SN850X 2000GB   1.=
00
PQ: 0 ANSI: 6
[  179.876489] sd 8:0:0:0: Attached scsi generic sg4 type 0
[  179.881878] sd 8:0:0:0: [sde] 3907029168 512-byte logical blocks: (2.00
TB/1.82 TiB)
[  179.882510] sd 8:0:0:0: [sde] Write Protect is off
[  179.882515] sd 8:0:0:0: [sde] Mode Sense: 37 00 00 08
[  179.883171] sd 8:0:0:0: [sde] Write cache: disabled, read cache: enabled,
doesn't support DPO or FUA
[  179.959742] sd 8:0:0:0: [sde] Attached SCSI disk

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
