From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Thu, 01 Jun 2006 12:21:57 -0400
Message-ID: <447F1425.3070205@torque.net>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com> <1149104797.7543.64.camel@localhost.localdomain> <447E0B78.5050700@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010108020607030804090802"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:62643 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030224AbWFAQWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 12:22:10 -0400
In-Reply-To: <447E0B78.5050700@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010108020607030804090802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> Alexis Bruemmer wrote:
> 
>>These patches look good and are running on our x260 and the ppc64
>>(power).  I was just wondering about a few things under the sys/class/:
>>
>>there is a sas_device, sas_end_device, and a sas_expander dir.
>>sas_device contains the same info as sas_end_device, and a sas_expander
>>can we eliminate one or the other?  Or was this a design choice?
>>
>>Also during the boot process on the x260 with an expander we see these
>>printk's:
>>sas: phy[n] matched wide port0
>>If we are going to print this then we better be sure that this is truly
>>a wide port.  It seems under the sys/class/ we have both a single
>>port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
>>although each phy seems to have the same sas_address the end_device
>>attached to that phy have unique addresses.  My understanding is that a
>>wide port has multiple phys with the same sas address and are attached
>>to one end device.
> 
> 
> A wide port is an abstraction just above the link
> layer in which two or more links running between
> the same two devices have phys with the same SAS
> addresses associated with them.
> 
> Assume we have two phys on a HBA connected to two
> phys on an expander, then two other phys on the
> expander connected to a dual ported SAS disk.
> That is one wide port connection (between the
> at HBA and the expander) and two narrow
> port connections (between the expander and each
> port on the SAS disk).
> 
> This comes about because phys on a HBA share a
> SAS address, phys on a expander share a SAS address
> but phys of a dual ported SAS disk have distinct
> SAS addresses.
> [Could someone suggest an instructive diagram url
> of this as the sas drafts are a bit complex.]
> 
> You are probably aware of this distinction but my
> guess is a lot of other people aren't.
> 
> Put another way, seen from a LLD or discover process when
> multiple phys on the same device have this tuple
> <SAS_address, attached_SAS_address> equal then there is
> a wide port connection.

I don't have a diagram, but I do have some real
output. The hardware is set up as in my example
above with a LSI SAS HBA (0x500605b00006f260).
There is a twelve port expander (0x500605b000000af0)
with phy ids 3 and 4 connected to the HBA, and phy
ids 8 and 9 connected to a dual ported SAS disk.

sg_vpd shows the naa-5 addresses for /dev/sdb
and /dev/sdc . So many to choose from! The first
is the lu name, next is the port identifier and the
last two are different renderings of the target device
name. Only the target port identifiers differ (the
secondary port is usually one higher than the primary).

[Aside: if lsscsi was to show a device's wwn then I
 believe it should show the lu name (if there is one).
 Thoughts?]

Doing a SMP discover on the expander's connected phys
shows a 2 link wide port to the HBA because the
two <sas_addres, attached_sas_address> tuples match. Note
that the attached phy ids (i.e. on the HBA) are not
consecutive. There are also two narrow port links to the
primary and secondary ports of the SAS disk.

Doug Gilbert



--------------010108020607030804090802
Content-Type: text/plain;
 name="wide_narrow_ex.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wide_narrow_ex.txt"

[root@sas ~]# lsscsi
[0:0:0:0]    disk    ATA      WDC WD360GD-00FL 33.0  /dev/sda
[4:2:0:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdb
[4:2:1:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdc

[root@sas ~]# sg_vpd /dev/sdb -iq
0x5000c50000520a2b
0x5000c50000520a2a
0x5000c50000520a28
naa.5000C50000520A28

[root@sas ~]# sg_vpd /dev/sdc -iq
0x5000c50000520a2b
0x5000c50000520a29
0x5000c50000520a28
naa.5000C50000520A28

[root@sas ~]# smp_discover -s 0x500605b000000af0 /dev/mptctl -b -p 3
Discover response:
  phy identifier: 3
  attached device type: end device
  negotiated physical link rate: phy enabled; 3 Gbps
  attached initiator: ssp=1 stp=1 smp=1 sata_host=0
  attached target: ssp=0 stp=0 smp=0 sata_device=0
  SAS address: 0x500605b000000af0
  attached SAS address: 0x500605b00006f260
  attached phy identifier: 0

[root@sas ~]# smp_discover -s 0x500605b000000af0 /dev/mptctl -b -p 4
Discover response:
  phy identifier: 4
  attached device type: end device
  negotiated physical link rate: phy enabled; 3 Gbps
  attached initiator: ssp=1 stp=1 smp=1 sata_host=0
  attached target: ssp=0 stp=0 smp=0 sata_device=0
  SAS address: 0x500605b000000af0
  attached SAS address: 0x500605b00006f260
  attached phy identifier: 3

[root@sas ~]# smp_discover -s 0x500605b000000af0 /dev/mptctl -b -p 8
Discover response:
  phy identifier: 8
  attached device type: end device
  negotiated physical link rate: phy enabled; 3 Gbps
  attached initiator: ssp=0 stp=0 smp=0 sata_host=0
  attached target: ssp=1 stp=0 smp=0 sata_device=0
  SAS address: 0x500605b000000af0
  attached SAS address: 0x5000c50000520a2a
  attached phy identifier: 1

[root@sas ~]# smp_discover -s 0x500605b000000af0 /dev/mptctl -b -p 9
Discover response:
  phy identifier: 9
  attached device type: end device
  negotiated physical link rate: phy enabled; 3 Gbps
  attached initiator: ssp=0 stp=0 smp=0 sata_host=0
  attached target: ssp=1 stp=0 smp=0 sata_device=0
  SAS address: 0x500605b000000af0
  attached SAS address: 0x5000c50000520a29
  attached phy identifier: 0

--------------010108020607030804090802--
