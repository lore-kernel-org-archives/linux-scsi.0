From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_?=
	=?windows-1252?Q?scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Fri, 30 Sep 2011 12:26:31 +0530
Message-ID: <CADDb1s3CSvmqNGA48sHyOJ-pGpB1ix3WEVd0KV4b+s5yE3abLw@mail.gmail.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	<CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	<1317245383.22022.23.camel@dabdike.hansenpartnership.com>
	<CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
	<1317320825.3190.70.camel@dabdike.hansenpartnership.com>
	<1317321077.3190.71.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317321077.3190.71.camel@dabdike.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

[root@localhost Tools]# sg_inq --page=3D0x0 /dev/sdb
 Only hex output supported. sg_vpd decodes more pages.
VPD INQUIRY, page code=3D0x00:
   [PQual=3D0  Peripheral device type: disk]
   Supported VPD pages:
     0x1f
[root@localhost Tools]#



[root@localhost Tools]# sg_modes --page=3D0x3f /dev/sdb
    SAMSUNG   HM501IX              peripheral_type: disk [0x0]
Mode parameter header from MODE SENSE(10):
  Mode data length=3D66, medium type=3D0x00, WP=3D0, DpoFua=3D0, longlb=
a=3D0
  Block descriptor length=3D0
>> Read-Write error recovery, page_control: current
 00     01 0a 00 00 00 00 00 00  00 00 00 00
>> Flexible geometry (obsolete), page_control: current
 00     05 0a ff ff 10 3f 02 00  3f ff 00 00
>> Caching, page_control: current
 00     08 12 00 00 00 00 00 00  00 00 00 00 01 00 00 00
 10     00 00 00 00
>> page_code: 0x1b, page_control: current
 00     1b 0a 00 01 00 00 00 00  00 00 00 00
>> Unit Attention condition [vendor specific format], page_control: cur=
rent
 00     00 00
[root@localhost Tools]#



[root@localhost Tools]# sginfo -A /dev/sdb
INQUIRY response (cmd: 0x12)
----------------------------
Device Type                        0
Vendor:                    SAMSUNG
Product:                   HM501IX
Revision level:

No serial number (bad format for supported VPDs)

Read-Write Error Recovery mode page (0x1)
-----------------------------------------
AWRE                               0
ARRE                               0
TB                                 0
RC                                 0
EER                                0
PER                                0
DTE                                0
DCR                                0
Read Retry Count                   0
Correction Span                    0
Head Offset Count                  0
Data Strobe Offset Count           0
Write Retry Count                  0
Recovery Time Limit (ms)           0

mode page: 0x05   [Flexible Disk]
---------------
0x02                               0xff
0x03                               0xff
0x04                               0x10
0x05                               0x3f
0x06                               0x02
0x07                               0x00
0x08                               0x3f
0x09                               0xff
0x0a                               0x00
0x0b                               0x00

Caching mode page (0x8)
-----------------------
Initiator Control                  0
ABPF                               0
CAP                                0
DISC                               0
SIZE                               0
Write Cache Enabled                0
MF                                 0
Read Cache Disabled                0
Demand Read Retention Priority     0
Demand Write Retention Priority    0
Disable Pre-fetch Transfer Length  0
Minimum Pre-fetch                  0
Maximum Pre-fetch                  0
Maximum Pre-fetch Ceiling          0
=46SW                                0
LBCSS                              0
DRA                                0
NV_DIS                             1
Number of Cache Segments           0
Cache Segment size                 0
Non-Cache Segment size             0

mode page: 0x1b
---------------
0x02                               0x00
0x03                               0x01
0x04                               0x00
0x05                               0x00
0x06                               0x00
0x07                               0x00
0x08                               0x00
0x09                               0x00
0x0a                               0x00
0x0b                               0x00

mode page: 0x00   [Vendor (non-page format)]
---------------
0x00                               0x00
0x01                               0x00

[root@localhost Tools]#

Comparision for USB HDD and Normal Hard disk connected to system.(For
USB HDD it showing Write Cache - False, for normal Hard disk - Write
Cache - True)
[root@localhost Tools]# sg_modes --page=3D0x3f /dev/sdb
    SAMSUNG   HM501IX              peripheral_type: disk [0x0]
Mode parameter header from MODE SENSE(10):
  Mode data length=3D66, medium type=3D0x00, WP=3D0, DpoFua=3D0, longlb=
a=3D0
  Block descriptor length=3D0
>> Read-Write error recovery, page_control: current
 00     01 0a 00 00 00 00 00 00  00 00 00 00
>> Flexible geometry (obsolete), page_control: current
 00     05 0a ff ff 10 3f 02 00  3f ff 00 00
>> Caching, page_control: current
 00     08 12 00 00 00 00 00 00  00 00 00 00 01 00 00 00
 10     00 00 00 00
>> page_code: 0x1b, page_control: current
 00     1b 0a 00 01 00 00 00 00  00 00 00 00
>> Unit Attention condition [vendor specific format], page_control: cur=
rent
 00     00 00
[root@localhost Tools]# sg_modes --page=3D0x3f /dev/sda
    ATA       SAMSUNG HD502HJ   1AJ1   peripheral_type: disk [0x0]
Mode parameter header from MODE SENSE(10):
  Mode data length=3D60, medium type=3D0x00, WP=3D0, DpoFua=3D0, longlb=
a=3D0
  Block descriptor length=3D8
> Direct access device block descriptors:
   Density code=3D0x0
 00     00 00 00 00 00 00 02 00

>> Read-Write error recovery, page_control: current
 00     01 0a 80 00 00 00 00 00  00 00 00 00
>> Caching, page_control: current
 00     08 12 04 00 00 00 00 00  00 00 00 00 00 00 00 00
 10     00 00 00 00
>> Control, page_control: current
 00     0a 0a 02 00 00 00 00 00  ff ff 00 1e
[root@localhost Tools]#

Now, for the USB HDD which do have write cache - sginfo is showing
them to Write Cache Enabled as false.
Why do the result of hdparm identification and sginfo varies- (I know
they have different interface to work with and hdparm takes care of
that by using SG_IO interface from it's code)? hdparm showed me
correct results - that lead me to digging in the kernel code and
checking the performance for USB HDD with Write cache enabled/disabled
- which also showed that QUEUE ordering chosen for USB HDD is not
correct.
I have a large number of USB HDD's - with different vendors, and for
all of them - it is showing Write Cache Enabled as false.
The code works only for the Pen Drives or the USB HDD which do not
have internal cache.

Also, for journalling filesystem being used on USB HDD - it does
becomes a cause of concern.

Please share your opinion, I guess we need a change for mode sensing
in the kernel code for USB HDD.

Thanks & Regards,
Amit Sahrawat



On Fri, Sep 30, 2011 at 12:01 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2011-09-29 at 13:27 -0500, James Bottomley wrote:
>> On Thu, 2011-09-29 at 14:49 +0530, Amit Sahrawat wrote:
>> > The patch did not work, although it did get pass the earlier condi=
tion
>> > which I mentioned- but still Write Cache is not taken into account=
 =96
>> > seems mode sensing in sd_read_cache_type() does not send proper
>> > request to the device =96 or does not read in proper bytes for thi=
s(as
>> > per hdparm command analysis):
>> >
>> > Logs After Connecting:
>> > scsi 0:0:0:0: Direct-Access =A0 =A0 Seagate =A0Portable =A0 =A0 =A0=
 =A0 0130 PQ: 0 ANSI: 4
>> > sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 G=
iB)
>> > sd 0:0:0:0: [sda] Write Protect is off
>> > sd 0:0:0:0: [sda] No Caching mode page present
>>
>> This line means that a request for page 0x0 didn't turn up the cachi=
ng
>> mode page in the list of supported pages.
>>
>> What does
>>
>> sg_inq =A0--page=3D0x0 /dev/sda
>
> Um, lets try that again, this time with the correct information. =A0W=
hat
> we're looking for is the list of mode pages, so
>
> sg_modes --page=3D0x3f /dev/sda
>
> Should return it.
>
> Thanks,
>
> James
>
>
>
