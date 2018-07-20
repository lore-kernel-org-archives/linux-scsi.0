From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi version 0.30 released
Date: Fri, 20 Jul 2018 15:11:48 -0400
Message-ID: <4ef33405-fc6d-f046-8a5e-a565e122b92d@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux 2.6, 3
and 4 series kernels in order to list information about SCSI
devices and SCSI hosts. The default format is one device (e.g. disk)
per line. Other storage devices that use the SCSI subsystem such as
SATA disks and USB keys are also listed.

Version 0.30 adds listing of NVMe devices following SCSI devices.
NVMe namespaces (e.g. /dev/nvme0n1) are listed with SCSI devices
(LUs) and have tuples that start with 'N' (e.g. "[N:0:1:1]"). NVMe
controllers (e.g. /dev/nvme0) are listed with SCSI hosts
(initiators).

lsblk differences:
   - lsblk lists disk partitions; lsscsi does not
   - lsblk lists storage devices that don't use the SCSI and NVMe
     subsystems; lsscsi does not. Example: non-USB connected
     SD cards with device names like /dev/mmcblk0...
   - lsscsi lists SCSI hosts (initiators) and NVMe controllers;
     lsblk does not
   - lsscsi lists pass-through devices (e.g. /dev/nvme0) which are
     typically character devices; lsblk does not
   - lsscsi lists meta storage devices such as tape robots and disk
     enclosures

Version 0.30 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
plus a Download and Build information section containing
tarballs, rpm and deb packages.

ChangeLog:
Version 0.30 2018/06/12 [svn: r154]
   - add support for NVMe devices and controllers
     - to build without: ./configure --disable-nvme-supp
     - deselect at runtime: lsscsi --no-nvme
     - deselect SCSI devices at runtime: lsscsi N
   - add --brief for tuple + device_name(s) only
   - add --pdt (-D) for device type in hex
   - extend --size (-s) so when given three times
     the size as a logical block count is output
   - add --sz-lbs (-S) that is equivalent to '-sss'
     when used twice adds comma then logical block size
   - '-w' now decodes 128 bit WWN without truncation
   - /dev/disk/by-id/wwn- is not guaranteed to be
     persistent (or stable); instead use
     /dev/disk/by-id/scsi-
   - '-t' on a FC host was not printing the comma
     separator resulting in garbled output, fix
   - debian: bump compat file contents from 7 to 10

Version 0.29 2016/05/14 [svn: r137]
   - '-u' now decodes locally assigned UUIDs (spc5r08)
   - as last try use T10 Vendor ID for lu name
   - if no lu name found, print 'none'
   - change '-uuu' to output the full lu name followed
     by the normal fields (which were skipped before)
   - add 'U' option, same action as '-uuu'
   - '-UU' prefixes lu names with 'eui.', 'naa.', etc
   - if '-s' given twice, lu size is base 2 related
   - if very long [h:c:t:l] then append space
   - print_enclosure_device() for FCP may be useless,
     comment out while checking ...
   - with '-t' print 0x0000000000000000 for non-SAS
     device in SAS domain
   - autogen.sh: upgrade to 20091223 version
   - automake: upgrade to 1.15 (ubuntu 16.04)

Version 0.28 2014/09/30 [svn: r120]
...

Examples:
$ lsscsi -gs
[0:0:0:0]  disk Linux    scsi_debug       0188  /dev/sda   /dev/sg0    419MB
[0:0:0:1]  disk Linux    scsi_debug       0188  /dev/sdb   /dev/sg1    419MB
[N:0:1:1]  disk INTEL SSDPEKKF256G7L__1                    /dev/nvme0n1   256GB

$ lsscsi -H
[0]    scsi_debug
[N:0]  /dev/nvme0  INTEL SSDPEKKF256G7L           BTPY00000AU6256D    123P

Douglas Gilbert
