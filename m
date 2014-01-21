From: =?utf-8?q?Milan_Svoboda?= <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
Subject: =?utf-8?q?Re=3A_usb_disk_recognized_but_fails?=
Date: Tue, 21 Jan 2014 21:56:36 +0100
Message-ID: <20140121215636.F5422382@centrum.cz>
References: <20140115154739.7DC8AFD8@centrum.cz>, <20140120182319.GB5545@xanatos>, <20140120200023.5F31B6AF@centrum.cz> <20140120194545.GE5545@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140120194545.GE5545@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?utf-8?q?USB_Storage_List?= <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

I have applied the patches to a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8:

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.=
c
index 53c2e29..64c36fe 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3008,7 +3008,7 @@ static int prepare_ring(struct xhci_hcd *xhci, st=
ruct xhci_ring *ep_ring,
                        if (num_trbs >=3D TRBS_PER_SEGMENT) {
                                xhci_err(xhci, "Too many fragments %d, =
max %d\n",
                                                num_trbs, TRBS_PER_SEGM=
ENT - 1);
-                               return -ENOMEM;
+                               return -EINVAL;
                        }
=20
                        nop_cmd =3D cpu_to_le32(TRB_TYPE(TRB_TR_NOOP) |
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4265b48..d45a0d5 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4713,8 +4713,8 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_=
quirks_t get_quirks)
        struct device           *dev =3D hcd->self.controller;
        int                     retval;
=20
-       /* Accept arbitrarily long scatter-gather lists */
-       hcd->self.sg_tablesize =3D ~0;
+       /* Limit the block layer scatter-gather lists to half a segment=
=2E */
+       hcd->self.sg_tablesize =3D TRBS_PER_SEGMENT / 2;
=20
        /* support to build packet from discontinuous buffers */
        hcd->self.no_sg_constraint =3D 1;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 03c74b7..c283cf1 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1260,7 +1260,7 @@ union xhci_trb {
  * since the command ring is 64-byte aligned.
  * It must also be greater than 16.
  */
-#define TRBS_PER_SEGMENT       64
+#define TRBS_PER_SEGMENT       256
 /* Allow two commands + a link TRB, along with any reserved command TR=
Bs */
 #define MAX_RSVD_CMD_TRBS      (TRBS_PER_SEGMENT - 3)
 #define TRB_SEGMENT_SIZE       (TRBS_PER_SEGMENT*16)


The output of lspci -vvv -n

00:14.0 0c03: 8086:1e31 (rev 04) (prog-if 30 [XHCI])
        Subsystem: 1028:0534
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 43
        Region 0: Memory at f7e20000 (64-bit, non-prefetchable) [size=3D=
64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0-,=
D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 P=
ME-
        Capabilities: [80] MSI: Enable+ Count=3D1/8 Maskable- 64bit+
                Address: 00000000fee00338  Data: 0000
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_hcd

The kernel logs:

[  114.854464] usb 3-1: new high-speed USB device number 2 using xhci_h=
cd
[  114.920229] usbcore: registered new interface driver usb-storage
[  114.920647] ums-cypress 3-1:1.0: USB Mass Storage device detected
[  114.920705] scsi6 : usb-storage 3-1:1.0
[  114.920816] usbcore: registered new interface driver ums-cypress
[  115.921301] scsi 6:0:0:0: Direct-Access     WDC WD64 00BPVT-00HXZT0 =
       PQ: 0 ANSI: 0
[  115.921991] sd 6:0:0:0: [sdb] 1250263728 512-byte logical blocks: (6=
40 GB/596 GiB)
[  115.922142] sd 6:0:0:0: [sdb] Write Protect is off
[  115.922145] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[  115.922269] sd 6:0:0:0: [sdb] No Caching mode page found
[  115.922271] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  115.922929] sd 6:0:0:0: [sdb] No Caching mode page found
[  115.922931] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  115.938479]  sdb: sdb1
[  115.939112] sd 6:0:0:0: [sdb] No Caching mode page found
[  115.939115] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  115.939117] sd 6:0:0:0: [sdb] Attached SCSI disk
[  124.241874] usb 3-1: reset high-speed USB device number 2 using xhci=
_hcd
[  124.255232] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called wi=
th disabled ep ffff8801f899f700
[  124.255237] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called wi=
th disabled ep ffff8801f899f740
[  128.552357] vboxdrv: Found 4 processor cores.
[  128.552802] vboxdrv: fAsync=3D0 offMin=3D0x1dd offMax=3D0x16bc
[  128.552862] vboxdrv: TSC mode is 'synchronous', kernel timer mode is=
 'normal'.
[  128.552864] vboxdrv: Successfully loaded version 4.3.6_OSE (interfac=
e 0x001a0007).
[  128.556554] vboxpci: IOMMU not found (not registered)
[  191.463779] sd 6:0:0:0: [sdb] Unhandled sense code
[  191.463786] sd 6:0:0:0: [sdb] =20
[  191.463788] Result: hostbyte=3D0x07 driverbyte=3D0x08
[  191.463791] sd 6:0:0:0: [sdb] =20
[  191.463793] Sense Key : 0x4 [current]=20
[  191.463797] sd 6:0:0:0: [sdb] =20
[  191.463799] ASC=3D0x0 ASCQ=3D0x0
[  191.463802] sd 6:0:0:0: [sdb] CDB:=20
[  191.463803] cdb[0]=3D0x28: 28 00 4a 85 6e af 00 00 08 00
[  191.463813] end_request: I/O error, dev sdb, sector 1250258607
[  191.463818] Buffer I/O error on device sdb1, logical block 625129272
[  191.463821] Buffer I/O error on device sdb1, logical block 625129273
[  191.463824] Buffer I/O error on device sdb1, logical block 625129274
[  191.463826] Buffer I/O error on device sdb1, logical block 625129275
[  258.486582] sd 6:0:0:0: [sdb] Unhandled sense code
[  258.486589] sd 6:0:0:0: [sdb] =20
[  258.486591] Result: hostbyte=3D0x07 driverbyte=3D0x08
[  258.486593] sd 6:0:0:0: [sdb] =20
[  258.486595] Sense Key : 0x4 [current]=20
[  258.486598] sd 6:0:0:0: [sdb] =20
[  258.486599] ASC=3D0x0 ASCQ=3D0x0
[  258.486602] sd 6:0:0:0: [sdb] CDB:=20
[  258.486603] cdb[0]=3D0x28: 28 00 4a 85 6e af 00 00 02 00
[  258.486610] end_request: I/O error, dev sdb, sector 1250258607
[  258.486614] Buffer I/O error on device sdb1, logical block 625129272
[  325.515320] sd 6:0:0:0: [sdb] Unhandled sense code
[  325.515325] sd 6:0:0:0: [sdb] =20
[  325.515326] Result: hostbyte=3D0x07 driverbyte=3D0x08
[  325.515328] sd 6:0:0:0: [sdb] =20
[  325.515329] Sense Key : 0x4 [current]=20
[  325.515331] sd 6:0:0:0: [sdb] =20
[  325.515332] ASC=3D0x0 ASCQ=3D0x0
[  325.515333] sd 6:0:0:0: [sdb] CDB:=20
[  325.515334] cdb[0]=3D0x28: 28 00 4a 85 6e b1 00 00 02 00
[  325.515340] end_request: I/O error, dev sdb, sector 1250258609
[  325.515343] Buffer I/O error on device sdb1, logical block 625129273
[  392.545197] sd 6:0:0:0: [sdb] Unhandled sense code
[  392.545202] sd 6:0:0:0: [sdb] =20
[  392.545204] Result: hostbyte=3D0x07 driverbyte=3D0x08
[  392.545205] sd 6:0:0:0: [sdb] =20
[  392.545206] Sense Key : 0x4 [current]=20
[  392.545210] sd 6:0:0:0: [sdb] =20
[  392.545211] ASC=3D0x0 ASCQ=3D0x0
[  392.545212] sd 6:0:0:0: [sdb] CDB:=20
[  392.545213] cdb[0]=3D0x28: 28 00 4a 85 6e b3 00 00 04 00
[  392.545220] end_request: I/O error, dev sdb, sector 1250258611
[  392.545223] Buffer I/O error on device sdb1, logical block 625129274
[  392.545226] Buffer I/O error on device sdb1, logical block 625129275
[  459.573963] sd 6:0:0:0: [sdb] Unhandled sense code
[  459.573973] sd 6:0:0:0: [sdb] =20
[  459.573975] Result: hostbyte=3D0x07 driverbyte=3D0x08
[  459.573976] sd 6:0:0:0: [sdb] =20
[  459.573977] Sense Key : 0x4 [current]=20
[  459.573980] sd 6:0:0:0: [sdb] =20
[  459.573980] ASC=3D0x0 ASCQ=3D0x0
[  459.573981] sd 6:0:0:0: [sdb] CDB:=20
[  459.573982] cdb[0]=3D0x28: 28 00 00 00 00 3f 00 00 08 00
[  459.573987] end_request: I/O error, dev sdb, sector 63
[  459.573990] Buffer I/O error on device sdb1, logical block 0
[  459.573992] Buffer I/O error on device sdb1, logical block 1
[  459.573993] Buffer I/O error on device sdb1, logical block 2
[  459.573994] Buffer I/O error on device sdb1, logical block 3

The disk is spinning for much longer time then before, but it doesn't c=
onnect correctly.

If you have anything else to try let me know. Otherwise I will try to b=
isect the thing.

Milan

______________________________________________________________
> Od: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Komu: Milan Svoboda <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
> Datum: 20.01.2014 20:45
> P=C5=99edm=C4=9Bt: Re: usb disk recognized but fails
>
> CC: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "USB Storage List" <usb-storage@lists.=
one-eyed-alien.net>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>On Mon, Jan 20, 2014 at 08:00:23PM +0100, Milan Svoboda wrote:
>> Non-working:
>>=20
>> 3.12.7-2-ARCH #1 SMP PREEMPT Sun Jan 12 13:09:09 CET 2014 x86_64 GNU=
/Linux
>>=20
>> I'm sorry, I don't remember exactly which version worked, I have had=
 the disk connected to TV for
>> a long time and only recently I wanted to copy some movies on it. I =
guess it worked something like
>> 6 or 9 months ago.
>
>If you're up for compiling a custom kernel, can you try 3.12.7 with
>these two patches applied?
>
>http://marc.info/?l=3Dlinux-usb&m=3D138921117504911&w=3D2
>http://marc.info/?l=3Dlinux-usb&m=3D138921117604912&w=3D2
>
>I'm concerned the I/O errors are caused by commit 459d3c146117 "usb:
>xhci: Link TRB must not occur within a USB payload burst".
>
>Can you also send me the output of `sudo lspci -vvv -n`?  I need the
>output for the xHCI host only.
>
>Sarah Sharp
>
>> ______________________________________________________________
>> > Od: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > Komu: Milan Svoboda <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
>> > Datum: 20.01.2014 19:23
>> > P=C5=99edm=C4=9Bt: Re: usb disk recognized but fails
>> >
>> > CC: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "USB Storage List" <usb-storage@lis=
ts.one-eyed-alien.net>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >Cc-ing the USB storage list, in case this device needs some quirk.
>> >
>> >On Wed, Jan 15, 2014 at 03:47:39PM +0100, Milan Svoboda wrote:
>> >> The SATA adapter has a power input, but it is not used, it is con=
nected to the
>> >> PC with Y-type USB cable.
>> >>=20
>> >> The disk works with my "smart" TV, it works with Windows on the s=
ame machine,
>> >> it also had worked some time ago with Linux, but now it shows the=
 following:
>> >
>> >Do you know which kernel version it worked with?  What version are =
you
>> >currently running?  Please run `uname -a`.
>> >
>> >> [ 2192.027213] usb 1-3: new high-speed USB device number 5 using =
xhci_hcd
>> >> [ 2192.042323] ums-cypress 1-3:1.0: USB Mass Storage device detec=
ted
>> >> [ 2192.042500] scsi9 : usb-storage 1-3:1.0
>> >> [ 2193.044219] scsi 9:0:0:0: Direct-Access     WDC WD64 00BPVT-00=
HXZT0        PQ: 0 ANSI: 0
>> >> [ 2193.045083] sd 9:0:0:0: [sdb] 1250263728 512-byte logical bloc=
ks: (640 GB/596 GiB)
>> >> [ 2193.045240] sd 9:0:0:0: [sdb] Write Protect is off
>> >> [ 2193.045245] sd 9:0:0:0: [sdb] Mode Sense: 03 00 00 00
>> >> [ 2193.045384] sd 9:0:0:0: [sdb] No Caching mode page found
>> >> [ 2193.045388] sd 9:0:0:0: [sdb] Assuming drive cache: write thro=
ugh
>> >> [ 2193.046259] sd 9:0:0:0: [sdb] No Caching mode page found
>> >> [ 2193.046264] sd 9:0:0:0: [sdb] Assuming drive cache: write thro=
ugh
>> >> [ 2193.054389]  sdb: sdb1
>> >> [ 2193.055092] sd 9:0:0:0: [sdb] No Caching mode page found
>> >> [ 2193.055095] sd 9:0:0:0: [sdb] Assuming drive cache: write thro=
ugh
>> >> [ 2193.055098] sd 9:0:0:0: [sdb] Attached SCSI disk
>> >> [ 2200.821345] usb 1-3: reset high-speed USB device number 5 usin=
g xhci_hcd
>> >> [ 2200.835063] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint cal=
led with disabled ep ffff8800bc71e480
>> >> [ 2200.835068] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint cal=
led with disabled ep ffff8800bc71e4c0
>> >> [ 2267.897715] sd 9:0:0:0: [sdb] Unhandled sense code
>> >> [ 2267.897719] sd 9:0:0:0: [sdb] =20
>> >> [ 2267.897721] Result: hostbyte=3D0x07 driverbyte=3D0x08
>> >> [ 2267.897722] sd 9:0:0:0: [sdb] =20
>> >> [ 2267.897724] Sense Key : 0x4 [current]=20
>> >> [ 2267.897735] sd 9:0:0:0: [sdb] =20
>> >> [ 2267.897736] ASC=3D0x0 ASCQ=3D0x0
>> >> [ 2267.897738] sd 9:0:0:0: [sdb] CDB:=20
>> >> [ 2267.897740] cdb[0]=3D0x28: 28 00 4a 85 6e af 00 00 08 00
>> >> [ 2267.897746] end_request: I/O error, dev sdb, sector 1250258607
>> >> [ 2267.897750] Buffer I/O error on device sdb1, logical block 625=
129272
>> >> [ 2267.897752] Buffer I/O error on device sdb1, logical block 625=
129273
>> >> [ 2267.897753] Buffer I/O error on device sdb1, logical block 625=
129274
>> >> [ 2267.897754] Buffer I/O error on device sdb1, logical block 625=
129275
>> >> [ 2270.884154] usb 1-3: USB disconnect, device number 5
>> >>=20
>> >> Bus 001 Device 010: ID 14cd:6116 Super Top M6116 SATA Bridge
>> >> Device Descriptor:
>> >>   bLength                18
>> >>   bDescriptorType         1
>> >>   bcdUSB               2.00
>> >>   bDeviceClass            0 (Defined at Interface level)
>> >>   bDeviceSubClass         0=20
>> >>   bDeviceProtocol         0=20
>> >>   bMaxPacketSize0        64
>> >>   idVendor           0x14cd Super Top
>> >>   idProduct          0x6116 M6116 SATA Bridge
>> >>   bcdDevice            1.50
>> >>   iManufacturer           1 Super Top  =20
>> >>   iProduct                3 USB 2.0  SATA BRIDGE  =20
>> >>   iSerial                 2 M6116018VE15
>> >>   bNumConfigurations      1
>> >>   Configuration Descriptor:
>> >>     bLength                 9
>> >>     bDescriptorType         2
>> >>     wTotalLength           32
>> >>     bNumInterfaces          1
>> >>     bConfigurationValue     1
>> >>     iConfiguration          0=20
>> >>     bmAttributes         0xc0
>> >>       Self Powered
>> >>     MaxPower                2mA
>> >>     Interface Descriptor:
>> >>       bLength                 9
>> >>       bDescriptorType         4
>> >>       bInterfaceNumber        0
>> >>       bAlternateSetting       0
>> >>       bNumEndpoints           2
>> >>       bInterfaceClass         8 Mass Storage
>> >>       bInterfaceSubClass      6 SCSI
>> >>       bInterfaceProtocol     80 Bulk-Only
>> >>       iInterface              0=20
>> >>       Endpoint Descriptor:
>> >>         bLength                 7
>> >>         bDescriptorType         5
>> >>         bEndpointAddress     0x81  EP 1 IN
>> >>         bmAttributes            2
>> >>           Transfer Type            Bulk
>> >>           Synch Type               None
>> >>           Usage Type               Data
>> >>         wMaxPacketSize     0x0200  1x 512 bytes
>> >>         bInterval               0
>> >>       Endpoint Descriptor:
>> >>         bLength                 7
>> >>         bDescriptorType         5
>> >>         bEndpointAddress     0x02  EP 2 OUT
>> >>         bmAttributes            2
>> >>           Transfer Type            Bulk
>> >>           Synch Type               None
>> >>           Usage Type               Data
>> >>         wMaxPacketSize     0x0200  1x 512 bytes
>> >>         bInterval               0
>> >> Device Qualifier (for other device speed):
>> >>   bLength                10
>> >>   bDescriptorType         6
>> >>   bcdUSB               2.00
>> >>   bDeviceClass            0 (Defined at Interface level)
>> >>   bDeviceSubClass         0=20
>> >>   bDeviceProtocol         0=20
>> >>   bMaxPacketSize0        64
>> >>   bNumConfigurations      1
>> >> Device Status:     0x0001
>> >>   Self Powered
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-u=
sb" in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>> >
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
