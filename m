From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_?=
	=?windows-1252?Q?scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Thu, 29 Sep 2011 14:49:32 +0530
Message-ID: <CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	<CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	<1317245383.22022.23.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48609 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1I2JTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2011 05:19:34 -0400
In-Reply-To: <1317245383.22022.23.camel@dabdike.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

The patch did not work, although it did get pass the earlier condition
which I mentioned- but still Write Cache is not taken into account =96
seems mode sensing in sd_read_cache_type() does not send proper
request to the device =96 or does not read in proper bytes for this(as
per hdparm command analysis):

Logs After Connecting:
scsi 0:0:0:0: Direct-Access     Seagate  Portable         0130 PQ: 0 AN=
SI: 4
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk

Second Hard-Disk
usb 4-1.4: new high speed USB device using ehci-sdp and address 3
usb 4-1.4: New USB device found, idVendor=3D152d, idProduct=3D2339
usb 4-1.4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
5
usb 4-1.4: Product: USB to ATA/ATAPI Bridge
usb 4-1.4: Manufacturer: JMicron
usb 4-1.4: SerialNumber: 3446184AA01C
scsi0 : usb-storage 4-1.4:1.0
usb 3-1.1.1: new full speed USB device using ehci-sdp and address 4
usb 3-1.1.1: New USB device found, idVendor=3D0a5c, idProduct=3D4502
usb 3-1.1.1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=
=3D0
usb 3-1.1.2: new full speed USB device using ehci-sdp and address 5
usb 3-1.1.2: New USB device found, idVendor=3D0a5c, idProduct=3D4503
usb 3-1.1.2: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=
=3D0
usb 3-1.1.3: new full speed USB device using ehci-sdp and address 6
usb 3-1.1.3: New USB device found, idVendor=3D0a5c, idProduct=3D2046
usb 3-1.1.3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=
=3D3
usb 3-1.1.3: Product: BCM2046B1
usb 3-1.1.3: Manufacturer: Broadcom Corp
usb 3-1.1.3: SerialNumber: E4E0C53861A2
scsi 0:0:0:0: Direct-Access     SAMSUNG  HM501IX               PQ: 0 AN=
SI: 2 CCS
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda:
 sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk

Device Identification Retrieved using =93hdparm =96I=94 shows this:
#> hdparm --verbose -I /dev/sda3

/dev/sda3:
outgoing cdb:  85 08 0e 00 00 00 01 00 00 00 00 00 00 40 ec 00
SG_IO: ATA_16 status=3D0x0, host_status=3D0x0, driver_status=3D0x0
SG_IO: sb[]:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
incoming_data:  5a 0c ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00 00 00
00 00 20 20 20 20 20 20 20 20 20 20 20 20 56 36 51 43 4e 33 35 57 00
00 00 40 04 00 30 30 32 30 53 42 31 4d 54 53 32 39 30 35 31 33 41 35
20 53 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
20 20 20 20 20 20 20 10 80 00 00 00 2f 00 40 00 02 00 02 07 00 ff 3f
10 00 3f 00 10 fc fb 00 10 01 ff ff ff 0f 00 00 07 00 03 00 78 00 78
00 78 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 1f 00 02 05 00 00
48 00 40 00 f0 01 29 00 6b 34 09 7d 23 61 69 34 09 bc 23 61 7f 40 24
00 24 00 80 80 fe ff 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 70 59
1c 1d 00 00 00 00 00 00 00 00 00 00 00 00 00 50 00 c5 dc 32 73 79 00
00 00 00 00 00 00 00 00 00 00 00 00 00 1e 40 1c 40 00 00 00 00 00 00
00 00 00 00 00 00 00 00 21 00 70 59 1c 1d 70 59 1c 1d 20 20 02 00 40
01 00 01 00 50 06 3c 0a 3c 00 00 3c 00 00 00 08 00 00 00 00 00 1f 00
80 02 00 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
3c 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 3b 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 18 15 00 00 00 00 00 00 00 00 10 10 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 a5 d4
SG_IO: desc[]:  00 00
      ATA_16 stat=3D00 err=3D00 nsect=3D00 lbal=3D00 lbam=3D00 lbah=3D0=
0 dev=3D00
ATA device, with non-removable media
	Model Number:       ST9250315AS
	Serial Number:      6VCQ3NW5
	Firmware Revision:  0002BSM1
	Transport:          Serial
Standards:
	Used: unknown (minor revision code 0x0029)
	Supported: 8 7 6 5
	Likely used: 8
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  488397168
	Logical/Physical Sector size:           512 bytes
	device size with M =3D 1024*1024:      238475 MBytes
	device size with M =3D 1000*1000:      250059 MBytes (250 GB)
	cache/buffer size  =3D 8192 KBytes
	Nominal Media Rotation Rate: 5400
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D 16
	Advanced power management level: 128
	Recommended acoustic management value: 254, current value: 0
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	IDLE_IMMEDIATE with UNLOAD
	    	Write-Read-Verify feature set
	   *	WRITE_UNCORRECTABLE_EXT command
	   *	{READ,WRITE}_DMA_EXT_GPL commands
	   *	Segmented DOWNLOAD_MICROCODE
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	    	Device-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Long Sector Access (AC1)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
	    	unknown 206[12] (vendor specific)
Security:
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
		supported: enhanced erase
	72min for SECURITY ERASE UNIT. 72min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000c50032dc7973
	NAA		: 5
	IEEE OUI	: 000c50
	Unique ID	: 032dc7973
Checksum: correct

And the impact of Enabling/Disabling Cache can be seen in:
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	    	Write cache =96 Changes after doing =91hdparm =96W 0/1=92
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command

Looking at corresponding code in =91hdparm=92 to fetch this: an ioctl w=
ith
command =91ATA_OP_IDENTIFY=92 is passed to the device using SG_IO
interface (function =96 get_identify_data()) =96 which receives the buf=
fer
data and that is passed to identify the device specification.
file:identify.c, function: void identify (__u16 *id_supplied)

printf("Commands/features:\n\tEnabled\tSupported:\n");
                print_features(val[CMDS_SUPP_0] & 0x7fff,
val[CMDS_EN_0], feat_word82_str);

static const char *feat_word82_str[16] =3D {
        "obsolete 82[15]",                              /* word 82 bit
15: obsolete  */
        "NOP cmd",                                      /* word 82 bit =
14 */
        "READ_BUFFER command",                          /* word 82 bit =
13 */
        "WRITE_BUFFER command",                         /* word 82 bit =
12 */
        "WRITE_VERIFY command",                         /* word 82 bit
11: obsolete  */
        "Host Protected Area feature set",              /* word 82 bit =
10 */
        "DEVICE_RESET command",                         /* word 82 bit =
 9 */
        "SERVICE interrupt",                            /* word 82 bit =
 8 */
        "Release interrupt",                            /* word 82 bit =
 7 */
        "Look-ahead",                                   /* word 82 bit =
 6 */
        "Write cache",                                  /* word 82 bit =
 5 */
        "PACKET command feature set",                   /* word 82 bit =
 4 */
        "Power Management feature set",                 /* word 82 bit =
 3 */
        "Removable Media feature set",                  /* word 82 bit =
 2 */
        "Security Mode feature set",                    /* word 82 bit =
 1 */
        "SMART feature set"                             /* word 82 bit =
 0 */
};
static void print_features (__u16 supported, __u16 enabled, const char =
*names[])
{
        int i;
        for (i =3D 0; i < 16; ++i) {
                __u16 mask =3D 1 << i;
                if ((supported & mask) && names[15 - i])
                        printf("\t   %c\t%s\n", (enabled & mask) ? '*'
: ' ', names[15 - i]);
        }
}

In this, the corresponding =91Words=92 which are passed are:
011010001101011 =96 34 6b -val[82] =96 Supported
011010001101001 =96 34 69 -val[85] =96 When Write Cache is Enabled
011010001001001 =96 34 49 -val[85] =96 When Write Cache is Disabled

Val[82], val[85] indicates Words from the buffer received in response
to the ATA_OP_IDENTIFY =96 IOCTL
=46or Disabled Write Cache:
Identify Data:  5a 0c ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00 00 00
00 00 20 20 20 20 20 20 20 20 20 20 20 20 56 36 51 43 4e 33 35 57 00
00 00 40 04 00 30 30 32 30 53 42 31 4d 54 53 32 39 30 35 31 33 41 35
20 53 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
20 20 20 20 20 20 20 10 80 00 00 00 2f 00 40 00 02 00 02 07 00 ff 3f
10 00 3f 00 10 fc fb 00 10 01 ff ff ff 0f 00 00 07 00 03 00 78 00 78
00 78 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 1f 00 02 05 00 00
48 00 40 00 f0 01 29 00 6b 34 09 7d 23 61 49 34 09 bc 23 61 7f 40 24
00 24 00 80 80 fe ff 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 70 59
1c 1d 00 00 00 00 00 00 00 00 00 00 00 00 00 50 00 c5 dc 32 73 79 00
00 00 00 00 00 00 00 00 00 00 00 00 00 1e 40 1c 40 00 00 00 00 00 00
00 00 00 00 00 00 00 00

=46or Enabled Write Cache:
Identify Data:  5a 0c ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00 00 00
00 00 20 20 20 20 20 20 20 20 20 20 20 20 56 36 51 43 4e 33 35 57 00
00 00 40 04 00 30 30 32 30 53 42 31 4d 54 53 32 39 30 35 31 33 41 35
20 53 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
20 20 20 20 20 20 20 10 80 00 00 00 2f 00 40 00 02 00 02 07 00 ff 3f
10 00 3f 00 10 fc fb 00 10 01 ff ff ff 0f 00 00 07 00 03 00 78 00 78
00 78 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 1f 00 02 05 00 00
48 00 40 00 f0 01 29 00 6b 34 09 7d 23 61 69 34 09 bc 23 61 7f 40 24
00 24 00 80 80 fe ff 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 70 59
1c 1d 00 00 00 00 00 00 00 00 00 00 00 00 00 50 00 c5 dc 32 73 79 00
00 00 00 00 00 00 00 00 00 00 00 00 00 1e 40 1c 40 00 00 00 00 00 00
00 00 00 00 00 00 00 00

So, probably the kernel code for sensing the disk and reading to check
for the presence of the cache is not working for these USB HDD=92s, I
have tried with a number of hard-disk=92s(different manufactures =96
with/without write cache) just to make sure that the observation is
correct.

The corresponding effect of enabling/disabling the write cache can be
seen on the write performance also - .

Please share your opinion on this.

Thanks & Regards,
Amit Sahrawat


On Thu, Sep 29, 2011 at 2:59 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2011-09-28 at 21:27 +0530, Amit Sahrawat wrote:
>> Marking mail to linux-scsi.
>>
>> Thanks Christoph.
>>
>> Regards,
>> Amit Sahrawat
>>
>> On Wed, Sep 28, 2011 at 9:12 PM, Amit Sahrawat
>> <amit.sahrawat83@gmail.com> wrote:
>> > When a USB HDD is connected to the device, it invokes slave_config=
ure
>> > to configure the USB HDD. In this function, whenever there is a SC=
SI
>> > device of type TYPE_DISK, it sets:
>> > =A0 =A0 =A0 =A0/* A number of devices have problems with MODE SENS=
E for
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * page x08, so we will skip it. */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sdev->skip_ms_page_8 =3D 1;
>> >
>> > Now, as a part of SCSI device probing, in the function
>> > sd_revalidate_disk()-->sd_read_cache_type(), there is a condition
>> > if (sdp->skip_ms_page_8)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto defaults;
>> > which becomes always true for all the USB HDD=92s =96 the net resu=
lt is
>> > that the Write Cache is never considered for USB HDD(WCE =3D 0) =96
>> > =93Assuming drive cache: write through=94
>> >
>> > What=92s more =96 the QUEUE ordering which is marked for WCE=3D0 i=
s
>> > QUEUE_ORDERED_DRAIN, instead of QUEUE_ORDERED_DRAIN_FLUSH
>> > This means there is no flushing of USB HDD internal cache (althoug=
h
>> > SYNCHRONIZE_CACHE is implemented as passed as command in
>> > sd_prepare_flush) =96 queue_flush()(called in function
>> > blk_do_ordered()-->start_ordered()) does not gets called in case o=
f
>> > QUEUE_ORDERED_DRAIN.
>> >
>> > This causes a serious impact on USB HDD=92s.
>> >
>> > Please let me know in case I have missed something in my observati=
ons.
>
> This should be working in 3.0 ... what version of the kernel are you
> testing. =A0The actual patch that relaxes the caching mode page check=
 is
> this one:
>
> commit 0bcaa11154f07502e68375617e5650173eea8e50
> Author: Luben Tuikov <ltuikov@yahoo.com>
> Date: =A0 Thu May 19 00:00:58 2011 -0700
>
> =A0 =A0[SCSI] Retrieve the Caching mode page (version 2)
>
> James
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
