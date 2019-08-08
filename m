From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion (resid=78, sector_sz=512)
Date: Thu, 8 Aug 2019 04:27:18 -0400
Message-ID: <002d01d54dc3$17c278c0$47476a40$@lucidpixels.com>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com> <yq1ftmcct1j.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ftmcct1j.fsf@oracle.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]=20
Sent: Wednesday, August 7, 2019 10:04 PM
To: Justin Piszcz
Cc: 'LKML'; linux-usb@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial =
completion (resid=3D78, sector_sz=3D512)


Justin,

> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back =
and
> ran some file copy tests and was getting these warnings-- is there any =
way
> to avoid these warnings?  I did confirm with parted that the partition =
was
> aligned but this appears to be something related to the firmware on =
the
> device according to [1] and [2]?

Please send us the output of:

# sg_vpd -p bl /dev/sdN
# sg_vpd -p bdc /dev/sdN
# sg_readcap -l /dev/sdN

[ .. ]

Disk type:
---
Disk /dev/sdf: 7.3 TiB, 8001562869760 bytes, 15628052480 sectors
Disk model: My Book 25EE

# sg_vpd -p bl /dev/sdf > /tmp/sg_vpd_bl.txt
# sg_vpd -p bdc /dev/sdf > /tmp/sg_vpd_bdc.txt
# sg_readcap -l /dev/sdf > /tmp/sg_readcap.txt
#  ls -l /tmp/sg_vpd_bl.txt /tmp/sg_vpd_bdc.txt /tmp/sg_readcap.txt
-rw-r--r-- 1 root root 421 Aug  8 04:26 /tmp/sg_readcap.txt
-rw-r--r-- 1 root root 244 Aug  8 04:25 /tmp/sg_vpd_bdc.txt
-rw-r--r-- 1 root root 972 Aug  8 04:25 /tmp/sg_vpd_bl.txt

Output:

sg_readcap.txt
Read Capacity results:
   Protection: prot_en=3D0, p_type=3D0, p_i_exponent=3D0
   Logical block provisioning: lbpme=3D0, lbprz=3D0
   Last LBA=3D15628052479 (0x3a38127ff), Number of logical =
blocks=3D15628052480
   Logical block length=3D512 bytes
   Logical blocks per physical block exponent=3D3 [so physical block =
length=3D4096 bytes]
   Lowest aligned LBA=3D0
Hence:
   Device size: 8001562869760 bytes, 7630885.0 MiB, 8001.56 GB, 8.00 TB

sg_vpd_bdc.txt
Block device characteristics VPD page (SBC):
  Nominal rotation rate: 5400 rpm
  Product type: Not specified
  WABEREQ=3D0
  WACEREQ=3D0
  Nominal form factor: 3.5 inch
  ZONED=3D0
  RBWZ=3D0
  BOCS=3D0
  FUAB=3D0
  VBULS=3D0
  DEPOPULATION_TIME=3D0 (seconds)

sg_vpd_bl.txt
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks [Command not implemented]
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 65535 blocks
  Optimal transfer length: 65535 blocks
  Maximum prefetch transfer length: 65535 blocks
  Maximum unmap LBA count: 0 [Unmap command not implemented]
  Maximum unmap block descriptor count: 0 [Unmap command not =
implemented]
  Optimal unmap granularity: 0 blocks [not reported]
  Unmap granularity alignment valid: false
  Unmap granularity alignment: 0 [invalid]
  Maximum write same length: 0 blocks [not reported]
  Maximum atomic transfer length: 0 blocks [not reported]
  Atomic alignment: 0 [unaligned atomic writes permitted]
  Atomic transfer length granularity: 0 [no granularity requirement
  Maximum atomic transfer length with atomic boundary: 0 blocks [not =
reported]
  Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]
