From: Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
	=?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
	=?windows-1252?Q?type=29?=
Date: Fri, 7 Oct 2011 10:39:45 +0530
Message-ID: <CADDb1s3524xiQfde3tiub=QvkrRH0yo8vsurSn2ewMQJe2oktw@mail.gmail.com>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	<Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
	<CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
	<CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
	<CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
	<1317835442.7238.8.camel@dabdike>
	<CADDb1s031VX65+G-Uq-12y4qWq98-OS6DKz7mUCo=8AQkVQVTQ@mail.gmail.com>
	<1317845295.7238.15.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317845295.7238.15.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Trying to set the cache type as "write back" through "echo "write
back" > /sys/class/scsi_disk/<disk>/cache_type" does not work.
=46ew logs :
#> usb 2-1.4: new high speed USB device using ehci-sdp and address 5
usb 2-1.4: New USB device found, idVendor=3D152d, idProduct=3D2339
usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
5
usb 2-1.4: Product: USB to ATA/ATAPI Bridge
usb 2-1.4: Manufacturer: JMicron
usb 2-1.4: SerialNumber: 3446184AA01C
scsi1 : usb-storage 2-1.4:1.0
scsi 1:0:0:0: Direct-Access     SAMSUNG  HM501IX               PQ: 0 AN=
SI: 2 CCS
sd 1:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda:

#> echo "write back" > /sys/class/scsi_disk/1\:0\:0\:0/cache_type
sd 1:0:0:0: [sda] Sense Key : 0x5 [current]
sd 1:0:0:0: [sda] ASC=3D0x20 ASCQ=3D0x0


#> usb 2-1.4: new high speed USB device using ehci-sdp and address 4
usb 2-1.4: New USB device found, idVendor=3D0bc2, idProduct=3D2300
usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
3
usb 2-1.4: Product: Portable
usb 2-1.4: Manufacturer: Seagate
usb 2-1.4: SerialNumber: 2GHW02GR
scsi0 : usb-storage 2-1.4:1.0

#>
#> scsi 0:0:0:0: Direct-Access     Seagate  Portable         0130 PQ: 0=
 ANSI: 4
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

#> echo "write back" > /sys/class/scsi_disk/0\:0\:0\:0/cache_type
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
#>


#> usb 2-1.4: new high speed USB device using ehci-sdp and address 7
usb 2-1.4: New USB device found, idVendor=3D1058, idProduct=3D070a
usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
3
usb 2-1.4: Product: My Passport 070A
usb 2-1.4: Manufacturer: Western Digital
usb 2-1.4: SerialNumber: 575832314132304534373635
scsi3 : usb-storage 2-1.4:1.0
scsi 3:0:0:0: Direct-Access     WD       My Passport 070A 1032 PQ: 0 AN=
SI: 4
scsi 3:0:0:1: CD-ROM            WD       Virtual CD 070A  1032 PQ: 0 AN=
SI: 4
scsi 3:0:0:2: Enclosure         WD       SES Device       1032 PQ: 0 AN=
SI: 4
sd 3:0:0:0: [sda] 623769600 512-byte logical blocks: (319 GB/297 GiB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] No Caching mode page present
sd 3:0:0:0: [sda] Assuming drive cache: write through
sd 3:0:0:0: [sda] No Caching mode page present
sd 3:0:0:0: [sda] Assuming drive cache: write through
 sda:
sd 3:0:0:0: [sda] No Caching mode page present
sd 3:0:0:0: [sda] Assuming drive cache: write through
sd 3:0:0:0: [sda] Attached SCSI disk

#> cat /sys/class/scsi_disk/3\:0\:0\:0/cache_type
write through
#> echo "write back" > /sys/class/scsi_disk/3\:0\:0\:0/cache_type
#>
#> echo "write back" > /sys/class/scsi_disk/3\:0\:0\:0/cache_type
#>
#>
#> cat /sys/class/scsi_disk/3\:0\:0\:0/cache_type
write through

Regards,
Amit Sahrawat

On Thu, Oct 6, 2011 at 1:38 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2011-10-06 at 01:21 +0530, Amit Sahrawat wrote:
>> > The best we could probably offer is an interface to turn on the WC=
E bit
>> > in software (technically, you can do this today
>> > in /scsi/class/scsi_disk/<disk>/cache_type, it's just that it will=
 try
>> > to commit the change as a MODE_SELECT which will presumably fail).
>> Thanks James, is this related with SCSI command MODE_SELECT? and thi=
s
>> is to be passed when there is some failure?
>> or simply doing an "echo <value>" to
>> /scsi/class/scsi_disk/<disk>/cache_type? can you please elaborate a
>> little
>
> You tell me since you have the device. =A0What that echo does is that=
 it
> does try to make the change permanent with a mode select ... that lik=
ely
> won't work and the cache change only takes if the revalidated disk sa=
ys
> the write back has been enabled (which I really think it won't). =A0S=
o I
> think you need an additional software bit to flip for the case where =
the
> device lies.
>
> James
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
