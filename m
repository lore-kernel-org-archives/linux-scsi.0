From: Alexander Voropay <alexander.voropay@gmail.com>
Subject: SCSI controller with CDB-16 (Was: sym53c8xx and Large disk (DCB-16))
Date: Wed, 31 May 2017 12:22:10 +0300
Message-ID: <CAGqcPWD2RuR5Odc+8Hf+tDgA9-DTpDiKJ4GwjF6g0qTJrjMJ8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36362 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbdEaJWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 05:22:12 -0400
Received: by mail-it0-f43.google.com with SMTP id m47so10484716iti.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2017 02:22:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, linux-scsi!

I've re replaced sym53c8xx SCSI controller with
Adaptec ASC-29320ALP (chip AIC-7901).
- Ultra320 bus does not work physically, too many errors.
- Ultra160 bus works relable, no errors.

Unfortunately Adaptec does not work with CDB-16 too :(

scsi11 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=3D7, PCI-X 101-133MHz, 51=
2 SCBs
scsi 11:0:0:0: Direct-Access     IFT      A24U-G2421-1     347R PQ: 0 ANSI:=
 5
scsi target11:0:0: asynchronous
scsi11:A:0:0: Tagged Queuing enabled.  Depth 4
scsi target11:0:0: Beginning Domain Validation
scsi target11:0:0: wide asynchronous
scsi target11:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
scsi target11:0:0: Ending Domain Validation
sd 11:0:0:0: [sde] Very big device. Trying to use READ CAPACITY(16).
sd 11:0:0:0: [sde] READ CAPACITY(16) failed
sd 11:0:0:0: [sde]  Result: hostbyte=3DDID_ABORT driverbyte=3DDRIVER_OK
sd 11:0:0:0: [sde] Sense not available.
sd 11:0:0:0: [sde] Using 0xffffffff as device size
sd 11:0:0:0: [sde] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
sd 11:0:0:0: [sde] Write Protect is off
sd 11:0:0:0: [sde] Mode Sense: 9b 00 00 08
sd 11:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 11:0:0:0: [sde] Very big device. Trying to use READ CAPACITY(16).
sd 11:0:0:0: [sde] READ CAPACITY(16) failed
sd 11:0:0:0: [sde]  Result: hostbyte=3DDID_ABORT driverbyte=3DDRIVER_OK
sd 11:0:0:0: [sde] Sense not available.
sd 11:0:0:0: [sde] Using 0xffffffff as device size
sd 11:0:0:0: Attached scsi generic sg5 type 0
sde: unknown partition table
sd 11:0:0:0: [sde] Very big device. Trying to use READ CAPACITY(16).
sd 11:0:0:0: [sde] READ CAPACITY(16) failed
sd 11:0:0:0: [sde]  Result: hostbyte=3DDID_ABORT driverbyte=3DDRIVER_OK
sd 11:0:0:0: [sde] Sense not available.
sd 11:0:0:0: [sde] Using 0xffffffff as device size
sd 11:0:0:0: [sde] Attached SCSI disk


CAN ANYONE PLEASE recommend a working Ultra320 SCSI controller
with CDB-16 support ?


2017-04-27 18:33 GMT+03:00 Alexander Voropay <alexander.voropay@gmail.com>:
> Hi!
>
> I have a nasty bug with =E2=80=98sym53c8xx_2=E2=80=99 SCSI driver. I=E2=
=80=99m trying to
> attach a large (>2Tb) storage to this controller but it does not work.
> Seems nobody tested such combination before...
>
>
> My SCSI controller is noname OEM for Intel, PCI-X card with SYN53C1010 ch=
ip.
> Storage: Infortrend A24U-G2421-1 (upto 24 SATA disks to Ulra-320 SCSI cha=
nnel).
> I have 11x1Tb  RAID5 as one large disk with 10Tb in size.
> My Linux is RHEL 6, kernel "kernel-2.6.32-696.1.1.el6.x86_64".
>
> Physical SCSI link is OK, full Ultra-160, no physical/parity errors
> e.t.c. BUT IT DOES NOT WORK due to a software error.
>
> As it is known, Linux=E2=80=99s =E2=80=98sd=E2=80=99 uses CDB-16 command =
set for large SCSI
> disks. On the other hand =E2=80=98sym53c8xx_2=E2=80=99 driver =E2=80=9CUt=
ilizes SCRIPTS
> Load/Store command=E2=80=9D and =E2=80=9CHandles Phase Mismatch from SCRI=
PTS=E2=80=9D. Seems
> there is a software error between driver and =E2=80=9Csd=E2=80=9D. As a r=
esult ALL
> disk operations are damn slow and gives a phase error in the =E2=80=9Cdme=
sg=E2=80=9D:
> sd 4:0:0:0: phase change 2-7 16@37a9af60 resid=3D10.
> sd 4:0:0:0: phase change 2-7 16@37a9af60 resid=3D10.
> sd 4:0:0:0: phase change 2-7 16@37a9af60 resid=3D10.
> e.t.c.
>
> Another problem: =E2=80=9Csd=E2=80=9D incorrectly determines a disk size.=
 Note a
> =E2=80=9Cphase change=E2=80=9D errors after and before =E2=80=9Ccapacity =
change=E2=80=9D. As a result
> =E2=80=9Csd=E2=80=9D switches to CDB-10 and maximum disk size limited by =
2Tb
>
> sym53c8xx 0000: 05:01.0: PCI INT A disabled
> sym53c8xx 0000: 05:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
> sym0: <1010-66> rev 0x1 at pci 0000: 05:01.0 irq 24
> sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: handling phase mismatch from SCRIPTS.
> sym0: SCSI BUS has been reset.
> scsi4 : sym-2.2.3
> scsi 4:0:0:0: Direct-Access     IFT      A24U-G2421-1     347R PQ: 0 ANSI=
: 5
> scsi target4:0:0: tagged command queuing enabled, command queue depth 16.
> scsi target4:0:0: Beginning Domain Validation
> scsi target4:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
> scsi target4:0:0: Ending Domain Validation
> sd 4:0:0:0: phase change 2-7 16@37a9af60 resid=3D10.
> sd 4:0:0:0: [sde] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
> sd 4:0:0:0: [sde] Write Protect is off
> sd 4:0:0:0: [sde] Mode Sense: 9b 00 00 08
> sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 4:0:0:0: phase change 2-7 16@37a9af60 resid=3D10.
> sd 4:0:0:0: Attached scsi generic sg5 type 0
> sd 4:0:0:0: [sde] 19529912320 512-byte logical blocks: (9.99 TB/9.09 TiB)
> sde: detected capacity change from 2199023255552 to 9999315107840
> sde: unknown partition table
> sd 4:0:0:0: phase change 2-7 16@37a9af60 resid=3D10.
> sd 4:0:0:0: [sde] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
> sd 4:0:0:0: [sde] Attached SCSI disk
>
> As a result =E2=80=98parted=E2=80=99 does not work too, it hangs on =E2=
=80=9Cmklabel gpt=E2=80=9D and
> kernel log filled with tons of =E2=80=9Cphase change=E2=80=9D errors.
>
> Interestingly, most of =E2=80=9Csg_*=E2=80=9D utilities works fine even w=
ith --16 option.
>
> [root@stora ~]# sg_readcap -v /dev/sg5
>    read capacity (10) cdb: 25 00 00 00 00 00 00 00 00 00
> READ CAPACITY (10) indicates device capacity too large
>  now trying 16 byte cdb variant
>    read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 0=
0
>    read capacity (16): requested 32 bytes but got 12 bytes
> Read Capacity results:
>   Protection: prot_en=3D1, p_type=3D7, p_i_exponent=3D15
>   Thin provisioning: tpe=3D1, tprz=3D1
>   Last logical block address=3D19529912319 (0x48c12cfff), Number of
> logical blocks=3D19529912320
>   Logical block length=3D512 bytes
>   Logical blocks per physical block exponent=3D15
>   Lowest aligned logical block address=3D16383
> Hence:
>   Device size: 9999315107840 bytes, 9536090.0 MiB, 9999.32 GB
>
> UPD: I=E2=80=99ve found another PCI-X card from the old SUN server on the
> NCR53C897 (it has no PC-style BIOS but recognized). IT DOES NOT WORK
> TOO with the SAME error.
>
> sym53c8xx 0000:06:02.0: PCI INT A disabled
> sym53c8xx 0000:06:02.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
> sym0: <896> rev 0x7 at pci 0000:06:02.0 irq 26
> sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
> sym0: SCSI BUS has been reset.
> scsi9 : sym-2.2.3
> sym53c8xx 0000:06:02.1: PCI INT B -> GSI 27 (level, low) -> IRQ 27
> sym1: <896> rev 0x7 at pci 0000:06:02.1 irq 27
> sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
> sym1: SCSI BUS has been reset.
> scsi10 : sym-2.2.3
> scsi 9:0:0:0: Direct-Access     IFT      A24U-G2421-1     347R PQ: 0 ANSI=
: 5
> scsi target9:0:0: tagged command queuing enabled, command queue depth 16.
> scsi target9:0:0: Beginning Domain Validation
> scsi target9:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
> scsi target9:0:0: Domain Validation skipping write tests
> scsi target9:0:0: Ending Domain Validation
> sd 9:0:0:0: phase change 2-7 16@37aaff60 resid=3D10.
> sd 9:0:0:0: [sde] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
> sd 9:0:0:0: Attached scsi generic sg5 type 0
> sd 9:0:0:0: [sde] Write Protect is off
> sd 9:0:0:0: [sde] Mode Sense: 9b 00 00 08
> sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 9:0:0:0: phase change 2-7 16@37aaff60 resid=3D10.
> sd 9:0:0:0: [sde] 19529912320 512-byte logical blocks: (9.99 TB/9.09 TiB)
> sde: detected capacity change from 2199023255552 to 9999315107840
> sde: unknown partition table
> sd 9:0:0:0: phase change 2-7 16@37aaff60 resid=3D10.
> sd 9:0:0:0: [sde] 4294967296 512-byte logical blocks: (2.19 TB/2.00 TiB)
> sd 9:0:0:0: [sde] Attached SCSI disk
>
>
> --
> -=3DAV=3D-
