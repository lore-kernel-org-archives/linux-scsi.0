From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] driverfs scsi for 2.5.24
Date: Wed, 03 Jul 2002 00:29:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D227DB2.FD3D151@torque.net>
References: <3D12032C.7040105@evision-ventures.com> <Pine.LNX.4.33.0206201230190.654-100000@geena.pdx.osdl.net> <20020621092943.D1243@austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------26DE32BF178181414B5E4F38"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: sullivan <sullivan@austin.ibm.com>
Cc: Patrick Mochel <mochel@osdl.org>, Martin Dalecki <dalecki@evision-ventures.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------26DE32BF178181414B5E4F38
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Attached is Mike Sullivan's driverfs patch which was released
on June 21. It has been minimally changed so it applies to
lk 2.5.24 . 

Here are Mike's original notes:

Mike Sullivan wrote:
> 
> The driverfs patch for SCSI that was recently posted was the kernel portion of
> a device naming project that is intended to support all devices, at least the
> ones that implement to driverfs in a standard way. There are three items that
> IMHO should be considered as part of the standard set that driverfs requires:
> 
> 1. device type - It appears that Pat is heading down this path with the class
>         type support so maybe this is a no brainer. Currently the scsi
>         driverfs provides a "type" file to contain this info. The current
>         strings used are taken from the scsi_device_types[] but should be
>         replaced with the system wide device types that driverfs will provide.
> 
> 2. uid - Since topology and discovery order of hardware can change, the
>         driverfs path names to a device are also subject to change. To
>         easily identify a device I think it's important that the driverfs
>         bus implementations be responsible for create a unique identifier.
> 
>         Since each bus and the devices attached to it will have varying
>         capabilities for identifying themselves the contents for this file
>         should probably be a variable length string.
> 
>         Even for older devices that can't do a great job of providing info to
>         uniquely identify themselves, the driverfs tree provides the nice
>         topological context to fall back upon that allows at least as
>         good of a job to be done as we do today.
> 
>         The scsi patch currently creates uid info from the INQUIRY evpd pages
>         and makes it available in the name file. I would prefer to see a
>         new standard uid file and let the name file contain a descriptive
>         (non-unique) name.
> 
> 3. kdev - To create/manage/interface with the device node we need to know the
>         kdev.
> 
> Because of coldplugging this information should be available in each driverfs
> device directory. Also, adding the driverfs path name on /sbin/hotplug
> events and allowing the consumer to retrieve the info from the filesystem might
> help simplify some of these implementations too.
> 
> The devnaming utility that is based on this strategy is available at
> http://www-124.ibm.com/devreg/
> 
> I'd welcome any thoughts or suggestions.

It will probably take a few iterations before we get
close to an "approved" naming model :-)
 
So people have some idea what this patch generates, here
is my system's "/proc/scsi/scsi" followed by a "du -a"
at the top of the driverfs tree:

$ cat /proc/scsi/scsi
Attached devices: 
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: FUJITSU  Model: MAM3184MP        Rev: 0105
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 09 Lun: 00
  Vendor: SEAGATE  Model: ST318451LW       Rev: 0003
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: Linux    Model: scsi_debug       Rev: 0003
  Type:   Direct-Access                    ANSI SCSI revision: 03

$ du -a
...
0       ./bus/usb
0       ./bus/scsi/drivers/sr
0       ./bus/scsi/drivers/sg
0       ./bus/scsi/drivers/sd		# empty directory
0       ./bus/scsi/drivers
0       ./bus/scsi/devices/3:0:0:0:disc  # symlinks across to "root" subtree
0       ./bus/scsi/devices/3:0:0:0:gen
0       ./bus/scsi/devices/3:0:0:0
0       ./bus/scsi/devices/1:0:9:0:gen
0       ./bus/scsi/devices/1:0:0:0:gen
0       ./bus/scsi/devices/1:0:9:0:p7
0       ./bus/scsi/devices/1:0:9:0:p6
0       ./bus/scsi/devices/1:0:9:0:p5
0       ./bus/scsi/devices/1:0:9:0:p4
0       ./bus/scsi/devices/1:0:9:0:p3
0       ./bus/scsi/devices/1:0:9:0:p2
0       ./bus/scsi/devices/1:0:9:0:p1
0       ./bus/scsi/devices/1:0:9:0:disc
0       ./bus/scsi/devices/1:0:0:0:p7
0       ./bus/scsi/devices/1:0:0:0:p6
0       ./bus/scsi/devices/1:0:0:0:p5
0       ./bus/scsi/devices/1:0:0:0:p4
0       ./bus/scsi/devices/1:0:0:0:p3
0       ./bus/scsi/devices/1:0:0:0:p2
0       ./bus/scsi/devices/1:0:0:0:p1
0       ./bus/scsi/devices/1:0:0:0:disc
0       ./bus/scsi/devices/1:0:9:0
0       ./bus/scsi/devices/1:0:0:0
0       ./bus/scsi/devices
0       ./bus/scsi
....
0       ./bus/pci/devices/00:0c.1 # symlinks, Tekram dual controller
0       ./bus/pci/devices/00:0c.0
....
0       ./bus/pci
0       ./bus

# scsi_debug "virtual" host bubbles to the top of "root"
# hierarchy because it has no "parent" bus type (i.e. it
# isn't pci). Why is the <h,c,t,l> given twice?
0       ./root/scsi3/3:0:0:0/3:0:0:0:disc/kdev
0       ./root/scsi3/3:0:0:0/3:0:0:0:disc/type
0       ./root/scsi3/3:0:0:0/3:0:0:0:disc/power
0       ./root/scsi3/3:0:0:0/3:0:0:0:disc/name  # S1234Linuxdisc
0       ./root/scsi3/3:0:0:0/3:0:0:0:disc
0       ./root/scsi3/3:0:0:0/3:0:0:0:gen/kdev
0       ./root/scsi3/3:0:0:0/3:0:0:0:gen/type
0       ./root/scsi3/3:0:0:0/3:0:0:0:gen/power
0       ./root/scsi3/3:0:0:0/3:0:0:0:gen/name   # S1234Linuxgeneric
0       ./root/scsi3/3:0:0:0/3:0:0:0:gen
0       ./root/scsi3/3:0:0:0/type
0       ./root/scsi3/3:0:0:0/power
0       ./root/scsi3/3:0:0:0/name  # S1234Linux
0       ./root/scsi3/3:0:0:0
0       ./root/scsi3/power
0       ./root/scsi3/name          # scsi_debug, Version: 1.59 ....
0       ./root/scsi3
0       ./root/pci0/00:0d.0/resources
0       ./root/pci0/00:0d.0/irq
.... 
0       ./root/pci0/00:0c.1/scsi2/power
0       ./root/pci0/00:0c.1/scsi2/name   # sym-2.1.16a
0       ./root/pci0/00:0c.1/scsi2
0       ./root/pci0/00:0c.1/resources
0       ./root/pci0/00:0c.1/irq
0       ./root/pci0/00:0c.1/power
0       ./root/pci0/00:0c.1/name      # PCI device 1000:0020
0       ./root/pci0/00:0c.1
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:gen/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:gen/type
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:gen/power
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:gen/name
              # S3CC01TTG000071033QEASEAGATEgeneric
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:gen
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p7/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p7/type
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p7/power
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p7/name
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p7
...
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p1/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p1/type
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p1/power
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p1/name
              # S3CC01TTG000071033QEASEAGATEpart1
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:p1
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:disc/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:disc/type
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:disc/power
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:disc/name
              # S3CC01TTG000071033QEASEAGATEdisc 
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/1:0:9:0:disc
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/type
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/power
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0/name
              # S3CC01TTG000071033QEASEAGATE
0       ./root/pci0/00:0c.0/scsi1/1:0:9:0
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:gen/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:gen/type
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:gen/power
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:gen/name
              # SUKS0P1B009PFFUJITSUgeneric
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:gen
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p7/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p7/type
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p7/power
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p7/name
              # SUKS0P1B009PFFUJITSUpart7
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p7
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p6/kdev
....
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p1/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p1/type
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p1/power
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p1/name
              # SUKS0P1B009PFFUJITSUpart1
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:p1
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:disc/kdev
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:disc/type
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:disc/power
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:disc/name
              # SUKS0P1B009PFFUJITSUdisc
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/1:0:0:0:disc
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/type
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/power
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0/name
              # SUKS0P1B009PFFUJITSU
0       ./root/pci0/00:0c.0/scsi1/1:0:0:0
0       ./root/pci0/00:0c.0/scsi1/power
0       ./root/pci0/00:0c.0/scsi1/name
              # sym-2.1.16a
0       ./root/pci0/00:0c.0/scsi1
0       ./root/pci0/00:0c.0/resources
0       ./root/pci0/00:0c.0/irq
0       ./root/pci0/00:0c.0/power
0       ./root/pci0/00:0c.0/name
0       ./root/pci0/00:0c.0
....
0       ./root/pci0/00:04.1/ata@01/power
0       ./root/pci0/00:04.1/ata@01/name  # ATA/ATAPI Host-Channel
0       ./root/pci0/00:04.1/ata@01


It would be useful if Martin could show us one of his ATA
driverfs trees.

Patrick mentioned that we can soon expect these directories:
     /driverfs/class/disk
     /driverfs/class/tape
     /driverfs/class/cd  (or cd-dvd, or ...)
and perhaps
     /driverfs/class/misc
for those nasty devices (e.g. tape robots and storage enclosures)
that need pass through drivers like sg. 
The "/driverfs/class/disk"
directory would contain all attached disks (i.e.
ATA, SCSI, USB ...) with enumerated names (i.e.
"disk0", "disk1"). These enumerated names would be symlinks
to the device.


I'll start with one suggestion: perhaps "kdev" could
be replaced by two files: "major" and "minor".

Comments?

Doug Gilbert
--------------26DE32BF178181414B5E4F38
Content-Type: application/x-gzip;
 name="scsi-driverfs_2524.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="scsi-driverfs_2524.diff.gz"

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
EZOPq5UAAA==
--------------26DE32BF178181414B5E4F38--

